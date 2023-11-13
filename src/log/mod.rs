use crate::lexer::Loc;

use std::path::PathBuf;
use std::cell::RefCell;
use std::collections::HashMap;

use ariadne::{sources, ReportKind, Report, Color, Source, Label};

thread_local! {
    static SRC_FILES: RefCell<HashMap<PathBuf, String>> = {
        RefCell::new(HashMap::with_capacity(1))
    }
}

/*fn get_file_content(path: PathBuf) -> String {
    if !SRC_FILES.with(|files| files.borrow().contains_key(&path)) {
        SRC_FILES.with(|files| files.borrow_mut().insert(path.clone(), lazily_load_src_file(&path)));
    }
    return SRC_FILES.with(|files| files.borrow().get(&path).unwrap().clone());
}*/

fn lazily_load_src_file<'a>(path: &'a std::path::PathBuf) -> String {
    if let Ok(content) = std::fs::read_to_string(path) {
        return content;
    }
    eprintln!("could not open file: `{:?}`", path);
    String::new()
}

pub fn token_expected<S: AsRef<str>>(loc: &Loc, msg: S, info: S) -> ! {
    let path_str = loc.file.to_str().unwrap();
    Report::build(ReportKind::Error, "", loc.start)
        .with_message(msg.as_ref())
        .with_label(
            Label::new((path_str, loc.start..loc.end))
            .with_message(info.as_ref())
            .with_color(Color::Red)
        )
        .finish()
        .eprint((path_str, Source::from(lazily_load_src_file(&loc.file.clone().into()))))
        .unwrap();
    std::process::exit(1);
}

pub fn token_expected_help<S: AsRef<str>>(loc: &Loc, msg: S, info: S, help: S) -> ! {
    let path_str = loc.file.to_str().unwrap();
    Report::build(ReportKind::Error, "", loc.start)
        .with_message(msg.as_ref())
        .with_label(
            Label::new((path_str, loc.start..loc.end))
            .with_message(info.as_ref())
            .with_color(Color::Red)
        )
        .with_help(help.as_ref())
        .finish()
        .eprint((path_str, Source::from(lazily_load_src_file(&loc.file.clone().into()))))
        .unwrap();
    std::process::exit(1);
}

pub fn error_msg(path: &str, msg: &str) -> ! {
    Report::<(&str, std::ops::Range<usize>)>::build(ReportKind::Error, "", 0)
        .with_message(msg)
        .finish()
        .eprint((path, Source::from(lazily_load_src_file(&PathBuf::from(path)))))
        .unwrap();

    std::process::exit(1);
}

use std::ops::Range;
#[derive(Clone)]
pub struct ErrorLabel {
    path: String,
    msg: String,
    range: Range<usize>,
}

impl ErrorLabel {
    pub fn new<S: ToString>(path: S, range: Range<usize>, msg: S) -> Self {
        Self{ path: path.to_string(), msg: msg.to_string(), range }
    }

    pub fn from<S: ToString>(loc: &Loc, msg: S) -> Self {
        Self{ path: loc.file.to_str().unwrap().into(), msg: msg.to_string(), range: loc.start..loc.end }
    }
}

impl<'a> From<&'a ErrorLabel> for Label<(String, Range<usize>)> {
    fn from(value: &'a ErrorLabel) -> Self {
        Label::new((value.path.clone(), value.range.clone())).with_message(value.msg.clone()).with_color(Color::Red)
    }
}

pub fn error_msg_label(msg: &str, label: ErrorLabel) -> ! {
    Report::<(String, std::ops::Range<usize>)>::build(ReportKind::Error, "", 0)
        .with_message(msg)
        .with_label(Label::from(&label))
        .finish()
        .eprint((label.path.clone(), Source::from(lazily_load_src_file(&PathBuf::from(&label.path)))))
        .unwrap();

    std::process::exit(1);
}

pub fn error_msg_label_info(msg: &str, label: ErrorLabel, info: &str) -> ! {
    Report::<(String, std::ops::Range<usize>)>::build(ReportKind::Error, "", 0)
        .with_message(msg)
        .with_label(Label::from(&label))
        .with_note(info)
        .finish()
        .eprint((label.path.clone(), Source::from(lazily_load_src_file(&PathBuf::from(&label.path)))))
        .unwrap();

    std::process::exit(1);
}

pub fn error_msg_labels(msg: &str, labels: &[ErrorLabel]) -> ! {

    let sources_vec: Vec<(String, String)> = labels.iter().map(|label| {
        return (label.path.to_owned(), lazily_load_src_file(&PathBuf::from(&label.path)));
    }).collect();

    let mut builder = Report::<(String, std::ops::Range<usize>)>::build(ReportKind::Error, "", 0);
    for label in labels {
        builder.add_label(Label::from(label));
    }
    builder.with_message(msg)
        .finish()
        .eprint(sources(sources_vec.clone()))
        .unwrap();

    std::process::exit(1);
}
