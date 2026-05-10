% =================================================================
% SMART STUDY ADVISOR - PROLOG INFERENCE ENGINE
% =================================================================

% --- 1. INFERENCE RULES ---

% recommend(Student, Course)
recommend(Student, Course) :-
    student(Student, Dept, CurrentYear, Prefs),
    course(Course, Dept, _Difficulty, CourseYear),
    CourseYear =< CurrentYear,                  
    \+ completed(Student, Course),            
    check_prerequisites(Student, Course),       
    match_interests(Prefs, Course).             

check_prerequisites(Student, Course) :-
    forall(prerequisite(Course, PreReq), completed(Student, PreReq)).

match_interests(Prefs, Course) :-
    course_tag(Course, Tag),
    member(Tag, Prefs).

% --- 2. THE KNOWLEDGE BASE (400 COURSES) ---
% format: course(Name, Department, Difficulty, Year).

% Architecture (49)
course('Architectural Design 1', 'Architecture', 'Medium', 1).
course('History of Architecture', 'Architecture', 'Easy', 1).
course('Applied City Planning 2', 'Architecture', 'Medium', 2).
course('Introduction to Urban Planning', 'Architecture', 'Easy', 1).
course('Advanced Environmental Control 3', 'Architecture', 'Hard', 3).
course('Applied Architectural Acoustics 2', 'Architecture', 'Medium', 2).
course('Applied Urban Sociology', 'Architecture', 'Medium', 2).
course('Contemporary Historic Preservation 2', 'Architecture', 'Medium', 2).
course('Computational Housing Development 1', 'Architecture', 'Hard', 1).
course('Theoretical Building Information Modeling 2', 'Architecture', 'Hard', 2).
course('Experimental Parametric Design 3', 'Architecture', 'Hard', 3).
course('Applied Interior Design 1', 'Architecture', 'Medium', 1).
course('Contemporary Urban Design 1', 'Architecture', 'Medium', 1).
course('Parametric Design 3', 'Architecture', 'Hard', 3).
course('Introduction to Parametric Design', 'Architecture', 'Easy', 1).
course('Introduction to Digital Fabrication 1', 'Architecture', 'Easy', 1).
course('Architectural Acoustics 3', 'Architecture', 'Hard', 3).
course('Contemporary Environmental Control 3', 'Architecture', 'Medium', 3).
course('Theoretical Sustainable Architecture 2', 'Architecture', 'Hard', 2).
course('Applied Housing Development 1', 'Architecture', 'Medium', 1).
course('Building Information Modeling 2', 'Architecture', 'Medium', 2).
course('Advanced Lighting Design', 'Architecture', 'Hard', 4).
course('Experimental Urban Planning 1', 'Architecture', 'Medium', 1).
course('Applied Building Construction', 'Architecture', 'Medium', 2).
course('Computational Parametric Design 3', 'Architecture', 'Hard', 3).
course('Fundamentals of Urban Sociology 2', 'Architecture', 'Medium', 2).
course('Applied Lighting Design 3', 'Architecture', 'Medium', 3).
course('Contemporary Urban Planning 1', 'Architecture', 'Medium', 1).
course('Computational Lighting Design 3', 'Architecture', 'Hard', 3).
course('Contemporary Housing Development 1', 'Architecture', 'Medium', 1).
course('Urban Design', 'Architecture', 'Medium', 3).
course('Landscape Architecture 1', 'Architecture', 'Medium', 1).
course('Computational Digital Fabrication 2', 'Architecture', 'Hard', 2).
course('Parametric Design', 'Architecture', 'Medium', 2).
course('Applied Landscape Architecture 2', 'Architecture', 'Medium', 2).
course('Advanced Building Construction 3', 'Architecture', 'Hard', 3).
course('Contemporary Digital Fabrication', 'Architecture', 'Medium', 4).
course('Experimental Historic Preservation 2', 'Architecture', 'Hard', 2).
course('Computational Landscape Architecture 3', 'Architecture', 'Hard', 3).
course('Theoretical Housing Development 1', 'Architecture', 'Hard', 1).
course('Experimental Landscape Architecture 1', 'Architecture', 'Medium', 1).
course('Applied Environmental Control 1', 'Architecture', 'Medium', 1).
course('Advanced Historic Preservation 3', 'Architecture', 'Hard', 3).
course('Applied Urban Planning', 'Architecture', 'Medium', 2).
course('Advanced Urban Sociology', 'Architecture', 'Hard', 4).
course('Principles of Interior Design 3', 'Architecture', 'Medium', 3).
course('Computational Building Construction 2', 'Architecture', 'Hard', 2).
course('Experimental Building Construction 2', 'Architecture', 'Hard', 2).
course('Digital Fabrication 2', 'Architecture', 'Medium', 2).

