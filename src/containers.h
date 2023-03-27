#pragma once

#include <iostream>

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
    Option& operator=(None) { some = false; }
    Option& operator=(Some<T> in) { some = true; value = in.value; }

    bool IsSome() { return some; }
    bool IsNone() { return !some; }
    T Unwrap() { if(IsNone()) { std::cout << "Error: calling unwarp on a None value" << std::endl; std::exit(1); } return value; }
    T Expect(const char *msg) { if(IsNone()) { std::cout << (msg ? msg : "Error: calling unwarp on a None value") << std::endl; std::exit(1); } return value; }
    private:
    bool some;
    T value;
};

template<typename T>
std::ostream &operator<<(std::ostream &os, Option<T> &self) {
    if(self.IsSome()) {
        os << "Some(" << self.Unwrap() << ")";
    }else {
        os << "None";
    }
    return os;
}

template<typename T>
struct Ok {
    Ok(T item): value(item) {}
    T value;
};

template<typename T, typename E>
struct Result {
    public:
    Result(Ok<T> ok): ok(true) {value.ok = ok.value;}
    Result& operator=(Ok<T> ok) { ok = true; value.ok = ok.value; }
    Result(E err): ok(false) {value.err = err;}
    Result& operator=(E err) { ok = false; value.err = err; }

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
