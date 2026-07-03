# tabtrack

Automatic tab coloring for your terminal.

Your tabs light up when you run commands — `claude` goes orange, `docker` goes blue, `npm` goes red. When a command finishes, the tab returns to a neutral idle color. No config needed, but fully customizable.

## Install

### Oh My Zsh

```bash
git clone https://github.com/wrabit/tabtrack ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/tabtrack
```

Add to your `.zshrc`:

```bash
plugins=(... tabtrack)
```

### Manual (plain Zsh)

```bash
git clone https://github.com/wrabit/tabtrack ~/.zsh/tabtrack
```

Add to your `.zshrc`:

```bash
source ~/.zsh/tabtrack/tabtrack.plugin.zsh
```

## How it works

- **Run a command** → tab color matches the command
- **Command finishes** → tab returns to idle color
- **No match?** → a unique color is auto-generated from the command name

## Built-in colors

| Command | Color | |
|---------|-------|-|
| `claude` | Orange | ![#ff8c00](https://placehold.co/200x20/ff8c00/ff8c00.png) |
| `npm` | Red | ![#CB3837](https://placehold.co/200x20/CB3837/CB3837.png) |
| `yarn` | Blue | ![#2C8EBB](https://placehold.co/200x20/2C8EBB/2C8EBB.png) |
| `pnpm` | Orange | ![#F69220](https://placehold.co/200x20/F69220/F69220.png) |
| `brew` | Brown | ![#BE862D](https://placehold.co/200x20/BE862D/BE862D.png) |
| `docker` | Docker Blue | ![#0db7ed](https://placehold.co/200x20/0db7ed/0db7ed.png) |
| `git` | Orange-Red | ![#f14e32](https://placehold.co/200x20/f14e32/f14e32.png) |
| `python` / `pip` | Python Blue | ![#3776AB](https://placehold.co/200x20/3776AB/3776AB.png) |
| `uv` / `uvx` | Purple | ![#6340AC](https://placehold.co/200x20/6340AC/6340AC.png) |
| `node` | Green | ![#339933](https://placehold.co/200x20/339933/339933.png) |
| `ruby` | Red | ![#CC342D](https://placehold.co/200x20/CC342D/CC342D.png) |
| `cargo` | Rust | ![#DEA584](https://placehold.co/200x20/DEA584/DEA584.png) |
| `go` | Cyan | ![#00ADD8](https://placehold.co/200x20/00ADD8/00ADD8.png) |
| `ssh` | Green | ![#4E9A06](https://placehold.co/200x20/4E9A06/4E9A06.png) |
| `vim` / `nvim` | Green | ![#019833](https://placehold.co/200x20/019833/019833.png) |
| `kubectl` | K8s Blue | ![#326CE5](https://placehold.co/200x20/326CE5/326CE5.png) |
| `terraform` | Purple | ![#7B42BC](https://placehold.co/200x20/7B42BC/7B42BC.png) |
| `redis` | Red | ![#DC382D](https://placehold.co/200x20/DC382D/DC382D.png) |
| `psql` | Postgres Blue | ![#336791](https://placehold.co/200x20/336791/336791.png) |
| `mysql` | MySQL Blue | ![#4479A1](https://placehold.co/200x20/4479A1/4479A1.png) |
| `make` | Gray | ![#6D8086](https://placehold.co/200x20/6D8086/6D8086.png) |
| `htop` / `top` | Sea Green | ![#2E8B57](https://placehold.co/200x20/2E8B57/2E8B57.png) |
| `pytest` | Gray | ![#696969](https://placehold.co/200x20/696969/696969.png) |
| `rails` | Red | ![#CC0000](https://placehold.co/200x20/CC0000/CC0000.png) |
| `mongosh` | Green | ![#47A248](https://placehold.co/200x20/47A248/47A248.png) |

## Custom colors

Create `~/.tabtrack` to add your own patterns. User patterns always take priority over built-ins.

```bash
# ~/.tabtrack
# Format: pattern=hexcolor

# Set the idle/default tab color
default=#1e1e1e

# Directories
/Users/me/work/acme*=#E91E63
/Users/me/personal*=#4CAF50

# Commands
rails*=#CC0000
mix*=#6E4A7E
```

Patterns use glob matching and are checked top-to-bottom — first match wins.

Command patterns apply while a command is running. Directory patterns are matched against the current directory whenever the shell is idle, so the tab keeps the directory color between commands. `~` expands to your home directory, so `~/work/acme*=#E91E63` works too.

## Options

### Default (idle) color

When no command is running, tabs show the idle color. Default is `#1e1e1e` (charcoal). Change it:

```bash
# In ~/.tabtrack
default=#2a2a2a

# Or export in .zshrc
export TT_DEFAULT="#2a2a2a"
```

### Disable auto-coloring

By default, commands without an explicit match get a deterministic color generated from the command name. To disable this and only color matched patterns:

```bash
export TT_AUTO_COLOR=false
```

## Supported terminals

- [iTerm2](https://iterm2.com/) (macOS) — full support

Other terminals with tab coloring APIs (Kitty, WezTerm) can be added via the `_tt_set_color` backend.

## Credits

Inspired by [bernardop/iterm-tab-color-oh-my-zsh](https://github.com/bernardop/iterm-tab-color-oh-my-zsh).

## License

MIT
