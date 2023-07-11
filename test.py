import os;

components = ["match", "member_fn", "for_loop", "init_list", "macro", "trait"]

def check():
    for component in components:
        if os.path.exists(f"tests/{component}.ly") and os.path.isfile(f"tests/{component}.ly"):
            continue
        print(f"test component `{component}` does not exist or is not a file")
        exit()

def compile():
    for component in components:
        print(f"[compiling]: {component}")
        os.system(f"bin/lygosc tests/{component}.ly -o tests/{component} -e llvm-ir")


def clean():
    for component in components:
        os.system(f"rm tests/{component} tests/{component}.ll tests/{component}.o")

def validate():
    failed_modules = []
    for component in components:
        if os.path.exists(f"tests/{component}.ly") and os.path.isfile(f"tests/{component}.ly"):
            continue
        print(f" failed to compile `{component}`")
        failed_modules.append(component)
    if len(failed_modules) == 0:
        print("successfully compiled all components")
    else:
        print(f"failed to compile components: {failed_modules}")

def main():
    check()
    clean()
    compile()
    #exectue()
    validate()

main()
