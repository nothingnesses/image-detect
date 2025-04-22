use dioxus::prelude::*;

#[derive(Clone, Copy)]
pub struct APIKey(pub Signal<String>);

impl APIKey {
	pub fn use_context_provider() {
		let api_key = use_signal(|| "".to_string());
		use_context_provider(|| APIKey(api_key));
	}
}