% Basic and Applied Sciences (53)
course('Mathematics 1 (Calculus)', 'Basic and Applied Sciences', 'Hard', 1).
course('Mathematics 2 (Integration)', 'Basic and Applied Sciences', 'Hard', 1).
course('Mathematics 3 (Differential Equations)', 'Basic and Applied Sciences', 'Hard', 2).
course('Physics 1 (Mechanics)', 'Basic and Applied Sciences', 'Hard', 1).
course('Physics 2 (Electricity)', 'Basic and Applied Sciences', 'Hard', 2).
course('Engineering Chemistry', 'Basic and Applied Sciences', 'Medium', 1).
course('Engineering Mechanics 1', 'Basic and Applied Sciences', 'Medium', 1).
course('Engineering Mechanics 2', 'Basic and Applied Sciences', 'Medium', 2).
course('Experimental Calculus of Variations', 'Basic and Applied Sciences', 'Hard', 3).
course('Applied Tensor Analysis 1', 'Basic and Applied Sciences', 'Hard', 1).
course('Principles of Discrete Mathematics 2', 'Basic and Applied Sciences', 'Medium', 2).
course('Fundamentals of Astrophysics', 'Basic and Applied Sciences', 'Medium', 3).
course('Fundamentals of Organic Chemistry', 'Basic and Applied Sciences', 'Medium', 2).
course('Introduction to Thermodynamics of Materials', 'Basic and Applied Sciences', 'Medium', 1).
course('Fundamentals of Modern Physics 3', 'Basic and Applied Sciences', 'Medium', 3).
course('Principles of Numerical Analysis 1', 'Basic and Applied Sciences', 'Medium', 1).
course('Advanced Calculus of Variations 2', 'Basic and Applied Sciences', 'Hard', 2).
course('Applied Astrophysics 2', 'Basic and Applied Sciences', 'Medium', 2).
course('Contemporary Biophysics 3', 'Basic and Applied Sciences', 'Medium', 3).
course('Computational Statistics 3', 'Basic and Applied Sciences', 'Hard', 3).
course('Theoretical Linear Algebra', 'Basic and Applied Sciences', 'Hard', 2).
course('Applied Discrete Mathematics 2', 'Basic and Applied Sciences', 'Medium', 2).
course('Experimental Numerical Analysis 1', 'Basic and Applied Sciences', 'Hard', 1).
course('Introduction to Calculus of Variations', 'Basic and Applied Sciences', 'Medium', 1).
course('Contemporary Modern Physics 1', 'Basic and Applied Sciences', 'Medium', 1).
course('Introduction to Linear Algebra', 'Basic and Applied Sciences', 'Easy', 1).
course('Advanced Tensor Analysis', 'Basic and Applied Sciences', 'Hard', 4).
course('Fundamentals of Thermodynamics of Materials', 'Basic and Applied Sciences', 'Medium', 2).
course('Principles of Statistics', 'Basic and Applied Sciences', 'Medium', 1).
course('Theoretical Inorganic Chemistry 2', 'Basic and Applied Sciences', 'Hard', 2).
course('Numerical Analysis 2', 'Basic and Applied Sciences', 'Medium', 2).
course('Theoretical Statistics', 'Basic and Applied Sciences', 'Hard', 3).
course('Experimental Numerical Analysis', 'Basic and Applied Sciences', 'Hard', 2).
course('Experimental Quantum Mechanics 1', 'Basic and Applied Sciences', 'Hard', 1).
course('Principles of Discrete Mathematics 1', 'Basic and Applied Sciences', 'Medium', 1).
course('Fundamentals of Biophysics 2', 'Basic and Applied Sciences', 'Medium', 2).
course('Theoretical Discrete Mathematics 1', 'Basic and Applied Sciences', 'Hard', 1).
course('Modern Physics 3', 'Basic and Applied Sciences', 'Medium', 3).
course('Introduction to Biophysics', 'Basic and Applied Sciences', 'Easy', 1).
course('Introduction to Topology', 'Basic and Applied Sciences', 'Medium', 3).
course('Contemporary Modern Physics 2', 'Basic and Applied Sciences', 'Medium', 2).
course('Fundamentals of Astrophysics 2', 'Basic and Applied Sciences', 'Medium', 2).
course('Fundamentals of Topology 1', 'Basic and Applied Sciences', 'Medium', 1).
course('Fundamentals of Statistics 1', 'Basic and Applied Sciences', 'Medium', 1).
course('Thermodynamics of Materials 1', 'Basic and Applied Sciences', 'Medium', 1).
course('Applied Linear Algebra 2', 'Basic and Applied Sciences', 'Medium', 2).
course('Contemporary Modern Physics 3', 'Basic and Applied Sciences', 'Medium', 3).
course('Fundamentals of Statistics 3', 'Basic and Applied Sciences', 'Medium', 3).
course('Computational Inorganic Chemistry 3', 'Basic and Applied Sciences', 'Hard', 3).
course('Linear Algebra 2', 'Basic and Applied Sciences', 'Medium', 2).
course('Applied Optics 1', 'Basic and Applied Sciences', 'Medium', 1).
course('Quantum Mechanics 3', 'Basic and Applied Sciences', 'Hard', 3).
course('Fundamentals of Calculus of Variations 3', 'Basic and Applied Sciences', 'Medium', 3).

