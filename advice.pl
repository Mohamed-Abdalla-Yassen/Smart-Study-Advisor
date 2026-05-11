:- dynamic student/5.
:- dynamic completed/2.

match_difficulty(StudentDiffs, Course) :-
    course(Course, _, CourseDiff, _),
    member(CourseDiff, StudentDiffs).

match_interests(Prefs, Course) :-
    course_tag(Course, Tag),
    member(Tag, Prefs).

check_prerequisites(Student, Course) :-
    forall(prerequisite(Course, PreReq), completed(Student, PreReq)).


% Tier 1 (100%): Same dept, within year, interests match, difficulty ok, prereqs met
recommend_tier1(Student, Course) :-
    student(Student, Dept, CurrentYear, Prefs, AllowedDiffs),
    course(Course, Dept, _, CourseYear),
    CourseYear =< CurrentYear,
    \+ completed(Student, Course),
    check_prerequisites(Student, Course),
    match_interests(Prefs, Course),
    match_difficulty(AllowedDiffs, Course).

% Tier 2 (70%): Same dept, within year, prereqs met, difficulty ok, interests don't match
recommend_tier2(Student, Course) :-
    student(Student, Dept, CurrentYear, Prefs, AllowedDiffs),
    course(Course, Dept, _, CourseYear),
    CourseYear =< CurrentYear,
    \+ completed(Student, Course),
    check_prerequisites(Student, Course),
    \+ match_interests(Prefs, Course),
    match_difficulty(AllowedDiffs, Course).

% Tier 3 (50%): Same dept, within year, prereqs met, neither interest nor difficulty match
recommend_tier3(Student, Course) :-
    student(Student, Dept, CurrentYear, Prefs, AllowedDiffs),
    course(Course, Dept, _, CourseYear),
    CourseYear =< CurrentYear,
    \+ completed(Student, Course),
    check_prerequisites(Student, Course),
    \+ match_interests(Prefs, Course),
    \+ match_difficulty(AllowedDiffs, Course).

% Tier 4 (20%): Future course, prereqs met, neither interest nor difficulty match
recommend_tier4(Student, Course) :-
    student(Student, Dept, CurrentYear, Prefs, AllowedDiffs),
    course(Course, Dept, _, CourseYear),
    CourseYear > CurrentYear,
    \+ completed(Student, Course),
    check_prerequisites(Student, Course),
    \+ match_interests(Prefs, Course),
    \+ match_difficulty(AllowedDiffs, Course).

% recommend(Student, Course)
%recommend(Student, Course) :-
%    student(Student, Dept, CurrentYear, Prefs),
%    course(Course, Dept, _Difficulty, CourseYear),
%    CourseYear =< CurrentYear,
%    \+ completed(Student, Course),
%    check_prerequisites(Student, Course),
%    match_interests(Prefs, Course).
% -----------------------------------------------------------------
% 3. KNOWLEDGE BASE — COURSE FACTS
% Format: course(Name, Department, Difficulty, Year)
% -----------------------------------------------------------------

