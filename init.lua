local plugin = require("plugin")
local log = plugin.log
local command = plugin.command
local fs = plugin.fs
local os = plugin.os
local network = plugin.network
local path = plugin.path
local dirs = plugin.dirs

local manager = require("manager")
manager.name = "Tailwind CSS for Dioxus CLI"
manager.repository = "https://github.com/arqalite/dioxus-cli-tailwind-plugin"
manager.author = "Antonio Curavalea <one.curavan@protonmail.com>"
manager.version = "0.0.5"

-- init manager plugin api
plugin.init(manager)

manager.on_init = function()
    download()
    init_config()
    return true
end

---@param info BuildInfo
manager.build.on_start = function(info)
    build_css()
end

---@param info ServeStartInfo
manager.serve.on_start = function(info)
    build_css()
end

---@param info ServeRebuildInfo
manager.serve.on_rebuild = function(info)
    build_css()
end

local src_folder = path.join(dirs.crate_dir(), "src")
local plugin_folder = path.join(dirs.crate_dir(), ".dioxus/plugins/tailwind-plugin")
local bin_folder = path.join(dirs.crate_dir(), ".dioxus/plugins/tailwind-plugin/bin/")
local tailwind_path = path.join(dirs.crate_dir(), ".dioxus/plugins/tailwind-plugin/bin/tailwindcss")

function build_css()
    --- Runs Tailwind and builds the CSS file in the ./public folder.
    log.info("Building CSS...")

    if os.current_platform() == "windows" then
        command.exec(
            { tailwind_path .. ".exe", "build", "-c", src_folder .. "/tailwind.config.js", "-i",
                src_folder .. "/input.css", "-o", "public/style.css" }, "inhert",
            "inhert")
    else
        command.exec(
            { tailwind_path, "build", "-c", src_folder .. "/tailwind.config.js", "-i",
                src_folder .. "/input.css", "-o", "public/style.css" }, "inhert",
            "inhert")
    end
end

function download()
    --- Downloads Tailwind CLI based on OS.
    if not (path.is_file(tailwind_path) or path.is_file(tailwind_path .. "/tailwindcss.exe")) then
        log.info("Downloading Tailwind CLI...")

        local url, executable, platform
        platform = os.current_platform()
        if platform == "windows" then
            url = "https://github.com/tailwindlabs/tailwindcss/releases/latest/download/tailwindcss-windows-x64.exe"
            executable = tailwind_path .. ".exe"
        elseif platform == "macos" then
            url = "https://github.com/tailwindlabs/tailwindcss/releases/latest/download/tailwindcss-macos-x64"
            executable = tailwind_path
        elseif platform == "linux" then
            url = "https://github.com/tailwindlabs/tailwindcss/releases/latest/download/tailwindcss-linux-x64"
            executable = tailwind_path
        end
        if not network.download_file(url, executable) then
            log.error("Failed to download Tailwind CLI.")
        else
            if platform == "macos" or platform == "linux" then
                command.exec({ "chmod", "+x", tailwind_path}, "inhert", "inhert")
            end
            log.info("Downloaded Tailwind CLI")
        end
    else
        log.info("Tailwind CLI already exists. Skipping.")
    end
end

function init_config()
    --- Creates tailwind.config.js and input.css in the project directory.
    -- If the files already exist, it will not overwrite them.

    log.info("Initializing Tailwind config.")
    copy_config_file("/assets/tailwind.config.js", "src/tailwind.config.js")
    copy_config_file("/assets/input.css", "src/input.css")
    log.info("Initialized successfully.")
end

function copy_config_file(source_file, dest_file)
    --- Copies a file from the given source to the given destination.
    -- @param source_file string - The source file path.
    -- @param dest_file string - The destination file path.

    if path.is_file(dest_file) then
        log.info(dest_file .. " already exists. Skipping.")
    else
        local input_css = fs.file_get_content(plugin_folder .. source_file)
        status = fs.file_set_content(dest_file, input_css)

        if status == false then
            log.error("Failed to create " .. dest_file .. ".")
            return
        else
            log.info("Created " .. dest_file .. ".")
        end
    end
end

return manager
