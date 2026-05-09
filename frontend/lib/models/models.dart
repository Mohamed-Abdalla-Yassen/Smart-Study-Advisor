// lib/models/models.dart

// ── Student Query ─────────────────────────────────────────────
// Matches exactly the GET params Django expects:
// difficulty, prereq, pref, year, dept
class StudentQuery {
  final String dept;
  final String pref;
  final String difficulty;
  final String prereq; // a previously known course name, or 'nan'
  final int year;

  const StudentQuery({
    required this.dept,
    required this.pref,
    required this.difficulty,
    required this.prereq,
    required this.year,
  });

  Map<String, String> toQueryParams() => {
        'dept': dept,
        'pref': pref,
        'difficulty': difficulty,
        'prereq': prereq,
        'year': year.toString(),
      };

  Map<String, dynamic> toJson() => {
        'dept': dept,
        'pref': pref,
        'difficulty': difficulty,
        'prereq': prereq,
        'year': year.toString(),
      };
}

// ── Course Result ─────────────────────────────────────────────
class CourseResult {
  final String name;
  const CourseResult({required this.name});

  static List<CourseResult> mockResults(String dept) {
    final map = {
      'CSE': [
        'Artificial Intelligence',
        'Data Structures and Algorithms',
        'Object-Oriented Programming',
        'Introduction to Cybersecurity',
        'Fundamentals of Web Development',
      ],
      'EE': [
        'Electrical Circuits 1',
        'Digital Electronics',
        'Smart Grids',
        'Fundamentals of Digital Signal Processing',
        'Applied Digital Signal Processing',
      ],
      'ME': [
        'Fluid Mechanics',
        'Engineering Thermodynamics',
        'Machine Design 1',
        'Heat and Mass Transfer 1',
        'Introduction to Dynamics',
      ],
      'CE': [
        'Structural Analysis 1',
        'Surveying',
        'Applied Soil Mechanics',
        'Introduction to Bridge Engineering',
        'Transportation Engineering 3',
      ],
      'Architecture': [
        'Architectural Design 1',
        'Urban Design',
        'Landscape Architecture 1',
        'Introduction to Parametric Design',
        'History of Architecture',
      ],
    };
    final list = map[dept] ?? [
      'Mathematics 1 (Calculus)',
      'Physics 1 (Mechanics)',
      'Engineering Chemistry',
      'Technical Report Writing',
      'Engineering Economy',
    ];
    return list.map((n) => CourseResult(name: n)).toList();
  }
}

// ── App Constants ─────────────────────────────────────────────
class AppConstants {
  static const List<String> departments = [
    'Architecture',
    'Basic and Applied Sciences',
    'CE',
    'CSE',
    'EE',
    'Humanities',
    'ME',
    'PE',
  ];

  static const Map<String, String> deptLabels = {
    'Architecture': 'Architecture',
    'Basic and Applied Sciences': 'Basic & Applied Sciences',
    'CE': 'Civil Engineering',
    'CSE': 'Computer & Systems Eng.',
    'EE': 'Electrical & Comm. Eng.',
    'Humanities': 'Humanities',
    'ME': 'Mechanical Engineering',
    'PE': 'Production Engineering',
  };

  static const List<String> preferences = [
    'AI', 'Chemistry', 'Circuits', 'Design', 'Electronics',
    'Field Work', 'Fluids', 'Hardware', 'Hardware/Software',
    'History', 'Management', 'Manufacturing', 'Math',
    'Optimization', 'Physics', 'Practical', 'Programming',
    'Research', 'Soft Skills', 'Software', 'Structures',
    'Theory', 'Thermal',
  ];

  static const List<String> difficulties = ['Easy', 'Medium', 'Hard'];
  static const List<int> years = [1, 2, 3, 4, 5];
}