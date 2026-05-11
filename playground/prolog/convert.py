import pandas as pd

# Load the Excel file
df = pd.read_excel('knowledge_base_400.xlsx')

# Open a new file to write our Prolog facts
with open('courses_data.pl', 'w', encoding='utf-8') as f:
    for index, row in df.iterrows():
        # Wrap strings in single quotes for Prolog atoms
        name = f"'{row['course_name']}'"
        diff = f"'{row['difficulty']}'"
        prereq = f"'{row['prerequisite']}'"
        pref = f"'{row['preference']}'"
        year = row['year_of_study'] # Keep as integer
        dept = f"'{row['department']}'"
        
        # Write the fact
        f.write(f"course({name}, {diff}, {prereq}, {pref}, {year}, {dept}).\n")

print("Success! Created courses_data.pl ready for GNU Prolog.")