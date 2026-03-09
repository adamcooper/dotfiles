# Solarized Themes + Claude Config Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Add consistent Solarized Light/Dark theming across tmux, nvim, and VS Code (auto-switching with macOS system preference), and manage Claude config files (`CLAUDE.md`, `settings.json`) via chezmoi.

**Architecture:** A central `theme-current` script outputs `light` or `dark` based on macOS system preference (defaulting to `dark` on Linux). Tmux sources a theme file on startup and via `dark-mode-notify` on macOS. Neovim uses `auto-dark-mode.nvim` + `maxmx03/solarized.nvim`. VS Code uses native `autoDetectColorScheme`. Claude files are chezmoi templates with role-gated sections and 1Password for work secrets.

**Tech Stack:** chezmoi templates, tmux `if-shell`, lazy.nvim, `maxmx03/solarized.nvim`, `f-person/auto-dark-mode.nvim`, `dark-mode-notify` (Homebrew, macOS only), VS Code JSON settings.

---

## Task 1: Theme detection script

**Files:**
- Create: `home/dot_local/bin/theme-current`

**Step 1: Create the script**

```sh
#!/bin/sh
# Outputs "dark" or "light" based on system preference.
# macOS: reads AppleInterfaceStyle. Linux: defaults to dark.
if [ "$(uname)" = "Darwin" ]; then
  if defaults read -g AppleInterfaceStyle 2>/dev/null | grep -q Dark; then
    echo dark
  else
    echo light
  fi
else
  echo dark
fi
```

**Step 2: Make executable**

```bash
chmod +x home/dot_local/bin/theme-current
```

chezmoi maps `home/dot_local/` → `~/.local/`, so this lands at `~/.local/bin/theme-current`.

**Step 3: Apply and verify**

```bash
chezmoi apply ~/.local/bin/theme-current
~/.local/bin/theme-current   # should output "light" or "dark"
```

**Step 4: Commit**

```bash
git add home/dot_local/bin/theme-current
git commit -m "feat: add theme-current detection script"
```

---

## Task 2: Tmux Solarized theme files

**Files:**
- Create: `home/dot_config/tmux/themes/solarized-dark.conf`
- Create: `home/dot_config/tmux/themes/solarized-light.conf`

**Step 1: Create dark theme**

```conf
# home/dot_config/tmux/themes/solarized-dark.conf
# Solarized Dark palette:
#   base03=#002b36  base02=#073642  base01=#586e75  base00=#657b83
#   base0=#839496   base1=#93a1a1   blue=#268bd2    cyan=#2aa198

set -g status-style "bg=#073642,fg=#839496"
set -g message-style "bg=#073642,fg=#2aa198"
set -g pane-border-style "fg=#586e75"
set -g pane-active-border-style "fg=#268bd2"
set -g status-left "#[fg=#268bd2,bold]#S #[fg=#586e75,nobold]| #[fg=#839496]#(whoami)@#H"
set -g status-right "#[fg=#586e75]%Y-%m-%d #[fg=#839496]%H:%M"
```

**Step 2: Create light theme**

```conf
# home/dot_config/tmux/themes/solarized-light.conf
# Solarized Light palette:
#   base3=#fdf6e3   base2=#eee8d5   base1=#93a1a1   base0=#839496
#   base00=#657b83  base01=#586e75  blue=#268bd2    cyan=#2aa198

set -g status-style "bg=#eee8d5,fg=#657b83"
set -g message-style "bg=#eee8d5,fg=#2aa198"
set -g pane-border-style "fg=#93a1a1"
set -g pane-active-border-style "fg=#268bd2"
set -g status-left "#[fg=#268bd2,bold]#S #[fg=#93a1a1,nobold]| #[fg=#657b83]#(whoami)@#H"
set -g status-right "#[fg=#93a1a1]%Y-%m-%d #[fg=#657b83]%H:%M"
```

**Step 3: Apply and inspect**

```bash
chezmoi apply ~/.config/tmux/themes/
ls ~/.config/tmux/themes/
```

**Step 4: Commit**

```bash
git add home/dot_config/tmux/themes/
git commit -m "feat: add tmux Solarized dark and light theme files"
```

---

## Task 3: Wire Solarized into tmux.conf

**Files:**
- Modify: `home/dot_config/tmux/tmux.conf`

**Step 1: Replace the hardcoded color block**

Remove lines 45–51 (the `set -g status-style` block through `status-right`) and replace with:

```conf
# Load Solarized theme based on system preference
if-shell '~/.local/bin/theme-current | grep -q dark' \
  'source-file ~/.config/tmux/themes/solarized-dark.conf' \
  'source-file ~/.config/tmux/themes/solarized-light.conf'
```

