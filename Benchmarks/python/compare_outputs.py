""" Compares the outputs from Anura3D and the stashed files that are deemed correct """
import os
import numpy as np
import pandas as pd

# def load_output(filename):
#     """Load output data from a file."""
#     return np.loadtxt(filename)

# def compare_outputs(actual_file, expected_file, tolerance=1e-6):
#     """Compare actual output with expected output."""
#     actual = load_output(actual_file)
#     expected = load_output(expected_file)
    
#     if actual.shape != expected.shape:
#         return False, f"Shape mismatch: actual {actual.shape}, expected {expected.shape}"
    
#     diff = np.abs(actual - expected)
#     max_diff = np.max(diff)
    
#     if max_diff > tolerance:
#         return False, f"Max difference {max_diff} exceeds tolerance {tolerance}"
    
#     return True, "Outputs match"

def is_float(token):
    """Return True if token can be converted to float."""
    try:
        float(token.replace("D", "E"))
        return True
    except ValueError:
        return False

def to_float(token):
    """Convert Fortran-style float text to Python float."""
    return float(token.replace("D", "E"))

def compare_files(file1_path, file2_path):
    """
    Compare two files line by line but ONLY for lines containing numerical data.
    Header/comment lines are ignored.
    """

    tolerance = 1e-6

    with open(file1_path, 'r', newline=None) as f1, open(file2_path, 'r', newline=None) as f2:
        lines1 = f1.readlines()
        lines2 = f2.readlines()

    differences = []
    max_lines = max(len(lines1), len(lines2))

    for i in range(max_lines):

        line1 = " ".join(lines1[i].split()) if i < len(lines1) else ""
        line2 = " ".join(lines2[i].split()) if i < len(lines2) else ""

        # Skip lines without any numeric content
        tokens_check = (line1 + " " + line2).split()
        if not any(is_float(t) for t in tokens_check):
            continue

        if line1 == line2:
            continue

        tokens1 = line1.split() if line1 else []
        tokens2 = line2.split() if line2 else []
        max_tokens = max(len(tokens1), len(tokens2))

        token_messages = []

        for j in range(max_tokens):
            tok1 = tokens1[j] if j < len(tokens1) else "<missing>"
            tok2 = tokens2[j] if j < len(tokens2) else "<missing>"

            if tok1 == tok2:
                continue

            # If both are numeric, ignore tiny differences
            if is_float(tok1) and is_float(tok2):
                diff = abs(to_float(tok1) - to_float(tok2))
                if diff <= tolerance:
                    continue

                token_messages.append(f"    Token {j+1} differs:")
                token_messages.append(f"      actual   = {tok1}")
                token_messages.append(f"      expected = {tok2}")
                token_messages.append(f"      abs diff = {diff:.16e}")
            else:
                token_messages.append(f"    Token {j+1} differs:")
                token_messages.append(f"      actual   = {tok1}")
                token_messages.append(f"      expected = {tok2}")

        # Only record the line if at least one real difference remains
        if token_messages:
            line_message = []
            line_message.append(f"Line {i+1} differs:")
            line_message.append(f"  actual   : {line1}")
            line_message.append(f"  expected : {line2}")
            line_message.extend(token_messages)
            differences.append("\n".join(line_message))

    if differences:
        passed = False
        message = "The test failed. Differences:\n\n" + "\n\n".join(differences[:10])
    else:
        passed = True
        message = "The test passed"

    return passed, message

def run_comparisons():
    """Run comparisons for wave ENG and all expected benchmark files automatically."""
    import glob

    script_dir = os.path.dirname(__file__)
    benchmark_root = os.path.abspath(os.path.join(script_dir, ".."))
    precommit_root = os.path.join(benchmark_root, "Pre-Commit_Tests")

    print("Benchmark root:", benchmark_root)

    all_passed = True
    compared_any = False
    passed_count = 0
    failed_count = 0

    # -------------------------------------------------
    # 1. Compare wave ENG file
    # -------------------------------------------------
    wave_actual = os.path.join(benchmark_root, "wave", "wave_small_001.ENG")
    wave_expected = os.path.join(benchmark_root, "wave", "wave_small_001_expected.ENG")

    if os.path.exists(wave_actual) and os.path.exists(wave_expected):
        compared_any = True
        passed, message = compare_files(wave_actual, wave_expected)

        status = "PASSED" if passed else "FAILED"
        print(f"[{status}] {wave_actual}")

        if not passed:
            print(message)
            failed_count += 1
        else:
            print(message)
            passed_count += 1

        all_passed = all_passed and passed
    else:
        print("[FAILED] wave ENG comparison files not found")
        all_passed = False
        failed_count += 1

    # -------------------------------------------------
    # 2. Compare all expected BMR/BMS/BM files recursively
    # -------------------------------------------------
    expected_files = sorted(
        glob.glob(os.path.join(precommit_root, "**", "*_expected.BMR"), recursive=True) +
        glob.glob(os.path.join(precommit_root, "**", "*_expected.BMS"), recursive=True) +
        glob.glob(os.path.join(precommit_root, "**", "*_expected.BM"), recursive=True)
    )

    if not expected_files:
        print("No expected BMR/BMS/BM files were found in Pre-Commit_Tests.")
    else:
        for expected_file in expected_files:
            actual_file = expected_file.replace("_expected", "")

            print(f"\nComparing:")
            print(f"  actual   = {actual_file}")
            print(f"  expected = {expected_file}")

            compared_any = True

            if not os.path.exists(actual_file):
                print(f"[FAILED] actual file not found: {actual_file}")
                all_passed = False
                failed_count += 1
                continue

            passed, message = compare_files(actual_file, expected_file)

            status = "PASSED" if passed else "FAILED"
            print(f"[{status}] {actual_file}")

            if not passed:
                print(message)
                failed_count += 1
            else:
                print(message)
                passed_count += 1

            all_passed = all_passed and passed

    if not compared_any:
        print("No benchmark comparisons were performed.")
        return False

    print(f"\nSummary: {passed_count} passed, {failed_count} failed")
    return all_passed
    
if __name__ == "__main__":
    # Run the comparisons
    all_passed = run_comparisons()
    print("made it through the check")
    exit(0 if all_passed else 1)
