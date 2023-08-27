use std::path::PathBuf;

pub fn read_file(path: &PathBuf) -> Result<String, std::io::Error> {
    std::fs::read_to_string(path)
}
