course(cse225, 'Programming Paradigms', 3).
course(cse311, 'Artificial Intelligence', 4).
course(cse412, 'Machine Learning', 5).

recommend(Student, 'High', CourseTitle) :-
    course(_, CourseTitle, Difficulty),
    Difficulty >= 4.

recommend(Student, 'Basic', CourseTitle) :-
    course(_, CourseTitle, Difficulty),
    Difficulty < 4.