course('Mathematics 1 (Calculus)', 'Basic and Applied Sciences', 'Hard', 2).
course('Mathematics 2 (Integration)', 'Basic and Applied Sciences', 'Hard', 4).
course('Mathematics 3 (Differential Equations)', 'Basic and Applied Sciences', 'Hard', 3).
course('Physics 1 (Mechanics)', 'Basic and Applied Sciences', 'Medium', 1).
course('Physics 2 (Electricity)', 'Basic and Applied Sciences', 'Hard', 2).
course('Engineering Chemistry', 'Basic and Applied Sciences', 'Medium', 4).
course('Engineering Mechanics 1', 'Basic and Applied Sciences', 'Medium', 1).
course('Engineering Mechanics 2', 'Basic and Applied Sciences', 'Hard', 3).
course('Introduction to Computer Engineering', 'CSE', 'Easy', 3).
course('Computer Programming (C/C++)', 'CSE', 'Medium', 4).
course('Object-Oriented Programming', 'CSE', 'Medium', 3).
course('Data Structures and Algorithms', 'CSE', 'Hard', 4).
course('Artificial Intelligence', 'CSE', 'Hard', 2).
course('Electrical Circuits 1', 'EE', 'Medium', 1).
course('Electrical Circuits 2', 'EE', 'Hard', 2).
course('Digital Electronics', 'EE', 'Medium', 3).
course('Engineering Thermodynamics', 'ME', 'Hard', 4).
course('Fluid Mechanics', 'ME', 'Hard', 3).
course('Machine Design 1', 'ME', 'Medium', 1).
course('Structural Analysis 1', 'CE', 'Medium', 1).
course('Surveying', 'CE', 'Medium', 2).
course('Production Engineering', 'PE', 'Medium', 2).
course('Operations Research', 'PE', 'Hard', 3).
course('Architectural Design 1', 'Architecture', 'Hard', 2).
course('History of Architecture', 'Architecture', 'Medium', 3).
course('Technical Report Writing', 'Humanities', 'Easy', 3).
course('Engineering Economy', 'Humanities', 'Medium', 4).
course('Network Security 1', 'CSE', 'Easy', 2).
course('Applied Satellite Communications 3', 'EE', 'Medium', 3).
course('Advanced Robotics and Automation 2', 'ME', 'Easy', 4).
course('Applied Reliability Engineering 1', 'PE', 'Hard', 3).
course('Applied Reinforced Concrete Design 1', 'CE', 'Hard', 5).
course('Applied City Planning 2', 'Architecture', 'Easy', 5).
course('Experimental Calculus of Variations', 'Basic and Applied Sciences', 'Easy', 3).
course('Theoretical Public Speaking 3', 'Humanities', 'Medium', 4).
course('Experimental Quantum Computing 2', 'CSE', 'Easy', 5).
course('Theoretical Electronic Devices 1', 'EE', 'Easy', 5).
course('Theoretical Advanced Manufacturing', 'ME', 'Easy', 2).
course('Material Science', 'PE', 'Hard', 4).
course('Contemporary GIS 1', 'CE', 'Hard', 3).
course('Introduction to Urban Planning', 'Architecture', 'Easy', 2).
course('Applied Tensor Analysis 1', 'Basic and Applied Sciences', 'Hard', 3).
course('Applied Technical Communication 2', 'Humanities', 'Medium', 1).
course('Applied Robotics 3', 'CSE', 'Medium', 1).
course('Theoretical Smart Grids', 'EE', 'Medium', 4).
course('Experimental HVAC Systems 3', 'ME', 'Easy', 3).
course('Computational Project Management 1', 'PE', 'Hard', 2).
course('Advanced Steel Structures', 'CE', 'Hard', 3).
course('Advanced Environmental Control 3', 'Architecture', 'Easy', 1).
course('Principles of Discrete Mathematics 2', 'Basic and Applied Sciences', 'Hard', 4).
course('Theoretical Human Rights 2', 'Humanities', 'Hard', 4).
course('Principles of Compiler Design 3', 'CSE', 'Medium', 5).
course('Computational Power Electronics', 'EE', 'Hard', 3).
course('Advanced Tribology', 'ME', 'Hard', 2).
course('Experimental Quality Control', 'PE', 'Hard', 2).
course('Properties of Materials 3', 'CE', 'Medium', 1).
course('Applied Architectural Acoustics 2', 'Architecture', 'Easy', 3).
course('Fundamentals of Astrophysics', 'Basic and Applied Sciences', 'Easy', 2).
course('Computational Sociology 3', 'Humanities', 'Medium', 5).
course('Computational Database Systems', 'CSE', 'Hard', 3).
course('Advanced Electronic Devices 3', 'EE', 'Hard', 5).
course('Theoretical Heat and Mass Transfer', 'ME', 'Easy', 3).
course('Contemporary Industrial Robotics', 'PE', 'Medium', 5).
course('Transportation Engineering 3', 'CE', 'Easy', 1).
course('Applied Urban Sociology', 'Architecture', 'Medium', 1).
course('Fundamentals of Organic Chemistry', 'Basic and Applied Sciences', 'Hard', 2).
course('Fundamentals of Organizational Behavior 2', 'Humanities', 'Hard', 1).
course('Computational Network Security 2', 'CSE', 'Medium', 2).
course('Contemporary Microwave Engineering 1', 'EE', 'Easy', 4).
course('Contemporary Nanotechnology 1', 'ME', 'Medium', 2).
course('Theoretical Six Sigma 3', 'PE', 'Hard', 5).
course('Fundamentals of Hydrology 1', 'CE', 'Hard', 1).
course('Contemporary Historic Preservation 2', 'Architecture', 'Easy', 3).
course('Introduction to Thermodynamics of Materials', 'Basic and Applied Sciences', 'Easy', 4).
course('Principles of Macroeconomics', 'Humanities', 'Hard', 1).
course('Introduction to Distributed Systems', 'CSE', 'Hard', 2).
course('Applied Digital Signal Processing', 'EE', 'Hard', 5).
course('Advanced Fracture Mechanics 3', 'ME', 'Easy', 3).
course('Fundamentals of Quality Control', 'PE', 'Easy', 2).
course('Advanced Reinforced Concrete Design', 'CE', 'Hard', 1).
course('Computational Housing Development 1', 'Architecture', 'Hard', 1).
course('Fundamentals of Modern Physics 3', 'Basic and Applied Sciences', 'Easy', 2).
course('Introduction to Engineering Law', 'Humanities', 'Easy', 2).
course('Theoretical Network Security 1', 'CSE', 'Easy', 3).
course('Theoretical Control Systems 2', 'EE', 'Medium', 1).
course('Advanced Energy Conversion', 'ME', 'Medium', 1).
course('Contemporary Ergonomics 1', 'PE', 'Medium', 1).
course('Wastewater Management 2', 'CE', 'Medium', 2).
course('Theoretical Building Information Modeling 2', 'Architecture', 'Medium', 2).
course('Principles of Numerical Analysis 1', 'Basic and Applied Sciences', 'Medium', 3).
course('Fundamentals of Business Communication 3', 'Humanities', 'Easy', 5).
course('Principles of Cloud Computing', 'CSE', 'Medium', 4).
course('Smart Grids', 'EE', 'Hard', 3).
course('Principles of Aerospace Engineering 2', 'ME', 'Medium', 2).
course('Computational Ergonomics 1', 'PE', 'Hard', 5).
course('Coastal Engineering', 'CE', 'Hard', 1).
course('Experimental Parametric Design 3', 'Architecture', 'Medium', 1).
course('Advanced Calculus of Variations 2', 'Basic and Applied Sciences', 'Easy', 5).
course('Applied Macroeconomics', 'Humanities', 'Easy', 4).
course('Experimental Formal Languages 1', 'CSE', 'Hard', 1).
course('Computational Smart Grids 3', 'EE', 'Hard', 1).
course('Experimental Composite Materials 3', 'ME', 'Medium', 4).
course('Applied Lean Manufacturing 2', 'PE', 'Hard', 4).
course('Applied Construction Management 1', 'CE', 'Easy', 5).
course('Applied Interior Design 1', 'Architecture', 'Hard', 3).
course('Applied Astrophysics 2', 'Basic and Applied Sciences', 'Easy', 2).
course('Professional Ethics 2', 'Humanities', 'Medium', 1).
course('Principles of Network Security', 'CSE', 'Medium', 1).
course('Contemporary Power Electronics 3', 'EE', 'Hard', 3).
course('Theoretical Tribology 2', 'ME', 'Easy', 5).
course('Computational Industrial Robotics 2', 'PE', 'Medium', 3).
course('Applied Coastal Engineering 2', 'CE', 'Medium', 4).
course('Contemporary Urban Design 1', 'Architecture', 'Easy', 2).
course('Contemporary Biophysics 3', 'Basic and Applied Sciences', 'Easy', 4).
course('Contemporary Microeconomics', 'Humanities', 'Hard', 3).
course('Introduction to Operating Systems 1', 'CSE', 'Easy', 2).
course('Principles of Radar Systems 1', 'EE', 'Easy', 4).
course('Principles of Energy Conversion 2', 'ME', 'Hard', 2).
course('Introduction to Industrial Management', 'PE', 'Hard', 1).
course('Fundamentals of Construction Management 2', 'CE', 'Hard', 1).
course('Parametric Design 3', 'Architecture', 'Hard', 1).
course('Computational Statistics 3', 'Basic and Applied Sciences', 'Hard', 3).
course('Computational Macroeconomics 1', 'Humanities', 'Hard', 3).
course('Theoretical Distributed Systems 1', 'CSE', 'Easy', 1).
course('Theoretical High Voltage Engineering 2', 'EE', 'Hard', 3).
course('Computational Tribology 1', 'ME', 'Hard', 4).
course('Principles of Quality Control 2', 'PE', 'Medium', 1).
course('Computational Hydrology 1', 'CE', 'Easy', 3).
course('Introduction to Parametric Design', 'Architecture', 'Hard', 3).
course('Theoretical Linear Algebra', 'Basic and Applied Sciences', 'Hard', 5).
course('Introduction to Technical Communication', 'Humanities', 'Hard', 2).
course('Theoretical Distributed Systems 3', 'CSE', 'Hard', 3).
course('Theoretical Electrical Power', 'EE', 'Medium', 1).
course('Experimental Refrigeration and Air Conditioning 3', 'ME', 'Easy', 1).
course('Contemporary Systems Engineering 1', 'PE', 'Easy', 1).
course('Fundamentals of Highway Engineering', 'CE', 'Medium', 2).
course('Introduction to Digital Fabrication 1', 'Architecture', 'Medium', 3).
course('Applied Discrete Mathematics 2', 'Basic and Applied Sciences', 'Easy', 4).
course('Introduction to Industrial Psychology', 'Humanities', 'Medium', 3).
course('Advanced Data Mining', 'CSE', 'Hard', 1).
course('Introduction to Biomedical Instrumentation', 'EE', 'Medium', 4).
course('Principles of Kinematics 3', 'ME', 'Medium', 3).
course('Introduction to Ergonomics', 'PE', 'Easy', 4).
course('Experimental Bridge Engineering 1', 'CE', 'Hard', 1).
course('Architectural Acoustics 3', 'Architecture', 'Easy', 1).
course('Experimental Numerical Analysis 1', 'Basic and Applied Sciences', 'Hard', 3).
course('Advanced Engineering Law 3', 'Humanities', 'Hard', 5).
course('Fundamentals of Big Data Analytics 2', 'CSE', 'Hard', 3).
course('Principles of Satellite Communications 3', 'EE', 'Medium', 3).
course('Applied Automotive Engineering 2', 'ME', 'Hard', 5).
course('Contemporary Operations Management', 'PE', 'Medium', 1).
course('Contemporary Pavement Design 1', 'CE', 'Hard', 2).
course('Contemporary Environmental Control 3', 'Architecture', 'Easy', 1).
course('Introduction to Calculus of Variations', 'Basic and Applied Sciences', 'Hard', 3).
course('Principles of Philosophy of Science 3', 'Humanities', 'Easy', 1).
course('Contemporary Data Mining', 'CSE', 'Medium', 3).
course('Contemporary Power Electronics 1', 'EE', 'Hard', 3).
course('Advanced Kinematics', 'ME', 'Hard', 2).
course('Facilities Planning 2', 'PE', 'Hard', 2).
course('Applied Earthquake Engineering 3', 'CE', 'Medium', 5).
course('Theoretical Sustainable Architecture 2', 'Architecture', 'Medium', 2).
course('Contemporary Modern Physics 1', 'Basic and Applied Sciences', 'Hard', 3).
course('Contemporary Industrial Psychology 1', 'Humanities', 'Hard', 3).
course('Theoretical Computer Architecture', 'CSE', 'Medium', 4).
course('Experimental Biomedical Instrumentation 1', 'EE', 'Easy', 1).
course('Advanced CAD/CAM', 'ME', 'Medium', 4).
course('Computational Operations Management 3', 'PE', 'Easy', 1).
course('Advanced Properties of Materials 2', 'CE', 'Easy', 1).
course('Applied Housing Development 1', 'Architecture', 'Hard', 5).
course('Introduction to Linear Algebra', 'Basic and Applied Sciences', 'Easy', 2).
course('Professional Ethics 3', 'Humanities', 'Hard', 3).
course('Contemporary Compiler Design 2', 'CSE', 'Easy', 1).
course('Introduction to Optical Communications', 'EE', 'Easy', 3).
course('Applied Internal Combustion Engines 2', 'ME', 'Hard', 2).
course('Contemporary Industrial Management 2', 'PE', 'Medium', 3).
course('Experimental Hydrology 2', 'CE', 'Hard', 1).
course('Building Information Modeling 2', 'Architecture', 'Medium', 1).
course('Advanced Tensor Analysis', 'Basic and Applied Sciences', 'Medium', 2).
course('Computational Microeconomics 2', 'Humanities', 'Medium', 5).
course('Computational Embedded Systems', 'CSE', 'Hard', 1).
course('Experimental Signals and Systems 3', 'EE', 'Medium', 4).
course('Applied Nanotechnology 2', 'ME', 'Medium', 5).
course('Fundamentals of Systems Engineering 3', 'PE', 'Medium', 1).
course('Introduction to Traffic Engineering 1', 'CE', 'Medium', 5).
course('Advanced Lighting Design', 'Architecture', 'Easy', 5).
course('Fundamentals of Thermodynamics of Materials', 'Basic and Applied Sciences', 'Hard', 3).
course('Entrepreneurship 2', 'Humanities', 'Medium', 4).
course('Computational Internet of Things', 'CSE', 'Easy', 2).
course('Contemporary Biomedical Instrumentation 3', 'EE', 'Medium', 1).
course('Fundamentals of Kinematics', 'ME', 'Easy', 1).
course('Contemporary Systems Engineering 2', 'PE', 'Hard', 5).
course('Principles of Transportation Engineering 2', 'CE', 'Hard', 1).
course('Experimental Urban Planning 1', 'Architecture', 'Easy', 5).
course('Principles of Statistics', 'Basic and Applied Sciences', 'Medium', 2).
course('Contemporary Entrepreneurship 3', 'Humanities', 'Easy', 4).
course('Introduction to Game Development', 'CSE', 'Hard', 5).
course('Principles of Control Systems 1', 'EE', 'Medium', 4).
course('Principles of Acoustics', 'ME', 'Easy', 1).
course('Principles of Industrial Management', 'PE', 'Medium', 5).
course('Experimental Reinforced Concrete Design', 'CE', 'Easy', 5).
course('Applied Building Construction', 'Architecture', 'Hard', 2).
course('Theoretical Inorganic Chemistry 2', 'Basic and Applied Sciences', 'Hard', 3).
course('Advanced Virtual Reality 3', 'CSE', 'Hard', 2).
course('Radar Systems', 'EE', 'Easy', 4).
course('Experimental Automotive Engineering 1', 'ME', 'Medium', 5).
course('Fundamentals of Quality Control 1', 'PE', 'Medium', 4).
course('Tunnel Engineering 3', 'CE', 'Easy', 3).
course('Computational Parametric Design 3', 'Architecture', 'Hard', 1).
course('Numerical Analysis 2', 'Basic and Applied Sciences', 'Easy', 3).
course('Contemporary Fundamentals of Management', 'Humanities', 'Medium', 5).
course('Algorithms', 'CSE', 'Hard', 2).
course('Advanced Electromagnetic Fields 2', 'EE', 'Medium', 2).
course('Heat and Mass Transfer 1', 'ME', 'Hard', 4).
course('Theoretical Industrial Management 1', 'PE', 'Medium', 5).
course('Applied Wastewater Management', 'CE', 'Easy', 1).
course('Fundamentals of Urban Sociology 2', 'Architecture', 'Medium', 4).
course('Theoretical Statistics', 'Basic and Applied Sciences', 'Hard', 2).
course('Applied Distributed Systems 1', 'CSE', 'Medium', 2).
course('Computational Electromagnetic Fields', 'EE', 'Easy', 4).
course('Fundamentals of Nanotechnology 2', 'ME', 'Hard', 5).
course('Advanced Computer Integrated Manufacturing', 'PE', 'Medium', 3).
course('Introduction to Earthquake Engineering', 'CE', 'Hard', 1).
course('Applied Lighting Design 3', 'Architecture', 'Easy', 2).
course('Experimental Numerical Analysis', 'Basic and Applied Sciences', 'Hard', 3).
course('Introduction to Philosophy of Science', 'Humanities', 'Medium', 5).
course('Theoretical Cybersecurity', 'CSE', 'Easy', 1).
course('Computational Electrical Power 3', 'EE', 'Hard', 3).
course('Principles of Finite Element Analysis 3', 'ME', 'Easy', 2).
course('Applied Industrial Robotics', 'PE', 'Easy', 5).
course('Traffic Engineering 3', 'CE', 'Hard', 4).
course('Contemporary Urban Planning 1', 'Architecture', 'Easy', 1).
course('Experimental Quantum Mechanics 1', 'Basic and Applied Sciences', 'Hard', 3).
course('Computational Technical Communication', 'Humanities', 'Hard', 5).
course('Fundamentals of Software Engineering 1', 'CSE', 'Hard', 3).
course('Advanced Communication Theory', 'EE', 'Medium', 1).
course('Theoretical Theory of Machines', 'ME', 'Hard', 5).
course('Advanced Operations Management', 'PE', 'Hard', 5).
course('Fundamentals of Wastewater Management 3', 'CE', 'Hard', 4).
course('Computational Lighting Design 3', 'Architecture', 'Easy', 2).
course('Principles of Discrete Mathematics 1', 'Basic and Applied Sciences', 'Hard', 4).
course('Contemporary Microeconomics 1', 'Humanities', 'Hard', 4).
course('Introduction to Cybersecurity', 'CSE', 'Medium', 4).
course('Smart Grids 2', 'EE', 'Medium', 2).
course('Fundamentals of Internal Combustion Engines 1', 'ME', 'Hard', 4).
course('Advanced Supply Chain Management', 'PE', 'Medium', 4).
course('Applied Soil Mechanics', 'CE', 'Easy', 2).
course('Contemporary Housing Development 1', 'Architecture', 'Hard', 2).
course('Fundamentals of Biophysics 2', 'Basic and Applied Sciences', 'Easy', 5).
course('Fundamentals of Entrepreneurship', 'Humanities', 'Medium', 5).
course('Theoretical Blockchain Technology 3', 'CSE', 'Hard', 1).
course('Computational Communication Theory', 'EE', 'Easy', 5).
course('Computational Robotics and Automation 3', 'ME', 'Hard', 5).
course('Contemporary Supply Chain Management 1', 'PE', 'Hard', 1).
course('Advanced Wastewater Management 3', 'CE', 'Easy', 4).
course('Urban Design', 'Architecture', 'Medium', 3).
course('Theoretical Discrete Mathematics 1', 'Basic and Applied Sciences', 'Hard', 3).
course('Fundamentals of Human Rights 3', 'Humanities', 'Hard', 2).
course('Fundamentals of Algorithms 3', 'CSE', 'Medium', 5).
course('Fundamentals of Control Systems 1', 'EE', 'Hard', 1).
course('Introduction to Energy Conversion', 'ME', 'Hard', 2).
course('Contemporary Operations Management 3', 'PE', 'Hard', 4).
course('Pavement Design 2', 'CE', 'Medium', 3).
course('Landscape Architecture 1', 'Architecture', 'Medium', 1).
course('Modern Physics 3', 'Basic and Applied Sciences', 'Medium', 4).
course('Technical Communication 3', 'Humanities', 'Easy', 1).
course('Applied Bioinformatics 1', 'CSE', 'Easy', 1).
course('Experimental Satellite Communications', 'EE', 'Hard', 1).
course('Introduction to Dynamics', 'ME', 'Medium', 4).
course('Advanced Manufacturing Processes 2', 'PE', 'Medium', 2).
course('Introduction to Bridge Engineering', 'CE', 'Hard', 1).
course('Computational Digital Fabrication 2', 'Architecture', 'Easy', 5).
course('Introduction to Biophysics', 'Basic and Applied Sciences', 'Medium', 3).
course('Professional Ethics 1', 'Humanities', 'Medium', 4).
course('Fundamentals of Web Development', 'CSE', 'Medium', 5).
course('Advanced Electronic Devices 2', 'EE', 'Hard', 5).
course('Fundamentals of Computational Fluid Dynamics', 'ME', 'Hard', 5).
course('Advanced Lean Manufacturing 2', 'PE', 'Hard', 4).
course('Advanced Geotechnical Engineering 3', 'CE', 'Hard', 2).
course('Parametric Design', 'Architecture', 'Hard', 5).
course('Principles of Public Speaking 3', 'Humanities', 'Hard', 3).
course('Theoretical Virtual Reality 3', 'CSE', 'Easy', 5).
course('Computational Electrical Machines 1', 'EE', 'Medium', 4).
course('Principles of Turbomachinery 3', 'ME', 'Easy', 5).
course('Advanced Reliability Engineering 3', 'PE', 'Hard', 3).
course('Construction Management 3', 'CE', 'Easy', 1).
course('Applied Landscape Architecture 2', 'Architecture', 'Hard', 5).
course('Introduction to Topology', 'Basic and Applied Sciences', 'Hard', 5).
course('Theoretical Philosophy of Science 3', 'Humanities', 'Medium', 5).
course('Contemporary Distributed Systems 1', 'CSE', 'Easy', 2).
course('Fundamentals of Digital Signal Processing', 'EE', 'Easy', 3).
course('Fundamentals of Finite Element Analysis 2', 'ME', 'Easy', 3).
course('Principles of Operations Management', 'PE', 'Easy', 2).
course('Experimental Coastal Engineering', 'CE', 'Hard', 1).
course('Advanced Building Construction 3', 'Architecture', 'Easy', 3).
course('Contemporary Modern Physics 2', 'Basic and Applied Sciences', 'Medium', 1).
course('Advanced Fundamentals of Management 2', 'Humanities', 'Hard', 4).
course('Theoretical Data Mining 3', 'CSE', 'Easy', 5).
course('Theoretical Industrial Automation 2', 'EE', 'Easy', 4).
course('Introduction to Internal Combustion Engines', 'ME', 'Medium', 4).
course('Material Science 1', 'PE', 'Easy', 1).
course('Experimental GIS 2', 'CE', 'Hard', 4).
course('Contemporary Digital Fabrication', 'Architecture', 'Medium', 1).
course('Fundamentals of Astrophysics 2', 'Basic and Applied Sciences', 'Hard', 4).
course('Experimental Fundamentals of Management 1', 'Humanities', 'Medium', 5).
course('Internet of Things 2', 'CSE', 'Easy', 2).
course('Electrical Machines 1', 'EE', 'Hard', 5).
course('Advanced Fracture Mechanics', 'ME', 'Hard', 3).
course('Applied Industrial Robotics 3', 'PE', 'Medium', 2).
course('Experimental Highway Engineering 2', 'CE', 'Medium', 3).
course('Experimental Historic Preservation 2', 'Architecture', 'Easy', 5).
course('Fundamentals of Topology 1', 'Basic and Applied Sciences', 'Medium', 1).
course('Organizational Behavior', 'Humanities', 'Medium', 2).
course('Computational Robotics 3', 'CSE', 'Hard', 3).
course('Contemporary Communication Theory 3', 'EE', 'Easy', 2).
course('Principles of Operations Management 1', 'PE', 'Medium', 4).
course('Theoretical Reinforced Concrete Design', 'CE', 'Hard', 3).
course('Computational Landscape Architecture 3', 'Architecture', 'Easy', 5).
course('Fundamentals of Statistics 1', 'Basic and Applied Sciences', 'Easy', 5).
course('Advanced Organizational Behavior', 'Humanities', 'Easy', 1).
course('Applied Human-Computer Interaction 2', 'CSE', 'Medium', 1).
course('Experimental Digital Signal Processing 1', 'EE', 'Easy', 5).
course('Experimental Composite Materials', 'ME', 'Easy', 2).
course('Computational Six Sigma 1', 'PE', 'Hard', 5).
course('Steel Structures 3', 'CE', 'Easy', 3).
course('Theoretical Housing Development 1', 'Architecture', 'Easy', 1).
course('Thermodynamics of Materials 1', 'Basic and Applied Sciences', 'Hard', 4).
course('Industrial Psychology', 'Humanities', 'Medium', 1).
course('Contemporary Compiler Design 1', 'CSE', 'Easy', 3).
course('Theoretical High Voltage Engineering', 'EE', 'Hard', 4).
course('Applied Kinematics 1', 'ME', 'Easy', 5).
course('Principles of Computer Integrated Manufacturing', 'PE', 'Medium', 1).
course('Applied Bridge Engineering 2', 'CE', 'Medium', 5).
course('Experimental Landscape Architecture 1', 'Architecture', 'Hard', 2).
course('Applied Linear Algebra 2', 'Basic and Applied Sciences', 'Hard', 1).
course('Public Speaking 2', 'Humanities', 'Easy', 5).
course('Advanced Embedded Systems 2', 'CSE', 'Medium', 3).
course('Principles of Digital Signal Processing 2', 'EE', 'Hard', 3).
course('Fundamentals of Internal Combustion Engines 3', 'ME', 'Easy', 3).
course('Theoretical Manufacturing Processes 2', 'PE', 'Medium', 5).
course('Advanced Highway Engineering', 'CE', 'Hard', 2).
course('Applied Environmental Control 1', 'Architecture', 'Hard', 1).
course('Contemporary Modern Physics 3', 'Basic and Applied Sciences', 'Hard', 3).
course('Experimental Philosophy of Science 1', 'Humanities', 'Hard', 4).
course('Computational Natural Language Processing', 'CSE', 'Medium', 5).
course('Fundamentals of Optical Communications 2', 'EE', 'Easy', 4).
course('Contemporary Aerospace Engineering 2', 'ME', 'Easy', 5).
course('Theoretical Project Management 2', 'PE', 'Medium', 2).
course('Contemporary Advanced Steel Design 2', 'CE', 'Hard', 3).
course('Advanced Historic Preservation 3', 'Architecture', 'Medium', 4).
course('Fundamentals of Statistics 3', 'Basic and Applied Sciences', 'Easy', 2).
course('Principles of Human Rights 1', 'Humanities', 'Medium', 2).
course('Contemporary Cybersecurity', 'CSE', 'Easy', 3).
course('Theoretical Power Electronics 2', 'EE', 'Medium', 3).
course('Robotics and Automation 2', 'ME', 'Medium', 4).
course('Theoretical Computer Integrated Manufacturing 2', 'PE', 'Hard', 4).
course('Principles of Construction Management 2', 'CE', 'Hard', 3).
course('Applied Urban Planning', 'Architecture', 'Hard', 4).
course('Computational Inorganic Chemistry 3', 'Basic and Applied Sciences', 'Hard', 5).
course('Theoretical Public Speaking', 'Humanities', 'Hard', 5).
course('Applied Internet of Things 3', 'CSE', 'Medium', 4).
course('Introduction to High Voltage Engineering', 'EE', 'Medium', 3).
course('Fundamentals of Nanotechnology 3', 'ME', 'Hard', 4).
course('Theoretical Manufacturing Processes', 'PE', 'Hard', 4).
course('Bridge Engineering 3', 'CE', 'Medium', 4).
course('Advanced Urban Sociology', 'Architecture', 'Medium', 4).
course('Linear Algebra 2', 'Basic and Applied Sciences', 'Easy', 2).
course('Computational Business Communication 1', 'Humanities', 'Hard', 2).
course('Theoretical Cryptography', 'CSE', 'Easy', 4).
course('Computational Industrial Automation', 'EE', 'Medium', 5).
course('Theoretical Aerospace Engineering 1', 'ME', 'Medium', 1).
course('Principles of Ergonomics 2', 'PE', 'Easy', 1).
course('Experimental Transportation Engineering 1', 'CE', 'Medium', 2).
course('Principles of Interior Design 3', 'Architecture', 'Easy', 2).
course('Computational Philosophy of Science', 'Humanities', 'Easy', 1).
course('Introduction to Software Testing', 'CSE', 'Easy', 4).
course('Fundamentals of Antenna Theory 1', 'EE', 'Easy', 3).
course('Fundamentals of Refrigeration and Air Conditioning 1', 'ME', 'Easy', 4).
course('Industrial Robotics 3', 'PE', 'Hard', 3).
course('Contemporary Bridge Engineering 1', 'CE', 'Easy', 3).
course('Computational Building Construction 2', 'Architecture', 'Medium', 2).
course('Applied Optics 1', 'Basic and Applied Sciences', 'Medium', 5).
course('Fundamentals of Macroeconomics 3', 'Humanities', 'Hard', 4).
course('Applied Formal Languages 2', 'CSE', 'Easy', 5).
course('VLSI Design 2', 'EE', 'Hard', 4).
course('Principles of Automotive Engineering 2', 'ME', 'Easy', 4).
course('Fundamentals of Bridge Engineering 2', 'CE', 'Medium', 4).
course('Experimental Building Construction 2', 'Architecture', 'Medium', 3).
course('Quantum Mechanics 3', 'Basic and Applied Sciences', 'Medium', 5).
course('Advanced Business Communication 2', 'Humanities', 'Easy', 2).
course('Bioinformatics 1', 'CSE', 'Hard', 4).
course('Principles of CAD/CAM', 'ME', 'Easy', 2).
course('Advanced Computer Integrated Manufacturing 3', 'PE', 'Medium', 2).
course('Hydrology 1', 'CE', 'Medium', 2).
course('Digital Fabrication 2', 'Architecture', 'Hard', 1).
course('Fundamentals of Calculus of Variations 3', 'Basic and Applied Sciences', 'Easy', 3).
course('Experimental Macroeconomics 2', 'Humanities', 'Hard', 4).
course('Experimental Digital Logic 2', 'CSE', 'Medium', 5).
course('Applied Electromagnetic Fields 3', 'EE', 'Easy', 3).
course('Introduction to Tribology 1', 'ME', 'Easy', 5).
course('Six Sigma 3', 'PE', 'Medium', 4).