% CE (49)
course('Structural Analysis 1', 'CE', 'Hard', 2).
course('Surveying', 'CE', 'Medium', 1).
course('Applied Reinforced Concrete Design 1', 'CE', 'Hard', 3).
course('Contemporary GIS 1', 'CE', 'Medium', 1).
course('Advanced Steel Structures', 'CE', 'Hard', 4).
course('Properties of Materials 3', 'CE', 'Medium', 3).
course('Transportation Engineering 3', 'CE', 'Medium', 3).
course('Fundamentals of Hydrology 1', 'CE', 'Medium', 1).
course('Advanced Reinforced Concrete Design', 'CE', 'Hard', 4).
course('Wastewater Management 2', 'CE', 'Medium', 2).
course('Coastal Engineering', 'CE', 'Hard', 3).
course('Applied Construction Management 1', 'CE', 'Medium', 1).
course('Applied Coastal Engineering 2', 'CE', 'Hard', 2).
course('Fundamentals of Construction Management 2', 'CE', 'Medium', 2).
course('Computational Hydrology 1', 'CE', 'Hard', 1).
course('Fundamentals of Highway Engineering', 'CE', 'Medium', 2).
course('Experimental Bridge Engineering 1', 'CE', 'Hard', 1).
course('Contemporary Pavement Design 1', 'CE', 'Medium', 1).
course('Applied Earthquake Engineering 3', 'CE', 'Hard', 3).
course('Advanced Properties of Materials 2', 'CE', 'Hard', 2).
course('Experimental Hydrology 2', 'CE', 'Hard', 2).
course('Introduction to Traffic Engineering 1', 'CE', 'Easy', 1).
course('Principles of Transportation Engineering 2', 'CE', 'Medium', 2).
course('Experimental Reinforced Concrete Design', 'CE', 'Hard', 4).
course('Tunnel Engineering 3', 'CE', 'Hard', 3).
course('Applied Wastewater Management', 'CE', 'Medium', 3).
course('Introduction to Earthquake Engineering', 'CE', 'Medium', 2).
course('Traffic Engineering 3', 'CE', 'Medium', 3).
course('Fundamentals of Wastewater Management 3', 'CE', 'Medium', 3).
course('Applied Soil Mechanics', 'CE', 'Hard', 2).
course('Advanced Wastewater Management 3', 'CE', 'Hard', 3).
course('Pavement Design 2', 'CE', 'Medium', 2).
course('Introduction to Bridge Engineering', 'CE', 'Medium', 2).
course('Advanced Geotechnical Engineering 3', 'CE', 'Hard', 3).
course('Construction Management 3', 'CE', 'Medium', 3).
course('Experimental Coastal Engineering', 'CE', 'Hard', 3).
course('Experimental GIS 2', 'CE', 'Hard', 2).
course('Experimental Highway Engineering 2', 'CE', 'Hard', 2).
course('Theoretical Reinforced Concrete Design', 'CE', 'Hard', 3).
course('Steel Structures 3', 'CE', 'Hard', 3).
course('Applied Bridge Engineering 2', 'CE', 'Hard', 2).
course('Advanced Highway Engineering', 'CE', 'Hard', 4).
course('Contemporary Advanced Steel Design 2', 'CE', 'Hard', 2).
course('Principles of Construction Management 2', 'CE', 'Medium', 2).
course('Bridge Engineering 3', 'CE', 'Hard', 3).
course('Experimental Transportation Engineering 1', 'CE', 'Hard', 1).
course('Contemporary Bridge Engineering 1', 'CE', 'Medium', 1).
course('Fundamentals of Bridge Engineering 2', 'CE', 'Medium', 2).
course('Hydrology 1', 'CE', 'Medium', 1).

