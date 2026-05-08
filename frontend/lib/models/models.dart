// lib/models/student_profile.dart

class StudentProfile {
  final String name;
  final String studentId;
  final List<String> completedCourses;
  final List<String> interests;
  final String difficultyPreference; // easy | medium | hard
  final int availableHoursPerWeek;

  const StudentProfile({
    required this.name,
    required this.studentId,
    required this.completedCourses,
    required this.interests,
    required this.difficultyPreference,
    required this.availableHoursPerWeek,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'student_id': studentId,
        'completed_courses': completedCourses,
        'interests': interests,
        'difficulty_preference': difficultyPreference,
        'available_hours_per_week': availableHoursPerWeek,
      };
}

// lib/models/course_recommendation.dart (combined for simplicity)
class CourseRecommendation {
  final String courseCode;
  final String courseName;
  final String difficulty; // easy | medium | hard
  final double matchScore; // 0.0 to 1.0
  final String reason;
  final List<String> prerequisites;
  final String category;

  const CourseRecommendation({
    required this.courseCode,
    required this.courseName,
    required this.difficulty,
    required this.matchScore,
    required this.reason,
    required this.prerequisites,
    required this.category,
  });

  factory CourseRecommendation.fromJson(Map<String, dynamic> json) {
    return CourseRecommendation(
      courseCode: json['course_code'] ?? '',
      courseName: json['course_name'] ?? '',
      difficulty: json['difficulty'] ?? 'medium',
      matchScore: (json['match_score'] ?? 0.0).toDouble(),
      reason: json['reason'] ?? '',
      prerequisites: List<String>.from(json['prerequisites'] ?? []),
      category: json['category'] ?? '',
    );
  }

  // Mock data for UI testing before backend is ready
  static List<CourseRecommendation> mockResults() => [
        const CourseRecommendation(
          courseCode: 'CSE-301',
          courseName: 'Machine Learning Fundamentals',
          difficulty: 'medium',
          matchScore: 0.94,
          reason: 'Strong alignment with your interest in AI and data analysis. You\'ve completed all prerequisites.',
          prerequisites: ['CSE-201', 'MATH-202'],
          category: 'Artificial Intelligence',
        ),
        const CourseRecommendation(
          courseCode: 'CSE-315',
          courseName: 'Distributed Systems',
          difficulty: 'hard',
          matchScore: 0.87,
          reason: 'Matches your preference for system-level programming and high challenge.',
          prerequisites: ['CSE-210', 'CSE-220'],
          category: 'Systems',
        ),
        const CourseRecommendation(
          courseCode: 'CSE-289',
          courseName: 'Computer Vision',
          difficulty: 'medium',
          matchScore: 0.81,
          reason: 'Complements your completed courses in linear algebra and programming paradigms.',
          prerequisites: ['CSE-225', 'MATH-301'],
          category: 'Artificial Intelligence',
        ),
      ];
}