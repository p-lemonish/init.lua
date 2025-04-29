# init.lua
This repo is used for tracking the changes in my configuration files for turning nvim into a replacement for VSCode.

The beginning of this project was largely inspired by ThePrimeagen and their video [0 to LSP : Neovim RC From Scratch](https://www.youtube.com/watch?v=w7i4amO_zaE).
Unlike in the video, I chose to use [lazy.nvim](https://github.com/folke/lazy.nvim) over Packer as a plugin manager, 
so the directory hierarchy had to be changed slightly, more info on this at https://github.com/ThePrimeagen/init.lua/tree/master.

## Plugins used
- Fuzzy search: [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
- Version control: [lazygit.nvim](https://github.com/kdheepak/lazygit.nvim)
- Highlighting: [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
- QoL for repetitive edits in many files: [Harpoon](https://github.com/ThePrimeagen/harpoon/tree/harpoon2)
- Colorscheme: [tokyonight.nvim](https://github.com/folke/tokyonight.nvim)
- Surround selections: [nvim-surround](https://github.com/kylechui/nvim-surround)
