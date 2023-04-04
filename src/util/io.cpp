#include "io.h"
#include "../error/log.h"

#include <sstream>
#include <fstream>
#include <string>
#include <system_error>

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

        bool EmitIr(std::filesystem::path path) {
            auto file_name = path.replace_extension(".ll").string();
            std::error_code e;
            llvm::raw_fd_ostream os(file_name, e);
            mod->print(os, nullptr);
            os.flush();
            return e.value();
        }

        bool EmitObj(std::filesystem::path path) {
            auto obj_path = path.replace_extension(".o").string();
            llvm::legacy::PassManager pass_manager;
            //add passes

            std::error_code e;
            llvm::raw_fd_ostream os(obj_path, e);
            if(target_machine->addPassesToEmitFile(pass_manager, os, nullptr, llvm::CGFT_ObjectFile)) {
                Log::Logger::Abort("cannot emit object file");
                return false;
            }
            pass_manager.run(*mod);
            os.flush();
            return true;
        }

        bool EmitExec(std::filesystem::path path) {
            EmitObj(path);
            std::string obj_path = path.replace_extension(".o").string();
            std::string exec_path = path.replace_extension("").string();
            std::string cmd = fmt::format("clang -o {} {} std/libstd.a -lc", exec_path, obj_path);
            std::cout << cmd << "\n";
            return std::system(cmd.c_str());
        }

        bool EmitAsm(std::filesystem::path path) {
            Log::Logger::Abort("TODO! [EmitAsm()]");
            return false;
        }
    }
}
