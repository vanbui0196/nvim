local options = {
  cmake_executable = "cmake",
  cmake_build_directory = "build",
  cmake_generate_options = { "-DCMAKE_EXPORT_COMPILE_COMMANDS=1" },
  cmake_build_options = {},
  cmake_console_size = 10,
  cmake_show_console = "always",
  cmake_dap_configuration = {
    name = "cpp",
    type = "codelldb",
    request = "launch",
  },
  cmake_variants_message = {
    short = { show = true },
    long = { show = true, max_length = 40 }
  }
}

return options