% -----------------------------------------------------------------
% 4. KNOWLEDGE BASE — PREREQUISITES
% Format: prerequisite(Course, RequiredCourse)
% -----------------------------------------------------------------

prerequisite('Mathematics 2 (Integration)', 'Intro to Basic and Applied Sciences').
prerequisite('Physics 2 (Electricity)', 'Intro to Basic and Applied Sciences').
prerequisite('Engineering Mechanics 1', 'Intro to Basic and Applied Sciences').
prerequisite('Engineering Mechanics 2', 'Intro to Basic and Applied Sciences').
prerequisite('Data Structures and Algorithms', 'Intro to CSE').
prerequisite('Digital Electronics', 'Intro to EE').
prerequisite('Engineering Thermodynamics', 'Intro to ME').
prerequisite('Fluid Mechanics', 'Intro to ME').
prerequisite('Surveying', 'Intro to CE').
prerequisite('Operations Research', 'Intro to PE').
prerequisite('Architectural Design 1', 'Intro to Architecture').
prerequisite('History of Architecture', 'Intro to Architecture').
prerequisite('Technical Report Writing', 'Intro to Humanities').
prerequisite('Network Security 1', 'Physics').
prerequisite('Applied Satellite Communications 3', 'Intro to EE').
prerequisite('Advanced Robotics and Automation 2', 'Physics').
prerequisite('Applied City Planning 2', 'Intro to Architecture').
prerequisite('Experimental Calculus of Variations', 'Calculus').
prerequisite('Theoretical Public Speaking 3', 'Intro to Humanities').
prerequisite('Experimental Quantum Computing 2', 'Physics').
prerequisite('Theoretical Electronic Devices 1', 'Calculus').
prerequisite('Theoretical Advanced Manufacturing', 'Intro to ME').
prerequisite('Material Science', 'Intro to PE').
prerequisite('Contemporary GIS 1', 'Physics').
prerequisite('Introduction to Urban Planning', 'Physics').
prerequisite('Applied Tensor Analysis 1', 'Intro to Basic and Applied Sciences').
prerequisite('Applied Technical Communication 2', 'Programming 1').
prerequisite('Theoretical Smart Grids', 'Physics').
prerequisite('Experimental HVAC Systems 3', 'Programming 1').
prerequisite('Computational Project Management 1', 'Calculus').
prerequisite('Advanced Steel Structures', 'Calculus').
prerequisite('Advanced Environmental Control 3', 'Intro to Architecture').
prerequisite('Principles of Discrete Mathematics 2', 'Calculus').
prerequisite('Theoretical Human Rights 2', 'Physics').
prerequisite('Computational Power Electronics', 'Physics').
prerequisite('Experimental Quality Control', 'Physics').
prerequisite('Properties of Materials 3', 'Programming 1').
prerequisite('Applied Architectural Acoustics 2', 'Physics').
prerequisite('Fundamentals of Astrophysics', 'Calculus').
prerequisite('Computational Sociology 3', 'Programming 1').
prerequisite('Computational Database Systems', 'Programming 1').
prerequisite('Advanced Electronic Devices 3', 'Calculus').
prerequisite('Theoretical Heat and Mass Transfer', 'Programming 1').
prerequisite('Contemporary Industrial Robotics', 'Physics').
prerequisite('Transportation Engineering 3', 'Calculus').
prerequisite('Applied Urban Sociology', 'Physics').
prerequisite('Fundamentals of Organic Chemistry', 'Calculus').
prerequisite('Fundamentals of Organizational Behavior 2', 'Intro to Humanities').
prerequisite('Computational Network Security 2', 'Physics').
prerequisite('Contemporary Microwave Engineering 1', 'Programming 1').
prerequisite('Contemporary Nanotechnology 1', 'Calculus').
prerequisite('Theoretical Six Sigma 3', 'Intro to PE').
prerequisite('Fundamentals of Hydrology 1', 'Calculus').
prerequisite('Contemporary Historic Preservation 2', 'Programming 1').
prerequisite('Introduction to Thermodynamics of Materials', 'Programming 1').
prerequisite('Principles of Macroeconomics', 'Calculus').
prerequisite('Introduction to Distributed Systems', 'Intro to CSE').
prerequisite('Applied Digital Signal Processing', 'Calculus').
prerequisite('Advanced Fracture Mechanics 3', 'Intro to ME').
prerequisite('Computational Housing Development 1', 'Physics').
prerequisite('Introduction to Engineering Law', 'Intro to Humanities').
prerequisite('Theoretical Control Systems 2', 'Physics').
prerequisite('Advanced Energy Conversion', 'Programming 1').
prerequisite('Wastewater Management 2', 'Calculus').
prerequisite('Principles of Numerical Analysis 1', 'Programming 1').
prerequisite('Smart Grids', 'Programming 1').
prerequisite('Principles of Aerospace Engineering 2', 'Intro to ME').
prerequisite('Computational Ergonomics 1', 'Intro to PE').
prerequisite('Experimental Parametric Design 3', 'Calculus').
prerequisite('Advanced Calculus of Variations 2', 'Physics').
prerequisite('Applied Macroeconomics', 'Programming 1').
prerequisite('Computational Smart Grids 3', 'Calculus').
prerequisite('Experimental Composite Materials 3', 'Programming 1').
prerequisite('Applied Lean Manufacturing 2', 'Physics').
prerequisite('Applied Construction Management 1', 'Physics').
prerequisite('Applied Astrophysics 2', 'Programming 1').
prerequisite('Principles of Network Security', 'Physics').
prerequisite('Theoretical Tribology 2', 'Programming 1').
prerequisite('Computational Industrial Robotics 2', 'Physics').
prerequisite('Applied Coastal Engineering 2', 'Intro to CE').
prerequisite('Contemporary Urban Design 1', 'Programming 1').
prerequisite('Contemporary Biophysics 3', 'Physics').
prerequisite('Introduction to Operating Systems 1', 'Intro to CSE').
prerequisite('Principles of Radar Systems 1', 'Physics').
prerequisite('Principles of Energy Conversion 2', 'Intro to ME').
prerequisite('Introduction to Industrial Management', 'Physics').
prerequisite('Parametric Design 3', 'Programming 1').
prerequisite('Computational Statistics 3', 'Intro to Basic and Applied Sciences').
prerequisite('Theoretical Distributed Systems 1', 'Intro to CSE').
prerequisite('Computational Tribology 1', 'Intro to ME').
prerequisite('Computational Hydrology 1', 'Programming 1').
prerequisite('Introduction to Parametric Design', 'Physics').
prerequisite('Theoretical Linear Algebra', 'Programming 1').
prerequisite('Introduction to Technical Communication', 'Physics').
prerequisite('Theoretical Distributed Systems 3', 'Physics').
prerequisite('Theoretical Electrical Power', 'Physics').
prerequisite('Experimental Refrigeration and Air Conditioning 3', 'Calculus').
prerequisite('Fundamentals of Highway Engineering', 'Intro to CE').
prerequisite('Introduction to Digital Fabrication 1', 'Calculus').
prerequisite('Applied Discrete Mathematics 2', 'Intro to Basic and Applied Sciences').
prerequisite('Introduction to Industrial Psychology', 'Physics').
prerequisite('Principles of Kinematics 3', 'Programming 1').
prerequisite('Introduction to Ergonomics', 'Intro to PE').
prerequisite('Experimental Bridge Engineering 1', 'Calculus').
prerequisite('Architectural Acoustics 3', 'Calculus').
prerequisite('Experimental Numerical Analysis 1', 'Programming 1').
prerequisite('Advanced Engineering Law 3', 'Calculus').
prerequisite('Fundamentals of Big Data Analytics 2', 'Intro to CSE').
prerequisite('Principles of Satellite Communications 3', 'Physics').
prerequisite('Applied Automotive Engineering 2', 'Physics').
prerequisite('Contemporary Pavement Design 1', 'Physics').
prerequisite('Introduction to Calculus of Variations', 'Calculus').
prerequisite('Principles of Philosophy of Science 3', 'Physics').
prerequisite('Contemporary Data Mining', 'Physics').
prerequisite('Contemporary Power Electronics 1', 'Calculus').
prerequisite('Applied Earthquake Engineering 3', 'Calculus').
prerequisite('Contemporary Modern Physics 1', 'Intro to Basic and Applied Sciences').
prerequisite('Contemporary Industrial Psychology 1', 'Physics').
prerequisite('Theoretical Computer Architecture', 'Calculus').
prerequisite('Experimental Biomedical Instrumentation 1', 'Calculus').
prerequisite('Computational Operations Management 3', 'Calculus').
prerequisite('Advanced Properties of Materials 2', 'Intro to CE').
prerequisite('Applied Housing Development 1', 'Programming 1').
prerequisite('Introduction to Linear Algebra', 'Intro to Basic and Applied Sciences').
prerequisite('Professional Ethics 3', 'Programming 1').
prerequisite('Contemporary Compiler Design 2', 'Intro to CSE').
prerequisite('Introduction to Optical Communications', 'Physics').
prerequisite('Applied Internal Combustion Engines 2', 'Calculus').
prerequisite('Contemporary Industrial Management 2', 'Physics').
prerequisite('Experimental Hydrology 2', 'Programming 1').
prerequisite('Building Information Modeling 2', 'Programming 1').
prerequisite('Advanced Tensor Analysis', 'Physics').
prerequisite('Computational Microeconomics 2', 'Physics').
prerequisite('Experimental Signals and Systems 3', 'Calculus').
prerequisite('Applied Nanotechnology 2', 'Intro to ME').
prerequisite('Advanced Lighting Design', 'Calculus').
prerequisite('Fundamentals of Thermodynamics of Materials', 'Programming 1').
prerequisite('Entrepreneurship 2', 'Physics').
prerequisite('Computational Internet of Things', 'Physics').
prerequisite('Contemporary Biomedical Instrumentation 3', 'Intro to EE').
prerequisite('Fundamentals of Kinematics', 'Intro to ME').
prerequisite('Contemporary Systems Engineering 2', 'Physics').
prerequisite('Principles of Statistics', 'Intro to Basic and Applied Sciences').
prerequisite('Contemporary Entrepreneurship 3', 'Intro to Humanities').
prerequisite('Introduction to Game Development', 'Intro to CSE').
prerequisite('Principles of Control Systems 1', 'Calculus').
prerequisite('Principles of Acoustics', 'Calculus').
prerequisite('Principles of Industrial Management', 'Calculus').
prerequisite('Applied Building Construction', 'Physics').
prerequisite('Theoretical Inorganic Chemistry 2', 'Intro to Basic and Applied Sciences').
prerequisite('Advanced Virtual Reality 3', 'Intro to CSE').
prerequisite('Experimental Automotive Engineering 1', 'Calculus').
prerequisite('Fundamentals of Quality Control 1', 'Intro to PE').
prerequisite('Tunnel Engineering 3', 'Physics').
prerequisite('Computational Parametric Design 3', 'Calculus').
prerequisite('Numerical Analysis 2', 'Calculus').
prerequisite('Contemporary Fundamentals of Management', 'Physics').
prerequisite('Algorithms', 'Programming 1').
prerequisite('Heat and Mass Transfer 1', 'Calculus').
prerequisite('Theoretical Industrial Management 1', 'Programming 1').
prerequisite('Applied Wastewater Management', 'Programming 1').
prerequisite('Fundamentals of Urban Sociology 2', 'Physics').
prerequisite('Theoretical Statistics', 'Programming 1').
prerequisite('Applied Distributed Systems 1', 'Programming 1').
prerequisite('Computational Electromagnetic Fields', 'Programming 1').
prerequisite('Fundamentals of Nanotechnology 2', 'Physics').
prerequisite('Advanced Computer Integrated Manufacturing', 'Physics').
prerequisite('Applied Lighting Design 3', 'Physics').
prerequisite('Experimental Numerical Analysis', 'Programming 1').
prerequisite('Introduction to Philosophy of Science', 'Programming 1').
prerequisite('Theoretical Cybersecurity', 'Intro to CSE').
prerequisite('Computational Electrical Power 3', 'Programming 1').
prerequisite('Principles of Finite Element Analysis 3', 'Programming 1').
prerequisite('Applied Industrial Robotics', 'Physics').
prerequisite('Traffic Engineering 3', 'Intro to CE').
prerequisite('Contemporary Urban Planning 1', 'Physics').
prerequisite('Experimental Quantum Mechanics 1', 'Intro to Basic and Applied Sciences').
prerequisite('Computational Technical Communication', 'Physics').
prerequisite('Advanced Communication Theory', 'Calculus').
prerequisite('Theoretical Theory of Machines', 'Calculus').
prerequisite('Advanced Operations Management', 'Programming 1').
prerequisite('Fundamentals of Wastewater Management 3', 'Programming 1').
prerequisite('Computational Lighting Design 3', 'Calculus').
prerequisite('Principles of Discrete Mathematics 1', 'Programming 1').
prerequisite('Contemporary Microeconomics 1', 'Calculus').
prerequisite('Introduction to Cybersecurity', 'Intro to CSE').
prerequisite('Smart Grids 2', 'Physics').
prerequisite('Fundamentals of Internal Combustion Engines 1', 'Intro to ME').
prerequisite('Advanced Supply Chain Management', 'Intro to PE').
prerequisite('Applied Soil Mechanics', 'Intro to CE').
prerequisite('Contemporary Housing Development 1', 'Programming 1').
prerequisite('Fundamentals of Biophysics 2', 'Intro to Basic and Applied Sciences').
prerequisite('Fundamentals of Entrepreneurship', 'Programming 1').
prerequisite('Theoretical Blockchain Technology 3', 'Programming 1').
prerequisite('Computational Communication Theory', 'Intro to EE').
prerequisite('Computational Robotics and Automation 3', 'Calculus').
prerequisite('Contemporary Supply Chain Management 1', 'Calculus').
prerequisite('Advanced Wastewater Management 3', 'Intro to CE').
prerequisite('Theoretical Discrete Mathematics 1', 'Physics').
prerequisite('Fundamentals of Human Rights 3', 'Physics').
prerequisite('Fundamentals of Algorithms 3', 'Physics').
prerequisite('Fundamentals of Control Systems 1', 'Calculus').
prerequisite('Introduction to Energy Conversion', 'Calculus').
prerequisite('Pavement Design 2', 'Calculus').
prerequisite('Technical Communication 3', 'Calculus').
prerequisite('Applied Bioinformatics 1', 'Physics').
prerequisite('Experimental Satellite Communications', 'Calculus').
prerequisite('Introduction to Dynamics', 'Intro to ME').
prerequisite('Advanced Manufacturing Processes 2', 'Programming 1').
prerequisite('Introduction to Bridge Engineering', 'Calculus').
prerequisite('Computational Digital Fabrication 2', 'Programming 1').
prerequisite('Introduction to Biophysics', 'Physics').
prerequisite('Professional Ethics 1', 'Physics').
prerequisite('Fundamentals of Web Development', 'Intro to CSE').
prerequisite('Advanced Electronic Devices 2', 'Calculus').
prerequisite('Fundamentals of Computational Fluid Dynamics', 'Calculus').
prerequisite('Advanced Geotechnical Engineering 3', 'Physics').
prerequisite('Parametric Design', 'Physics').
prerequisite('Principles of Public Speaking 3', 'Calculus').
prerequisite('Computational Electrical Machines 1', 'Programming 1').
prerequisite('Applied Landscape Architecture 2', 'Physics').
prerequisite('Introduction to Topology', 'Calculus').
prerequisite('Theoretical Philosophy of Science 3', 'Physics').
prerequisite('Contemporary Distributed Systems 1', 'Calculus').
prerequisite('Fundamentals of Finite Element Analysis 2', 'Intro to ME').
prerequisite('Principles of Operations Management', 'Physics').
prerequisite('Experimental Coastal Engineering', 'Physics').
prerequisite('Advanced Building Construction 3', 'Calculus').
prerequisite('Contemporary Modern Physics 2', 'Physics').
prerequisite('Advanced Fundamentals of Management 2', 'Programming 1').
prerequisite('Theoretical Data Mining 3', 'Programming 1').
prerequisite('Introduction to Internal Combustion Engines', 'Programming 1').
prerequisite('Material Science 1', 'Programming 1').
prerequisite('Experimental GIS 2', 'Physics').
prerequisite('Contemporary Digital Fabrication', 'Programming 1').
prerequisite('Experimental Fundamentals of Management 1', 'Intro to Humanities').
prerequisite('Electrical Machines 1', 'Calculus').
prerequisite('Advanced Fracture Mechanics', 'Physics').
prerequisite('Applied Industrial Robotics 3', 'Physics').
prerequisite('Experimental Highway Engineering 2', 'Calculus').
prerequisite('Fundamentals of Topology 1', 'Calculus').
prerequisite('Organizational Behavior', 'Programming 1').
prerequisite('Computational Robotics 3', 'Physics').
prerequisite('Contemporary Communication Theory 3', 'Calculus').
prerequisite('Principles of Operations Management 1', 'Programming 1').
prerequisite('Theoretical Reinforced Concrete Design', 'Intro to CE').
prerequisite('Fundamentals of Statistics 1', 'Calculus').
prerequisite('Advanced Organizational Behavior', 'Intro to Humanities').
prerequisite('Applied Human-Computer Interaction 2', 'Calculus').
prerequisite('Computational Six Sigma 1', 'Intro to PE').
prerequisite('Steel Structures 3', 'Physics').
prerequisite('Theoretical Housing Development 1', 'Physics').
prerequisite('Contemporary Compiler Design 1', 'Physics').
prerequisite('Theoretical High Voltage Engineering', 'Calculus').
prerequisite('Applied Kinematics 1', 'Programming 1').
prerequisite('Principles of Computer Integrated Manufacturing', 'Physics').
prerequisite('Experimental Landscape Architecture 1', 'Intro to Architecture').
prerequisite('Applied Linear Algebra 2', 'Programming 1').
prerequisite('Public Speaking 2', 'Programming 1').
prerequisite('Advanced Embedded Systems 2', 'Programming 1').
prerequisite('Principles of Digital Signal Processing 2', 'Physics').
prerequisite('Fundamentals of Internal Combustion Engines 3', 'Physics').
prerequisite('Theoretical Manufacturing Processes 2', 'Calculus').
prerequisite('Applied Environmental Control 1', 'Calculus').
prerequisite('Experimental Philosophy of Science 1', 'Intro to Humanities').
prerequisite('Computational Natural Language Processing', 'Calculus').
prerequisite('Contemporary Aerospace Engineering 2', 'Intro to ME').
prerequisite('Theoretical Project Management 2', 'Calculus').
prerequisite('Contemporary Advanced Steel Design 2', 'Physics').
prerequisite('Advanced Historic Preservation 3', 'Physics').
prerequisite('Principles of Human Rights 1', 'Physics').
prerequisite('Theoretical Power Electronics 2', 'Programming 1').
prerequisite('Robotics and Automation 2', 'Physics').
prerequisite('Theoretical Computer Integrated Manufacturing 2', 'Intro to PE').
prerequisite('Principles of Construction Management 2', 'Calculus').
prerequisite('Computational Inorganic Chemistry 3', 'Programming 1').
prerequisite('Theoretical Public Speaking', 'Programming 1').
prerequisite('Applied Internet of Things 3', 'Physics').
prerequisite('Introduction to High Voltage Engineering', 'Physics').
prerequisite('Fundamentals of Nanotechnology 3', 'Calculus').
prerequisite('Theoretical Manufacturing Processes', 'Intro to PE').
prerequisite('Bridge Engineering 3', 'Physics').
prerequisite('Advanced Urban Sociology', 'Intro to Architecture').
prerequisite('Computational Business Communication 1', 'Programming 1').
prerequisite('Theoretical Cryptography', 'Programming 1').
prerequisite('Computational Industrial Automation', 'Programming 1').
prerequisite('Theoretical Aerospace Engineering 1', 'Physics').
prerequisite('Principles of Ergonomics 2', 'Intro to PE').
prerequisite('Principles of Interior Design 3', 'Intro to Architecture').
prerequisite('Computational Philosophy of Science', 'Calculus').
prerequisite('Fundamentals of Antenna Theory 1', 'Calculus').
prerequisite('Fundamentals of Refrigeration and Air Conditioning 1', 'Programming 1').
prerequisite('Industrial Robotics 3', 'Physics').
prerequisite('Contemporary Bridge Engineering 1', 'Programming 1').
prerequisite('Computational Building Construction 2', 'Programming 1').
prerequisite('Applied Optics 1', 'Programming 1').
prerequisite('Applied Formal Languages 2', 'Intro to CSE').
prerequisite('VLSI Design 2', 'Physics').
prerequisite('Principles of Automotive Engineering 2', 'Programming 1').
prerequisite('Fundamentals of Bridge Engineering 2', 'Programming 1').
prerequisite('Quantum Mechanics 3', 'Physics').
prerequisite('Advanced Business Communication 2', 'Intro to Humanities').
prerequisite('Digital Fabrication 2', 'Calculus').
prerequisite('Fundamentals of Calculus of Variations 3', 'Programming 1').
prerequisite('Experimental Macroeconomics 2', 'Physics').
prerequisite('Experimental Digital Logic 2', 'Calculus').
prerequisite('Applied Electromagnetic Fields 3', 'Programming 1').
prerequisite('Introduction to Tribology 1', 'Programming 1').
prerequisite('Six Sigma 3', 'Programming 1').

