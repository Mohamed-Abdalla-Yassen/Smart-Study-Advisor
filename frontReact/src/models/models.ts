// models.ts
// ── Student Query ─────────────────────────────────────────────
export interface StudentQuery {
  dept: string;
  pref: string;
  difficulty: string;
  prereq: string;
  year: number;
}

/**
 * Helper to convert a query object to URLSearchParams for GET requests
 */
export const toQueryParams = (query: StudentQuery): Record<string, string> => ({
  dept: query.dept,
  pref: query.pref,
  difficulty: query.difficulty,
  prereq: query.prereq,
  year: query.year.toString(),
});

// ── Multi-select form state ───────────────────────────────────
export interface StudentForm {
  dept: string;
  prefs: Set<string>;
  difficulties: Set<string>;
  years: Set<number>;
  prereqs: Set<string>;
}

export const isFormValid = (form: StudentForm): boolean => {
  return (
    form.dept.length > 0 &&
    form.prefs.size > 0 &&
    form.difficulties.size > 0 &&
    form.years.size > 0 &&
    form.prereqs.size > 0
  );
};

/**
 * Converts Form state (with Sets) to JSON-serializable object (with Arrays)
 */
export const studentFormToJson = (form: StudentForm) => ({
  dept: form.dept,
  prefs: Array.from(form.prefs),
  difficulties: Array.from(form.difficulties),
  years: Array.from(form.years).map((y) => y.toString()),
  prereqs: Array.from(form.prereqs),
});

// ── Course Result ─────────────────────────────────────────────
export interface CourseResult {
  name: string;
  matchPercentage: number;
  matchTier: string;
  difficulty: string;
  prerequisite: string | null;
  preference: string;
  yearOfStudy: number;
  department: string;
}

export class CourseMapper {
  /**
   * Equivalent to factory CourseResult.fromJson
   */
  static fromJson(json: any): CourseResult {
    const details = json.details ?? {};
    const rawPrereq = details.prerequisite;

    return {
      name: json.course_name?.toString() ?? '',
      matchPercentage: Number(json.match_percentage) ?? 0.0,
      matchTier: json.match_tier?.toString() ?? '',
      difficulty: details.difficulty?.toString() ?? '',
      prerequisite: 
        (rawPrereq === null || rawPrereq === 'null' || rawPrereq === 'NaN') 
          ? null 
          : rawPrereq.toString(),
      preference: details.preference?.toString() ?? '',
      yearOfStudy: Number(details.year_of_study) ?? 0,
      department: details.department?.toString() ?? '',
    };
  }

  static mockResults(dept: string): CourseResult[] {
    const raw = [
      {
        course_name: 'Artificial Intelligence',
        match_percentage: 100.0,
        match_tier: 'Tier 1 (100%)',
        details: { difficulty: 'Hard', prerequisite: null, preference: 'AI', year_of_study: 2, department: dept },
      },
      {
        course_name: 'Object-Oriented Programming',
        match_percentage: 100.0,
        match_tier: 'Tier 1 (100%)',
        details: { difficulty: 'Medium', prerequisite: null, preference: 'Programming', year_of_study: 3, department: dept },
      },
      // ... Add other mock items as needed
    ];
    return raw.map((e) => this.fromJson(e));
  }
}

