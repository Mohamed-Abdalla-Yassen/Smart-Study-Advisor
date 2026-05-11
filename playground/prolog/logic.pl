:- include('courses_data.pl').

recommend(Difficulty, _Prereq, Preference, Year, Department, Course) :-
    course(Course, Difficulty, _, Preference, Year, Department).