% CSE (53)
course('Introduction to Computer Engineering', 'CSE', 'Easy', 1).
course('Computer Programming (C/C++)', 'CSE', 'Medium', 1).
course('Object-Oriented Programming', 'CSE', 'Medium', 2).
course('Data Structures and Algorithms', 'CSE', 'Hard', 2).
course('Artificial Intelligence', 'CSE', 'Hard', 4).
course('Network Security 1', 'CSE', 'Hard', 3).
course('Experimental Quantum Computing 2', 'CSE', 'Hard', 2).
course('Applied Robotics 3', 'CSE', 'Hard', 3).
course('Principles of Compiler Design 3', 'CSE', 'Hard', 3).
course('Computational Database Systems', 'CSE', 'Medium', 2).
course('Computational Network Security 2', 'CSE', 'Hard', 2).
course('Introduction to Distributed Systems', 'CSE', 'Medium', 3).
course('Theoretical Network Security 1', 'CSE', 'Hard', 1).
course('Principles of Cloud Computing', 'CSE', 'Medium', 3).
course('Experimental Formal Languages 1', 'CSE', 'Hard', 1).
course('Principles of Network Security', 'CSE', 'Medium', 3).
course('Introduction to Operating Systems 1', 'CSE', 'Medium', 1).
course('Theoretical Distributed Systems 1', 'CSE', 'Hard', 1).
course('Theoretical Distributed Systems 3', 'CSE', 'Hard', 3).
course('Advanced Data Mining', 'CSE', 'Hard', 4).
course('Fundamentals of Big Data Analytics 2', 'CSE', 'Medium', 2).
course('Contemporary Data Mining', 'CSE', 'Medium', 3).
course('Theoretical Computer Architecture', 'CSE', 'Hard', 3).
course('Contemporary Compiler Design 2', 'CSE', 'Medium', 2).
course('Computational Embedded Systems', 'CSE', 'Hard', 3).
course('Computational Internet of Things', 'CSE', 'Hard', 3).
course('Introduction to Game Development', 'CSE', 'Easy', 2).
course('Advanced Virtual Reality 3', 'CSE', 'Hard', 3).
course('Algorithms', 'CSE', 'Hard', 2).
course('Applied Distributed Systems 1', 'CSE', 'Medium', 1).
course('Theoretical Cybersecurity', 'CSE', 'Hard', 4).
course('Fundamentals of Software Engineering 1', 'CSE', 'Medium', 1).
course('Introduction to Cybersecurity', 'CSE', 'Easy', 1).
course('Theoretical Blockchain Technology 3', 'CSE', 'Hard', 3).
course('Fundamentals of Algorithms 3', 'CSE', 'Medium', 3).
course('Applied Bioinformatics 1', 'CSE', 'Medium', 1).
course('Fundamentals of Web Development', 'CSE', 'Easy', 1).
course('Theoretical Virtual Reality 3', 'CSE', 'Hard', 3).
course('Contemporary Distributed Systems 1', 'CSE', 'Medium', 1).
course('Theoretical Data Mining 3', 'CSE', 'Hard', 3).
course('Internet of Things 2', 'CSE', 'Medium', 2).
course('Computational Robotics 3', 'CSE', 'Hard', 3).
course('Applied Human-Computer Interaction 2', 'CSE', 'Medium', 2).
course('Contemporary Compiler Design 1', 'CSE', 'Medium', 1).
course('Advanced Embedded Systems 2', 'CSE', 'Hard', 2).
course('Computational Natural Language Processing', 'CSE', 'Hard', 4).
course('Contemporary Cybersecurity', 'CSE', 'Medium', 3).
course('Applied Internet of Things 3', 'CSE', 'Medium', 3).
course('Theoretical Cryptography', 'CSE', 'Hard', 4).
course('Introduction to Software Testing', 'CSE', 'Easy', 3).
course('Applied Formal Languages 2', 'CSE', 'Medium', 2).
course('Bioinformatics 1', 'CSE', 'Medium', 1).
course('Experimental Digital Logic 2', 'CSE', 'Hard', 2).

