package.path = library_dir .. "/?.lua"

local plugin = require("plugin")
local log = plugin.log
local command = plugin.command
local fs = plugin.fs
local os = plugin.os

local manager = require("manager")
manager.name = "Tailwind CSS for Dioxus CLI"
manager.repository = "https://github.com/arqalite/dioxus-cli-tailwind-plugin"
manager.author = "Antonio Curavalea <one.curavan@protonmail.com>"
manager.version = "0.0.1"

-- init manager plugin api
plugin.init(manager)

manager.on_init = function()
    log.info("Initializing plugin: " .. manager.name)

    download()
    init_config()

    return true
end

---@param info BuildInfo
manager.build.on_start = function(info)
    log.info("Build starting: " .. info.name)
    build_css()
end


---@param info ServeStartInfo
manager.serve.on_start = function(info)
    -- this function will after clean & print to run, so you can print some thing.
    log.info("Serve start: " .. info.name)
    build_css()
end

---@param info ServeRebuildInfo
manager.serve.on_rebuild = function(info)
    build_css()
end


function build_css()
    --- Runs Tailwind and builds the CSS file in the ./public folder.

    log.info("Building CSS...")
    command.exec({ "tailwindcss", "build", "-c", "src/tailwind.config.js", "-i", "src/input.css", "-o", "public/style.css" }, "inhert", "inhert")
end

function download()
    --- Downloads Tailwind CLI based on OS.
    -- TODO: Move the CLI to the appropriate folder.

    log.info("Downloading Tailwind CLI... (unimplemented)")
    if os.current_platform == "windows" then
        -- network.download_file("https://github.com/tailwindlabs/tailwindcss/releases/latest/download/tailwindcss-windows-x64.exe", "tailwindcss.exe")
    elseif os.current_platform == "macos" then
        -- network.download_file("https://github.com/tailwindlabs/tailwindcss/releases/latest/download/tailwindcss-macos-x64", "tailwindcss")
    elseif os.current_platform == "linux" then
        -- network.download_file("https://github.com/tailwindlabs/tailwindcss/releases/latest/download/tailwindcss-linux-x64", "tailwindcss")
    end
    log.info("Downloaded Tailwind CLI")
end

function init_config()
    --- Creates tailwind.config.js and input.css in the project directory.

    log.info("Initialize Tailwind config and input CSS...")
    local config = fs.file_get_content(library_dir .. "/../dioxus-cli-tailwind-plugin/assets/tailwind.config.js")
    local status = fs.file_set_content("src/tailwind.config.js", config)

    local input_css = fs.file_get_content(library_dir .. "/../dioxus-cli-tailwind-plugin/assets/input.css")
    status = fs.file_set_content("src/input.css", input_css)

    log.info("Initialized Tailwind config and input CSS")
end

return manager