The existing `bind r source-file` line at line 19 already reloads the config, so
prefix+r will re-detect and apply the correct theme.

**Step 2: Apply and test**

```bash
chezmoi apply ~/.config/tmux/tmux.conf
tmux source-file ~/.config/tmux/tmux.conf
# Status bar should now use Solarized colors
```

**Step 3: Verify in both modes (macOS)**

```bash
# Switch system to Dark in System Preferences, then:
tmux source-file ~/.config/tmux/tmux.conf
# Status bar should go dark

# Switch system to Light, then:
tmux source-file ~/.config/tmux/tmux.conf
# Status bar should go light
```

**Step 4: Commit**

```bash
git add home/dot_config/tmux/tmux.conf
git commit -m "feat: wire Solarized theme into tmux via system preference detection"
```

---

## Task 4: Live tmux theme switching on macOS (dark-mode-notify)

**Files:**
- Create: `home/dot_local/bin/theme-switch`
- Create: `home/Library/LaunchAgents/com.adamcooper.dark-mode-notify.plist.tmpl` (macOS only)

**Step 1: Install dark-mode-notify**

```bash
brew install dark-mode-notify
```

Add to `scripts/bootstrap-macos.sh` if it exists:

```bash
brew install dark-mode-notify
```

**Step 2: Create the switch script**

```sh
#!/bin/sh
# ~/.local/bin/theme-switch
# Called by dark-mode-notify when macOS appearance changes.
# Re-sources the tmux theme in all running sessions.
THEME=$(~/.local/bin/theme-current)
tmux source-file ~/.config/tmux/themes/solarized-${THEME}.conf 2>/dev/null || true
```

Make it executable:
```bash
chmod +x home/dot_local/bin/theme-switch
```

**Step 3: Create the LaunchAgent plist template**

This is macOS-only — create the directory and file:

```xml
<!-- home/Library/LaunchAgents/com.adamcooper.dark-mode-notify.plist.tmpl -->
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>com.adamcooper.dark-mode-notify</string>
  <key>ProgramArguments</key>
  <array>
    <string>/opt/homebrew/bin/dark-mode-notify</string>
    <string>{{ .chezmoi.homeDir }}/.local/bin/theme-switch</string>
  </array>
  <key>RunAtLoad</key>
  <true/>
  <key>KeepAlive</key>
  <true/>
</dict>
</plist>
```

**Step 4: Exclude the LaunchAgents directory on Linux via .chezmoiignore**

Create or edit `home/.chezmoiignore`:

```
{{ if ne .chezmoi.os "darwin" }}
Library
{{ end }}
```

**Step 5: Apply and load the agent**

```bash
chezmoi apply
launchctl load ~/Library/LaunchAgents/com.adamcooper.dark-mode-notify.plist

# Test: toggle macOS appearance in System Settings → Appearance
# Tmux status bar should change within a second
```

**Step 6: Commit**

```bash
git add home/dot_local/bin/theme-switch \
        "home/Library/LaunchAgents/com.adamcooper.dark-mode-notify.plist.tmpl" \
        home/.chezmoiignore
git commit -m "feat: live tmux theme switching via dark-mode-notify on macOS"
```

---

## Task 5: Neovim Solarized theme + auto dark mode

**Files:**
- Modify: `home/dot_config/nvim/init.lua`

**Step 1: Add plugins to the lazy.nvim setup block**

In `init.lua`, inside `require("lazy").setup({ ... })`, after the Telescope plugin entry, add:

```lua
  {
    "maxmx03/solarized.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
    config = function(_, opts)
      require("solarized").setup(opts)
      vim.cmd.colorscheme("solarized")
    end,
  },
  {
    "f-person/auto-dark-mode.nvim",
    opts = {
      set_dark_mode = function()
        vim.o.background = "dark"
      end,
      set_light_mode = function()
        vim.o.background = "light"
      end,
    },
  },
```

**Step 2: Apply and test**

```bash
chezmoi apply ~/.config/nvim/init.lua
nvim  # should open with Solarized theme matching system preference
# :checkhealth auto-dark-mode  — verify plugin is detecting correctly
```

**Step 3: Toggle system appearance and verify nvim updates within ~3 seconds**

**Step 4: Commit**

```bash
git add home/dot_config/nvim/init.lua
git commit -m "feat: add Solarized nvim theme with auto dark/light switching"
```

---

## Task 6: VS Code Solarized theme

**Files:**
- Create: `home/Library/Application Support/Code/User/settings.json.tmpl`

Note: The directory name contains a space — git and chezmoi handle this fine, but use quotes in shell commands.

**Step 1: Check what VS Code settings already exist**

