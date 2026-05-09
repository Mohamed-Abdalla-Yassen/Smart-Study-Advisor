<div align="center">

# 🎓 Smart Study Advisor
### CSE-225 · Programming Languages Paradigms · Lab 3
#### Alexandria University — Faculty of Engineering — Computer & Systems Engineering

<br/>

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Django](https://img.shields.io/badge/Django-092E20?style=for-the-badge&logo=django&logoColor=white)
![Prolog](https://img.shields.io/badge/Prolog-FF6600?style=for-the-badge&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)

> An intelligent course recommendation system built with **multiple programming paradigms** —  
> Logic (Prolog), OOP, Functional, and Imperative — with an AI-powered alternative via Groq.

</div>

---

## 📸 Screenshots

> _Add your screenshots here after running the app_

| Home Screen | Advisor Form | Results |
|:-----------:|:------------:|:-------:|
| ![Home](assets/screenshots/home.png) | ![Form](assets/screenshots/form.png) | ![Results](assets/screenshots/results.png) |

<!-- To add screenshots:
  1. Take screenshots while the app is running
  2. Save them in assets/screenshots/
  3. The table above will render them automatically -->

---

## 🎬 Demo Videos

> _Add your demo video links here_

### Part 1 — AI Advisor (Groq)
[![AI Demo](https://img.shields.io/badge/▶_Watch_Demo-FF0000?style=for-the-badge&logo=youtube)](https://youtube.com/your-link-here)

<!-- Or embed directly if hosted:
![AI Demo](assets/videos/ai_demo.gif) -->

### Part 2 — Logic Advisor (Prolog)
[![Logic Demo](https://img.shields.io/badge/▶_Watch_Demo-FF0000?style=for-the-badge&logo=youtube)](https://youtube.com/your-link-here)

<!-- Replace the YouTube links above with your actual video URLs -->

---

## 📋 Overview

This project implements a **Smart Study Advisor** that recommends university courses to students based on their department, interests, difficulty preference, and year of study.

The system is built in **two versions**:

| Version | Engine | Description |
|---------|--------|-------------|
| 🤖 **AI Advisor** | Groq LLM API | Uses a large language model to reason about student profiles and generate natural language recommendations |
| 🧠 **Logic Advisor** | Prolog + PySwip | Uses formal logical rules and an inference engine to deterministically match courses |

---

## 🏗️ System Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     Flutter Frontend                        │
│    Home Screen → Advisor Form → Results Screen             │
└──────────────────────────┬──────────────────────────────────┘
                           │ HTTP
           ┌───────────────┴───────────────┐
           ▼                               ▼
┌─────────────────────┐       ┌────────────────────────┐
│   Django REST API   │       │   Django REST API      │
│  /recommend/noAi/   │       │   /recommend/ai/       │
└──────────┬──────────┘       └───────────┬────────────┘
           │                              │
           ▼                              ▼
┌─────────────────────┐       ┌────────────────────────┐
│   Prolog Engine     │       │      Groq LLM API      │
│  (PySwip + logic.pl)│       │  (compound model)      │
└─────────────────────┘       └────────────────────────┘
```

### API Endpoints

| Method | URL | View | Description |
|--------|-----|------|-------------|
| `GET` | `/playground/recommend/noAi/` | `get_recommendations` | Logic-based via Prolog |
| `POST` | `/playground/recommendPost/noAi/` | `get_recommendations_post` | Logic-based via Prolog (POST) |
| `POST` | `/playground/recommend/ai/` | `get_AI_recommendations` | AI-based via Groq |

---

## 🧩 Paradigms Used

This project is a **paradigms blender** — each layer uses the paradigm that fits it best:

### 🔵 Logic Paradigm — Prolog
**Where:** `logic.pl` inference engine  
**Why:** Prolog is purpose-built for rule-based reasoning. Course prerequisites, difficulty levels, and student–course matching are naturally expressed as logical facts and rules — no loops, just declarations.
```prolog
recommend(Difficulty, Prereq, Pref, Year, Dept, Course) :-
    course(Course, Dept, Pref, Difficulty, Year),
    ...
```

### 🟢 OOP Paradigm — Django Models & Classes
**Where:** Django views, models, and service classes  
**Why:** The system entities (Student, Course, Recommendation) map cleanly to objects. OOP enables encapsulation of API logic and clean separation of concerns across views.

### 🟡 Functional Paradigm — Django + Flutter data transformation
**Where:** Response parsing, list transformations in both Django and Flutter  
**Why:** Transforming raw Prolog query results into clean JSON responses is a pure data transformation — no side effects, ideal for functional-style `map`, `filter`, and list comprehensions.
```python
recommended_courses = list({
    result["Course"].decode('utf-8')
    for result in prolog.query(query)
})
```

### 🔴 Imperative Paradigm — Execution flow control
**Where:** Django view request handling, Flutter navigation and state  
**Why:** Handling HTTP requests, validating inputs, sequencing API calls, and managing UI state require explicit step-by-step control flow — exactly what imperative programming excels at.

---

## 📱 Flutter Frontend

### Screens

| Screen | File | Description |
|--------|------|-------------|
| 🏠 Home | `home_screen.dart` | Mode selector (AI vs Logic) with animated pipeline diagram |
| 📝 Advisor Form | `advisor_screen.dart` | Student profile input — department, interest, difficulty, year |
| ✅ Results | `results_screen.dart` | Ranked course cards from the backend |

### File Structure

```
lib/
├── main.dart                   # Entry point, theme, orientation lock
│
├── theme/
│   └── app_theme.dart          # AppColors, typography (Syne + Space Grotesk), ThemeData
│
├── models/
│   └── models.dart             # StudentQuery (API params) · CourseResult · AppConstants
│
├── services/
│   └── api_service.dart        # All HTTP calls to Django:
│                               #   getLogicRecommendations()  → GET  /recommend/noAi/
│                               #   getLogicRecommendationsPost() → POST /recommendPost/noAi/
│                               #   getAiRecommendations()     → POST /recommend/ai/
│
├── widgets/
│   └── widgets.dart            # GlowCard · NeonButton · ChipTag · DifficultyBadge · SectionLabel
│
└── screens/
    ├── home_screen.dart
    ├── advisor_screen.dart
    └── results_screen.dart
```

### Design System

| Token | Value |
|-------|-------|
| Background | `#080C14` Obsidian |
| Surface | `#111827` |
| Border | `#1E2D45` |
| **Teal** — Logic mode | `#00E5CC` |
| **Amber** — AI mode | `#FFB830` |
| Display font | **Syne** |
| Body font | **Space Grotesk** |

---

## 🚀 Setup & Running

### Prerequisites
```bash
# Ubuntu / Debian
sudo apt install flutter cmake ninja-build libgtk-3-dev clang lld -y
```

### Flutter (Frontend)
```bash
cd flutter_app/
flutter pub get
flutter run -d linux        # Linux desktop
flutter run -d chrome       # Web (if Chrome available)
```

### Django (Backend)
```bash
cd backend/
pip install django pyswip openai django-cors-headers
python manage.py runserver
```

### Connecting Frontend to Backend
Open `lib/services/api_service.dart` and set:
```dart
// Linux desktop (same machine)
static const String baseUrl = 'http://127.0.0.1:8000/playground';

// Real Android/iOS device
static const String baseUrl = 'http://YOUR_PC_IP:8000/playground';
```

> **Demo Mode:** If Django is unreachable, the app automatically shows mock data so the UI can be demonstrated independently.

---

## 📊 Knowledge Base

The system covers **349 courses** across **8 departments**:

| Department | Courses |
|------------|---------|
| Architecture | 49 |
| Basic and Applied Sciences | 53 |
| Civil Engineering (CE) | 49 |
| Computer & Systems Engineering (CSE) | 53 |
| Electrical & Communications Engineering (EE) | 50 |
| Humanities | 47 |
| Mechanical Engineering (ME) | 50 |
| Production Engineering (PE) | 49 |

Filtered by **23 interest tags**: AI · Chemistry · Circuits · Design · Electronics · Field Work · Fluids · Hardware · Hardware/Software · History · Management · Manufacturing · Math · Optimization · Physics · Practical · Programming · Research · Soft Skills · Software · Structures · Theory · Thermal

---

## 💭 Reflection

> _If you were building a real AI system, what approach would you choose and why?_

For a real production study advisor, we would combine both approaches:

- **Prolog for hard constraints** — prerequisites, credit hours, graduation requirements. These are non-negotiable rules that must be enforced exactly, and Prolog's declarative logic makes them easy to audit and update.
- **LLM for soft recommendations** — understanding student goals, suggesting electives, explaining reasoning in natural language. LLMs excel at nuanced, context-aware suggestions that rule engines can't capture.

The hybrid approach gives you the **reliability of logic** with the **flexibility of AI** — neither alone is sufficient for a system students depend on for their academic careers.

---

## 👥 Team

| Role | Responsibility |
|------|---------------|
| 🎨 **Frontend Engineer** | Flutter app — UI/UX, screens, API integration |
| ⚙️ **Backend Engineer** | Django REST API — views, paradigm demonstrations |
| 🧠 **Logic Programmer** | Prolog inference engine — rules, facts, queries |
| 🤖 **AI Integrator** | Groq API — prompt engineering, response handling |

---

<div align="center">

**CSE-225 · Programming Languages Paradigms · Lab 3**  
Alexandria University — Faculty of Engineering

</div>
