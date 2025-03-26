local jdtls = require("jdtls")
local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
local root_dir = require("jdtls.setup").find_root(root_markers)
if not root_dir then return end

local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. project_name

vim.api.nvim_create_user_command("InsertDebugSout", function()
    local lines = {
        'System.out.println("######################################################################################################");',
        'System.out.println();',
        'System.out.println();',
        'System.out.println("DEBUG MESSAGE");',
        'System.out.println();',
        'System.out.println();',
        'System.out.println("######################################################################################################");'
    }
    -- Insert the lines at the current cursor position (before the current line)
    local pos = vim.api.nvim_win_get_cursor(0)
    vim.api.nvim_buf_set_lines(0, pos[1] - 1, pos[1] - 1, false, lines)
end, {})

-- Organize Imports
vim.keymap.set("n", "<A-o>", function()
    require("jdtls").organize_imports()
end, { noremap = true, silent = false })

-- Extract Variable
vim.keymap.set("n", "crv", function()
    require("jdtls").extract_variable()
end, { noremap = true, silent = false })

vim.keymap.set("v", "crv", function()
    require("jdtls").extract_variable(true)
end, { noremap = true, silent = false })

-- Extract Constant
vim.keymap.set("n", "crc", function()
    require("jdtls").extract_constant()
end, { noremap = true, silent = false })

vim.keymap.set("v", "crc", function()
    require("jdtls").extract_constant(true)
end, { noremap = true, silent = false })

-- Extract Method
vim.keymap.set("v", "crm", function()
    require("jdtls").extract_method(true)
end, { noremap = true, silent = false })

local config = {
    cmd = { "jdtls" },
    root_dir = root_dir,
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
    settings = {
        java = {
            configuration = {
                runtimes = {
                    {
                        name = "JavaSE-21",
                        path = "/usr/lib/jvm/java-21-openjdk-amd64",
                    },
                },
            },
        },
    },
}

jdtls.start_or_attach(config)
