# Architecture

Below is the global directory structure of a new wini project:

```sh
.
├── .editorconfig
├── biome.json             
├── build.rs
├── bun.lockb
├── Cargo.toml
├── clippy.toml
├── flake.nix
├── justfile
├── package.json
├── packages-files.toml
├── README.md
├── rustfmt.toml
├── taplo.toml
├── tsconfig.json
├── wini.toml
├── macros/
│   ├── Cargo.toml
│   └── src/
├── public/
├── scripts/
├── src/
│   ├── components/
│   ├── cron/
│   ├── layouts/
│   ├── lib.rs
│   ├── main.rs
│   ├── pages/
│   ├── server.rs
│   ├── shared/
│   ├── template/
│   └── utils/
├── target/
└── tests/
```

It can be easily intimidating, and even more if you are new to front-end development.

In the 3 next chapter I will explain what is the purpose of each of file, so you understand how everything works.
