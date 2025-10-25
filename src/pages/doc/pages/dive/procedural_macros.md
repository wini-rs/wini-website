# Procedural macros

This chapter covers how the procedural macros of `macros/` work

## `#[component]`

Components can accept arguments if they are called with the following syntax: `[my_component(arg1, arg2)]`

### Parameters

- `js_pkgs` - Array of JavaScript package names to include

### Working

`#[component]` is the easiest macro. The only thing that it does is includes linked CSS, Javascript files and other pkgs included with `js_pkgs`.

### Example

```rs
use {maud::{html, Markup}, wini_macros::component};

#[component(js_pkgs = ["alpinejs"])]
pub async fn my_component(name: String, count: u32) -> ServerResult<Markup> {
    Ok(html! {
        div x-data="{ open: false }" {
            h2 { "Component: " (name) }
            p { "Count: " (count) }
        }
    })
}
```

_Definition of [`#[component]`](<https://github.com/wini-rs/wini-template/src/branch/main/macros/src/macros/wini/component.rs>)_

<br/>

## `#[page]`

Pages can accept arguments if the function implements [`axum::handler::Handler`](https://docs.rs/axum/latest/axum/handler/trait.Handler.html).

### Parameters

- `title` - Page title (sets `<title>` and `og:title`)
- `description` - Meta description (sets `description` and `og:description`)
- `keywords` - Array of keywords for SEO
- `author` - Content author
- `site_name` - Site name for Open Graph
- `lang` - Language code (e.g., "en", "fr")
- `img` - Open Graph image URL
- `robots` - Robot indexing instructions (e.g., "index, follow")
- `js_pkgs` - Array of JavaScript package names to include
- `other_meta` - Array of custom meta tag key-value pairs

### Working 
The `page` macro will do the following actions:
1. Execution of the base function
2. Propagation of the error if there is one and add a `Backtrace`
3. Conversion to `axum::response::Response`
4. Linking JS/CSS files from the current directory
5. Linking related files from `js_pkgs` if there are some
6. Injecting of SEO meta tags

### Example

```rs
#[page(
    title = "Complete Example",
    description = "A page with all parameters",
    keywords = ["example", "documentation"],
    author = "Jane Doe",
    site_name = "Wini Framework",
    lang = "en",
    img = "/images/og-image.png",
    robots = "index, follow",
    js_pkgs = ["alpinejs", "htmx"],
    other_meta = [
        "theme-color" = "#3B82F6"
    ]
)]
pub async fn complete_example(uri: Uri) -> Markup {
    html! {
        h1 { "Complete example"  }
        p { "This page has all available parameters configured. Called at: " (uri) }
    }
}
```

_Definition of [`#[page]`](<https://github.com/wini-rs/wini-template/src/branch/main/macros/src/macros/wini/page.rs>)_

<br/>

## `#[layout]`

Layouts can accept different argument types depending on your needs. Arguments must have a
type that either implements:
- `axum::extract::FromRequestParts`,
- `wini::shared::wini::response::FromResponseBody`
- `wini::shared::wini::response::FromResponseParts`

There are just a few rules:
1. Arguments that come from `FromResponseBody` MUST be the last argument.
2. Only one argument can come from `FromResponseBody`.
3. In case of conflicts (ex: an argument has a type of `http::header::HeaderMap`, which
   implements both `FromRequestParts` and `FromResponseParts`), you can specify from which
   implementation it should come from with the following macro attributes:
   - `#[from_request_parts]`
   - `#[from_response_parts]`
   - `#[from_response_body]`

### Parameters

- `title` - Page title (sets `<title>` and `og:title`)
- `description` - Meta description (sets `description` and `og:description`)
- `keywords` - Array of keywords for SEO
- `author` - Content author
- `site_name` - Site name for Open Graph
- `lang` - Language code (e.g., "en", "fr")
- `img` - Open Graph image URL
- `robots` - Robot indexing instructions
- `js_pkgs` - Array of JavaScript package names to include
- `other_meta` - Array of custom meta tag key-value pairs

### Working 
The `layout` macro will do the following actions:
1. Verify the rules of argument validity
2. Apply `FromRequestParts` for all arguments that need it
3. Run `next.run(req)`
4. Apply `FromResponseParts` and `FromResponseBody` for all arguments that need it
5. Execution of the base function
6. Propagation of the error if there is one and add a `Backtrace`
7. Conversion to `axum::response::Response`
8. Linking JS/CSS files from the current directory
9. Linking related files from `js_pkgs` if there are some
10. Injecting of SEO meta tags

### Example
```rs
use {
    axum::http::Uri,
    hyper::StatusCode,
    maud::{html, Markup},
    wini_macros::layout
};

#[layout(
    title = "Complete Layout",
    description = "A layout with all parameters",
    keywords = ["layout", "example"],
    author = "Jane Doe",
    site_name = "Wini Framework",
    lang = "en",
    img = "/og-image.png",
    robots = "index, follow",
    js_pkgs = ["htmx", "alpinejs"],
    other_meta = ["theme-color" = "#3B82F6"]
)]
pub async fn complete_layout(
    uri: Uri,
    #[from_request_parts] headers_req: HeaderMap,
    status: StatusCode,
    child: Markup
) -> Markup {
    html! {
        header { "Layout header - Status: " (status.as_u16()) " - Path: " (uri.path()) " - Headers:" (format!("{headers_req:#?}")) }
        main { (child) }
        footer { "Layout footer" }
    }
}
```


_Definition of [`#[layout]`](<https://codeberg.org/wini/wini-template/src/branch/main/macros/src/macros/wini/layout.rs>)_
