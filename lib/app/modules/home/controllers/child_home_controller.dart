import 'package:dynamic_icons/dynamic_icons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/app/routes/app_pages.dart';
import 'package:kioku_navi/controllers/base_controller.dart';
import 'package:kioku_navi/widgets/course_section_widget.dart';
import 'package:kioku_navi/widgets/subject_selection_dialog.dart';

import '../models/models.dart';
import '../services/child_api.dart';

class ChildHomeController extends BaseController {
  // API data
  final RxList<Course> courses = <Course>[].obs;
  final RxBool isLoadingData = true.obs;
  final RxString loadingError = ''.obs;

  // Observable list of course sections
  final RxList<CourseSection> courseSections = <CourseSection>[].obs;

  // Currently selected subject
  final Rx<Subject> selectedSubject = Subject.comprehensive.obs;

  // Scroll controller for tracking scroll position
  final ScrollController scrollController = ScrollController();

  // Current visible chapter title
  final RxString currentVisibleChapter = ''.obs;
  
  // Current visible course title
  final RxString currentVisibleCourse = ''.obs;

  // Global keys for measuring last node positions
  final List<GlobalKey> lastNodeKeys = [];

  // Key for the SizedBox that acts as intersection point
  GlobalKey? _sizedBoxKey;

  // Throttling for scroll events to improve performance
  bool _isUpdating = false;

  // Child API service
  late final ChildApi _childApi;

  @override
  void onInit() {
    super.onInit();
    _childApi = Get.find<ChildApi>();
    _loadChildHomeData();
    _initializeScrollTracking();
  }

