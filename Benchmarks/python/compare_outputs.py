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

def compare_files(file1_path, file2_path):
    """
    Compare the files passed in. If they don't match set passed to false and return the information that is different
    """

    # Open the files and read all of the lines
    with open(file1_path, 'r', newline=None) as f1, open(file2_path, 'r', newline=None) as f2:
        lines1 = f1.readlines()
        lines2 = f2.readlines()
    
    # Init list to track the differences between the files
    differences = []

    # Get the max number of lines in 
    max_lines = max(len(lines1), len(lines2))
    
    # print the actual file
    print(file1_path)

    for i in range(max_lines):
        # Get the line i of the file if i is not greater than the length of the file
        line1 = " ".join(lines1[i].split()) if i < len(lines1) else ""
        line2 = " ".join(lines2[i].split()) if i < len(lines2) else ""
        if line1 != line2:
            differences.append((i + 1, line1, line2))
    
    if len(differences) > 0:
        passed = False
        message = "The test failed. The differences are: \n" + \
                   "Line #    ---- Actual -----   ---- Expected ----- \n" + \
                   "\n".join(map(str, differences[:10])) + "\n"
    else:
        passed = True
        message = "The test passed"

    return passed, message

def compare_file_as_dfs(file_1_path, file_2_path, tolerance = 1e-4):
    """
    Load in two files and compare them as dfs
    Assumes that the columns are all the same
    """


    # Store the first file as a df
    df1 = pd.read_csv(file_1_path, sep = "\\s+")

    # Store the second as a df
    df2 = pd.read_csv(file_2_path, sep = "\\s+")

    diff = df1 - df2

    abs_diff = np.abs(diff)
    
    # Check if the difference are with the tolerance
    within_tolerance = abs_diff <= tolerance

    # Check if all values are with the tolerance
    all_within_tolerance = within_tolerance.all().all()

    if all_within_tolerance:
        passed = True
        message = "The test passed"
    else:
        passed = False
        message = "The test failed"

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
    skipped_count = 0

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
            passed_count += 1

        all_passed = all_passed and passed
    else:
        print("[FAILED] wave ENG comparison files not found")
        all_passed = False
        failed_count += 1

    # -------------------------------------------------
    # 2. Compare all Pre-Commit_Tests expected files
    # -------------------------------------------------
    benchmark_dirs = sorted(
        d for d in glob.glob(os.path.join(precommit_root, "*")) if os.path.isdir(d)
    )

    for bench in benchmark_dirs:
        a3d_dirs = sorted(glob.glob(os.path.join(bench, "*.A3D")))

        if not a3d_dirs:
            print(f"[SKIPPED] No .A3D folder found in {bench}")
            skipped_count += 1
            continue

        for a3d_dir in a3d_dirs:
            print(f"\n=== Checking benchmark: {a3d_dir} ===")

            expected_files = sorted(
                glob.glob(os.path.join(a3d_dir, "*_expected.BMR")) +
                glob.glob(os.path.join(a3d_dir, "*_expected.BMS")) +
                glob.glob(os.path.join(a3d_dir, "*_expected.BM"))
            )

            if not expected_files:
                print(f"[SKIPPED] No expected comparison files found in {a3d_dir}")
                skipped_count += 1
                continue

            for expected_file in expected_files:
                actual_file = expected_file.replace("_expected", "")
                print(f"Comparing:\n  actual   = {actual_file}\n  expected = {expected_file}")

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
                    passed_count += 1

                all_passed = all_passed and passed

    if not compared_any:
        print("No expected benchmark files were found.")
        return False

    print(f"\nSummary: {passed_count} passed, {failed_count} failed, {skipped_count} skipped")
    return all_passed
    
if __name__ == "__main__":
    # Run the comparisons
    all_passed = run_comparisons()
    print("made it through the check")
    exit(0 if all_passed else 1)
