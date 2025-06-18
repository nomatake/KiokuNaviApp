import 'package:get/get.dart';
import 'package:kioku_navi/widgets/course_section_widget.dart';

class ChildHomeController extends GetxController {
  // Observable list of course sections
  final RxList<CourseSection> courseSections = <CourseSection>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initializeCourseSections();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void _initializeCourseSections() {
    courseSections.assignAll([
      CourseSection(
        title: 'スタート',
        isAlignedRight: true,
        totalDots: 6,
        completedDots: 1,
        showDolphin: true,
      ),
      CourseSection(
        title: '基礎学習',
        isAlignedRight: false,
        totalDots: 9,
        completedDots: 3,
        showDolphin: true,
      ),
      CourseSection(
        title: '応用問題',
        isAlignedRight: true,
        totalDots: 7,
        completedDots: 0,
        showDolphin: true,
      ),
      CourseSection(
        title: '実践テスト',
        isAlignedRight: false,
        totalDots: 8,
        completedDots: 0,
        showDolphin: false,
      ),
    ]);
  }

  void onSectionTapped(CourseSection section) {
    // Handle section tap
    print('Tapped on ${section.title}');
    // TODO: Navigate to section or show section details
  }

  void updateSectionProgress(int sectionIndex, int completedDots) {
    if (sectionIndex >= 0 && sectionIndex < courseSections.length) {
      final section = courseSections[sectionIndex];
      courseSections[sectionIndex] = CourseSection(
        title: section.title,
        isAlignedRight: section.isAlignedRight,
        totalDots: section.totalDots,
        completedDots: completedDots,
        showDolphin: section.showDolphin,
        subjectIcon: section.subjectIcon,
      );
      courseSections.refresh();
    }
  }
}
