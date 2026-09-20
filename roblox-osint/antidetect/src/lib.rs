pub mod ja3;
pub mod crypto;
pub mod headers;

pub const VERSION: &str = "2.0.0";

pub fn info() -> String {
    format!("roblox-osint-antidetect v{}", VERSION)
}
