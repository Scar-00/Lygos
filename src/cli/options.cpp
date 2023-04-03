#include "options.h"

namespace lygos {
    namespace Cli {
        Options::Options(int argc, char **argv) {
            for(s32 i = 0; i < argc; i++) {
                args.push_back(argv[i]);
            }
            for(u32 i = 1; i < args.size(); i++) {
                auto &arg = args[i];
                if(arg == "-c") {
                    if(args.size() > i + 1) {
                        input = Some<Path>(args[i + 1]);
                        emit_exe = false;
                        i += 1;
                        continue;
                    }
                }
                if(arg == "-o") {
                    if(args.size() > i + 1) {
                        output = Some<Path>(args[i + 1]);
                        i += 1;
                        continue;
                    }
                }

                if(arg == "-e") {
                    if(args.size() > i + 1 && args[i + 1] == "llvm-ir") {
                        emit_ir = true;
                        i += 1;
                        continue;
                    }
                }

                input = Some<Path>(arg);
                emit_exe = true;
            }
        }
    }
}
