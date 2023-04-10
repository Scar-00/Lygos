#ifndef _LYGOS_LOG_H_
#define _LYGOS_LOG_H_

#include <string>
#include <sstream>

namespace lygos {
    class Token;
    namespace Log {
        class Logger {
        public:
            static void Init();
            static void Destroy();
            static void Flush();
            static bool WasErrorReported();
            static void Warn(Token &token, std::string format);
            static void Warn(std::string format);
            static void Abort(std::string format);
        private:
            Logger();
            ~Logger();
            Logger &operator=(Logger &) = delete;
            Logger(Logger &) = delete;
            std::ostringstream ostream;
        };
    }
}

#endif // _LYGOS_LOG_H_
