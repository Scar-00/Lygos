macro println {
    () -> {
        printf("\n");
    }
    (string: $) -> {
        printf("%s\n", $string);
    }

    (fmt: $, args: $[]) -> {
        printf($fmt, $args);
        printf("\n");
    }
}

fn simple_if(x: i32) {
    if x > 10 {
        println$("test");
    }
    println$("end");
}

fn simple_if_early_ret(x: i32) -> i32 {
    if x > 10 {
        //println$("test");
        return 10;
    }
    println$("test");
    return 20;
}

fn if_else(x: i32) {
    if x > 10 {
        println$("true");
    }else {
        println$("false");
    }
    println$("end");
}

fn if_else_early_ret(x: i32) -> i32 {
    if x > 10 {
        return 10;
    }else {
        return 20;
    }
}

fn main() -> i32 {
    return 0;
}
