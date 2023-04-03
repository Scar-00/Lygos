#include "log.h"

#include <iostream>
#include "../ast/ast.h"
#include "../lex/lexer.h"

#define RESET   "\033[0m"
#define BLACK   "\033[30m"      /* Black */
#define RED     "\033[31m"      /* Red */
#define GREEN   "\033[32m"      /* Green */
#define YELLOW  "\033[33m"      /* Yellow */
#define BLUE    "\033[34m"      /* Blue */
#define MAGENTA "\033[35m"      /* Magenta */
#define CYAN    "\033[36m"      /* Cyan */
#define WHITE   "\033[37m"      /* White */
#define BOLDBLACK   "\033[1m\033[30m"      /* Bold Black */
#define BOLDRED     "\033[1m\033[31m"      /* Bold Red */
#define BOLDGREEN   "\033[1m\033[32m"      /* Bold Green */
#define BOLDYELLOW  "\033[1m\033[33m"      /* Bold Yellow */
#define BOLDBLUE    "\033[1m\033[34m"      /* Bold Blue */
#define BOLDMAGENTA "\033[1m\033[35m"      /* Bold Magenta */
#define BOLDCYAN    "\033[1m\033[36m"      /* Bold Cyan */
#define BOLDWHITE   "\033[1m\033[37m"      /* Bold White */

namespace lygos {
    namespace Log {
        Logger *logger;

        Logger::Logger() {}

        Logger::~Logger() {}

        void Logger::Init() {
            if(logger)
                return;
            logger = new Logger();
        }

        void Logger::Destroy() {
            if(!logger)
                return;
            delete logger;
        }

        bool Logger::WasErrorReported() {
            return logger->ostream.tellp() != std::streampos(0);
        }

        void Logger::Flush() {
            std::cout << logger->ostream.str() << std::endl;
            logger->ostream.str("");
            logger->ostream.clear();
        }

        void Logger::Warn(Token &token, std::string format) {
            auto &stream = logger->ostream;
            stream << RED << "error: " << RESET << format << "\n";
            stream << CYAN << "--> " << RESET << mod->getSourceFileName() << ":" << token.loc.GetLine() << "\n";
            stream << CYAN << "|\n" << RESET;
            stream << CYAN << "|\t" << RESET << "found: " << token.value << "\n";
            stream << CYAN << "|\n\n" << RESET;
            Flush();
            std::exit(1);
        }

        void Logger::Warn(AST::AST *node, std::string format) {
            auto &stream = logger->ostream;
            stream << RED << "error: " << RESET << format << "\n";
            Flush();
            std::exit(1);
        }

        void Logger::Warn(std::string format) {
            logger->ostream << RED << "error: " << RESET << format << "\n";
            Flush();
            std::exit(1);
        }

        void Logger::Abort(std::string format) {
            logger->ostream << "error: " << format << "\n";
            Flush();
            std::exit(1);
        }
    }
}
