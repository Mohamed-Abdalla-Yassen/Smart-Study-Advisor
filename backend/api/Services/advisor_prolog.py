from .base import BaseAdvisorService
from .DataInjectionService import DataInjectionService
from pyswip import Prolog
import os

class PrologAdvisorService(BaseAdvisorService):
    def __init__(self):
        self.prolog = Prolog()
        self.injector = DataInjectionService(self.prolog)

        try:
            current_dir = os.path.dirname(os.path.abspath(__file__))
            root_dir = os.path.dirname(os.path.dirname(os.path.dirname(current_dir)))
            prolog_file = os.path.join(root_dir, "advice.pl")
            self.prolog.consult(prolog_file.replace('\\', '/'))
        except Exception as e:
            print(f"[ERROR] Consult failed: {e}")

    def get_recommendations(self, data: dict) -> list:
        student_name = data.get('student_name', 'guest').lower()

        try:
            # Inject Dynamic Facts (Moving beyond hardcoded 'zaki')
            self.injector.inject_student_data(data)

            query = f"recommend({student_name}, Course)"
            results = self.prolog.query(query)

            # λres.str(res["Course"])
            # map the transformation function over the raw Prolog result dictionaries from dictionary objects to clean course name strings
            # list
            recommendations = list(map(lambda res: str(res["Course"]), results))

            # λx.x!="None"
            # filter the list of course strings using a predicate to remove empty or invalid entries
            # list
            final_list = list(filter(lambda x: x != "None", recommendations))

            # Retract temporary facts to keep the engine state stateless for the next request
            self.prolog.retractall(f"student({student_name}, _, _, _)")
            self.prolog.retractall(f"completed({student_name}, _)")
            return final_list if final_list else ["No recommendations found."]

        except Exception as e:
            return [f"Logic Engine Error: {e}"]