  @override
  void onReady() {
    super.onReady();
    _setupScrollListener();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  /// Load child home data from API
  Future<void> _loadChildHomeData() async {
    try {
      isLoadingData.value = true;
      loadingError.value = '';
      
      // Make API call to get child home data
      final response = await _childApi.getChildHome();
      
      // Parse the response to get Course models
      final courseData = response['data'] as List;
      courses.assignAll(
        courseData.map((courseJson) => Course.fromJson(courseJson)).toList(),
      );
      
      // Convert API data to course sections for UI
      _convertCoursesToSections();
      
      isLoadingData.value = false;
    } catch (e) {
      loadingError.value = 'Failed to load courses: $e';
      isLoadingData.value = false;
      
      // Keep empty course sections on error - user can retry
      courseSections.clear();
    }
  }

  /// Convert API courses to CourseSection widgets
  void _convertCoursesToSections() {
    final sections = <CourseSection>[];
    
    for (int courseIndex = 0; courseIndex < courses.length; courseIndex++) {
      final course = courses[courseIndex];
      
      if (course.chapters != null) {
        for (int chapterIndex = 0; chapterIndex < course.chapters!.length; chapterIndex++) {
          final chapter = course.chapters![chapterIndex];
          
          if (chapter.topics != null) {
            final nodes = <CourseNode>[];
            
            for (final topic in chapter.topics!) {
              nodes.add(CourseNode(
                completionPercentage: _getTopicCompletionPercentage(topic.id),
                customIcon: _getIconDataFromName(topic.iconText),
                id: topic.id,
              ));
            }
            
            sections.add(CourseSection(
              title: chapter.title,
              isAlignedRight: chapterIndex % 2 == 1,
              showDolphin: true,
              nodes: nodes,
            ));
          }
        }
      }
    }
    
    courseSections.assignAll(sections);
    
    // Initialize last node keys based on actual course sections count
    lastNodeKeys.clear();
    for (int i = 0; i < courseSections.length; i++) {
      lastNodeKeys.add(GlobalKey());
    }

    // Set initial chapter title
    if (courseSections.isNotEmpty) {
      currentVisibleChapter.value = courseSections.first.title;
      // Set initial course title (find the course that contains the first chapter)
      _updateVisibleCourse(courseSections.first.title);
    }
  }
  
  /// Get completion percentage for a topic (disabled for now)
  double _getTopicCompletionPercentage(int topicId) {
    // Progress display disabled - all nodes show as active
    return 0.0;
  }

  /// Convert icon name string to Material IconData
  IconData? _getIconDataFromName(String? iconName) {
    if (iconName == null || iconName.isEmpty) {
      return Icons.help_outline; // Default icon
    }

    try {
      // Get the Icon widget from dynamic_icons
      final iconWidget = DynamicIcons.getIconFromName(iconName);
      
      // If the widget is returned, extract the IconData from it
      if (iconWidget is Icon) {
        return iconWidget.icon;
      }
      
      // Fallback to default icon
      return Icons.help_outline;
    } catch (e) {
      // If icon not found, return default icon
      if (kDebugMode) {
        print('Failed to find icon: $iconName, error: $e');
      }
      return Icons.help_outline;
    }
  }


  void _initializeScrollTracking() {
    // Set initial chapter title
    if (courseSections.isNotEmpty) {
      currentVisibleChapter.value = courseSections.first.title;
    }
  }

  void _setupScrollListener() {
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    // Throttle scroll updates to improve performance
    if (_isUpdating) return;
    _isUpdating = true;
    
    // Use post frame callback to avoid blocking the UI thread
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateVisibleChapter();
      _isUpdating = false;
    });
  }

  void _updateVisibleChapter() {
    if (lastNodeKeys.isEmpty || courseSections.isEmpty || _sizedBoxKey == null) return;

    try {
      // Get the intersection point (SizedBox)
      final sizedBoxContext = _sizedBoxKey!.currentContext;
      if (sizedBoxContext == null) return;
      
      final sizedBoxRenderBox = sizedBoxContext.findRenderObject() as RenderBox?;
      if (sizedBoxRenderBox == null) return;
      
      final sizedBoxPosition = sizedBoxRenderBox.localToGlobal(Offset.zero);
      final sizedBoxCenter = sizedBoxPosition.dy + (sizedBoxRenderBox.size.height / 2);

      String newChapter = courseSections.first.title; // Default to first chapter

      // Find the last chapter whose last node has crossed the intersection point
      int lastCrossedChapterIndex = -1;
      
      for (int i = 0; i < lastNodeKeys.length && i < courseSections.length; i++) {
        final key = lastNodeKeys[i];
        final context = key.currentContext;
        if (context != null) {
          final renderBox = context.findRenderObject() as RenderBox?;
          if (renderBox != null) {
            final nodePosition = renderBox.localToGlobal(Offset.zero);
            final nodeBottom = nodePosition.dy + renderBox.size.height;
            
            // Check if the last node has completely passed the SizedBox center
            if (nodeBottom <= sizedBoxCenter) {
              lastCrossedChapterIndex = i;
              // Don't break - keep looking for the last chapter that crossed
            }
          }
        }
      }

      // Show the next chapter's title after the last crossed chapter
      if (lastCrossedChapterIndex >= 0) {
        int nextChapterIndex = lastCrossedChapterIndex + 1;
        if (nextChapterIndex < courseSections.length) {
          // Show the next chapter's title
          newChapter = courseSections[nextChapterIndex].title;
        } else {
          // If we've crossed the last chapter's last node, keep showing the last chapter
          newChapter = courseSections[lastCrossedChapterIndex].title;
        }
      }
      // If no chapter's last node has crossed, keep showing the first chapter (default)

      if (currentVisibleChapter.value != newChapter) {
        currentVisibleChapter.value = newChapter;
        // Update current visible course based on the chapter
        _updateVisibleCourse(newChapter);
      }
    } catch (e, stackTrace) {
      // Log errors during scroll tracking for debugging
      if (kDebugMode) {
        print('Error in _updateVisibleChapter: $e');
        print('Stack trace: $stackTrace');
      }
    }
  }

  /// Update the visible course based on the current chapter
  void _updateVisibleCourse(String chapterTitle) {
    try {
      // Find which course contains the chapter with the given title
      for (final course in courses) {
        if (course.chapters != null) {
          for (final chapter in course.chapters!) {
            if (chapter.title == chapterTitle) {
              if (currentVisibleCourse.value != course.title) {
                currentVisibleCourse.value = course.title;
              }
              return;
            }
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error in _updateVisibleCourse: $e');
      }
    }
  }

  // Getter for last node keys to be used in the view
  GlobalKey getLastNodeKey(int index) {
    if (index >= 0 && index < lastNodeKeys.length) {
      return lastNodeKeys[index];
    }
    return GlobalKey(); // Return a new key as fallback
  }

  // Set the SizedBox key for intersection detection
  void setSizedBoxKey(GlobalKey key) {
    _sizedBoxKey = key;
  }

  void onNodeTapped(CourseNode node) {
    Get.toNamed(Routes.QUESTION, arguments: {
      'topicId': node.id,
    });
  }

  void onSubjectSelected(Subject subject) {
    selectedSubject.value = subject;
    // Filter courses based on selected subject and rebuild sections
    _convertCoursesToSections();
  }

  /// Public method to reload child home data
  Future<void> reloadData() async {
    await _loadChildHomeData();
  }

  /// Updates the progress of a specific node in a course section
  void updateNodeProgress(
      int sectionIndex, int nodeIndex, double completionPercentage) {
    if (sectionIndex >= 0 && sectionIndex < courseSections.length) {
      final section = courseSections[sectionIndex];
      if (nodeIndex >= 0 && nodeIndex < section.nodes.length) {
        // Create a new list of nodes with updated progress
        final updatedNodes = List<CourseNode>.from(section.nodes);
        updatedNodes[nodeIndex] = CourseNode(
          completionPercentage: completionPercentage,
          customIcon: section.nodes[nodeIndex].customIcon,
          customText: section.nodes[nodeIndex].customText,
          id: section.nodes[nodeIndex].id,
        );

        // Update the section with new nodes
        courseSections[sectionIndex] = CourseSection(
          title: section.title,
          isAlignedRight: section.isAlignedRight,
          nodes: updatedNodes,
          showDolphin: section.showDolphin,
          subjectIcon: section.subjectIcon,
        );
        courseSections.refresh();
      }
    }
  }

  /// Updates the progress of an entire section by setting completion percentage for all nodes up to a certain index
  void updateSectionProgress(int sectionIndex, int completedNodeCount) {
    if (sectionIndex >= 0 && sectionIndex < courseSections.length) {
      final section = courseSections[sectionIndex];
      final updatedNodes = <CourseNode>[];

      for (int i = 0; i < section.nodes.length; i++) {
        final node = section.nodes[i];
        double newCompletion;

        if (i < completedNodeCount) {
          newCompletion = 100.0; // Fully completed
        } else if (i == completedNodeCount) {
          newCompletion = 50.0; // Currently in progress
        } else {
          newCompletion = 0.0; // Not started
        }

        updatedNodes.add(CourseNode(
          completionPercentage: newCompletion,
          customIcon: node.customIcon,
          customText: node.customText,
          id: node.id,
        ));
      }

      courseSections[sectionIndex] = CourseSection(
        title: section.title,
        isAlignedRight: section.isAlignedRight,
        nodes: updatedNodes,
        showDolphin: section.showDolphin,
        subjectIcon: section.subjectIcon,
      );
      courseSections.refresh();
    }
  }
}
