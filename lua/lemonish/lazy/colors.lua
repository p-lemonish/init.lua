function ColorMyPencils(color)
	color = color or "tokyonight-night"
	vim.cmd.colorscheme(color)

    -- Uncomment if you'd like to have a background image
	-- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

return { 
	{
		"folke/tokyonight.nvim", 
		lazy = false,
		priority = 1000,
		opts = {},
		config = function()
			ColorMyPencils()
		end
	},
}
