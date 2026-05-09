#!/usr/bin/env python
"""
Diagnostic script to test Gemini setup components
Run this from your project root: python diagnostic_test.py
"""

import os
import sys

print("=" * 70)
print("GEMINI API DIAGNOSTIC TEST")
print("=" * 70)

# TEST 1: Check .env file
print("\n[TEST 1] Checking .env file...")
if os.path.exists(".env"):
    print("✓ .env file found")
    with open(".env", "r") as f:
        content = f.read()
        if "GEMINI_API_KEY" in content:
            print("✓ GEMINI_API_KEY found in .env")
            for line in content.split("\n"):
                if line.startswith("GEMINI_API_KEY"):
                    key_part = line.split("=", 1)[1].strip() if "=" in line else ""
                    if key_part:
                        print(f"  Key found: {key_part[:20]}...{key_part[-15:] if len(key_part) > 35 else ''}")
                        if key_part.startswith('"') or key_part.startswith("'"):
                            print("  ⚠️  WARNING: Key has quotes - REMOVE THEM!")
                    else:
                        print("  ✗ Key is empty!")
        else:
            print("✗ GEMINI_API_KEY NOT found in .env")
else:
    print("✗ .env file NOT found - Create it with: GEMINI_API_KEY=your_key_here")

# TEST 2: Load .env
print("\n[TEST 2] Loading .env variables...")
try:
    from dotenv import load_dotenv
    load_dotenv()
    api_key = os.getenv("GEMINI_API_KEY")
    if api_key:
        print(f"✓ API key loaded: {len(api_key)} characters")
        print(f"  First 20 chars: {api_key[:20]}...")
    else:
        print("✗ API key is EMPTY after loading .env")
        print("  Check: Is .env in the same directory as this script?")
except Exception as e:
    print(f"✗ Error loading .env: {e}")

# TEST 3: Check packages
print("\n[TEST 3] Checking Python packages...")

# Check for old deprecated package
try:
    import google.generativeai as genai_old
    print("⚠️  OLD package found: google.generativeai (DEPRECATED)")
    print("  Remove it: pip uninstall google-generativeai -y")
except ImportError:
    print("✓ Old google.generativeai not installed (good!)")

# Check for new package
try:
    from google import genai
    print("✓ NEW package found: google-genai (correct!)")
except ImportError:
    print("✗ google-genai NOT installed")
    print("  Install it: pip install google-genai")

# TEST 4: Try to create Gemini client
print("\n[TEST 4] Testing Gemini client creation...")
try:
    from google import genai
    if api_key:
        client = genai.Client(api_key=api_key)
        print("✓ Gemini client created successfully")
    else:
        print("⊘ Skipping (no API key available)")
except Exception as e:
    print(f"✗ Error creating client: {type(e).__name__}: {e}")

# TEST 5: Check advice.pl file
print("\n[TEST 5] Checking advice.pl file...")
prolog_found = False
possible_paths = [
    "advice.pl",
    "./advice.pl",
    os.path.join(os.getcwd(), "advice.pl"),
]

for path in possible_paths:
    if os.path.exists(path):
        abs_path = os.path.abspath(path)
        print(f"✓ Found advice.pl at: {abs_path}")
        
        try:
            with open(path, 'r', encoding='utf-8') as f:
                content = f.read()
            print(f"  File size: {len(content)} bytes")
            
            # Check for course patterns
            import re
            pattern = r"course\('([^']+)',\s*'([^']+)'"
            matches = re.findall(pattern, content)
            print(f"  Courses found: {len(matches)}")
            
            if matches:
                print("\n  Sample courses:")
                for course, dept in matches[:5]:
                    print(f"    - {course} (Dept: {dept})")
            else:
                print("  ⚠️  No courses matched the regex pattern")
                print("  Expected format: course('Name', 'Department', ...)")
                print(f"\n  First 500 chars of file:")
                print(f"  {content[:500]}")
            
            prolog_found = True
            break
        except Exception as e:
            print(f"  ✗ Error reading file: {e}")
            break

if not prolog_found:
    print("✗ advice.pl NOT found")
    print("  Searched in:")
    for path in possible_paths:
        print(f"    - {os.path.abspath(path)}")

# TEST 6: Try actual Gemini API call
print("\n[TEST 6] Testing Gemini API call...")
if api_key:
    try:
        from google import genai
        client = genai.Client(api_key=api_key)
        print("  Sending test prompt to Gemini 1.5 Flash...")
        
        response = client.models.generate_content(
            model="models/gemini-2.5-flash",
            contents="Say 'SUCCESS' and nothing else."
        )
        
        print(f"✓ API call successful!")
        print(f"  Response: {response.text}")
        
    except Exception as e:
        print(f"✗ API call failed: {type(e).__name__}")
        print(f"  Error message: {str(e)}")
        
        # Give more specific guidance
        if "API key" in str(e).upper():
            print("\n  💡 This looks like an API key issue:")
            print("     - Check your GEMINI_API_KEY is correct")
            print("     - Make sure it has no extra spaces or quotes")
            print("     - Generate a new key from https://aistudio.google.com/apikey")
        elif "404" in str(e):
            print("\n  💡 Model not found - check the model name")
            print("     - Try: gemini-1.5-flash or gemini-1.5-pro")
        elif "Authentication" in str(e) or "auth" in str(e).lower():
            print("\n  💡 Authentication error - API key problem")
else:
    print("⊘ Skipping (no API key loaded)")

print("\n" + "=" * 70)
print("DIAGNOSTIC TEST COMPLETE")
print("=" * 70)
print("\nNext steps:")
print("1. Check the [TEST X] results above for any ✗ marks")
print("2. Fix those issues (most common: API key or .env location)")
print("3. Run: python manage.py runserver")
print("4. Test with curl command")
print("=" * 70)