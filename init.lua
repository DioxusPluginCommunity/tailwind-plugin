-- ----------------------------------
-- Tailwind CSS plugin for Dioxus CLI
-- ----------------------------------

local plugin = require("plugin")
local manager = require("manager")

manager.name = "Tailwind CSS for Dioxus CLI"
manager.repository = "https://github.com/DioxusPluginCommunity/tailwind-plugin"
manager.author = "Antonio Curavalea <one.curavan@protonmail.com>"
manager.version = "0.1.0"
plugin.init(manager)

-- Define paths since we can't reliably get them from the Dioxus CLI.
local src_folder = plugin.path.join(plugin.dirs.crate_dir(), "src")
local plugin_folder = plugin.path.join(plugin.dirs.crate_dir(), ".dioxus/plugins/tailwind-plugin")
local bin_folder = plugin.path.join(plugin.dirs.crate_dir(), ".dioxus/plugins/tailwind-plugin/bin/")
local tailwind_path = plugin.path.join(plugin.dirs.crate_dir(), ".dioxus/plugins/tailwind-plugin/bin/tailwindcss")

-- For Unix-like OSes, the binary is named "tailwindcss", but for Windows it's "tailwindcss.exe".
if plugin.os.current_platform() == "windows" then
    tailwind_path = tailwind_path .. ".exe"
end

-- Hacky way of loading other Lua files 
local download = dofile(plugin_folder .. "/src/download.lua")
local config = dofile(plugin_folder .. "/src/config.lua")
local build = dofile(plugin_folder .. "/src/build.lua")


-- When the plugin first runs, we download Tailwind and initialize the config.
manager.on_init = function()
    download.download(bin_folder)
    config.init_config(plugin_folder)
    return true
end

-- When building the project, we build the CSS file alongside it.
---@param info BuildInfo
manager.build.on_start = function(info)
    build.build_css(tailwind_path, src_folder)
end

-- We build the CSS when the server starts, and after every rebuild.
-- The plan is to add a before_serve event in the CLI to be able to compile Tailwind before rebuilding, 
-- to avoid repeatedly triggering the CLI reloading mechanism.
---@param info ServeStartInfo
manager.serve.on_start = function(info)
    build.build_css(tailwind_path, src_folder)
end

---@param info ServeRebuildInfo
manager.serve.on_rebuild = function(info)
    build.build_css(tailwind_path, src_folder)
end

return manager
