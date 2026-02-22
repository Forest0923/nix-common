# AGENTS.md - Nix Configuration Repository

## Build & Test Commands

```bash
# Check flake syntax and validate all modules
nix flake check

# Build a specific module (e.g., tmux, neovim)
nix build .#homeConfigurations.<username>.activationPackage --print-build-logs

# Preview configuration without applying
nix run nix-direnv -- nix develop --command echo "test"

# Lint Nix code with nixpkgs-fmt
nix fmt

# Format all Nix files
nix fmt

# Test a specific home-manager configuration
home-manager -f modules/tmux/default.nix --dry-run
```

### Running Single Tests

```bash
# Validate module syntax only
nix-instantiate --parse modules/tmux/default.nix

# Evaluate a module with Nix REPL
nix repl
nix-repl> :l modules/tmux/default.nix
nix-repl> config.programs.tmux.enable
```

## Code Style Guidelines

### Nix Language Conventions

- **Imports**: Use `with pkgs; [ ... ]` for package lists, import modules with relative paths (`./module`)
- **Indentation**: 2 spaces (not tabs)
- **Comments**: Use `#` for single-line, `'' ... ''` for multi-line strings in config
- **Variable Naming**: Use kebab-case for files/dirs, snake_case for variables
- **String Interpolation**: Use `${variable}` syntax

### File Structure

```
modules/
  <toolname>/
    default.nix        # Main module (must exist)
    <optional>.nix     # Additional config files
    <script>.sh        # Shell scripts if needed
applications/
  <appname>/
    default.nix
devshells/
  <language>/
    flake.nix          # Dev shell flakes
```

### Module Format

```nix
{ config, pkgs, lib, ... }:
{
  programs.<tool> = {
    enable = true;
    
    plugins = with pkgs; [
      plugin1
      plugin2
    ];
    
    extraConfig = ''
      # Shell-like configuration
      key value
    '';
  };
}
```

### Configuration Best Practices

- **Plugin order**: Load themes first, then management plugins, then misc plugins
- **Key bindings**: Use `bind` prefix for tmux, `vim.keymap.set` for neovim
- **LSP configuration**: Use `vim.lsp.config('*', { ... })` with wildcard for global settings
- **Error handling**: Use `pkgs.mkShellNoCC` for dev shells without gcc

### Shell Scripts (bash/zsh)

- **Shebang**: `#!/usr/bin/env bash`
- **Strict mode**: `set -euo pipefail` at top of scripts
- **Functions**: Define before use, add help/usage messages
- **Conditional checks**: Use `command -v <cmd> &> /dev/null` for command existence

### Naming Conventions

- **Modules**: Lowercase, no spaces (`tmux`, `neovim`, `git`)
- **Variables**: snake_case (`initExtra`, `extraConfig`, `shellAliases`)
- **Aliases**: Short, memorable commands (`ls`, `la`, `ll` for eza; `cat` for bat)

### Type System

- Use `lib.mkOrder` for zsh initContent ordering
- Use `lib.mkMerge` to combine multiple config sections
- Use `builtins.readFile` to include external files
- Use `pkgs.mkShellNoCC` for pure development environments

## Formatting & Linting

```bash
# Format Nix files (nixpkgs-fmt)
nix fmt

# Check flake syntax
nix flake check --print-build-logs

# Validate individual modules
nix-instantiate --strict modules/<module>/default.nix
```

## Integration with Tools

### Home Manager Modules
- Located in `modules/<toolname>/default.nix`
- Import viaflake outputs: `./modules/tmux` or useHM module picker

### Development Shells
- Rust: Uses fenix for toolchain management
- Python: Uses venv with hash-based dependency caching
- Location: `devshells/<language>/flake.nix`

## Cursor/Copilot Rules

No specific rules file found. Follow Nix language server recommendations and maintain consistent formatting across all `.nix` files.
