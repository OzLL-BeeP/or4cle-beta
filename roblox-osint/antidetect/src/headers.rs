use rand::Rng;

pub const UA_POOL: &[&str] = &[
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
    "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
    "Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1",
];

pub fn random_ua() -> String {
    let mut rng = rand::thread_rng();
    UA_POOL[rng.gen_range(0..UA_POOL.len())].to_string()
}

pub fn spoofed_headers() -> Vec<(String, String)> {
    let mut rng = rand::thread_rng();
    vec![
        ("User-Agent".into(), random_ua()),
        ("Accept".into(), "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8".into()),
        ("Accept-Language".into(), "en-US,en;q=0.9".into()),
        ("Accept-Encoding".into(), "gzip, deflate, br".into()),
        ("Sec-Ch-Ua".into(), format!("\"Chromium\";v=\"{}\"", rng.gen_range(115..122))),
        ("Sec-Fetch-Dest".into(), "document".into()),
        ("Sec-Fetch-Mode".into(), "navigate".into()),
        ("Sec-Fetch-Site".into(), "none".into()),
        ("DNT".into(), "1".into()),
        ("Connection".into(), "keep-alive".into()),
    ]
}
