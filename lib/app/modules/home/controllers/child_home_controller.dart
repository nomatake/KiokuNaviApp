import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/app/routes/app_pages.dart';
import 'package:kioku_navi/controllers/base_controller.dart';
import 'package:kioku_navi/generated/locales.g.dart';
import 'package:kioku_navi/widgets/course_section_widget.dart';
import 'package:kioku_navi/widgets/subject_selection_dialog.dart';

class ChildHomeController extends BaseController {
  // Observable list of course sections
  final RxList<CourseSection> courseSections = <CourseSection>[].obs;

  // Currently selected subject
  final Rx<Subject> selectedSubject = Subject.comprehensive.obs;

  // Scroll controller for tracking scroll position
  final ScrollController scrollController = ScrollController();

  // Current visible chapter title
  final RxString currentVisibleChapter = ''.obs;

  // Global keys for measuring section positions
  final List<GlobalKey> sectionKeys = [];

  // Key for the SizedBox that acts as intersection point
  GlobalKey? _sizedBoxKey;

  // Throttling for scroll events to improve performance
  bool _isUpdating = false;

  @override
  void onInit() {
    super.onInit();
    _initializeCourseSections();
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

  void _initializeCourseSections() {
    courseSections.assignAll([
      CourseSection(
        title: LocaleKeys.pages_course_sections_start.tr,
        isAlignedRight: true,
        showDolphin: true,
        nodes: [
          CourseNode(
            completionPercentage: 100.0,
            customIcon: Icons.science,
            id: 'start_1',
          ),
          CourseNode(
            completionPercentage: 75.0,
            customIcon: Icons.lightbulb,
            id: 'start_2',
          ),
          CourseNode(
            completionPercentage: 50.0,
            customIcon: Icons.book,
            id: 'start_3',
          ),
          CourseNode(
            completionPercentage: 25.0,
            customIcon: Icons.star,
            id: 'start_4',
          ),
          CourseNode(
            completionPercentage: 0.0,
            customIcon: Icons.flag,
            id: 'start_5',
          ),
          CourseNode(
            completionPercentage: 0.0,
            customIcon: Icons.celebration,
            id: 'start_6',
          ),
        ],
      ),
      CourseSection(
        title: LocaleKeys.pages_course_sections_basicLearning.tr,
        isAlignedRight: false,
        showDolphin: true,
        nodes: [
          CourseNode(
            completionPercentage: 100.0,
            customText: '1',
            id: 'basic_1',
          ),
          CourseNode(
            completionPercentage: 100.0,
            customText: '2',
            id: 'basic_2',
          ),
          CourseNode(
            completionPercentage: 100.0,
            customText: '3',
            id: 'basic_3',
          ),
          CourseNode(
            completionPercentage: 80.0,
            customText: '4',
            id: 'basic_4',
          ),
          CourseNode(
            completionPercentage: 60.0,
            customText: '5',
            id: 'basic_5',
          ),
          CourseNode(
            completionPercentage: 0.0,
            customText: '6',
            id: 'basic_6',
          ),
          CourseNode(
            completionPercentage: 0.0,
            customText: '7',
            id: 'basic_7',
          ),
          CourseNode(
            completionPercentage: 0.0,
            customText: '8',
            id: 'basic_8',
          ),
          CourseNode(
            completionPercentage: 0.0,
            customText: '9',
            id: 'basic_9',
          ),
        ],
      ),
      CourseSection(
        title: LocaleKeys.pages_course_sections_appliedProblems.tr,
        isAlignedRight: true,
        showDolphin: true,
        nodes: [
          CourseNode(
            completionPercentage: 100.0,
            customIcon: Icons.add,
            id: 'advanced_1',
          ),
          CourseNode(
            completionPercentage: 100.0,
            customIcon: Icons.remove,
            id: 'advanced_2',
          ),
          CourseNode(
            completionPercentage: 90.0,
            customIcon: Icons.close, // multiply
            id: 'advanced_3',
          ),
          CourseNode(
            completionPercentage: 70.0,
            customText: '÷',
            id: 'advanced_4',
          ),
          CourseNode(
            completionPercentage: 30.0,
            customIcon: Icons.functions,
            id: 'advanced_5',
          ),
          CourseNode(
            completionPercentage: 0.0,
            customIcon: Icons.calculate,
            id: 'advanced_6',
          ),
          CourseNode(
            completionPercentage: 0.0,
            customIcon: Icons.rule,
            id: 'advanced_7',
          ),
        ],
      ),
      CourseSection(
        title: LocaleKeys.pages_course_sections_practiceTest.tr,
        isAlignedRight: false,
        showDolphin: false,
        nodes: [
          CourseNode(
            completionPercentage: 100.0,
            customIcon: Icons.quiz,
            id: 'test_1',
          ),
          CourseNode(
            completionPercentage: 85.0,
            customIcon: Icons.assignment,
            id: 'test_2',
          ),
          CourseNode(
            completionPercentage: 65.0,
            customIcon: Icons.grading,
            id: 'test_3',
          ),
          CourseNode(
            completionPercentage: 40.0,
            customIcon: Icons.school,
            id: 'test_4',
          ),
          CourseNode(
            completionPercentage: 0.0,
            customIcon: Icons.emoji_events,
            id: 'test_5',
          ),
          CourseNode(
            completionPercentage: 0.0,
            customIcon: Icons.military_tech,
            id: 'test_6',
          ),
          CourseNode(
            completionPercentage: 0.0,
            customIcon: Icons.workspace_premium,
            id: 'test_7',
          ),
          CourseNode(
            completionPercentage: 0.0,
            customIcon: Icons.diamond,
            id: 'test_8',
          ),
        ],
      ),
    ]);

    // Initialize section keys based on actual course sections count
    sectionKeys.clear();
    for (int i = 0; i < courseSections.length; i++) {
      sectionKeys.add(GlobalKey());
    }

    // Set initial chapter title
    if (courseSections.isNotEmpty) {
      currentVisibleChapter.value = courseSections.first.title;
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
    if (sectionKeys.isEmpty || courseSections.isEmpty || _sizedBoxKey == null) return;

    try {
      // Get the intersection point (SizedBox)
      final sizedBoxContext = _sizedBoxKey!.currentContext;
      if (sizedBoxContext == null) return;
      
      final sizedBoxRenderBox = sizedBoxContext.findRenderObject() as RenderBox?;
      if (sizedBoxRenderBox == null) return;
      
      final sizedBoxPosition = sizedBoxRenderBox.localToGlobal(Offset.zero);
      final sizedBoxCenter = sizedBoxPosition.dy + (sizedBoxRenderBox.size.height / 2);

      String newChapter = courseSections.first.title; // Default to first chapter

      // Find the last section header that has crossed the SizedBox center
      // This ensures we keep the chapter active until the next one crosses
      for (int i = 0; i < sectionKeys.length && i < courseSections.length; i++) {
        final key = sectionKeys[i];
        final context = key.currentContext;
        if (context != null) {
          final renderBox = context.findRenderObject() as RenderBox?;
          if (renderBox != null) {
            final headerPosition = renderBox.localToGlobal(Offset.zero);
            final headerCenter = headerPosition.dy + (renderBox.size.height / 2);
            
            // Check if the section header center has passed the SizedBox center
            // This means the header has crossed the intersection point
            if (headerCenter <= sizedBoxCenter) {
              newChapter = courseSections[i].title;
              // Don't break - keep looking for the last header that crossed
            }
          }
        }
      }

      if (currentVisibleChapter.value != newChapter) {
        currentVisibleChapter.value = newChapter;
      }
    } catch (e, stackTrace) {
      // Log errors during scroll tracking for debugging
      if (kDebugMode) {
        print('Error in _updateVisibleChapter: $e');
        print('Stack trace: $stackTrace');
      }
    }
  }

  // Getter for section keys to be used in the view
  GlobalKey getSectionKey(int index) {
    if (index >= 0 && index < sectionKeys.length) {
      return sectionKeys[index];
    }
    return GlobalKey(); // Return a new key as fallback
  }

  // Set the SizedBox key for intersection detection
  void setSizedBoxKey(GlobalKey key) {
    _sizedBoxKey = key;
  }

  void onSectionTapped(CourseSection section) {
    Get.toNamed(Routes.QUESTION, arguments: {
      'topicId': 1,
    });
  }

  void onSubjectSelected(Subject subject) {
    selectedSubject.value = subject;
    // TODO: Update the course sections based on selected subject
    // For now, just refresh the current sections
    _initializeCourseSections();
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
