from .base import BaseAdvisorService
from pyswip import Prolog

class PrologAdvisorService(BaseAdvisorService):
    def __init__(self):
        self.prolog = Prolog()
        self.prolog.consult("inference_engine.pl")

    def get_recommendations(self, data: dict) -> list:
        # dept = data.get('department')
        # year = data.get('year_of_study')
        # pref = data.get('preferences')
        # passed = data.get('passed_courses', [])


        # Logic Paradigm: Single query with all arguments Approach A (mentioned in course.py)
        # No facts are saved in Prolog memory; everything is in this string
        # query = f"recommend({year}, '{dept}', '{pref}', {passed_prolog_format}, Course)"

        # results = list(self.prolog.query(query))

        # return [str(res["Course"]) for res in results]
        #  Dynamic Fact Injection
        # Use self.prolog.assertz() to 'upload' Dept, Year, and Passed Courses (can work in two approaches) or passing only student data ( Approach B)
        # Call a simple query: recommend_for_student(Course)
        # This follows the 'Memory' approach rather than 'Function' approach
        pass