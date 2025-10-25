use {
    crate::pages::doc::PAGES_STRUCTURE,
    axum::http::uri::Uri,
    maud::{html, Markup, PreEscaped},
    wini_macros::layout,
};

#[layout(js_pkgs = ["alpinejs", "htmx.org"])]
pub async fn render(uri: Uri, child: Markup) -> Markup {
    html! {
        div
            x-data={"{\
                isSidebarHidden: false,\
                liClick: () => {\
                    if (window.innerWidth < 1200) $data.isSidebarHidden = true;\
                },\
                page: '"(uri.path().split('/').last().unwrap_or_default())"',\
            }"}
        {
            nav
                #sidebar
                x-bind:class="isSidebarHidden && 'hidden'"
            {
                (PAGES_STRUCTURE.rec_display())
            }
            main {
                header {
                    div {
                        button #hide-sidebar x-on:click="isSidebarHidden = !isSidebarHidden" {
                            img src="/bars-solid.svg";
                        }
                    }
                    span #title {"Wini's book"}
                    div {
                        a href="https://github.com/wini-rs/wini" {
                            img src="/github.svg";
                        }
                        a href="https://codeberg.org/wini/wini" {
                            img src="/codeberg.svg";
                        }
                    }
                }
                div #horizontal-content hx-disinherit="*" {
                    (child)
                }
            }
        }
    }
}
