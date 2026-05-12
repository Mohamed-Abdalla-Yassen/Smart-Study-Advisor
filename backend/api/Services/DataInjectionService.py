from pyswip import Prolog

class DataInjectionService:
    def __init__(self, prolog_instance: Prolog):
        self.prolog = prolog_instance

    def inject_student_data(self, data: dict):
        dept = data.get('department', 'CSE')
        year = data.get('year', 1)
        interests = data.get('interests', [])
        passed_courses = data.get('passed_courses', [])
        diffs = data.get('difficulties', ['Easy', 'Medium', 'Hard'])

        try:
            # λ interests . str(interests).replace('"', "'")
            # Lambda transformation to convert Python double-quoted strings into Prolog-compatible single-quoted atoms within a list.
            format_list = lambda items: str(items).replace('"', "'")
            interests_prolog = format_list(interests)
            diffs_prolog = format_list(diffs)
            name = 'non'
            student_fact = f"student({name}, '{dept}', {year}, {interests_prolog}, {diffs_prolog})"
            self.prolog.assertz(student_fact)

            for course in passed_courses:
                self.prolog.assertz(f"completed({name}, '{course}')")

            print(f"[DEBUG] Facts successfully injected for: {name}")

        except Exception as e:
            print(f"[ERROR] Injection failed: {e}")