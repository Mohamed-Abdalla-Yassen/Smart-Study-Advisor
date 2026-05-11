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
        student_name = 'non'

        try:
            # Inject Dynamic Facts (Moving beyond hardcoded 'zaki')
            self.injector.inject_student_data(data)

            tiers = [
                ("recommend_tier1", 100, "1"),
                ("recommend_tier2", 70, "2"),
                ("recommend_tier3", 50, "3"),
                ("recommend_tier4", 20, "4")
            ]

            final_results = []
            seen_courses = set()

            for predicate, percentage, tier_label in tiers:
                results = self.prolog.query(f"{predicate}({student_name}, Course)")

                # λres.str(res["Course"])
                # map the transformation function over the raw Prolog result dictionaries from dictionary objects to clean course name strings
                # list
                recommendations = list(map(lambda res: str(res["Course"]), results))

                # λx.x!="None"
                # filter the list of course strings using a predicate to remove empty or invalid entries
                # list
                valid_courses = list(filter(lambda x: x != "None", recommendations))
                # λx.x not in seen_courses
                # filter the list of course strings using a predicate to remove duplicate entries across tiers
                # list
                unique_tier_courses = list(filter(lambda x: x not in seen_courses, valid_courses)) #Already handled in prolog file

                for course_name in unique_tier_courses:
                    course_query = list(self.prolog.query(f"course('{course_name}', Dept, Diff, Year)"))
                    c_info = course_query[0] if course_query else {"Dept": "Unknown", "Diff": "Unknown", "Year": 0}
                    tag_query = list(self.prolog.query(f"course_tag('{course_name}', Tag)"))
                    c_tag = str(tag_query[0]["Tag"]) if tag_query else "General"
                    pre_query = self.prolog.query(f"prerequisite('{course_name}', PreReq)")
                    # λp.str(p["PreReq"])
                    # map the transformation function over the raw Prolog result dictionaries from dictionary objects to clean course name strings
                    # list
                    pre_list = list(map(lambda p: str(p["PreReq"]), pre_query))

                    final_results.append({
                        "course_name": course_name,
                        "match_percentage": float(percentage),
                        "match_tier": f"Tier {tier_label} ({percentage}%)",
                        "details": {
                            "course_name": course_name,
                            "difficulty": str(c_info["Diff"]),
                            "prerequisite": ", ".join(pre_list) if pre_list else "None",
                            "preference": c_tag,
                            "year_of_study": int(c_info["Year"]),
                            "department": str(c_info["Dept"])
                        }
                    })
                    seen_courses.add(course_name)

            # Retract temporary facts to keep the engine state stateless for the next request
            self.prolog.retractall(f"student({student_name}, _, _, _, _)")
            self.prolog.retractall(f"completed({student_name}, _)")

            return final_results if final_results else ["No recommendations found."]

        except Exception as e:
            return [{"error": f"Logic Engine Error: {e}"}]