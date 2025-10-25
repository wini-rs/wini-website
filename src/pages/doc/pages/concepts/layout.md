# Layouts

Layouts are functions that wraps the computation of the requested page in another HTML and return back the resulting HTML.

## Usage

```rs
#[page]
async fn my_page() {
    html! { "Hello world!" }
}


#[layout]
async fn my_layout(child: Markup) {
    html! {
        header {
            "Hello"
        }
        main {
            (html)
        }
    }
} // Will return `<header>Hello</header><main>Hello world!</main>` when applied to my_page
```

## About

Multiple layouts can be applied to an endpoint/request. In this case, the parent layout get the computation of the previous layout:

```
      requests
         |
         v
+--- layer_one ---+
| +- layer_two -+ |
| |             | |
| |   my_page   | |
| |             | |
| +- layer_two -+ |
+--- layer_one ---+
         |
         v
      responses
```

Will result in: `layout_one(layout_two(my_page))`

(_Graph inspired by: <https://docs.rs/axum/latest/axum/middleware/index.html>_)


<div class="note">

A layout can also use a component

```rs
#[layout]
pub async fn my_layout(html: Markup) {
    html! {
        header {
            [my_header]
        }
        main {
            (html)
        }
    }
}
```

</div>

