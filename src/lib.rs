use base64::{engine::general_purpose::STANDARD, Engine as _};
use image::load_from_memory;
use image::ImageOutputFormat::Png;
use wasm_bindgen::prelude::*;
use web_sys::console::log_1 as log;

#[wasm_bindgen]
pub fn grayscale(encoded_file: &str) -> String {
    log(&"Grayscale called".into());

    let base64_to_vector = STANDARD.decode(encoded_file).unwrap();
    log(&"Ïmage decoded".into());

    let mut img = load_from_memory(&base64_to_vector).unwrap();
    log(&"Image loaded".into());

    img = img.grayscale();
    log(&"Grayscale effect applied".into());

    let mut buffer = vec![];
    img.write_to(&mut buffer, Png).unwrap();
    log(&"New image created".into());

    let encoded_img = STANDARD.encode(&buffer);
    let data_url = format!("data:image/png;base64,{}", encoded_img);

    return data_url;
}
