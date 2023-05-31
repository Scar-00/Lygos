#ifndef _LYGOS_CONTAINERS_H_
#define _LYGOS_CONTAINERS_H_

#include <concepts>
#include <fmt/core.h>
#include <iostream>
#include <iterator>
#include <string>
#include <vector>
#include <algorithm>
#include "types.h"

namespace lygos {
    struct None_t{};
    template<typename T>
    struct Some{
        Some(T some): value(some) {}
        T value;
    };

    constexpr None_t None{};

    template<typename T>
    struct Option {
    using None = None_t;
    public:
        Option(None): some(false) {}
        Option(Some<T> some): some(true), value(some.value) {}
        Option &operator=(None) { some = false; return *this; }
        Option &operator=(Some<T> in) { some = true; value = in.value; return *this; }

        bool IsSome() { return some; }
        bool IsNone() { return !some; }
        T Unwrap() { if(IsNone()) { std::cout << "Error: calling unwarp on a None value" << std::endl; std::exit(1); } return value; }
        T UnwrapOrDefault(T value) { return IsSome() ? this->value : value; }
        T Expect(const char *msg) { if(IsNone()) { std::cout << (msg ? msg : "Error: calling unwarp on a None value") << std::endl; std::exit(1); } return value; }
    private:
        bool some;
        T value;
    };

    template<typename T>
    struct Ok {
        Ok(T item): value(item) {}
        T value;
    };

    template<typename T, typename E>
    struct Result {
    public:
        Result(Ok<T> ok): ok(true) {value.ok = ok.value;}
        Result &operator=(Ok<T> ok) { ok = true; value.ok = ok.value; return *this; }
        Result(E err): ok(false) {value.err = err;}
        Result &operator=(E err) { ok = false; value.err = err; return *this; }
        Result &operator=(const Result other) { return other; }

        bool IsOk() { return ok; }
        bool IsErr() { return !ok; }
        T Unwrap() { if(IsErr()) { std::cout << "Error: calling unwarp on a Err value" << std::endl; std::exit(1); } return value.ok; }
        T Expect(const char *msg) { if(IsErr()) { std::cout << (msg ? msg : "Error: calling unwarp on a Err value") << std::endl; std::exit(1); } return value.ok; }
        E GetErr() { if(IsOk()) { std::cout << "Error: calling GetErr on an ok value" << std::endl; std::exit(1); } return value.err; }
    private:
        bool ok;
        union {
            T ok;
            E err;
        }value;
    };

    template<typename T>
    bool VecContains(std::vector<T> vec, T &item) {
        return std::find(vec.begin(), vec.end(), item) != vec.end();
    }

    template<typename T>
    void VecInsertAt(std::vector<T> &vec, s32 index, std::vector<T> &elems) {
        for(u32 i = 0; i < elems.size(); i++) {
            vec.insert(vec.begin() + index + i, std::move(elems[i]));
        }
    }

    template<typename T>
    void VecInsertAt(std::vector<T> &vec, s32 index, T &elem) {
        vec.insert(vec.begin() + index, std::move(elem));
    }

    template<typename T>
    void VecReplaceAt(std::vector<T> &vec, s32 index, std::vector<T> &elems) {
        vec.erase(vec.begin() + index);
        for(u32 i = 0; i < elems.size(); i++) {
            //vec.insert(vec.begin() + index + i, std::move(elems[i]));
            vec.insert(vec.begin() + index + i, elems[i]);
        }
    }

    template<typename T>
    void VecReplaceAt(std::vector<T> &vec, s32 index, T &elem) {
        //vec[index] = std::move(elem);
        vec[index] = elem;
    }
}

template<typename T>
std::ostream &operator<<(std::ostream &os, lygos::Option<T> &self) {
    if(self.IsSome()) {
        os << "Some(" << self.Unwrap() << ")";
    }else {
        os << "None";
    }
    return os;
}

#endif // _LYGOS_CONTAINERS_H_
