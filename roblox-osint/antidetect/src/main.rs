use std::env;
use antidetect::{headers, ja3};

fn main() {
    let args: Vec<String> = env::args().collect();
    if args.len() < 2 {
        eprintln!("Usage: antidetect <ja3|headers|crypto>");
        std::process::exit(1);
    }

    match args[1].as_str() {
        "ja3" => {
            let j = ja3::random_ja3();
            println!("{}", j);
        }
        "headers" => {
            for (k, v) in headers::spoofed_headers() {
                println!("{}: {}", k, v);
            }
        }
        _ => {
            eprintln!("Unknown: {}", args[1]);
            std::process::exit(1);
        }
    }
}
