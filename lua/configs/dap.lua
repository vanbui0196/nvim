local dap = require("dap")
local dapui = require("dapui")

-- Setup DAP UI
dapui.setup({
  icons = { expanded = "", collapsed = "", current_frame = "" },
  mappings = {
    expand = { "<CR>", "<2-LeftMouse>" },
    open = "o",
    remove = "d",
    edit = "e",
    repl = "r",
    toggle = "t",
  },
  expand_lines = vim.fn.has("nvim-0.7") == 1,
  layouts = {
    {
      elements = {
        { id = "scopes", size = 0.25 },
        "breakpoints",
        "stacks",
        "watches",
      },
      size = 40,
      position = "left",
    },
    {
      elements = {
        "repl",
        "console",
      },
      size = 0.25,
      position = "bottom",
    },
  },
  controls = {
    enabled = true,
    element = "repl",
    icons = {
      pause = "",
      play = "",
      step_into = "",
      step_over = "",
      step_out = "",
      step_back = "",
      run_last = "",
      terminate = "",
    },
  },
  floating = {
    max_height = nil,
    max_width = nil,
    border = "single",
    mappings = {
      close = { "q", "<Esc>" },
    },
  },
  windows = { indent = 1 },
  render = {
    max_type_length = nil,
    max_value_lines = 100,
  }
})

-- Setup virtual text
require("nvim-dap-virtual-text").setup({
  enabled = true,
  enabled_commands = true,
  highlight_changed_variables = true,
  highlight_new_as_changed = false,
  show_stop_reason = true,
  commented = false,
  only_first_definition = true,
  all_references = false,
  filter_references_pattern = '<module',
  virt_text_pos = 'eol',
  all_frames = false,
  virt_lines = false,
  virt_text_win_col = nil
})

-- CodeLLDB adapter configuration for C/C++
dap.adapters.codelldb = {
  type = 'server',
  port = "${port}",
  executable = {
    command = vim.fn.exepath('codelldb'),
    args = {"--port", "${port}"},
  }
}

-- C/C++ configuration
dap.configurations.cpp = {
  {
    name = "Launch file",
    type = "codelldb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/build/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = {},
    runInTerminal = false,
  },
  {
    name = "Attach to process",
    type = "codelldb",
    request = "attach",
    pid = require('dap.utils').pick_process,
    args = {},
  }
}

-- Use the same configuration for C
dap.configurations.c = dap.configurations.cpp

-- Auto open/close DAP UI
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

-- Key mappings for DAP
local map = vim.keymap.set

map("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
map("n", "<leader>dB", function()
  dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
end, { desc = "Set Conditional Breakpoint" })
map("n", "<leader>dc", dap.continue, { desc = "Continue" })
map("n", "<leader>da", function()
  dap.continue({ before = get_args })
end, { desc = "Run with Args" })
map("n", "<leader>dC", dap.run_to_cursor, { desc = "Run to Cursor" })
map("n", "<leader>dg", dap.goto_, { desc = "Go to line (no execute)" })
map("n", "<leader>di", dap.step_into, { desc = "Step Into" })
map("n", "<leader>dj", dap.down, { desc = "Down" })
map("n", "<leader>dk", dap.up, { desc = "Up" })
map("n", "<leader>dl", dap.run_last, { desc = "Run Last" })
map("n", "<leader>do", dap.step_out, { desc = "Step Out" })
map("n", "<leader>dO", dap.step_over, { desc = "Step Over" })
map("n", "<leader>dp", dap.pause, { desc = "Pause" })
map("n", "<leader>dr", dap.repl.toggle, { desc = "Toggle REPL" })
map("n", "<leader>ds", dap.session, { desc = "Session" })
map("n", "<leader>dt", dap.terminate, { desc = "Terminate" })
map("n", "<leader>dw", require("dap.ui.widgets").hover, { desc = "Widgets" })

-- DAP UI mappings
map("n", "<leader>du", dapui.toggle, { desc = "Toggle DAP UI" })
map("n", "<leader>de", dapui.eval, { desc = "Eval", mode = {"n", "v"} })
