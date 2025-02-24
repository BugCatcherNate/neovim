
# Download Neovim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux64.tar.gz
rm nvim-linux64.tar.gz
# set to path

line='export PATH="$PATH:/opt/nvim-linux64/bin"'

# Check if the line already exists in .bashrc
if ! grep -Fxq "$line" ~/.bashrc; then
    # If not, append the line to .bashrc
    echo "$line" >> ~/.bashrc
    echo "Line added to .bashrc"
else
    echo "Line already exists in .bashrc"
fi
source ~/.bashrc
# Set Config
# Define the directory and file path
dir="$HOME/.config/nvim"
file="$dir/init.vim"

# Create the directory if it doesn't exist
mkdir -p "$dir"
cat <<EOL > "$file"
set nocompatible            " disable compatibility to old-time vi
set showmatch               " show matching 
set ignorecase              " case insensitive 
set mouse=v                 " middle-click paste with 
set hlsearch                " highlight search 
set incsearch               " incremental search
set tabstop=4               " number of columns occupied by a tab 
set softtabstop=4           " see multiple spaces as tabstops so <BS> does the right thing
set expandtab               " converts tabs to white space
set shiftwidth=4            " width for autoindents
set autoindent              " indent a new line the same amount as the line just typed
set number                  " add line numbers
set wildmode=longest,list   " get bash-like tab completions
set cc=80                  " set an 80 column border for good coding style
filetype plugin indent on   "allow auto-indenting depending on file type
set mouse=a                 " enable mouse click
set clipboard=unnamedplus   " using system clipboard
filetype plugin on
set cursorline              " highlight current cursorline
set ttyfast                 " Speed up scrolling in Vim
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
EOL

echo "init.vim file created at $file"

# Install vim-plug

sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
echo "Installed vim plug"

# Plugins
plugin_config=$(cat <<EOL

call plug#begin("~/.vim/plugged")
" Plugin Section
Plug 'neanias/everforest-nvim', { 'branch': 'main' }
Plug 'sheerun/vim-polyglot'
Plug 'Valloric/YouCompleteMe'
Plug 'dense-analysis/ale'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
call plug#end()
EOL
)

echo "$plugin_config" >> "$file"

echo "Plugin configuration appended to $file"

# Plugins config
plugins_configuration=$(cat <<EOL
colorscheme everforest
syntax on                   " syntax highlighting
EOL
)

echo "$plugins_configuration" >> "$file"

echo "Plugins configuration appended to $file"

# Plug Install
nvim --headless +PlugInstall +qall 

echo "Plug installed plugins"

# Install YCM
python3 ~/.vim/plugged/YouCompleteMe/install.py --rust-completer

echo "YCM installed"
