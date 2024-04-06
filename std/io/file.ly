#include "../ffi/libc.ly"

static SYSTEM_PATH_SEPERATOR: str = "/";

struct PathBuf {
    buf: String;
};

impl PathBuf {
    fn new() -> Self {
        return {
            .buf = String::new((:u32)0),
        };
    }

    fn from(s: String) -> Self {
        return {
            .buf = s,
        };
    }

    fn as_path(&self) -> FilePath {
        return FilePath::new(self.buf.as_str());
    }

    fn as_string(&self) -> String {
        return self.buf;
    }

    fn push(&mut self, path: FilePath) {
        self.buf.push_str(SYSTEM_PATH_SEPERATOR);
        self.buf.push_str(path.inner);
    }

    fn absolutize(&mut self) {
        todo$("PathBuf::absolutize");
    }
}

struct FilePath {
    inner: str;
};

impl FilePath {
    fn new(s: str) -> Self {
        return {
            s
        };
    }

    fn as_str(&self) -> str {
        return self.inner;
    }
}

impl_debug$(FilePath);
impl_debug$(PathBuf);

impl Display for FilePath {
    fn fmt(&self, fmt: &mut Formatter) -> FormattingError {
        return self.inner.fmt(&fmt);
    }
}

struct File {
    path: FilePath;
    fd: FileDescriptor;
};

impl Drop for File {
    fn drop(&mut self) {
        fclose(self.fd);
    }
}

impl File {
    fn open(path: FilePath) -> Self {
        let this: Self = { .path = path, .fd = fopen(path.inner.as_ptr(), "r".as_ptr()) };
        if this.fd == (:FileDescriptor)0 {
            panic$("failed to open file: {}", path);
        }
        return this;
    }

    fn read(&self) -> String {
        fseek(self.fd, (:u64)0, (:i32)2);
        let size = ftell(self.fd);
        rewind(self.fd);
        let content = String::new((:u32)(size + (:u64)1));
        fread(content.data, (:u64)1, size, self.fd);
        content.data[size] = (:i8)0;
        content.len = ((:u32)size);
        return content;
    }

    fn read_to_string(path: FilePath) -> String {
        let file = File::open(path);
        let content = file.read();
        file.drop();
        return content;
    }
}
