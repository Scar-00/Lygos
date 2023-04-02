#ifndef _LYGOS_IO_H_
#define _LYGOS_IO_H_

#include "../core.h"

#include <string>
#include <filesystem>

namespace lygos {
    namespace IO {
        Result<std::string, Error::IOError> ReadFile(std::filesystem::path path);
    }
}

#endif // _LYGOS_IO_H_
