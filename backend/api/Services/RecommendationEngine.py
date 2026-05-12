class RecommendationEngine:
    def __init__(self, prolog, repository):
        self.prolog = prolog
        self.repo = repository
        self.tiers = [
            ("recommend_tier1", 100, "1"),
            ("recommend_tier2", 70, "2"),
            ("recommend_tier3", 50, "3"),
            ("recommend_tier4", 20, "4")
        ]

    def compute_recommendations(self, student_name):
        final_results = []
        seen_courses = set()

        for predicate, percentage, tier_label in self.tiers:
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
            unique_tier_courses = list(filter(lambda x: x not in seen_courses, valid_courses))

            for course_name in unique_tier_courses:
                details = self.repo.get_course_details(course_name)
                pre_list = self.repo.get_prerequisites(course_name)
                c_tag = self.repo.get_course_tag(course_name)

                final_results.append({
                    "course_name": course_name,
                    "match_percentage": float(percentage),
                    "match_tier": f"Tier {tier_label} ({percentage}%)",
                    "details": {
                        "course_name": course_name,
                        "difficulty": str(details["Diff"]),
                        "prerequisite": ", ".join(pre_list) if pre_list else "None",
                        "preference": c_tag,
                        "year_of_study": int(details["Year"]),
                        "department": str(details["Dept"])
                    }
                })
                seen_courses.add(course_name)

        return final_results