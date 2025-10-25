# Repository:    https://github.com/casey/just
# Documentation: https://just.systems/man


# Enter the development environment
[group: "wini"]
env:
    nix develop -c "$SHELL"

# Run in dev
[group: "build"]
run:
    @./scripts/run.sh

[group: "check"]
check: compile-ts compile-scss
    cargo check

# Create the binary for the production
[group: "build"]
build-prod: compile-ts compile-scss
    ENV_TYPE="PROD" cargo build --release

# Run in production
[group: "build"]
run-prod: js-i js-sync-packages compile-ts compile-scss
    ENV_TYPE="PROD" cargo run --release

# Create the binary for the staging
[group: "build"]
build-staging: compile-ts compile-scss
    ENV_TYPE="STAGING" cargo build --release

# Run in staging
[group: "build"]
run-staging: js-i js-sync-packages compile-ts compile-scss
    ENV_TYPE="STAGING" cargo run --release



# Create a new *something* based on a template
[group: "wini"]
new kind:
    @./scripts/new.sh {{kind}}

# Format
[group: "check"]
fmt:
    @./scripts/fmt.sh

# Lint
[group: "check"]
lint:
    @./scripts/lint.sh

# Synchronises the template that you're using by pulling latest commits
[group: "wini"]
sync-template:
    @./scripts/sync-template.sh

# Synchronises the `last_commit_hash` from your wini.toml
[group: "wini"]
sync-commit-hash:
    @./scripts/sync-commit-hash.sh

# Adds a javascript package
[group: "javascript"]
js-add pkg: && js-sync-packages
    bun a {{pkg}}
    @echo -e "\e[1m=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="
    bun i
    @echo -e "\e[1m=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="
    @echo -e "Adding {{pkg}} to ./packages-files.toml\e[0m"
    @./scripts/ask-path-packages.sh {{pkg}}

# Removes a javascript package
[group: "javascript"]
js-rm pkg: && js-sync-packages
    bun rm {{pkg}}
    @sed -i '/^{{pkg}}\s*=/d' ./packages-files.toml

# Update javascript packages to their new version
[group: "javascript"]
js-update: && js-sync-packages
    bun update

[group: "javascript"]
js-i:
    bun i

# Sync all the javascript packages in ./public/modules/
[group: "javascript"]
js-sync-packages:
    @./scripts/sync-packages.sh


# Compile and watch for SCSS files
[group: "build"]
compile-scss:
    @echo -e '\e[34m[\e[32m+\e[34m]\e[0m Reloading SCSS...'
    @./scripts/scss.sh

# Compile and watch for Typescript files
[group: "build"]
compile-ts:
    @echo -e '\e[34m[\e[32m+\e[34m]\e[0m Reloading TypeScript...'
    @./scripts/typescript.sh

# Terminate process running on port `PORT` and start a new server
[group: "build"]
clean-launch:
    @./scripts/launch.sh
