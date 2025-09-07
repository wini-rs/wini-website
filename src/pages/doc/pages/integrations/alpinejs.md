# alpinejs

_[alpinejs](https://alpinejs.dev/) is a JavaScript framework that enables dynamic interactivity in HTML through declarative syntax and reactive data binding_

## 1. Easy to install:

```sh
wini js-add alpinejs
```

## 2. Easy to use:

Simply add this code to the script linked to the page where you want to use htmx.

```js
import "alpinejs";
```

## 3. Goes well with maud:

```scss
main x-data="{ isActive: false }" {
    div x-bind:class="isActive && 'active'"{
        "Some info"
    }
    button x-on:click="isActive = !isActive" {
        "Toggle"
    }
}
```

More on alpine js here: <https://alpinejs.dev/>

> [!NOTE]
>
> The `:class` (`x-bind` short syntax) and `@click` (`x-on` short syntax), don't work in wini, since `maud` doesn't support this syntax.
