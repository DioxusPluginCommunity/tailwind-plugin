-- ----------------------------------
-- Tailwind CSS plugin for Dioxus CLI
-- ----------------------------------

local plugin = require("plugin")
local manager = require("manager")

manager.name = "Tailwind CSS for Dioxus CLI"
manager.repository = "https://github.com/DioxusPluginCommunity/tailwind-plugin"
manager.author = "Antonio Curavalea <one.curavan@protonmail.com>"
manager.version = "0.2.0"
plugin.init(manager)

-- Define paths since we can't reliably get them from the Dioxus CLI.
src_folder = plugin.path.join(plugin.dirs.crate_dir(), "src")
plugin_folder = plugin.path.join(plugin.dirs.crate_dir(), ".dioxus/plugins/tailwind-plugin")
bin_folder = plugin.path.join(plugin.dirs.crate_dir(), ".dioxus/plugins/tailwind-plugin/bin/")
tailwind_path = plugin.path.join(plugin.dirs.crate_dir(), ".dioxus/plugins/tailwind-plugin/bin/tailwindcss")

-- Basically a ternary operator but not really.
-- If Dioxus.toml has a filename defined in `style` then we use that one,
-- otherwise we default to "style.css"
local css_file = plugin.config.dioxus_toml().web.resource.style[1] ~= "" and
plugin.config.dioxus_toml().web.resource.style[1] or "style.css"

-- For Unix-like OSes, the binary is named "tailwindcss", but for Windows it's "tailwindcss.exe".
if plugin.os.current_platform() == "windows" then
    tailwind_path = tailwind_path .. ".exe"
end

-- Hacky way of loading other Lua files
download = dofile(plugin_folder .. "/src/download.lua")
config = dofile(plugin_folder .. "/src/config.lua")
build = dofile(plugin_folder .. "/src/build.lua")

-- When the plugin first runs, we download Tailwind and initialize the config.
manager.on_init = function()
    download.download_tailwind(bin_folder)
    config.init_config(plugin_folder)
    return true
end

-- When building the project, we build the CSS file alongside it.
---@param info BuildInfo
manager.build.on_start = function(info)
    build.build_css(tailwind_path, src_folder, css_file)
end

-- We build the CSS when the server starts, and after every rebuild.
-- The plan is to add a before_serve event in the CLI to be able to compile Tailwind before rebuilding,
-- to avoid repeatedly triggering the CLI reloading mechanism.
---@param info ServeStartInfo
manager.serve.on_start = function(info)
    build.build_css(tailwind_path, src_folder, css_file)
end

---@param info ServeRebuildInfo
manager.serve.on_rebuild_end = function(info)
    --build.build_css(tailwind_path, src_folder, css_file)
end

---@param info ServeRebuildInfo
manager.serve.on_rebuild_start = function(info)
    build.build_css(tailwind_path, src_folder, css_file)
end

return manager
