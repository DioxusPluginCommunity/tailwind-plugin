-- ----------------------------------
-- Tailwind CSS plugin for Dioxus CLI
-- ----------------------------------
--
-- This module deals with building the CSS file using Tailwind.
--
-- This function will be ran after every build and server reload.
-- Runs Tailwind CSS using the project config files,
-- and generates a CSS file.


local build = {}
local plugin = require("plugin")

function build.build_css(executable, src_folder, css_file)
   if not (plugin.path.is_file(bin_folder .. "/tailwindcss") or plugin.path.is_file(bin_folder .. "/tailwindcss.exe")) then
      download.download_tailwind(bin_folder)
   end

   build.run_tailwind(executable, src_folder, css_file)
end

function build.run_tailwind(executable, src_folder, css_file)
   --- Runs Tailwind and builds the CSS file in the ./public folder.

   plugin.log.info("Building CSS...")
   plugin.command.exec(
   { executable, "build", "-c", src_folder .. "/tailwind.config.js", "-i", src_folder .. "/input.css", "-o",
      "public/" .. css_file, "--minify" }, "inhert", "inhert")
end

return build