
## Start with chezmoi

```bash
chezmoi init --apply siisee11
```

## Rust

```
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```


## Mise

```
curl https://mise.run | sh
echo 'eval "$(~/.local/bin/mise activate zsh)"' >> ~/.zshrc
```



# Legacies

## Link vimrc file

```bash
$ ln -s -f dotfiles/vim/.vimrc ~/.vimrc
```

if nvim
```bash
$ ln -s -f dotfiles/vim/init.vim ~/.config/nvim/init.vim
```

## Link tmux.conf file

```bash
$ ln -s -f dotfiles/tmux/.tmux.conf ~/.tmux.conf
```

## Link zshrc file

```bash
$ ln -s -f dotfiles/zsh/.zshrc ~/.zshrc
```
