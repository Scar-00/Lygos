#ifndef _LYGOS_LOG_H_
#define _LYGOS_LOG_H_

#include <string>
#include <sstream>

namespace lygos {
    namespace Log {
        class Logger {
        public:
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