% EE (50)
course('Electrical Circuits 1', 'EE', 'Hard', 1).
course('Electrical Circuits 2', 'EE', 'Hard', 2).
course('Digital Electronics', 'EE', 'Medium', 2).
course('Applied Satellite Communications 3', 'EE', 'Hard', 3).
course('Theoretical Electronic Devices 1', 'EE', 'Hard', 1).
course('Theoretical Smart Grids', 'EE', 'Hard', 4).
course('Computational Power Electronics', 'EE', 'Hard', 3).
course('Advanced Electronic Devices 3', 'EE', 'Hard', 3).
course('Contemporary Microwave Engineering 1', 'EE', 'Medium', 1).
course('Applied Digital Signal Processing', 'EE', 'Medium', 3).
course('Theoretical Control Systems 2', 'EE', 'Hard', 2).
course('Smart Grids', 'EE', 'Medium', 4).
course('Computational Smart Grids 3', 'EE', 'Hard', 3).
course('Contemporary Power Electronics 3', 'EE', 'Medium', 3).
course('Principles of Radar Systems 1', 'EE', 'Medium', 1).
course('Theoretical High Voltage Engineering 2', 'EE', 'Hard', 2).
course('Theoretical Electrical Power', 'EE', 'Hard', 3).
course('Introduction to Biomedical Instrumentation', 'EE', 'Easy', 2).
course('Principles of Satellite Communications 3', 'EE', 'Medium', 3).
course('Contemporary Power Electronics 1', 'EE', 'Medium', 1).
course('Experimental Biomedical Instrumentation 1', 'EE', 'Hard', 1).
course('Introduction to Optical Communications', 'EE', 'Easy', 3).
course('Experimental Signals and Systems 3', 'EE', 'Hard', 3).
course('Contemporary Biomedical Instrumentation 3', 'EE', 'Medium', 3).
course('Principles of Control Systems 1', 'EE', 'Medium', 1).
course('Radar Systems', 'EE', 'Medium', 4).
course('Advanced Electromagnetic Fields 2', 'EE', 'Hard', 2).
course('Computational Electromagnetic Fields', 'EE', 'Hard', 3).
course('Computational Electrical Power 3', 'EE', 'Hard', 3).
course('Advanced Communication Theory', 'EE', 'Hard', 4).
course('Smart Grids 2', 'EE', 'Medium', 2).
course('Computational Communication Theory', 'EE', 'Hard', 3).
course('Fundamentals of Control Systems 1', 'EE', 'Medium', 1).
course('Experimental Satellite Communications', 'EE', 'Hard', 4).
course('Advanced Electronic Devices 2', 'EE', 'Hard', 2).
course('Computational Electrical Machines 1', 'EE', 'Hard', 1).
course('Fundamentals of Digital Signal Processing', 'EE', 'Medium', 2).
course('Theoretical Industrial Automation 2', 'EE', 'Hard', 2).
course('Electrical Machines 1', 'EE', 'Medium', 3).
course('Contemporary Communication Theory 3', 'EE', 'Medium', 3).
course('Experimental Digital Signal Processing 1', 'EE', 'Hard', 1).
course('Theoretical High Voltage Engineering', 'EE', 'Hard', 4).
course('Principles of Digital Signal Processing 2', 'EE', 'Medium', 2).
course('Fundamentals of Optical Communications 2', 'EE', 'Medium', 2).
course('Theoretical Power Electronics 2', 'EE', 'Hard', 2).
course('Introduction to High Voltage Engineering', 'EE', 'Easy', 3).
course('Computational Industrial Automation', 'EE', 'Hard', 3).
course('Fundamentals of Antenna Theory 1', 'EE', 'Medium', 1).
course('VLSI Design 2', 'EE', 'Hard', 2).
course('Applied Electromagnetic Fields 3', 'EE', 'Medium', 3).

