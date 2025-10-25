# Error handling and error propagation

Every page, component or layout in Wini, can return a `Result<_, _>`. But the way the error is handled is different.

## Component

Saying that a component should return is pretty straightforward:

```rs
#[component]
async fn my_component() -> ServerResult<Markup> {
    Ok(html! {})
}
```

Though, when a component depends on some files (`.js`, `.css` or via `js_pkgs`) and return a `ServerError` the files will **not** be included. 

> [!NOTE]
>
> This is also true for `#[layout]` and `#[page]`

The thing that is a bit more complex, is handling the error on the caller of the component. Usually when we call a component, we just do:

```rs
html! {
    [my_component]
}
```

But, if `my_component` can return a `ServerError`, what happens ? It seems somewhat unclear.

This is why, when the component can error, another syntax is used: `[my_component?]` or `[my_component!]`

```rs
#[component]
fn my_component() -> ServerResult<Markup> { ... }

#[page]
fn example_1() -> ServerResult<Markup> {
    html! {
        [my_component?]
    }
}

#[page]
fn example_2() -> Markup {
    html! {
        [my_component!]
    }
}
```
1. In `example_1` we use the `?` operator at the end. This has the same behaviour as in normal
   Rust: it behaves as `return Err(...)`.
2. In `example_2` we use the `!` operator at the end. This operator behaves exactly as
   `.unwrap_or_default()`

If you want some more advanced handling of error you can do something like:
```rs
#[component]
fn my_component() -> ServerResult<Markup> { ... }

fn process_error(component_result: ServerResult<Markup>) -> Markup {
    component_result.unwrap_or_else(|_| html!("An error occurred!"))
}

#[page]
fn example_1() -> ServerResult<Markup> {
    html! {
        [process_error(my_component().await)]
    }
}
```

## Page

Pages don't add a lot of new complexity. You can call component and handle how you want to handle the error like seen in the last example.

The true difference is how the error is handled behind the hood.

Pages contrary to components will have their return type converted to `Response` with the `IntoResponse` trait.
In case of `ServerError`, no HTML will be sent back from the page, and the `Response` will have an `Extension` with `Backtrace` a struct that adds information on the origin of the error

```rs
pub struct Backtrace {
    pub markup: Option<Markup>,
    pub err: Arc<ServerErrorKind>,
    // First element is the oldest
    pub trace: Vec<Trace>,
}
```

## Layout

The reason that we put the `Backtrace` in the extension of the response is because we can later use them in middleware or layouts like so:

```rs
#[layout]
async fn my_layout(backtrace: Option<Backtrace>, child: Markup) -> Markup {
    html! {
        main {
            // In case we have an error
            @if let Some(backtrace) = backtrace {
                "An error occurred"
                ...
                // Do something with backtrace if you want
            } else {
                (child)
            }
        }
    }
}
```

And that's basically how you handle the propagation of error in layouts!
