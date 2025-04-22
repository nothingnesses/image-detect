use dioxus::prelude::*;

use crate::state::APIKey;

/// Save the OpenRouter API key.
#[component]
pub fn APIKeyInput() -> Element {
    APIKey::use_context_provider();
    let mut response = use_signal(|| String::new());

    rsx! {
        div {
            h4 { "OpenRouter API Key" }
            input {
                placeholder: "Input OpenRouter API Key here...",
                oninput:  move |event| async move {
                    consume_context::<APIKey>().0.set(echo_server(event.value()).await.unwrap());
                    response.set(use_context::<APIKey>().0.to_string());
                },
            }
            if !response().is_empty() {
                p {
                    "Server echoed: "
                    i { "{response}" }
                }
            }
        }
    }
}

#[server]
async fn echo_server(input: String) -> Result<String, ServerFnError> {
    Ok(input)
}
