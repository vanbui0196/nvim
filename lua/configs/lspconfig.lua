require("nvchad.configs.lspconfig").defaults()

local servers = { "html", "cssls", "clangd", "cmake" }
vim.lsp.enable(servers)

-- Optional: Configure clangd specific settings for better C++ support
local lspconfig = require("lspconfig")
lspconfig.clangd.setup({
  cmd = { "clangd", "--background-index", "--clang-tidy" },
  filetypes = { "c", "cpp", "objc", "objcpp" },
  root_dir = lspconfig.util.root_pattern("compile_commands.json", ".git"),
})

-- Optional: Configure cmake LSP
lspconfig.cmake.setup({
  filetypes = { "cmake" },
  init_options = {
    buildDirectory = "build"
  }
})
-- read :h vim.lsp.config for changing options of lsp servers 
