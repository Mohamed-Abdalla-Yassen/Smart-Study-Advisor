from .base import BaseAdvisorService
from pyswip import Prolog
import os

class PrologAdvisorService(BaseAdvisorService):
    def __init__(self):
        self.prolog = Prolog()
        try:
            current_dir = os.path.dirname(os.path.abspath(__file__))
            api_dir = os.path.dirname(current_dir)
            backend_dir = os.path.dirname(api_dir)
            root_dir = os.path.dirname(backend_dir)

            prolog_file = os.path.join(root_dir, "advice.pl")

            if os.path.exists(prolog_file):
                self.prolog.consult(prolog_file.replace('\\', '/'))
                print(f"[DEBUG] Successfully consulted: {prolog_file}")
            else:
                print(f"[ERROR] Prolog file not found at {prolog_file}")
        except Exception as e:
            print(f"[ERROR] Initialization error: {e}")

    def get_recommendations(self, data: dict) -> list:
        student_name = data.get('student_name').lower()

        try:
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

            return final_list if final_list else ["No recommendations found."]

        except Exception as e:
            print(f"[ERROR] Prolog query failed: {e}")
            return [f"Error in logic engine: {e}"]