```bash
cat ~/Library/Application\ Support/Code/User/settings.json 2>/dev/null || echo "(none)"
```

Copy any existing settings you want to preserve.

**Step 2: Create the settings template**

```json
{
  "workbench.colorTheme": "Solarized Light",
  "workbench.preferredLightColorTheme": "Solarized Light",
  "workbench.preferredDarkColorTheme": "Solarized Dark",
  "window.autoDetectColorScheme": true,
  "editor.fontFamily": "JetBrainsMono Nerd Font, Menlo, Monaco, 'Courier New', monospace",
  "editor.fontSize": 14,
  "editor.fontLigatures": true,
  "editor.tabSize": 2,
  "editor.formatOnSave": true,
  "editor.rulers": [120],
  "editor.minimap.enabled": false,
  "terminal.integrated.fontFamily": "JetBrainsMono Nerd Font",
  "terminal.integrated.fontSize": 14,
  "files.trimTrailingWhitespace": true,
  "files.insertFinalNewline": true
}
```

The `autoDetectColorScheme` setting is the key — VS Code will switch between `preferredLightColorTheme` and `preferredDarkColorTheme` based on macOS system preference automatically.

Note: Solarized Light and Solarized Dark are built into VS Code — no extension needed.

**Step 3: Apply and verify**

```bash
chezmoi apply "~/Library/Application Support/Code/User/settings.json"
# Open VS Code — should show Solarized theme
# Toggle system appearance — VS Code should switch automatically
```

**Step 4: Commit**

```bash
git add "home/Library/Application Support/Code/User/settings.json.tmpl"
git commit -m "feat: add VS Code Solarized theme with auto dark/light switching"
```

---

## Task 7: Update bat theme to Solarized

**Files:**
- Modify: `home/dot_zshrc.tmpl`

**Step 1: Update BAT_THEME**

Find line `export BAT_THEME="ansi"` and replace with:

```sh
export BAT_THEME="Solarized (dark)"
```

Note: bat has both `Solarized (dark)` and `Solarized (light)`. Unfortunately bat doesn't auto-switch, but dark works well in both terminal modes. If you want system-aware bat theming later, wrap it with `$(~/.local/bin/theme-current | grep -q dark && echo "Solarized (dark)" || echo "Solarized (light)")`.

**Step 2: Apply and verify**

```bash
chezmoi apply ~/.zshrc
source ~/.zshrc
bat --list-themes | grep -i solar   # confirm theme name
echo "hello world" | bat --language sh
```

**Step 3: Commit**

```bash
git add home/dot_zshrc.tmpl
git commit -m "feat: update bat theme to Solarized"
```

---

## Task 8: Claude CLAUDE.md in chezmoi

**Files:**
- Create: `home/dot_claude/CLAUDE.md`

**Step 1: Create the file**

```markdown
# Global Claude Instructions

## Code Style
- Prefer simple, readable solutions over clever ones
- YAGNI: don't add features that aren't needed now
- Small, focused commits with clear messages

## Workflow
- Read files before editing them
- Run tests before claiming something works
- Ask before taking irreversible actions (force push, delete, etc.)

## Tools
- Shell: zsh
- Editor: nvim (remote), VS Code (mac)
- Runtime manager: mise
- Package manager: Homebrew (mac), apt (linux)
```

**Step 2: Apply and verify**

```bash
chezmoi apply ~/.claude/CLAUDE.md
cat ~/.claude/CLAUDE.md
```

**Step 3: Commit**

```bash
git add home/dot_claude/CLAUDE.md
git commit -m "feat: add global CLAUDE.md to chezmoi"
```

---

## Task 9: Claude settings.json template

**Files:**
- Create: `home/dot_claude/settings.json.tmpl`

**Step 1: Create the base template**

