# shell-watch
`shell-watch` is a zsh script that automatically sources your `~/.zshrc` when it is modified. This allows you to access changes to your `~/.zshrc` instantly (such as setting environment variables).

## Installation

To install

```
mkdir -p ~/.shell-watch && curl "https://raw.githubusercontent.com/seanyeh/shell-watch/master/shell-watch.zsh" -o ~/.shell-watch/shell-watch.zsh
```

Add the following to your `~/.zshrc`:
```
source ~/.shell-watch/shell-watch.zsh
```

Finally, run `source ~/.zshrc`. This should be the last time you ever need to do this!

## Configuration

### Custom watch list
By default, `shell-watch` watches your `~/.zshrc`, but you can also configure it to watch other files instead. 
Simply create a file in `~/.config/shell-watch/` (or `$XDG_CONFIG_HOME/shell-watch` if you have a custom `$XDG_CONFIG_HOME`) called `watchlist`:

```
# ~/.config/shell-watch/watchlist
# List files you want to watch, one per line
~/.zshrc
~/.profile
```

### Custom command
When a change is made to a file on the watch list, `source ~/.zshrc` is run. You can customize this by creating a file in `~/.config/shell-watch/` (or `$XDG_CONFIG_HOME/shell-watch` if you have a custom `$XDG_CONFIG_HOME`) called `command`. If this file exists, `source ~/.config/shell-watch/command` will be run instead.

```
# ~/.config/shell-watch/command
# Run any commands you want
source ~/.zshrc
echo "hello"
```