% Humanities (47)
course('Technical Report Writing', 'Humanities', 'Easy', 1).
course('Engineering Economy', 'Humanities', 'Medium', 2).
course('Theoretical Public Speaking 3', 'Humanities', 'Hard', 3).
course('Applied Technical Communication 2', 'Humanities', 'Medium', 2).
course('Theoretical Human Rights 2', 'Humanities', 'Hard', 2).
course('Computational Sociology 3', 'Humanities', 'Hard', 3).
course('Fundamentals of Organizational Behavior 2', 'Humanities', 'Medium', 2).
course('Principles of Macroeconomics', 'Humanities', 'Medium', 1).
course('Introduction to Engineering Law', 'Humanities', 'Easy', 2).
course('Fundamentals of Business Communication 3', 'Humanities', 'Medium', 3).
course('Applied Macroeconomics', 'Humanities', 'Medium', 2).
course('Professional Ethics 2', 'Humanities', 'Medium', 2).
course('Contemporary Microeconomics', 'Humanities', 'Medium', 1).
course('Computational Macroeconomics 1', 'Humanities', 'Hard', 1).
course('Introduction to Technical Communication', 'Humanities', 'Easy', 1).
course('Introduction to Industrial Psychology', 'Humanities', 'Easy', 2).
course('Advanced Engineering Law 3', 'Humanities', 'Hard', 3).
course('Principles of Philosophy of Science 3', 'Humanities', 'Medium', 3).
course('Contemporary Industrial Psychology 1', 'Humanities', 'Medium', 1).
course('Professional Ethics 3', 'Humanities', 'Medium', 3).
course('Computational Microeconomics 2', 'Humanities', 'Hard', 2).
course('Entrepreneurship 2', 'Humanities', 'Medium', 2).
course('Contemporary Entrepreneurship 3', 'Humanities', 'Medium', 3).
course('Contemporary Fundamentals of Management', 'Humanities', 'Medium', 1).
course('Introduction to Philosophy of Science', 'Humanities', 'Easy', 1).
course('Computational Technical Communication', 'Humanities', 'Hard', 2).
course('Contemporary Microeconomics 1', 'Humanities', 'Medium', 1).
course('Fundamentals of Entrepreneurship', 'Humanities', 'Medium', 1).
course('Fundamentals of Human Rights 3', 'Humanities', 'Medium', 3).
course('Technical Communication 3', 'Humanities', 'Medium', 3).
course('Professional Ethics 1', 'Humanities', 'Easy', 1).
course('Principles of Public Speaking 3', 'Humanities', 'Medium', 3).
course('Theoretical Philosophy of Science 3', 'Humanities', 'Hard', 3).
course('Advanced Fundamentals of Management 2', 'Humanities', 'Hard', 2).
course('Experimental Fundamentals of Management 1', 'Humanities', 'Hard', 1).
course('Organizational Behavior', 'Humanities', 'Medium', 2).
course('Advanced Organizational Behavior', 'Humanities', 'Hard', 4).
course('Industrial Psychology', 'Humanities', 'Medium', 3).
course('Public Speaking 2', 'Humanities', 'Medium', 2).
course('Experimental Philosophy of Science 1', 'Humanities', 'Hard', 1).
course('Principles of Human Rights 1', 'Humanities', 'Medium', 1).
course('Theoretical Public Speaking', 'Humanities', 'Hard', 2).
course('Computational Business Communication 1', 'Humanities', 'Hard', 1).
course('Computational Philosophy of Science', 'Humanities', 'Hard', 2).
course('Fundamentals of Macroeconomics 3', 'Humanities', 'Medium', 3).
course('Advanced Business Communication 2', 'Humanities', 'Hard', 2).
course('Experimental Macroeconomics 2', 'Humanities', 'Hard', 2).

