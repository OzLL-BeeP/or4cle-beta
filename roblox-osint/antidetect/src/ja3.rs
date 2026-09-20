use rand::Rng;

pub fn random_ja3() -> String {
    let mut rng = rand::thread_rng();
    let ciphers: Vec<String> = (0..12).map(|_| rng.gen_range(0x1301..0x13ff).to_string()).collect();
    let extensions: Vec<String> = (0..8).map(|_| rng.gen_range(0..50).to_string()).collect();
    let curves: Vec<String> = (0..4).map(|_| rng.gen_range(1..30).to_string()).collect();
    format!("771,{},{},{},0",
        ciphers.join("-"),
        extensions.join("-"),
        curves.join("-"))
}

pub fn ja3_hash(ja3: &str) -> String {
    use sha2::{Digest, Sha256};
    let mut hasher = Sha256::new();
    hasher.update(ja3.as_bytes());
    hex::encode(hasher.finalize())[..32].to_string()
}
