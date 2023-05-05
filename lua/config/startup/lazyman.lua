local settings = {
  -- every line should be same width without escaped \
  header = {
    type = "text",
    oldfiles_directory = false,
    align = "center",
    fold_section = false,
    title = "Header",
    margin = 5,
    content = {
      " ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗",
      " ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║",
      " ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║",
      " ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║",
      " ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║",
      " ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝",
    },
    highlight = "Statement",
    default_color = "",
    oldfiles_amount = 0,
  },
  -- name which will be displayed and command
  body = {
    type = "mapping",
    oldfiles_directory = false,
    align = "center",
    fold_section = false,
    title = "Lazyman Commands",
    margin = 5,
    content = {
      { " New File",              "lua require'startup'.new_file()", "n" },
      { " Find File",             "Telescope find_files",            "f" },
      { " Find Word",             "Telescope live_grep",             "w" },
      { " Recent Files",          "Telescope oldfiles",              "r" },
      { " File Browser",          "Telescope file_browser",          "b" },
      { " Colorschemes",          "Telescope colorscheme",           "s" },
      { " Cheatsheet",            "Cheatsheet",                      "c" },
      { " Lazyman Main Menu",     "Lazyman",                         "l" },
      { " Lazyman Configuration", "Lazyconf",                        "C" },
      { " Lazy Menu",             "Lazy",                            "L" },
      { " Mason Menu",            "Mason",                           "M" },
      { " Quit",                  "quitall",                         "q" },
    },
    highlight = "String",
    default_color = "",
    oldfiles_amount = 0,
  },
  footer = {
    type = "text",
    oldfiles_directory = false,
    align = "center",
    fold_section = false,
    title = "Footer",
    margin = 5,
    content = { "Lazyman Neovim with Startup" },
    highlight = "Number",
    default_color = "",
    oldfiles_amount = 0,
  },

  options = {
    mapping_keys = true,
    cursor_column = 0.5,
    empty_lines_between_mappings = false,
    disable_statuslines = true,
    paddings = { 1, 1, 1, 0 },
  },
  mappings = {
    execute_command = "<CR>",
    open_file = "o",
    open_file_split = "<c-o>",
    open_section = "<TAB>",
    open_help = "?",
  },
  colors = {
    background = "#1f2227",
    folded_section = "#56b6c2",
  },
  parts = { "header", "body", "footer" },
}
return settings
