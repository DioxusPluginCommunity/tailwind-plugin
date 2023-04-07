package.path = library_dir .. "/?.lua"

local plugin = require("plugin")
local log = plugin.log
local command = plugin.command
local fs = plugin.fs
local os = plugin.os
local network = plugin.network
local path = plugin.path

local manager = require("manager")
manager.name = "Tailwind CSS for Dioxus CLI"
manager.repository = "https://github.com/arqalite/dioxus-cli-tailwind-plugin"
manager.author = "Antonio Curavalea <one.curavan@protonmail.com>"
manager.version = "0.0.2"

-- init manager plugin api
plugin.init(manager)

manager.on_init = function()
    -- download()
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


function build_css()
    --- Runs Tailwind and builds the CSS file in the ./public folder.
    log.info("Building CSS...")
    command.exec(
    { "tailwindcss", "build", "-c", "src/tailwind.config.js", "-i", "src/input.css", "-o", "public/style.css" }, "inhert",
    "inhert")
end

function download()
    --- Downloads Tailwind CLI based on OS.
    -- TODO: Move the CLI to the appropriate folder.

    log.info("Downloading Tailwind CLI... (unimplemented)")
    if os.current_platform() == "windows" then
        network.download_file("https://github.com/tailwindlabs/tailwindcss/releases/latest/download/tailwindcss-windows-x64.exe", "tailwindcss.exe")
    elseif os.current_platform() == "macos" then
        network.download_file("https://github.com/tailwindlabs/tailwindcss/releases/latest/download/tailwindcss-macos-x64", "tailwindcss")
    elseif os.current_platform() == "linux" then
        network.download_file("https://github.com/tailwindlabs/tailwindcss/releases/latest/download/tailwindcss-linux-x64", "tailwindcss")
    end
    log.info("Downloaded Tailwind CLI")
end

function init_config()
    --- Creates tailwind.config.js and input.css in the project directory.
    -- If the files already exist, it will not overwrite them.

    log.info("Initializing Tailwind config.")
    copy_config_file("/../dioxus-cli-tailwind-plugin/assets/tailwind.config.js", "src/tailwind.config.js")
    copy_config_file("/../dioxus-cli-tailwind-plugin/assets/input.css", "src/input.css")
    log.info("Initialized successfully.")
end

function copy_config_file(source_file, dest_file)
    --- Copies a file from the given source to the given destination.
    -- @param source_file string - The source file path.
    -- @param dest_file string - The destination file path.

    if path.is_file(dest_file) then
        log.info(dest_file .. " already exists. Skipping.")
    else
        local input_css = fs.file_get_content(library_dir .. source_file)
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
