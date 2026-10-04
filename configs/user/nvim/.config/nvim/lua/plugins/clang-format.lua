return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      c = { "clang-format" },
      cpp = { "clang-format" },
    },
    formatters = {
      ["clang-format"] = {
        -- Use the nearest .clang-format (project or ~/.clang-format)
        prepend_args = { "--style=file" },
      },
    },
  },
}
