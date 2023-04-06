# dioxus-cli-tailwind-plugin
Tailwind CSS plugin for [Dioxus CLI]. Currenly a very early WIP.

## Goals

* Download Tailwind automatically on first run, making sure it downloads the right executable for your OS
* On first run, generate default config files without overwriting existing ones.
* Regenerate CSS on each reload
    * Currently it's bugged and the CLI and plugin are causing each other to reload repeatedly. This is a known issue and will be fixed soon.
## Usage
The plugin system is still in development, so first install @mrxiaozhuox's fork of Dioxus CLI:

```bash
cargo install --git https://github.com/mrxiaozhuox/dioxus-cli
```
    
Then install the plugin:

```bash
dioxus plugin add https://github.com/arqalite/dioxus-cli-tailwind-plugin
```

Downloading Tailwind automatically doesn't work, so make sure you have the [Tailwind CLI] installed in your PATH.

## Contributing
All contributions are welcome! Please feel free to open an issue or a pull request.
## License
This project is licensed under the [MIT license](https://github.com/arqalite/rummy-nights/blob/main/LICENSE).

Unless you explicitly state otherwise, any contribution intentionally submitted
for inclusion in Rummy Nights, shall be licensed as MIT, without any additional
terms or conditions. We reserve the right to reject contributions that will not be licensed as such.

[Dioxus CLI]: https://github.com/DioxusLabs/cli
[Tailwind CLI]: https://github.com/tailwindlabs/tailwindcss/releases 