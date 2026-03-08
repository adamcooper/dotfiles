# Dotfiles Workflow

## Daily mental model

chezmoi is the source of truth. It pushes from `~/.dotfiles` → your home directory.
Changes made directly in `~` don't automatically flow back. You have to bring them back explicitly.

---

## Common scenarios

### Pull updates from another machine
```bash
dotfiles-sync
# expands to: cd ~/.dotfiles && git pull && chezmoi apply
```

### Check what's drifted (what chezmoi would change if you applied)
```bash
chezmoi diff
```

### See which files chezmoi manages
```bash
chezmoi managed
```

---

## Changing a config file

### "I want to edit a dotfile"
Always edit the source, not `~`:
```bash
chezmoi edit ~/.zshrc        # opens source file in $EDITOR
chezmoi apply ~/.zshrc       # applies the change
```

### "I edited a file in ~ directly and want to keep it"
Depends on whether chezmoi manages it as a plain file or a template.

**Plain file** (e.g. `.gitconfig`):
```bash
chezmoi re-add ~/.gitconfig  # pulls ~ back into source
cd ~/.dotfiles && git diff   # review
git add -p && git commit
```

**Template file** (e.g. `.zshrc`): you can't re-add a template automatically.
Open the source and make the change there:
```bash
chezmoi edit ~/.zshrc
```

**Modify script** (e.g. `.claude/settings.json`): the script only manages specific
keys. Everything else in the file is already preserved automatically. If you want
to promote a new key into the managed set, edit the script:
```bash
chezmoi edit ~/.claude/settings.json  # opens the modify script
chezmoi apply                         # verify it merges correctly
```

---

## Adding a new file to chezmoi
```bash
chezmoi add ~/.config/some/file   # imports into source
chezmoi edit ~/.config/some/file  # edit if needed
cd ~/.dotfiles && git add -p && git commit
```

---

## Setting up a new machine
```bash
brew install chezmoi
chezmoi init --apply https://github.com/adamcooper/dotfiles.git
chezmoi edit-config          # set role = "personal" | "work" | "remote"
chezmoi apply
```

---

## After setup on a work machine
Work-specific config goes in files chezmoi doesn't manage — changes there survive `chezmoi apply`:

| What | Where |
|------|-------|
| Shell aliases, env vars, work tools | `~/.config/zsh/local.zsh` |
| Work git identity | `~/.gitconfig.local` (add `[user]` block) |
| Work MCP servers | Add to `.claude/settings.json` directly — the modify script preserves them |

---

## Committing changes
```bash
cd ~/.dotfiles
git add -p          # review what you're committing
git commit -m "..."
git push
```

Or use the alias:
```bash
dotfiles-commit "your message"
```
