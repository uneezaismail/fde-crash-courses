import sys
import os
import importlib.util

def main():
    test_file = sys.argv[1] if len(sys.argv) > 1 else "test/test_calculator.py"
    keyword = sys.argv[2] if len(sys.argv) > 2 else ""
    
    test_dir = os.path.dirname(os.path.abspath(test_file))
    worktree_root = os.path.dirname(test_dir)
    
    sys.path.insert(0, os.path.join(worktree_root, "src"))
    sys.path.insert(0, test_dir)
    
    if "calculator" in sys.modules:
        del sys.modules["calculator"]
        
    try:
        spec = importlib.util.spec_from_file_location("test_module", test_file)
        test_module = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(test_module)
    except Exception as e:
        print(f"Error loading test file: {e}")
        sys.exit(1)
    
    test_funcs = [
        name for name in dir(test_module)
        if name.startswith("test_") and (not keyword or keyword in name)
    ]
    
    failed = False
    for func_name in test_funcs:
        func = getattr(test_module, func_name)
        try:
            func()
            print(f"PASS: {func_name}")
        except Exception as e:
            print(f"FAIL: {func_name} ({type(e).__name__}: {e})")
            failed = True
            
    if failed:
        sys.exit(1)
    else:
        sys.exit(0)

if __name__ == "__main__":
    main()
