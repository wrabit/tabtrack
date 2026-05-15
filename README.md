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
| `claude` | Orange | ![#ff8c00](https://img.shields.io/badge/%20-%20-ff8c00) |
| `npm` | Red | ![#CB3837](https://img.shields.io/badge/%20-%20-CB3837) |
| `yarn` | Blue | ![#2C8EBB](https://img.shields.io/badge/%20-%20-2C8EBB) |
| `pnpm` | Orange | ![#F69220](https://img.shields.io/badge/%20-%20-F69220) |
| `brew` | Brown | ![#BE862D](https://img.shields.io/badge/%20-%20-BE862D) |
| `docker` | Docker Blue | ![#0db7ed](https://img.shields.io/badge/%20-%20-0db7ed) |
| `git` | Orange-Red | ![#f14e32](https://img.shields.io/badge/%20-%20-f14e32) |
| `python` / `pip` | Python Blue | ![#3776AB](https://img.shields.io/badge/%20-%20-3776AB) |
| `uv` / `uvx` | Purple | ![#6340AC](https://img.shields.io/badge/%20-%20-6340AC) |
| `node` | Green | ![#339933](https://img.shields.io/badge/%20-%20-339933) |
| `ruby` | Red | ![#CC342D](https://img.shields.io/badge/%20-%20-CC342D) |
| `cargo` | Rust | ![#DEA584](https://img.shields.io/badge/%20-%20-DEA584) |
| `go` | Cyan | ![#00ADD8](https://img.shields.io/badge/%20-%20-00ADD8) |
| `ssh` | Green | ![#4E9A06](https://img.shields.io/badge/%20-%20-4E9A06) |
| `vim` / `nvim` | Green | ![#019833](https://img.shields.io/badge/%20-%20-019833) |
| `kubectl` | K8s Blue | ![#326CE5](https://img.shields.io/badge/%20-%20-326CE5) |
| `terraform` | Purple | ![#7B42BC](https://img.shields.io/badge/%20-%20-7B42BC) |
| `redis` | Red | ![#DC382D](https://img.shields.io/badge/%20-%20-DC382D) |
| `psql` | Postgres Blue | ![#336791](https://img.shields.io/badge/%20-%20-336791) |
| `mysql` | MySQL Blue | ![#4479A1](https://img.shields.io/badge/%20-%20-4479A1) |
| `make` | Gray | ![#6D8086](https://img.shields.io/badge/%20-%20-6D8086) |
| `htop` / `top` | Sea Green | ![#2E8B57](https://img.shields.io/badge/%20-%20-2E8B57) |
| `pytest` | Gray | ![#696969](https://img.shields.io/badge/%20-%20-696969) |
| `rails` | Red | ![#CC0000](https://img.shields.io/badge/%20-%20-CC0000) |
| `mongosh` | Green | ![#47A248](https://img.shields.io/badge/%20-%20-47A248) |

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
