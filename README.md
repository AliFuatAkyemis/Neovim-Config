# AliFuat's Neovim Configuration 🚀

A modular, high-performance, and aesthetically pleasing Neovim configuration tailored for **Java (Spring Boot)** and Lua development.

## ✨ Features

- **Modular Design**: Config is split into `options`, `keymaps`, and `plugins`.
- **Advanced Java Support**: 
  - Full LSP support via `nvim-jdtls`.
  - **Lombok** integration (automatic detection in `lib/` or global).
  - Debugger and Test integration via `nvim-dap`.
- **Modern UI**:
  - **Catppuccin** Mocha theme.
  - **Lualine** for a clean status line.
  - **Neo-tree** for file navigation.
  - **Telescope** for fuzzy finding.
- **Robust Indentation**: Fixed 8-space indentation as preferred for maximum readability in large projects.

---

## 📂 File Structure

```text
~/.config/nvim/
├── init.lua              # Entry point
├── ftplugin/
│   └── java.lua          # Java-specific LSP & DAP settings
└── lua/
    ├── config/
    │   ├── keymaps.lua   # Global keybindings
    │   ├── lazy.lua      # Plugin manager (Lazy.nvim)
    │   └── options.lua   # Vim options & aesthetics
    └── plugins/
        ├── java.lua      # Java plugin dependencies
        ├── mason.lua     # LSP/DAP/Linter installer
        └── ...           # Other UI & tool plugins
```

---

## ⌨️ Keymaps (Java Specific)

| Keymap | Action |
| :--- | :--- |
| `<leader>jo` | Organize Imports |
| `<leader>jc` | Extract Constant |
| `<leader>jv` | Extract Variable |
| `<leader>jt` | Test Class |
| `<leader>jT` | Test Nearest Method |
| `K` | Show Documentation (Hover) |
| `gd` | Go to Definition |

---

## 🛠️ Requirements

- **Neovim** >= 0.10.0
- **JDK 17 or 21** (Installed at `/usr/lib/jvm/java-21-openjdk`)
- **Maven/Gradle** for project management.
- **Lombok**: Project-specific `lib/lombok.jar` will be used if present, otherwise falls back to Mason global version.

---

## 🚀 Installation

1. Clone this repository to `~/.config/nvim`:
   ```bash
   git clone <your-repo-ui> ~/.config/nvim
   ```
2. Open Neovim:
   ```bash
   nvim
   ```
3. Lazy.nvim will automatically bootstrap and install all plugins.
4. Run `:Mason` to verify `jdtls`, `java-debug-adapter`, and `java-test` are installed.

---

## 🎨 Aesthetics

This configuration uses **Catppuccin Mocha** by default with customized cursor lines and list characters for a premium feel. 
Indentation is strictly set to **8 spaces**.

---
*Maintained with ❤️ by Ali Fuat.*
