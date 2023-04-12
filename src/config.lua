-- ----------------------------------
-- Tailwind CSS plugin for Dioxus CLI
-- ----------------------------------
--
-- This module deals with Tailwind configuration files.
--
-- Checks if Tailwind config files already exist.
-- If not, it creates them using default files found in ./assets
-- and places them in the project folder.

local config = {}
local plugin = require("plugin")

local function copy_config_file(source_file, dest_file)
    --- Copies a file from the given source to the given destination.
    -- @param source_file string - The source file.
    -- @param dest_file string - The destination file.

    if plugin.path.is_file(dest_file) then
        plugin.log.info(dest_file .. " already exists. Skipping.")
    else
        local input_css = plugin.fs.file_get_content(source_file)
        local status = plugin.fs.file_set_content(dest_file, input_css)

        if status == false then
            plugin.log.error("Failed to create " .. dest_file .. ".")
            return
        else
            plugin.log.info("Created " .. dest_file .. ".")
        end
    end
end

function config.init_config(source_folder)
    --- Creates tailwind.config.js and input.css in the project directory.
    --- If the files already exist, it will not overwrite them.
    -- @param source_folder string - The source folder from which to copy.

    plugin.log.info("Initializing Tailwind config.")
    copy_config_file(source_folder .. "/assets/tailwind.config.js", "src/tailwind.config.js")
    copy_config_file(source_folder .. "/assets/input.css", "src/input.css")
    plugin.log.info("Initialized successfully.")
end

return config