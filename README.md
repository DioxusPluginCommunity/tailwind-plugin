# dioxus-cli-tailwind-plugin
This is a WIP Tailwind CSS plugin for Dioxus CLI.

Goals:
* Download Tailwind automatically on first run
    * Make sure it gets the right executable for each supported platform
* On first run, generate config files
    * Don't overwrite existing files!
* Regenerate CSS on each reload
    * Reload only once per change (this might need forking the CLI)
