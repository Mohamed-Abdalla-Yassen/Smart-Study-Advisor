from .base import BaseAdvisorService
from .DataInjectionService import DataInjectionService
from .CourseRepository import CourseRepository
from .RecommendationEngine import RecommendationEngine
from pyswip import Prolog
import os

class PrologAdvisorService(BaseAdvisorService):
    def __init__(self):
        self.prolog = Prolog()
        self.injector = DataInjectionService(self.prolog)
        self.repo = CourseRepository(self.prolog)
        self.engine = RecommendationEngine(self.prolog, self.repo)

        try:
            current_dir = os.path.dirname(os.path.abspath(__file__))
            root_dir = os.path.dirname(os.path.dirname(os.path.dirname(current_dir)))
            prolog_file = os.path.join(root_dir, "advice.pl")
            self.prolog.consult(prolog_file.replace('\\', '/'))
        except Exception as e:
            print(f"[ERROR] Consult failed: {e}")

    def get_recommendations(self, data: dict) -> list:
        student_name = 'non'

        try:
            # Inject Dynamic Facts using the injected service
            self.injector.inject_student_data(data)

            # Delegate computation to the recommendation engine
            results = self.engine.compute_recommendations(student_name)

            # Retract temporary facts to keep the engine state stateless for the next request
            self.prolog.retractall(f"student({student_name}, _, _, _, _)")
            self.prolog.retractall(f"completed({student_name}, _)")

            return results if results else ["No recommendations found."]

        except Exception as e:
            return [{"error": f"Logic Engine Error: {e}"}]