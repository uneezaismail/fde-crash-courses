import sys
import os
import importlib.util

def main():
    if len(sys.argv) < 2:
        print("Usage: run_tests.py <test_file> [keyword]")
        sys.exit(1)
        
    test_file = sys.argv[1]
    keyword = sys.argv[2] if len(sys.argv) > 2 else ""
    
    # Add the directory containing the test file and its parent's src to path
    test_dir = os.path.dirname(os.path.abspath(test_file))
    worktree_root = os.path.dirname(test_dir)
    
    # Insert worktree src and test directories at the beginning of sys.path
    sys.path.insert(0, os.path.join(worktree_root, "src"))
    sys.path.insert(0, test_dir)
    
    # Force reload calculator if it was already imported
    if "calculator" in sys.modules:
        del sys.modules["calculator"]
        
    # Load the test file module
    try:
        spec = importlib.util.spec_from_file_location("test_module", test_file)
        test_module = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(test_module)
    except Exception as e:
        print(f"Error loading test file {test_file}: {e}")
        sys.exit(1)
    
    # Find all test functions matching the keyword
    test_funcs = [
        name for name in dir(test_module)
        if name.startswith("test_") and (not keyword or keyword in name)
    ]
    
    if not test_funcs:
        print(f"No tests found matching keyword: {keyword}")
        sys.exit(1)
        
    failed = False
    for func_name in test_funcs:
        func = getattr(test_module, func_name)
        try:
            func()
            print(f"PASS: {func_name}")
        except AssertionError as e:
            print(f"FAIL: {func_name} (AssertionError)")
            failed = True
        except Exception as e:
            print(f"FAIL: {func_name} ({type(e).__name__}: {e})")
            failed = True
            
    if failed:
        sys.exit(1)
    else:
        sys.exit(0)

if __name__ == "__main__":
    main()
