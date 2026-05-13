from pyswip import Prolog

class DataInjectionService:
    def __init__(self, prolog_instance: Prolog):
        self.prolog = prolog_instance

    def inject_student_data(self, data: dict):
        dept = data.get('dept', 'CSE')
        years = data.get('years', [1])
        years = [int(y) for y in years]

        interests = data.get('prefs', [])
        passed_courses = data.get('prereqs', [])
        diffs = data.get('difficulties', ['Easy', 'Medium', 'Hard'])

        print(data)
        try:
            # λ interests . str(interests).replace('"', "'")
            # Lambda transformation to convert Python double-quoted strings into Prolog-compatible single-quoted atoms within a list.
            format_list = lambda items: str(items).replace('"', "'")
            interests_prolog = format_list(interests)
            diffs_prolog = format_list(diffs)
            years_prolog = format_list(years)
            name = 'non'
            student_fact = f"student({name}, '{dept}', {years_prolog}, {interests_prolog}, {diffs_prolog})"
            self.prolog.assertz(student_fact)

            for course in passed_courses:
                self.prolog.assertz(f"completed({name}, '{course}')")

            print(f"[DEBUG] Facts successfully injected for: {name}")

        except Exception as e:
            print(f"[ERROR] Injection failed: {e}")