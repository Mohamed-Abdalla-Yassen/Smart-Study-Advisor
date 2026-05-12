class CourseRepository:
    def __init__(self, prolog):
        self.prolog = prolog

    def get_course_details(self, course_name):
        query = list(self.prolog.query(f"course('{course_name}', Dept, Diff, Year)"))
        return query[0] if query else {"Dept": "Unknown", "Diff": "Unknown", "Year": 0}

    def get_course_tag(self, course_name):
        query = list(self.prolog.query(f"course_tag('{course_name}', Tag)"))
        return str(query[0]["Tag"]) if query else "General"

    def get_prerequisites(self, course_name):
        query = self.prolog.query(f"prerequisite('{course_name}', PreReq)")
        # λp.str(p["PreReq"])
        # map the transformation function over the raw Prolog result dictionaries from dictionary objects to clean course name strings
        # list
        return list(map(lambda p: str(p["PreReq"]), query))