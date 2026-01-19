import 'package:myapp/features/learn/domain/entities/lesson.dart';

class LearningPath {
  final String title;
  final String description;
  final double progress; // 0.0 to 1.0
  final List<Lesson> lessons;
  final String icon;

  LearningPath({
    required this.title,
    required this.description,
    required this.progress,
    required this.lessons,
    required this.icon,
  });
}
