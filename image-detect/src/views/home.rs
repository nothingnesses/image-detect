use crate::{components::{APIKeyInput, Echo, Hero, OpenRouterOutput}, state::APIKey};
use dioxus::prelude::*;

/// The Home page component that will be rendered when the current route is `[Route::Home]`
#[component]
pub fn Home() -> Element {
    APIKey::use_context_provider();
    rsx! {
        APIKeyInput {}
        Hero {}
        Echo {}
        OpenRouterOutput {}
    }
}
