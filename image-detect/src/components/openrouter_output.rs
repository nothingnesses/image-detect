use dioxus::prelude::*;

use crate::state::APIKey;

/// Display outputs from OpenRouter.
#[component]
pub fn OpenRouterOutput() -> Element {
    APIKey::use_context_provider();
    let mut response = use_signal(|| String::new());

    rsx! {
        div {
            h4 { "Outputs from OpenRouter" }
            div {
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