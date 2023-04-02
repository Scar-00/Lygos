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
        private:
            std::vector<std::string> args;
            Option<Path> input = None;
            Option<Path> output = None;
        };
    }
}

#endif // _LYGOS_OPTIONS_H_
