# Git Pre-Commit Hook for NixOS/Homemanager Configs

## Overview
This document outlines the steps to create and configure a pre-commit hook that ensures all NixOS and Home Manager configuration files are properly formatted using `treefmt` (and subsequently `nix fmt`). The goal is to maintain code quality and consistency before commits are made.

## Steps to Implement

1. **Create the Hook Script**
   - Navigate to the `.git/hooks` directory within your project root:
     ```bash
     cd .git/hooks
     ```
   - Create a new file named `pre-commit` (no extension):
     ```bash
     touch pre-commit
     ```
   - Open the file in your preferred editor and add the following content:
     ```bash
     #!/bin/bash
     # Strict pre-commit hook for NixOS/Homemanager configurations
     # Ensures all .nix files are properly formatted using treefmt/nix fmt
     
     # Run treefmt on all .nix files
     if ! treefmt --check; then
         echo "❌ Formatting issues detected! Run: treefmt to fix them."
         exit 1
     fi
     
     # Optionally, you can also run nix fmt here if you want a stricter check
     # nix fmt --check
     echo "✅ Formatting checks passed"
     ```
   - Make the script executable:
     ```bash
     chmod +x pre-commit
     ```

2. **Update .gitignore (if needed)**
   - Ensure the generated hook file isn't accidentally committed:
     ```bash
     echo ".git/hooks/pre-commit" >> .gitignore
     ```

3. **Document the Hook Setup**
   - In `CONTRIBUTING.md`, add a section titled *Git Pre-Commit Hook*:
     ```markdown
     ### Git Pre-Commit Hook
     
     To ensure all configuration files are formatted correctly, a pre-commit hook is provided in the repository. This hook runs `treefmt` (treefmt-nix) on all `.nix` files in the repository. Before committing, the hook will:
     
     1. Run `treefmt --check` to verify formatting correctness.
     2. If formatting is needed, it will output instructions to run `treefmt`.
     3. If formatting issues are found, the commit will be aborted.
     
     To enable this hook, ensure the `pre-commit` script is present in `.git/hooks/` and is executable (`chmod +x .git/hooks/pre-commit`). The script should be included in the repository, as shown above.
     
     ## Verification
     
     After committing the hook file, run `git commit -m "initial commit"` to test:
     
     - No changes should be required if all formatting is correct.
     - If formatting is needed, `treefmt` will output instructions.
     ```
     
     This documentation ensures contributors understand how to use the hook and what to do when formatting issues are detected.
     
     ## Resources
     
     - [treefmt-nix Documentation](https://github.com/numtide/treefmt-nix)
     - [Nixfmt Documentation](https://nixos.org/manual/nix/stable/language/commands.html#nix-fmt)
     
     By following these steps, contributors can maintain consistent formatting across the repository, reducing merge conflicts and improving code readability.
     "}}