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

  @override
  void onInit() {
    super.onInit();
    _initializeCourseSections();
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
  }

  void onSectionTapped(CourseSection section) {
    Get.toNamed(Routes.QUESTION, arguments: {
      'topicId': 7,
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
