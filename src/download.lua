-- ----------------------------------
-- Tailwind CSS plugin for Dioxus CLI
-- ----------------------------------
--
-- This module adds download functionality.
--
-- Checks if Tailwind CSS is already installed. If not,
-- it downloads Tailwind for the user's operating system, 
-- and places it in the ./bin folder of the plugin.
-- For Unix-like systems, it also marks the binary as executable.
local download = {}
local plugin = require("plugin")

function download.download(destination_folder)
    --- Downloads Tailwind CLI based on operating system.
    -- @param destination_folder string - The source file path.

    if not (plugin.path.is_file(destination_folder .. "/tailwindcss") or plugin.path.is_file(destination_folder .. "/tailwindcss.exe")) then
        if not plugin.path.is_dir(destination_folder) then
            plugin.fs.create_dir(destination_folder, true)
        end

        plugin.log.info("Downloading Tailwind CLI...")

        local url, executable, platform
        platform = plugin.os.current_platform()
        if platform == "windows" then
            url = "https://github.com/tailwindlabs/tailwindcss/releases/latest/download/tailwindcss-windows-x64.exe"
            executable = destination_folder .. "tailwindcss.exe"
        elseif platform == "macos" then
            url = "https://github.com/tailwindlabs/tailwindcss/releases/latest/download/tailwindcss-macos-x64"
            executable = destination_folder .. "tailwindcss"
        elseif platform == "linux" then
            url = "https://github.com/tailwindlabs/tailwindcss/releases/latest/download/tailwindcss-linux-x64"
            executable = destination_folder .. "tailwindcss"
        end
        if not plugin.network.download_file(url, executable) then
            plugin.log.error("Failed to download Tailwind CLI.")
        else
            if platform == "macos" or platform == "linux" then
                plugin.command.exec({ "chmod", "+x", executable}, "inhert", "inhert")
            end
            plugin.log.info("Downloaded Tailwind CLI")
        end
    else
        plugin.log.info("Tailwind CLI already exists. Skipping.")
    end
end

return download