% ME (50)
course('Engineering Thermodynamics', 'ME', 'Hard', 1).
course('Fluid Mechanics', 'ME', 'Hard', 2).
course('Machine Design 1', 'ME', 'Medium', 2).
course('Advanced Robotics and Automation 2', 'ME', 'Hard', 2).
course('Theoretical Advanced Manufacturing', 'ME', 'Hard', 4).
course('Experimental HVAC Systems 3', 'ME', 'Hard', 3).
course('Advanced Tribology', 'ME', 'Hard', 4).
course('Theoretical Heat and Mass Transfer', 'ME', 'Hard', 3).
course('Contemporary Nanotechnology 1', 'ME', 'Medium', 1).
course('Advanced Fracture Mechanics 3', 'ME', 'Hard', 3).
course('Advanced Energy Conversion', 'ME', 'Hard', 4).
course('Principles of Aerospace Engineering 2', 'ME', 'Medium', 2).
course('Experimental Composite Materials 3', 'ME', 'Hard', 3).
course('Theoretical Tribology 2', 'ME', 'Hard', 2).
course('Principles of Energy Conversion 2', 'ME', 'Medium', 2).
course('Computational Tribology 1', 'ME', 'Hard', 1).
course('Experimental Refrigeration and Air Conditioning 3', 'ME', 'Hard', 3).
course('Principles of Kinematics 3', 'ME', 'Medium', 3).
course('Applied Automotive Engineering 2', 'ME', 'Medium', 2).
course('Advanced Kinematics', 'ME', 'Hard', 4).
course('Advanced CAD/CAM', 'ME', 'Hard', 4).
course('Applied Internal Combustion Engines 2', 'ME', 'Medium', 2).
course('Applied Nanotechnology 2', 'ME', 'Medium', 2).
course('Fundamentals of Kinematics', 'ME', 'Medium', 1).
course('Principles of Acoustics', 'ME', 'Medium', 2).
course('Experimental Automotive Engineering 1', 'ME', 'Hard', 1).
course('Heat and Mass Transfer 1', 'ME', 'Medium', 1).
course('Fundamentals of Nanotechnology 2', 'ME', 'Medium', 2).
course('Principles of Finite Element Analysis 3', 'ME', 'Medium', 3).
course('Theoretical Theory of Machines', 'ME', 'Hard', 3).
course('Fundamentals of Internal Combustion Engines 1', 'ME', 'Medium', 1).
course('Computational Robotics and Automation 3', 'ME', 'Hard', 3).
course('Introduction to Energy Conversion', 'ME', 'Easy', 1).
course('Introduction to Dynamics', 'ME', 'Easy', 1).
course('Fundamentals of Computational Fluid Dynamics', 'ME', 'Medium', 2).
course('Principles of Turbomachinery 3', 'ME', 'Medium', 3).
course('Fundamentals of Finite Element Analysis 2', 'ME', 'Medium', 2).
course('Introduction to Internal Combustion Engines', 'ME', 'Easy', 1).
course('Advanced Fracture Mechanics', 'ME', 'Hard', 4).
course('Experimental Composite Materials', 'ME', 'Hard', 4).
course('Applied Kinematics 1', 'ME', 'Medium', 1).
course('Fundamentals of Internal Combustion Engines 3', 'ME', 'Medium', 3).
course('Contemporary Aerospace Engineering 2', 'ME', 'Medium', 2).
course('Robotics and Automation 2', 'ME', 'Medium', 2).
course('Fundamentals of Nanotechnology 3', 'ME', 'Medium', 3).
course('Theoretical Aerospace Engineering 1', 'ME', 'Hard', 1).
course('Fundamentals of Refrigeration and Air Conditioning 1', 'ME', 'Medium', 1).
course('Principles of Automotive Engineering 2', 'ME', 'Medium', 2).
course('Principles of CAD/CAM', 'ME', 'Medium', 2).
course('Introduction to Tribology 1', 'ME', 'Easy', 1).

% PE (49)
course('Production Engineering', 'PE', 'Medium', 1).
course('Operations Research', 'PE', 'Hard', 2).
course('Applied Reliability Engineering 1', 'PE', 'Medium', 1).
course('Material Science', 'PE', 'Medium', 1).
course('Computational Project Management 1', 'PE', 'Hard', 1).
course('Experimental Quality Control', 'PE', 'Hard', 4).
course('Contemporary Industrial Robotics', 'PE', 'Medium', 4).
course('Theoretical Six Sigma 3', 'PE', 'Hard', 3).
course('Fundamentals of Quality Control', 'PE', 'Medium', 1).
course('Contemporary Ergonomics 1', 'PE', 'Medium', 1).
course('Computational Ergonomics 1', 'PE', 'Hard', 1).
course('Applied Lean Manufacturing 2', 'PE', 'Medium', 2).
course('Computational Industrial Robotics 2', 'PE', 'Hard', 2).
course('Introduction to Industrial Management', 'PE', 'Easy', 1).
course('Principles of Quality Control 2', 'PE', 'Medium', 2).
course('Contemporary Systems Engineering 1', 'PE', 'Medium', 1).
course('Introduction to Ergonomics', 'PE', 'Easy', 1).
course('Contemporary Operations Management', 'PE', 'Medium', 4).
course('Facilities Planning 2', 'PE', 'Medium', 2).
course('Computational Operations Management 3', 'PE', 'Hard', 3).
course('Contemporary Industrial Management 2', 'PE', 'Medium', 2).
course('Fundamentals of Systems Engineering 3', 'PE', 'Medium', 3).
course('Contemporary Systems Engineering 2', 'PE', 'Medium', 2).
course('Principles of Industrial Management', 'PE', 'Medium', 4).
course('Fundamentals of Quality Control 1', 'PE', 'Medium', 1).
course('Theoretical Industrial Management 1', 'PE', 'Hard', 1).
course('Advanced Computer Integrated Manufacturing', 'PE', 'Hard', 4).
course('Applied Industrial Robotics', 'PE', 'Medium', 4).
course('Advanced Operations Management', 'PE', 'Hard', 4).
course('Advanced Supply Chain Management', 'PE', 'Hard', 4).
course('Contemporary Supply Chain Management 1', 'PE', 'Medium', 1).
course('Contemporary Operations Management 3', 'PE', 'Medium', 3).
course('Advanced Manufacturing Processes 2', 'PE', 'Hard', 2).
course('Advanced Lean Manufacturing 2', 'PE', 'Hard', 2).
course('Advanced Reliability Engineering 3', 'PE', 'Hard', 3).
course('Principles of Operations Management', 'PE', 'Medium', 4).
course('Material Science 1', 'PE', 'Medium', 1).
course('Applied Industrial Robotics 3', 'PE', 'Medium', 3).
course('Principles of Operations Management 1', 'PE', 'Medium', 1).
course('Computational Six Sigma 1', 'PE', 'Hard', 1).
course('Principles of Computer Integrated Manufacturing', 'PE', 'Medium', 4).
course('Theoretical Manufacturing Processes 2', 'PE', 'Hard', 2).
course('Theoretical Project Management 2', 'PE', 'Hard', 2).
course('Theoretical Computer Integrated Manufacturing 2', 'PE', 'Hard', 2).
course('Theoretical Manufacturing Processes', 'PE', 'Hard', 4).
course('Principles of Ergonomics 2', 'PE', 'Medium', 2).
course('Industrial Robotics 3', 'PE', 'Medium', 3).
course('Advanced Computer Integrated Manufacturing 3', 'PE', 'Hard', 3).
course('Six Sigma 3', 'PE', 'Medium', 3).

