#include "io.h"
#include "../error/log.h"

#include <sstream>
#include <fstream>

namespace lygos {
    namespace IO {
        std::string ReadFile(std::filesystem::path path) {
            std::ifstream istream;
            istream.open(path);
            istream.seekg(0, std::ios::end);
            size_t length = istream.tellg();
            if(length < 1)
                return {};
            istream.seekg(0, std::ios::beg);
            std::string buffer(length, ' ');
            istream.read(&buffer[0], length);
            return buffer;
        }

        bool EmitObj(std::filesystem::path path) {

        }

        bool EmitExec(std::filesystem::path path) {

        }

        bool EmitAsm(std::filesystem::path path) {
            Log::Logger::Abort("TODO! [EmitAsm()]");
        }
    }
}
