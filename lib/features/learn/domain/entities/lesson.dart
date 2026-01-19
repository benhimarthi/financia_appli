enum LessonStatus { completed, inProgress, locked }

class Lesson {
  final String title;
  final int durationInMinutes;
  final LessonStatus status;

  Lesson({
    required this.title,
    required this.durationInMinutes,
    required this.status,
  });
}