// ── App Constants ─────────────────────────────────────────────
export const AppConstants = {
  departments: [
    'Architecture', 'Basic and Applied Sciences', 'CE', 'CSE',
    'EE', 'Humanities', 'ME', 'PE',
  ] as const,

  deptLabels: {
    'Architecture': 'Architecture',
    'Basic and Applied Sciences': 'Basic & Applied Sciences',
    'CE': 'Civil Engineering',
    'CSE': 'Computer & Systems Eng.',
    'EE': 'Electrical & Comm. Eng.',
    'Humanities': 'Humanities',
    'ME': 'Mechanical Engineering',
    'PE': 'Production Engineering',
  } as Record<string, string>,

  preferences: [
    'AI', 'Chemistry', 'Circuits', 'Design', 'Electronics',
    'Field Work', 'Fluids', 'Hardware', 'Hardware/Software',
    'History', 'Management', 'Manufacturing', 'Math',
    'Optimization', 'Physics', 'Practical', 'Programming',
    'Research', 'Soft Skills', 'Software', 'Structures',
    'Theory', 'Thermal',
  ],

  difficulties: ['Easy', 'Medium', 'Hard'],
  years: [1, 2, 3, 4, 5],

  allCourses: [
    'none', 'Architectural Design 1', 'History of Architecture', 'Applied City Planning 2',
    'Introduction to Urban Planning', 'Advanced Environmental Control 3',
    'Applied Architectural Acoustics 2', 'Applied Urban Sociology',
    'Contemporary Historic Preservation 2', 'Computational Housing Development 1',
    'Theoretical Building Information Modeling 2', 'Experimental Parametric Design 3',
    'Applied Interior Design 1', 'Contemporary Urban Design 1', 'Parametric Design 3',
    'Introduction to Parametric Design', 'Introduction to Digital Fabrication 1',
    'Architectural Acoustics 3', 'Contemporary Environmental Control 3',
    'Theoretical Sustainable Architecture 2', 'Applied Housing Development 1',
    'Building Information Modeling 2', 'Advanced Lighting Design',
    'Experimental Urban Planning 1', 'Applied Building Construction',
    'Computational Parametric Design 3', 'Fundamentals of Urban Sociology 2',
    'Applied Lighting Design 3', 'Contemporary Urban Planning 1',
    'Computational Lighting Design 3', 'Contemporary Housing Development 1',
    'Urban Design', 'Landscape Architecture 1', 'Computational Digital Fabrication 2',
    'Parametric Design', 'Applied Landscape Architecture 2',
    'Advanced Building Construction 3', 'Contemporary Digital Fabrication',
    'Experimental Historic Preservation 2', 'Computational Landscape Architecture 3',
    'Theoretical Housing Development 1', 'Experimental Landscape Architecture 1',
    'Applied Environmental Control 1', 'Advanced Historic Preservation 3',
    'Applied Urban Planning', 'Advanced Urban Sociology', 'Principles of Interior Design 3',
    'Computational Building Construction 2', 'Experimental Building Construction 2',
    'Digital Fabrication 2',
    // Basic and Applied Sciences
    'Mathematics 1 (Calculus)', 'Mathematics 2 (Integration)',
    'Mathematics 3 (Differential Equations)', 'Physics 1 (Mechanics)',
    'Physics 2 (Electricity)', 'Engineering Chemistry', 'Engineering Mechanics 1',
    'Engineering Mechanics 2', 'Experimental Calculus of Variations',
    'Applied Tensor Analysis 1', 'Principles of Discrete Mathematics 2',
    'Fundamentals of Astrophysics', 'Fundamentals of Organic Chemistry',
    'Introduction to Thermodynamics of Materials', 'Fundamentals of Modern Physics 3',
    'Principles of Numerical Analysis 1', 'Advanced Calculus of Variations 2',
    'Applied Astrophysics 2', 'Contemporary Biophysics 3', 'Computational Statistics 3',
    'Theoretical Linear Algebra', 'Applied Discrete Mathematics 2',
    'Experimental Numerical Analysis 1', 'Introduction to Calculus of Variations',
    'Contemporary Modern Physics 1', 'Introduction to Linear Algebra',
    'Advanced Tensor Analysis', 'Fundamentals of Thermodynamics of Materials',
    'Principles of Statistics', 'Theoretical Inorganic Chemistry 2',
    'Numerical Analysis 2', 'Theoretical Statistics', 'Experimental Numerical Analysis',
    'Experimental Quantum Mechanics 1', 'Principles of Discrete Mathematics 1',
    'Fundamentals of Biophysics 2', 'Theoretical Discrete Mathematics 1',
    'Modern Physics 3', 'Introduction to Biophysics', 'Introduction to Topology',
    'Contemporary Modern Physics 2', 'Fundamentals of Astrophysics 2',
    'Fundamentals of Topology 1', 'Fundamentals of Statistics 1',
    'Thermodynamics of Materials 1', 'Applied Linear Algebra 2',
    'Contemporary Modern Physics 3', 'Fundamentals of Statistics 3',
    'Computational Inorganic Chemistry 3', 'Linear Algebra 2', 'Applied Optics 1',
    'Quantum Mechanics 3', 'Fundamentals of Calculus of Variations 3',
    // CE
    'Structural Analysis 1', 'Surveying', 'Applied Reinforced Concrete Design 1',
    'Contemporary GIS 1', 'Advanced Steel Structures', 'Properties of Materials 3',
    'Transportation Engineering 3', 'Fundamentals of Hydrology 1',
    'Advanced Reinforced Concrete Design', 'Wastewater Management 2',
    'Coastal Engineering', 'Applied Construction Management 1',
    'Applied Coastal Engineering 2', 'Fundamentals of Construction Management 2',
    'Computational Hydrology 1', 'Fundamentals of Highway Engineering',
    'Experimental Bridge Engineering 1', 'Contemporary Pavement Design 1',
    'Applied Earthquake Engineering 3', 'Advanced Properties of Materials 2',
    'Experimental Hydrology 2', 'Introduction to Traffic Engineering 1',
    'Principles of Transportation Engineering 2', 'Experimental Reinforced Concrete Design',
    'Tunnel Engineering 3', 'Applied Wastewater Management',
    'Introduction to Earthquake Engineering', 'Traffic Engineering 3',
    'Fundamentals of Wastewater Management 3', 'Applied Soil Mechanics',
    'Advanced Wastewater Management 3', 'Pavement Design 2',
    'Introduction to Bridge Engineering', 'Advanced Geotechnical Engineering 3',
    'Construction Management 3', 'Experimental Coastal Engineering',
    'Experimental GIS 2', 'Experimental Highway Engineering 2',
    'Theoretical Reinforced Concrete Design', 'Steel Structures 3',
    'Applied Bridge Engineering 2', 'Advanced Highway Engineering',
    'Contemporary Advanced Steel Design 2', 'Principles of Construction Management 2',
    'Bridge Engineering 3', 'Experimental Transportation Engineering 1',
    'Contemporary Bridge Engineering 1', 'Fundamentals of Bridge Engineering 2',
    'Hydrology 1',
    // CSE
    'Introduction to Computer Engineering', 'Computer Programming (C/C++)',
    'Object-Oriented Programming', 'Data Structures and Algorithms',
    'Artificial Intelligence', 'Network Security 1', 'Experimental Quantum Computing 2',
    'Applied Robotics 3', 'Principles of Compiler Design 3',
    'Computational Database Systems', 'Computational Network Security 2',
    'Introduction to Distributed Systems', 'Theoretical Network Security 1',
    'Principles of Cloud Computing', 'Experimental Formal Languages 1',
    'Principles of Network Security', 'Introduction to Operating Systems 1',
    'Theoretical Distributed Systems 1', 'Theoretical Distributed Systems 3',
    'Advanced Data Mining', 'Fundamentals of Big Data Analytics 2',
    'Contemporary Data Mining', 'Theoretical Computer Architecture',
    'Contemporary Compiler Design 2', 'Computational Embedded Systems',
    'Computational Internet of Things', 'Introduction to Game Development',
    'Advanced Virtual Reality 3', 'Algorithms', 'Applied Distributed Systems 1',
    'Theoretical Cybersecurity', 'Fundamentals of Software Engineering 1',
    'Introduction to Cybersecurity', 'Theoretical Blockchain Technology 3',
    'Fundamentals of Algorithms 3', 'Applied Bioinformatics 1',
    'Fundamentals of Web Development', 'Theoretical Virtual Reality 3',
    'Contemporary Distributed Systems 1', 'Theoretical Data Mining 3',
    'Internet of Things 2', 'Computational Robotics 3',
    'Applied Human-Computer Interaction 2', 'Contemporary Compiler Design 1',
    'Advanced Embedded Systems 2', 'Computational Natural Language Processing',
    'Contemporary Cybersecurity', 'Applied Internet of Things 3',
    'Theoretical Cryptography', 'Introduction to Software Testing',
    'Applied Formal Languages 2', 'Bioinformatics 1', 'Experimental Digital Logic 2',
    // EE
    'Electrical Circuits 1', 'Electrical Circuits 2', 'Digital Electronics',
    'Applied Satellite Communications 3', 'Theoretical Electronic Devices 1',
    'Theoretical Smart Grids', 'Computational Power Electronics',
    'Advanced Electronic Devices 3', 'Contemporary Microwave Engineering 1',
    'Applied Digital Signal Processing', 'Theoretical Control Systems 2',
    'Smart Grids', 'Computational Smart Grids 3', 'Contemporary Power Electronics 3',
    'Principles of Radar Systems 1', 'Theoretical High Voltage Engineering 2',
    'Theoretical Electrical Power', 'Introduction to Biomedical Instrumentation',
    'Principles of Satellite Communications 3', 'Contemporary Power Electronics 1',
    'Experimental Biomedical Instrumentation 1', 'Introduction to Optical Communications',
    'Experimental Signals and Systems 3', 'Contemporary Biomedical Instrumentation 3',
    'Principles of Control Systems 1', 'Radar Systems',
    'Advanced Electromagnetic Fields 2', 'Computational Electromagnetic Fields',
    'Computational Electrical Power 3', 'Advanced Communication Theory',
    'Smart Grids 2', 'Computational Communication Theory',
    'Fundamentals of Control Systems 1', 'Experimental Satellite Communications',
    'Advanced Electronic Devices 2', 'Computational Electrical Machines 1',
    'Fundamentals of Digital Signal Processing', 'Theoretical Industrial Automation 2',
    'Electrical Machines 1', 'Contemporary Communication Theory 3',
    'Experimental Digital Signal Processing 1', 'Theoretical High Voltage Engineering',
    'Principles of Digital Signal Processing 2', 'Fundamentals of Optical Communications 2',
    'Theoretical Power Electronics 2', 'Introduction to High Voltage Engineering',
    'Computational Industrial Automation', 'Fundamentals of Antenna Theory 1',
    'VLSI Design 2', 'Applied Electromagnetic Fields 3',
    // Humanities
    'Technical Report Writing', 'Engineering Economy', 'Theoretical Public Speaking 3',
    'Applied Technical Communication 2', 'Theoretical Human Rights 2',
    'Computational Sociology 3', 'Fundamentals of Organizational Behavior 2',
    'Principles of Macroeconomics', 'Introduction to Engineering Law',
    'Fundamentals of Business Communication 3', 'Applied Macroeconomics',
    'Professional Ethics 2', 'Contemporary Microeconomics',
    'Computational Macroeconomics 1', 'Introduction to Technical Communication',
    'Introduction to Industrial Psychology', 'Advanced Engineering Law 3',
    'Principles of Philosophy of Science 3', 'Contemporary Industrial Psychology 1',
    'Professional Ethics 3', 'Computational Microeconomics 2', 'Entrepreneurship 2',
    'Contemporary Entrepreneurship 3', 'Contemporary Fundamentals of Management',
    'Introduction to Philosophy of Science', 'Computational Technical Communication',
    'Contemporary Microeconomics 1', 'Fundamentals of Entrepreneurship',
    'Fundamentals of Human Rights 3', 'Technical Communication 3',
    'Professional Ethics 1', 'Principles of Public Speaking 3',
    'Theoretical Philosophy of Science 3', 'Advanced Fundamentals of Management 2',
    'Experimental Fundamentals of Management 1', 'Organizational Behavior',
    'Advanced Organizational Behavior', 'Industrial Psychology', 'Public Speaking 2',
    'Experimental Philosophy of Science 1', 'Principles of Human Rights 1',
    'Theoretical Public Speaking', 'Computational Business Communication 1',
    'Computational Philosophy of Science', 'Fundamentals of Macroeconomics 3',
    'Advanced Business Communication 2', 'Experimental Macroeconomics 2',
    // ME
    'Engineering Thermodynamics', 'Fluid Mechanics', 'Machine Design 1',
    'Advanced Robotics and Automation 2', 'Theoretical Advanced Manufacturing',
    'Experimental HVAC Systems 3', 'Advanced Tribology',
    'Theoretical Heat and Mass Transfer', 'Contemporary Nanotechnology 1',
    'Advanced Fracture Mechanics 3', 'Advanced Energy Conversion',
    'Principles of Aerospace Engineering 2', 'Experimental Composite Materials 3',
    'Theoretical Tribology 2', 'Principles of Energy Conversion 2',
    'Computational Tribology 1', 'Experimental Refrigeration and Air Conditioning 3',
    'Principles of Kinematics 3', 'Applied Automotive Engineering 2',
    'Advanced Kinematics', 'Advanced CAD/CAM', 'Applied Internal Combustion Engines 2',
    'Applied Nanotechnology 2', 'Fundamentals of Kinematics', 'Principles of Acoustics',
    'Experimental Automotive Engineering 1', 'Heat and Mass Transfer 1',
    'Fundamentals of Nanotechnology 2', 'Principles of Finite Element Analysis 3',
    'Theoretical Theory of Machines', 'Fundamentals of Internal Combustion Engines 1',
    'Computational Robotics and Automation 3', 'Introduction to Energy Conversion',
    'Introduction to Dynamics', 'Fundamentals of Computational Fluid Dynamics',
    'Principles of Turbomachinery 3', 'Fundamentals of Finite Element Analysis 2',
    'Introduction to Internal Combustion Engines', 'Advanced Fracture Mechanics',
    'Experimental Composite Materials', 'Applied Kinematics 1',
    'Fundamentals of Internal Combustion Engines 3', 'Contemporary Aerospace Engineering 2',
    'Robotics and Automation 2', 'Fundamentals of Nanotechnology 3',
    'Theoretical Aerospace Engineering 1', 'Fundamentals of Refrigeration and Air Conditioning 1',
    'Principles of Automotive Engineering 2', 'Principles of CAD/CAM',
    'Introduction to Tribology 1',
    // PE
    'Production Engineering', 'Operations Research', 'Applied Reliability Engineering 1',
    'Material Science', 'Computational Project Management 1', 'Experimental Quality Control',
    'Contemporary Industrial Robotics', 'Theoretical Six Sigma 3',
    'Fundamentals of Quality Control', 'Contemporary Ergonomics 1',
    'Computational Ergonomics 1', 'Applied Lean Manufacturing 2',
    'Computational Industrial Robotics 2', 'Introduction to Industrial Management',
    'Principles of Quality Control 2', 'Contemporary Systems Engineering 1',
    'Introduction to Ergonomics', 'Contemporary Operations Management',
    'Facilities Planning 2', 'Computational Operations Management 3',
    'Contemporary Industrial Management 2', 'Fundamentals of Systems Engineering 3',
    'Contemporary Systems Engineering 2', 'Principles of Industrial Management',
    'Fundamentals of Quality Control 1', 'Theoretical Industrial Management 1',
    'Advanced Computer Integrated Manufacturing', 'Applied Industrial Robotics',
    'Advanced Operations Management', 'Advanced Supply Chain Management',
    'Contemporary Supply Chain Management 1', 'Contemporary Operations Management 3',
    'Advanced Manufacturing Processes 2', 'Advanced Lean Manufacturing 2',
    'Advanced Reliability Engineering 3', 'Principles of Operations Management',
    'Material Science 1', 'Applied Industrial Robotics 3',
    'Principles of Operations Management 1', 'Computational Six Sigma 1',
    'Principles of Computer Integrated Manufacturing',
    'Theoretical Manufacturing Processes 2', 'Theoretical Project Management 2',
    'Theoretical Computer Integrated Manufacturing 2', 'Theoretical Manufacturing Processes',
    'Principles of Ergonomics 2', 'Industrial Robotics 3',
    'Advanced Computer Integrated Manufacturing 3', 'Six Sigma 3',
  ],
};