% --- 3. COURSE TAGGING (Preferences) ---
% course_tag(CourseName, Tag).
course_tag('Artificial Intelligence', 'AI').
course_tag('Computational Natural Language Processing', 'AI').
course_tag('Computer Programming (C/C++)', 'Programming').
course_tag('Data Structures and Algorithms', 'Programming').
course_tag('Object-Oriented Programming', 'Software').
course_tag('Fundamentals of Software Engineering 1', 'Software').
course_tag('Introduction to Cybersecurity', 'Software').
course_tag('Electrical Circuits 1', 'Circuits').
course_tag('Electrical Circuits 2', 'Circuits').
course_tag('Digital Electronics', 'Electronics').
course_tag('VLSI Design 2', 'Hardware').
course_tag('Advanced Embedded Systems 2', 'Hardware/Software').
course_tag('Mathematics 1 (Calculus)', 'Math').
course_tag('Physics 1 (Mechanics)', 'Physics').
course_tag('Fluid Mechanics', 'Fluids').
course_tag('Engineering Thermodynamics', 'Thermal').
course_tag('Structural Analysis 1', 'Structures').
course_tag('History of Architecture', 'History').
course_tag('Technical Report Writing', 'Soft Skills').
course_tag('Public Speaking 2', 'Soft Skills').
course_tag('Principles of Macroeconomics', 'Management').
course_tag('Fundamentals of Entrepreneurship', 'Management').
course_tag('Advanced Robotics and Automation 2', 'Optimization').
course_tag('Advanced Manufacturing Processes 2', 'Manufacturing').
course_tag('Field Work', 'Practical'). 
course_tag('Theoretical Computer Architecture', 'Theory').

% --- 4. PREREQUISITES ---
% prerequisite(Course, MustBeFinishedFirst).
prerequisite('Mathematics 2 (Integration)', 'Mathematics 1 (Calculus)').
prerequisite('Mathematics 3 (Differential Equations)', 'Mathematics 2 (Integration)').
prerequisite('Data Structures and Algorithms', 'Computer Programming (C/C++)').
prerequisite('Object-Oriented Programming', 'Computer Programming (C/C++)').
prerequisite('Artificial Intelligence', 'Data Structures and Algorithms').
prerequisite('Advanced Reinforced Concrete Design', 'Applied Reinforced Concrete Design 1').
prerequisite('Electrical Circuits 2', 'Electrical Circuits 1').
:- dynamic student/4.
:- dynamic completed/2.


% --- 5. TEST DATA ---
% student(Name, Dept, Year, [Interests]).
student(zaki, 'CSE', 2, ['AI', 'Programming', 'Software']).
completed(zaki, 'Mathematics 1 (Calculus)').
completed(zaki, 'Introduction to Computer Engineering').
completed(zaki, 'Computer Programming (C/C++)').

% results
% ?- recommend(zaki, Course).
% Course = 'Object-Oriented Programming' ;
% Course = 'Data Structures and Algorithms' ;
% Course = 'Fundamentals of Software Engineering 1' ;
% Course = 'Introduction to Cybersecurity' ;
% false.