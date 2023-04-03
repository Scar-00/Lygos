#ifndef _LYGOS_OPTIONS_H_
#define _LYGOS_OPTIONS_H_

#include "../core.h"

namespace lygos {
    using Path = std::filesystem::path;
    namespace Cli {
        class Options {
        public:
            Options(int argc, char **argv);
            Option<Path> InputFile() { return input; }
            Option<Path> OutputFile() { return output; }
            bool EmitExe() { return emit_exe; }
            bool EmitIr() { return emit_ir; }
        private:
            std::vector<std::string> args;
            Option<Path> input = None;
            Option<Path> output = None;
            bool emit_exe = false;
            bool emit_ir = false;
        };
    }
}

#endif // _LYGOS_OPTIONS_H_
