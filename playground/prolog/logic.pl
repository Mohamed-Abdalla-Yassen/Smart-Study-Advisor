% Load the generated facts automatically
:- include('courses_data.pl').

% ==========================================
% Inference Engine Rules (Lab 3 Requirements)
% ==========================================

% Rule 1: Basic Recommendation based on student preference and department
recommend(Preference, Department, RecommendedCourse) :-
    course(RecommendedCourse, _Difficulty, _Prereq, Preference, _Year, Department).

% Rule 2: Recommend appropriate courses for a student,s current year
% (Assuming they can take courses from their current year or earlier)
recommend_by_year(StudentYear, RecommendedCourse) :-
    course(RecommendedCourse, _Difficulty, _Prereq, _Preference, CourseYear, _Dept),
    CourseYear =< StudentYear.

% Rule 3: Find courses that don,t have prerequisites (Good for freshmen)
no_prereq_course(Course, Department) :-
    course(Course, _Difficulty, 'None', _Preference, _Year, Department).

% Rule 4: Advanced Recommendation: Match Year, Preference, AND Difficulty
smart_recommend(StudentYear, StudentPref, MaxDifficulty, Course) :-
    course(Course, MaxDifficulty, _Prereq, StudentPref, CourseYear, _Dept),
    CourseYear =< StudentYear.

recommend(Difficulty, Prereq, Preference, Year, Department, RecommendedCourse) :-
    course(RecommendedCourse, Difficulty, Prereq, Preference, Year, Department).
