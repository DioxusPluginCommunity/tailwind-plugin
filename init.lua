package.path = library_dir .. "/?.lua"

local plugin = require("plugin")
local manager = require("manager")

-- deconstruct api functions
local log = plugin.log
local command = plugin.command
local fs = plugin.fs

-- plugin information
manager.name = "Tailwind CSS for Dioxus CLI"
manager.repository = "https://github.com/arqalite/dioxus-cli-tailwind-plugin"
manager.author = "Antonio Curavalea <one.curavan@protonmail.com>"
manager.version = "0.0.1"

-- init manager plugin api
plugin.init(manager)

manager.on_init = function()
    -- when the first time plugin been load, this function will be execute.
    -- system will create a `dcp.json` file to verify init state.

    log.info("Initializing plugin: " .. manager.name)

    download()
    init_config()

    return true
end

---@param info BuildInfo
manager.build.on_start = function(info)
    -- before the build work start, system will execute this function.
    log.info("Build starting: " .. info.name)
    build_css()
end

-- ---@param info BuildInfo
-- manager.build.on_finish = function (info)
--     -- when the build work is done, system will execute this function.
--     log.info("Build finished: " .. info.name)
-- end

---@param info ServeStartInfo
manager.serve.on_start = function(info)
    -- this function will after clean & print to run, so you can print some thing.
    log.info("Serve start: " .. info.name)
    build_css()
end

---@param info ServeRebuildInfo
manager.serve.on_rebuild = function(info)
    -- this function will after clean & print to run, so you can print some thing.
    -- local files = plugin.tool.dump(info.changed_files)
    -- log.info("Serve rebuild: '" .. files .. "'")
    build_css()
end

-- manager.serve.on_shutdown = function ()
--     --- this function will after serve shutdown.
--     log.info("Serve shutdown")
-- end

function build_css()
    log.info("Building CSS...")
    command.exec(
    { "tailwindcss", "build", "-c", "src/tailwind.config.js", "-i", "src/input.css", "-o", "public/style.css" }, "inhert",
    "inhert")
end

function download()
    log.info("Downloading Tailwind CLI... - joking, that's not implemented yet")
    -- network.download_file("https://github.com/tailwindlabs/tailwindcss/releases/latest/download/tailwindcss-linux-x64", "tailwindcss")
    log.info("Downloaded Tailwind CLI")
end

function init_config()
    log.info("Initialize Tailwind config and input CSS...")
    local config = fs.file_get_content(library_dir .. "/../dioxus-cli-tailwind-plugin/assets/tailwind.config.js")
    local status = fs.file_set_content("src/tailwind.config.js", config)

    local input_css = fs.file_get_content(library_dir .. "/../dioxus-cli-tailwind-plugin/assets/input.css")
    status = fs.file_set_content("src/input.css", input_css)

    log.info("Initialized Tailwind config and input CSS")
end

return manager
