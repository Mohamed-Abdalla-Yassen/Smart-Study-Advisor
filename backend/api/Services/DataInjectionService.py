from pyswip import Prolog

class DataInjectionService:
    def __init__(self, prolog_instance: Prolog):
        self.prolog = prolog_instance

    def inject_student_data(self, data: dict):
        name = data.get('student_name', 'guest').lower()
        dept = data.get('department', 'CSE')
        year = data.get('year', 1)
        interests = data.get('interests', [])
        passed_courses = data.get('passed_courses', [])

        try:
            # λ interests . str(interests).replace('"', "'")
            # Lambda transformation to convert Python double-quoted strings into Prolog-compatible single-quoted atoms within a list.
            format_list = lambda items: str(items).replace('"', "'")
            interests_prolog = format_list(interests)

            student_fact = f"student({name}, '{dept}', {year}, {interests_prolog})"
            self.prolog.assertz(student_fact)

            # Cam use Map here
            for course in passed_courses:
                self.prolog.assertz(f"completed({name}, '{course}')")

            print(f"[DEBUG] Facts successfully injected for: {name}")

        except Exception as e:
            print(f"[ERROR] Injection failed: {e}")