% -----------------------------------------------------------------
% 5. KNOWLEDGE BASE — COURSE TAGS
% Format: course_tag(Course, Tag)
% -----------------------------------------------------------------

course_tag('Mathematics 1 (Calculus)', 'Math').
course_tag('Mathematics 2 (Integration)', 'Math').
course_tag('Mathematics 3 (Differential Equations)', 'Math').
course_tag('Physics 1 (Mechanics)', 'Physics').
course_tag('Physics 2 (Electricity)', 'Physics').
course_tag('Engineering Chemistry', 'Chemistry').
course_tag('Engineering Mechanics 1', 'Physics').
course_tag('Engineering Mechanics 2', 'Physics').
course_tag('Introduction to Computer Engineering', 'Hardware/Software').
course_tag('Computer Programming (C/C++)', 'Programming').
course_tag('Object-Oriented Programming', 'Programming').
course_tag('Data Structures and Algorithms', 'Programming').
course_tag('Artificial Intelligence', 'AI').
course_tag('Electrical Circuits 1', 'Circuits').
course_tag('Electrical Circuits 2', 'Circuits').
course_tag('Digital Electronics', 'Electronics').
course_tag('Engineering Thermodynamics', 'Thermal').
course_tag('Fluid Mechanics', 'Fluids').
course_tag('Machine Design 1', 'Design').
course_tag('Structural Analysis 1', 'Structures').
course_tag('Surveying', 'Field Work').
course_tag('Production Engineering', 'Manufacturing').
course_tag('Operations Research', 'Optimization').
course_tag('Architectural Design 1', 'Design').
course_tag('History of Architecture', 'History').
course_tag('Technical Report Writing', 'Soft Skills').
course_tag('Engineering Economy', 'Management').
course_tag('Network Security 1', 'Software').
course_tag('Applied Satellite Communications 3', 'Design').
course_tag('Advanced Robotics and Automation 2', 'Design').
course_tag('Applied Reliability Engineering 1', 'Math').
course_tag('Applied Reinforced Concrete Design 1', 'Management').
course_tag('Applied City Planning 2', 'Software').
course_tag('Experimental Calculus of Variations', 'Math').
course_tag('Theoretical Public Speaking 3', 'Software').
course_tag('Experimental Quantum Computing 2', 'Management').
course_tag('Theoretical Electronic Devices 1', 'Design').
course_tag('Theoretical Advanced Manufacturing', 'Theory').
course_tag('Material Science', 'Research').
course_tag('Contemporary GIS 1', 'Field Work').
course_tag('Introduction to Urban Planning', 'Theory').
course_tag('Applied Tensor Analysis 1', 'Math').
course_tag('Applied Technical Communication 2', 'Practical').
course_tag('Applied Robotics 3', 'Theory').
course_tag('Theoretical Smart Grids', 'Management').
course_tag('Experimental HVAC Systems 3', 'Design').
course_tag('Computational Project Management 1', 'Math').
course_tag('Advanced Steel Structures', 'Design').
course_tag('Advanced Environmental Control 3', 'Field Work').
course_tag('Principles of Discrete Mathematics 2', 'Field Work').
course_tag('Theoretical Human Rights 2', 'Software').
course_tag('Principles of Compiler Design 3', 'Programming').
course_tag('Computational Power Electronics', 'Software').
course_tag('Advanced Tribology', 'Theory').
course_tag('Experimental Quality Control', 'Design').
course_tag('Properties of Materials 3', 'Hardware').
course_tag('Applied Architectural Acoustics 2', 'Field Work').
course_tag('Fundamentals of Astrophysics', 'Design').
course_tag('Computational Sociology 3', 'Hardware').
course_tag('Computational Database Systems', 'Research').
course_tag('Advanced Electronic Devices 3', 'Programming').
course_tag('Theoretical Heat and Mass Transfer', 'Software').
course_tag('Contemporary Industrial Robotics', 'Management').
course_tag('Transportation Engineering 3', 'Management').
course_tag('Applied Urban Sociology', 'Software').
course_tag('Fundamentals of Organic Chemistry', 'Practical').
course_tag('Fundamentals of Organizational Behavior 2', 'Hardware').
course_tag('Computational Network Security 2', 'Design').
course_tag('Contemporary Microwave Engineering 1', 'Management').
course_tag('Contemporary Nanotechnology 1', 'Field Work').
course_tag('Theoretical Six Sigma 3', 'Research').
course_tag('Fundamentals of Hydrology 1', 'Design').
course_tag('Contemporary Historic Preservation 2', 'Practical').
course_tag('Introduction to Thermodynamics of Materials', 'Design').
course_tag('Principles of Macroeconomics', 'Software').
course_tag('Introduction to Distributed Systems', 'Software').
course_tag('Applied Digital Signal Processing', 'Math').
course_tag('Advanced Fracture Mechanics 3', 'Programming').
course_tag('Fundamentals of Quality Control', 'Research').
course_tag('Advanced Reinforced Concrete Design', 'Design').
course_tag('Computational Housing Development 1', 'Research').
course_tag('Fundamentals of Modern Physics 3', 'Theory').
course_tag('Introduction to Engineering Law', 'Programming').
course_tag('Theoretical Network Security 1', 'Field Work').
course_tag('Theoretical Control Systems 2', 'Programming').
course_tag('Advanced Energy Conversion', 'Management').
course_tag('Contemporary Ergonomics 1', 'Design').
course_tag('Wastewater Management 2', 'Hardware').
course_tag('Theoretical Building Information Modeling 2', 'Hardware').
course_tag('Principles of Numerical Analysis 1', 'Field Work').
course_tag('Fundamentals of Business Communication 3', 'Hardware').
course_tag('Principles of Cloud Computing', 'Design').
course_tag('Smart Grids', 'Theory').
course_tag('Principles of Aerospace Engineering 2', 'Hardware').
course_tag('Computational Ergonomics 1', 'Software').
course_tag('Coastal Engineering', 'Programming').
course_tag('Experimental Parametric Design 3', 'Math').
course_tag('Advanced Calculus of Variations 2', 'Design').
course_tag('Applied Macroeconomics', 'Theory').
course_tag('Experimental Formal Languages 1', 'Programming').
course_tag('Computational Smart Grids 3', 'Math').
course_tag('Experimental Composite Materials 3', 'Management').
course_tag('Applied Lean Manufacturing 2', 'Design').
course_tag('Applied Construction Management 1', 'Practical').
course_tag('Applied Interior Design 1', 'Hardware').
course_tag('Applied Astrophysics 2', 'Management').
course_tag('Professional Ethics 2', 'Field Work').
course_tag('Principles of Network Security', 'Field Work').
course_tag('Contemporary Power Electronics 3', 'Math').
course_tag('Theoretical Tribology 2', 'Programming').
course_tag('Computational Industrial Robotics 2', 'Design').
course_tag('Applied Coastal Engineering 2', 'Design').
course_tag('Contemporary Urban Design 1', 'Design').
course_tag('Contemporary Biophysics 3', 'Hardware').
course_tag('Contemporary Microeconomics', 'Hardware').
course_tag('Introduction to Operating Systems 1', 'Programming').
course_tag('Principles of Radar Systems 1', 'Software').
course_tag('Principles of Energy Conversion 2', 'Programming').
course_tag('Introduction to Industrial Management', 'Field Work').
course_tag('Fundamentals of Construction Management 2', 'Research').
course_tag('Parametric Design 3', 'Field Work').
course_tag('Computational Statistics 3', 'Management').
course_tag('Computational Macroeconomics 1', 'Research').
course_tag('Theoretical Distributed Systems 1', 'Math').
course_tag('Theoretical High Voltage Engineering 2', 'Software').
course_tag('Computational Tribology 1', 'Field Work').
course_tag('Principles of Quality Control 2', 'Programming').
course_tag('Computational Hydrology 1', 'Design').
course_tag('Introduction to Parametric Design', 'Research').
course_tag('Theoretical Linear Algebra', 'Field Work').
course_tag('Introduction to Technical Communication', 'Math').
course_tag('Theoretical Distributed Systems 3', 'Math').
course_tag('Theoretical Electrical Power', 'Design').
course_tag('Experimental Refrigeration and Air Conditioning 3', 'Theory').
course_tag('Contemporary Systems Engineering 1', 'Design').
course_tag('Fundamentals of Highway Engineering', 'Field Work').
course_tag('Introduction to Digital Fabrication 1', 'Research').
course_tag('Applied Discrete Mathematics 2', 'Programming').
course_tag('Introduction to Industrial Psychology', 'Practical').
course_tag('Advanced Data Mining', 'Software').
course_tag('Introduction to Biomedical Instrumentation', 'Practical').
course_tag('Principles of Kinematics 3', 'Software').
course_tag('Introduction to Ergonomics', 'Research').
course_tag('Experimental Bridge Engineering 1', 'Programming').
course_tag('Architectural Acoustics 3', 'Theory').
course_tag('Experimental Numerical Analysis 1', 'Math').
course_tag('Advanced Engineering Law 3', 'Software').
course_tag('Fundamentals of Big Data Analytics 2', 'Field Work').
course_tag('Principles of Satellite Communications 3', 'Practical').
course_tag('Applied Automotive Engineering 2', 'Field Work').
course_tag('Contemporary Operations Management', 'Theory').
course_tag('Contemporary Pavement Design 1', 'Field Work').
course_tag('Contemporary Environmental Control 3', 'Field Work').
course_tag('Introduction to Calculus of Variations', 'Programming').
course_tag('Principles of Philosophy of Science 3', 'Practical').
course_tag('Contemporary Data Mining', 'Field Work').
course_tag('Contemporary Power Electronics 1', 'Design').
course_tag('Advanced Kinematics', 'Math').
course_tag('Facilities Planning 2', 'Math').
course_tag('Applied Earthquake Engineering 3', 'Management').
course_tag('Theoretical Sustainable Architecture 2', 'Math').
course_tag('Contemporary Modern Physics 1', 'Theory').
course_tag('Contemporary Industrial Psychology 1', 'Theory').
course_tag('Theoretical Computer Architecture', 'Field Work').
course_tag('Experimental Biomedical Instrumentation 1', 'Programming').
course_tag('Advanced CAD/CAM', 'Practical').
course_tag('Computational Operations Management 3', 'Programming').
course_tag('Advanced Properties of Materials 2', 'Math').
course_tag('Applied Housing Development 1', 'Software').
course_tag('Introduction to Linear Algebra', 'Design').
course_tag('Professional Ethics 3', 'Theory').
course_tag('Contemporary Compiler Design 2', 'Software').
course_tag('Introduction to Optical Communications', 'Hardware').
course_tag('Applied Internal Combustion Engines 2', 'Practical').
course_tag('Contemporary Industrial Management 2', 'Design').
course_tag('Experimental Hydrology 2', 'Management').
course_tag('Building Information Modeling 2', 'Design').
course_tag('Advanced Tensor Analysis', 'Programming').
course_tag('Computational Microeconomics 2', 'Design').
course_tag('Computational Embedded Systems', 'Software').
course_tag('Experimental Signals and Systems 3', 'Software').
course_tag('Applied Nanotechnology 2', 'Theory').
course_tag('Fundamentals of Systems Engineering 3', 'Design').
course_tag('Introduction to Traffic Engineering 1', 'Management').
course_tag('Advanced Lighting Design', 'Design').
course_tag('Fundamentals of Thermodynamics of Materials', 'Design').
course_tag('Entrepreneurship 2', 'Software').
course_tag('Computational Internet of Things', 'Software').
course_tag('Contemporary Biomedical Instrumentation 3', 'Management').
course_tag('Fundamentals of Kinematics', 'Research').
course_tag('Contemporary Systems Engineering 2', 'Field Work').
course_tag('Principles of Transportation Engineering 2', 'Software').
course_tag('Experimental Urban Planning 1', 'Math').
course_tag('Principles of Statistics', 'Hardware').
course_tag('Contemporary Entrepreneurship 3', 'Hardware').
course_tag('Introduction to Game Development', 'Design').
course_tag('Principles of Control Systems 1', 'Theory').
course_tag('Principles of Acoustics', 'Design').
course_tag('Principles of Industrial Management', 'Hardware').
course_tag('Experimental Reinforced Concrete Design', 'Field Work').
course_tag('Applied Building Construction', 'Practical').
course_tag('Theoretical Inorganic Chemistry 2', 'Hardware').
course_tag('Advanced Virtual Reality 3', 'Practical').
course_tag('Radar Systems', 'Design').
course_tag('Experimental Automotive Engineering 1', 'Management').
course_tag('Fundamentals of Quality Control 1', 'Field Work').
course_tag('Tunnel Engineering 3', 'Hardware').
course_tag('Computational Parametric Design 3', 'Programming').
course_tag('Numerical Analysis 2', 'Theory').
course_tag('Contemporary Fundamentals of Management', 'Programming').
course_tag('Algorithms', 'Management').
course_tag('Advanced Electromagnetic Fields 2', 'Management').
course_tag('Heat and Mass Transfer 1', 'Design').
course_tag('Theoretical Industrial Management 1', 'Design').
course_tag('Applied Wastewater Management', 'Design').
course_tag('Fundamentals of Urban Sociology 2', 'Field Work').
course_tag('Theoretical Statistics', 'Design').
course_tag('Applied Distributed Systems 1', 'Practical').
course_tag('Computational Electromagnetic Fields', 'Software').
course_tag('Fundamentals of Nanotechnology 2', 'Research').
course_tag('Advanced Computer Integrated Manufacturing', 'Theory').
course_tag('Introduction to Earthquake Engineering', 'Management').
course_tag('Applied Lighting Design 3', 'Math').
course_tag('Experimental Numerical Analysis', 'Software').
course_tag('Introduction to Philosophy of Science', 'Math').
course_tag('Theoretical Cybersecurity', 'Field Work').
course_tag('Computational Electrical Power 3', 'Field Work').
course_tag('Principles of Finite Element Analysis 3', 'Math').
course_tag('Applied Industrial Robotics', 'Management').
course_tag('Traffic Engineering 3', 'Software').
course_tag('Contemporary Urban Planning 1', 'Management').
course_tag('Experimental Quantum Mechanics 1', 'Programming').
course_tag('Computational Technical Communication', 'Programming').
course_tag('Fundamentals of Software Engineering 1', 'Design').
course_tag('Advanced Communication Theory', 'Practical').
course_tag('Theoretical Theory of Machines', 'Field Work').
course_tag('Advanced Operations Management', 'Theory').
course_tag('Fundamentals of Wastewater Management 3', 'Hardware').
course_tag('Computational Lighting Design 3', 'Programming').
course_tag('Principles of Discrete Mathematics 1', 'Practical').
course_tag('Contemporary Microeconomics 1', 'Theory').
course_tag('Introduction to Cybersecurity', 'Math').
course_tag('Smart Grids 2', 'Research').
course_tag('Fundamentals of Internal Combustion Engines 1', 'Management').
course_tag('Advanced Supply Chain Management', 'Practical').
course_tag('Applied Soil Mechanics', 'Programming').
course_tag('Contemporary Housing Development 1', 'Practical').
course_tag('Fundamentals of Biophysics 2', 'Hardware').
course_tag('Fundamentals of Entrepreneurship', 'Math').
course_tag('Theoretical Blockchain Technology 3', 'Math').
course_tag('Computational Communication Theory', 'Research').
course_tag('Computational Robotics and Automation 3', 'Practical').
course_tag('Contemporary Supply Chain Management 1', 'Research').
course_tag('Advanced Wastewater Management 3', 'Management').
course_tag('Urban Design', 'Theory').
course_tag('Theoretical Discrete Mathematics 1', 'Hardware').
course_tag('Fundamentals of Human Rights 3', 'Practical').
course_tag('Fundamentals of Algorithms 3', 'Software').
course_tag('Fundamentals of Control Systems 1', 'Math').
course_tag('Introduction to Energy Conversion', 'Theory').
course_tag('Contemporary Operations Management 3', 'Practical').
course_tag('Pavement Design 2', 'Programming').
course_tag('Landscape Architecture 1', 'Theory').
course_tag('Modern Physics 3', 'Research').
course_tag('Technical Communication 3', 'Field Work').
course_tag('Applied Bioinformatics 1', 'Research').
course_tag('Experimental Satellite Communications', 'Management').
course_tag('Introduction to Dynamics', 'Hardware').
course_tag('Advanced Manufacturing Processes 2', 'Practical').
course_tag('Introduction to Bridge Engineering', 'Programming').
course_tag('Computational Digital Fabrication 2', 'Theory').
course_tag('Introduction to Biophysics', 'Programming').
course_tag('Professional Ethics 1', 'Programming').
course_tag('Fundamentals of Web Development', 'Management').
course_tag('Advanced Electronic Devices 2', 'Design').
course_tag('Fundamentals of Computational Fluid Dynamics', 'Math').
course_tag('Advanced Lean Manufacturing 2', 'Design').
course_tag('Advanced Geotechnical Engineering 3', 'Design').
course_tag('Parametric Design', 'Theory').
course_tag('Principles of Public Speaking 3', 'Software').
course_tag('Theoretical Virtual Reality 3', 'Software').
course_tag('Computational Electrical Machines 1', 'Software').
course_tag('Principles of Turbomachinery 3', 'Math').
course_tag('Advanced Reliability Engineering 3', 'Programming').
course_tag('Construction Management 3', 'Programming').
course_tag('Applied Landscape Architecture 2', 'Research').
course_tag('Introduction to Topology', 'Theory').
course_tag('Theoretical Philosophy of Science 3', 'Management').
course_tag('Contemporary Distributed Systems 1', 'Theory').
course_tag('Fundamentals of Digital Signal Processing', 'Management').
course_tag('Fundamentals of Finite Element Analysis 2', 'Theory').
course_tag('Principles of Operations Management', 'Hardware').
course_tag('Experimental Coastal Engineering', 'Practical').
course_tag('Advanced Building Construction 3', 'Programming').
course_tag('Contemporary Modern Physics 2', 'Management').
course_tag('Advanced Fundamentals of Management 2', 'Hardware').
course_tag('Theoretical Data Mining 3', 'Practical').
course_tag('Theoretical Industrial Automation 2', 'Programming').
course_tag('Introduction to Internal Combustion Engines', 'Practical').
course_tag('Material Science 1', 'Management').
course_tag('Experimental GIS 2', 'Practical').
course_tag('Contemporary Digital Fabrication', 'Management').
course_tag('Fundamentals of Astrophysics 2', 'Software').
course_tag('Experimental Fundamentals of Management 1', 'Programming').
course_tag('Internet of Things 2', 'Research').
course_tag('Electrical Machines 1', 'Design').
course_tag('Advanced Fracture Mechanics', 'Theory').
course_tag('Applied Industrial Robotics 3', 'Management').
course_tag('Experimental Highway Engineering 2', 'Programming').
course_tag('Experimental Historic Preservation 2', 'Theory').
course_tag('Fundamentals of Topology 1', 'Research').
course_tag('Organizational Behavior', 'Hardware').
course_tag('Computational Robotics 3', 'Design').
course_tag('Contemporary Communication Theory 3', 'Field Work').
course_tag('Principles of Operations Management 1', 'Programming').
course_tag('Theoretical Reinforced Concrete Design', 'Theory').
course_tag('Computational Landscape Architecture 3', 'Management').
course_tag('Fundamentals of Statistics 1', 'Math').
course_tag('Advanced Organizational Behavior', 'Practical').
course_tag('Applied Human-Computer Interaction 2', 'Field Work').
course_tag('Experimental Digital Signal Processing 1', 'Math').
course_tag('Experimental Composite Materials', 'Management').
course_tag('Computational Six Sigma 1', 'Management').
course_tag('Steel Structures 3', 'Theory').
course_tag('Theoretical Housing Development 1', 'Field Work').
course_tag('Thermodynamics of Materials 1', 'Math').
course_tag('Industrial Psychology', 'Field Work').
course_tag('Contemporary Compiler Design 1', 'Theory').
course_tag('Theoretical High Voltage Engineering', 'Management').
course_tag('Applied Kinematics 1', 'Practical').
course_tag('Principles of Computer Integrated Manufacturing', 'Theory').
course_tag('Applied Bridge Engineering 2', 'Programming').
course_tag('Experimental Landscape Architecture 1', 'Programming').
course_tag('Applied Linear Algebra 2', 'Management').
course_tag('Public Speaking 2', 'Research').
course_tag('Advanced Embedded Systems 2', 'Research').
course_tag('Principles of Digital Signal Processing 2', 'Theory').
course_tag('Fundamentals of Internal Combustion Engines 3', 'Research').
course_tag('Theoretical Manufacturing Processes 2', 'Theory').
course_tag('Advanced Highway Engineering', 'Programming').
course_tag('Applied Environmental Control 1', 'Research').
course_tag('Contemporary Modern Physics 3', 'Hardware').
course_tag('Experimental Philosophy of Science 1', 'Management').
course_tag('Computational Natural Language Processing', 'Software').
course_tag('Fundamentals of Optical Communications 2', 'Hardware').
course_tag('Contemporary Aerospace Engineering 2', 'Research').
course_tag('Theoretical Project Management 2', 'Practical').
course_tag('Contemporary Advanced Steel Design 2', 'Design').
course_tag('Advanced Historic Preservation 3', 'Software').
course_tag('Fundamentals of Statistics 3', 'Practical').
course_tag('Principles of Human Rights 1', 'Practical').
course_tag('Contemporary Cybersecurity', 'Management').
course_tag('Theoretical Power Electronics 2', 'Math').
course_tag('Robotics and Automation 2', 'Practical').
course_tag('Theoretical Computer Integrated Manufacturing 2', 'Research').
course_tag('Principles of Construction Management 2', 'Design').
course_tag('Applied Urban Planning', 'Programming').
course_tag('Computational Inorganic Chemistry 3', 'Research').
course_tag('Theoretical Public Speaking', 'Field Work').
course_tag('Applied Internet of Things 3', 'Management').
course_tag('Introduction to High Voltage Engineering', 'Software').
course_tag('Fundamentals of Nanotechnology 3', 'Field Work').
course_tag('Theoretical Manufacturing Processes', 'Programming').
course_tag('Bridge Engineering 3', 'Software').
course_tag('Advanced Urban Sociology', 'Research').
course_tag('Linear Algebra 2', 'Theory').
course_tag('Computational Business Communication 1', 'Management').
course_tag('Theoretical Cryptography', 'Math').
course_tag('Computational Industrial Automation', 'Design').
course_tag('Theoretical Aerospace Engineering 1', 'Programming').
course_tag('Principles of Ergonomics 2', 'Math').
course_tag('Experimental Transportation Engineering 1', 'Management').
course_tag('Principles of Interior Design 3', 'Research').
course_tag('Computational Philosophy of Science', 'Theory').
course_tag('Introduction to Software Testing', 'Software').
course_tag('Fundamentals of Antenna Theory 1', 'Management').
course_tag('Fundamentals of Refrigeration and Air Conditioning 1', 'Hardware').
course_tag('Industrial Robotics 3', 'Theory').
course_tag('Contemporary Bridge Engineering 1', 'Design').
course_tag('Computational Building Construction 2', 'Research').
course_tag('Applied Optics 1', 'Math').
course_tag('Fundamentals of Macroeconomics 3', 'Hardware').
course_tag('Applied Formal Languages 2', 'Hardware').
course_tag('VLSI Design 2', 'Design').
course_tag('Principles of Automotive Engineering 2', 'Theory').
course_tag('Fundamentals of Bridge Engineering 2', 'Research').
course_tag('Experimental Building Construction 2', 'Math').
course_tag('Quantum Mechanics 3', 'Research').
course_tag('Advanced Business Communication 2', 'Design').
course_tag('Bioinformatics 1', 'Research').
course_tag('Principles of CAD/CAM', 'Programming').
course_tag('Advanced Computer Integrated Manufacturing 3', 'Theory').
course_tag('Hydrology 1', 'Field Work').
course_tag('Digital Fabrication 2', 'Design').
course_tag('Fundamentals of Calculus of Variations 3', 'Programming').
course_tag('Experimental Macroeconomics 2', 'Software').
course_tag('Experimental Digital Logic 2', 'Design').
course_tag('Applied Electromagnetic Fields 3', 'Research').
course_tag('Introduction to Tribology 1', 'Design').
course_tag('Six Sigma 3', 'Field Work').