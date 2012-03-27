# DotFiles

These are my dotfiles that I use.  They are setup primarily around Terminal Vim, ITerm2, and Tmux.

There is a little bit of specific initial setup to get things working smoothly.

# Setup

* Make sure you have the latest vim, tmux, and iterm2

```
brew install --HEAD https://raw.github.com/adamv/homebrew-alt/master/duplicates/vim.rb
brew install tmux
brew install reattach-to-user-namespace
```

# Iterm 2 Setup

I installed the solarized colorscheme.  Vim and tmux have the corresponding color schemes setup as well.

* Download it here: http://ethanschoonover.com/solarized
* I configured two seperate profiles.  One for light and one for dark.  I often switch between them based on day or night to combat glare. Tmux makes it very easy to switch without losing a beat.
** CMD-O, select new profile.  Then run ```tmux attach``` and you are good to go.  Vim is also configured with a shortcut <F5> to switch between light and dark themes
* Make sure you setup the profile to 'Report Terminal Type: xterm-256color' under "Profiles" / "Terminal".  This helps address vim color issues in terminal.

# Credits

A lot of this setup is summarized nicely and stolen from here: http://rhnh.net/2011/08/20/vim-and-tmux-on-osx





