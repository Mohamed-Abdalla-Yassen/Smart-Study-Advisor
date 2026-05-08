from pyswip import Prolog

def get_prolog_recommendation(student_name, interest_level , add):
    prolog = Prolog()
    prolog.consult("inference_engine.pl")
    if add:
        prolog.assertz(f"course('cse412','LA', 2)")


    query = f"recommend({student_name}, '{interest_level}', CourseTitle)"
    results = list(prolog.query(query))

    return [str(res["CourseTitle"]) for res in results]