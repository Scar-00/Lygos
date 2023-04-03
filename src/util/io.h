#ifndef _LYGOS_IO_H_
#define _LYGOS_IO_H_

#include <string>
#include <filesystem>

namespace lygos {
    namespace IO {
        std::string ReadFile(std::filesystem::path path);

        bool EmitObj(std::filesystem::path path);
        bool EmitExec(std::filesystem::path path);
        bool EmitAsm(std::filesystem::path path);
    }
}

#endif // _LYGOS_IO_H_