```json
{
  "env": {
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"
  },
  "model": "sonnet",
  "effortLevel": "medium",
  "statusLine": {
    "type": "command",
    "command": "node {{ .chezmoi.homeDir }}/.claude/hud/omc-hud.mjs"
  },
  "enabledPlugins": {
    "claude-dashboard@claude-dashboard": true,
    "greptile@claude-plugins-official": true,
    "github@claude-plugins-official": true,
    "rails-ai@rails-ai-marketplace": true,
    "superpowers@superpowers-dev": true,
    "frontend-design@claude-plugins-official": true,
    "code-review@claude-plugins-official": true{{ if ne .role "remote" }},
    "xclaude-plugin@xclaude-plugin-marketplace": true,
    "swift-lsp@claude-plugins-official": true{{ end }}
  },
  "allowedTools": [
    "Bash", "Edit", "Write", "Read", "Glob", "Grep",
    "mcp__context7__resolve-library-id",
    "mcp__context7__query-docs"{{ if ne .role "remote" }},
    "mcp__plugin_xclaude-plugin_xc-build__xcode_build",
    "mcp__plugin_xclaude-plugin_xc-build__xcode_clean",
    "mcp__plugin_xclaude-plugin_xc-build__xcode_list",
    "mcp__plugin_xclaude-plugin_xc-all__xcode_build",
    "mcp__plugin_xclaude-plugin_xc-all__xcode_clean",
    "mcp__plugin_xclaude-plugin_xc-all__xcode_test",
    "mcp__plugin_xclaude-plugin_xc-all__xcode_list",
    "mcp__plugin_xclaude-plugin_xc-all__simulator_list",
    "mcp__plugin_xclaude-plugin_xc-all__simulator_boot",
    "mcp__plugin_xclaude-plugin_xc-all__simulator_screenshot",
    "mcp__plugin_xclaude-plugin_xc-all__simulator_install_app",
    "mcp__plugin_xclaude-plugin_xc-all__simulator_launch_app",
    "mcp__plugin_xclaude-plugin_xc-all__idb_describe",
    "mcp__plugin_xclaude-plugin_xc-all__idb_tap",
    "mcp__plugin_xclaude-plugin_xc-all__idb_input",
    "mcp__plugin_xclaude-plugin_xc-all__idb_find_element",
    "mcp__plugin_xclaude-plugin_xc-all__idb_check_quality"{{ end }}
  ],
  "mcpServers": {
    "context7": {
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp"]
    },
    "playwright": {
      "command": "npx",
      "args": ["@playwright/mcp", "--headless"]
    }{{ if eq .role "work" }},
    {{ template "work-mcp-servers" . }}{{ end }}
  },
  "skipDangerousModePermissionPrompt": true
}
```

**Step 2: Add work MCP servers to 1Password first (do this on work machine)**

For each work MCP server that has an API key:
1. Open 1Password → create item named `Claude MCP - <service>`
2. Add field `api_key` with the key value
3. Note the vault name (e.g., `Work`)

Then add to the template above (replacing the `{{ template "work-mcp-servers" . }}` placeholder):

```json
"your-work-service": {
  "command": "npx",
  "args": ["-y", "some-mcp-package"],
  "env": {
    "API_KEY": "{{ onepasswordRead \"op://Work/Claude MCP - your-work-service/api_key\" }}"
  }
}
```

**Step 3: Apply and verify on personal machine**

```bash
chezmoi apply ~/.claude/settings.json
cat ~/.claude/settings.json   # should have no 1Password placeholders — just personal settings
# Restart Claude Code and verify it loads correctly
```

**Step 4: Commit**

```bash
git add home/dot_claude/settings.json.tmpl home/dot_claude/CLAUDE.md
git commit -m "feat: add Claude settings.json template and CLAUDE.md to chezmoi"
```

---

## Task 10: Verify all themes end-to-end

**Step 1: Apply all changes**

```bash
chezmoi apply
```

**Step 2: Check each tool**

| Tool | Check |
|------|-------|
| Ghostty | Already working — light/dark switches with system |
| tmux | New tmux session in light mode → status bar should be tan/beige |
| tmux | Switch to dark mode → status bar should be dark blue-green |
| nvim | Open nvim in light mode → Solarized Light |
| nvim | Switch to dark mode → nvim updates within ~3s |
| VS Code | Open VS Code → Solarized Light in light mode |
| VS Code | Switch to dark mode → Solarized Dark |
| bat | `echo test | bat --language sh` → Solarized colored output |

**Step 3: Test on remote (if available)**

```bash
ssh your-remote-server
tmux new-session   # should default to Solarized Dark
nvim               # should open with Solarized Dark
```

**Step 4: Final commit if any adjustments made**

```bash
git add -p
git commit -m "chore: theme verification adjustments"
```

---

## Work Machine Setup Notes

See `docs/plans/2026-03-07-design.md` §3 for the full inventory + reconciliation process.

Quick reference for pulling in work machine drift:

```bash
# On work machine — before applying dotfiles:
cat ~/.claude/settings.json          # capture work MCP servers
cat ~/.config/zsh/local.zsh 2>/dev/null  # any work shell config
cat ~/.gitconfig.local 2>/dev/null   # work git identity

# Apply dotfiles
chezmoi init --apply https://github.com/adamcooper/dotfiles.git
chezmoi edit-config   # set role = "work"

# Install 1Password CLI
brew install 1password-cli
op signin                            # authenticate with 1Password

# Re-apply with secrets
chezmoi apply

# Work-local shell additions (not committed)
$EDITOR ~/.config/zsh/local.zsh
```
