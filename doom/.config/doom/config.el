;;(add-to-list 'load-path "/opt/homebrew/Library/Taps/larrasket/homebrew-emacs-liquid-glass/lisp")
;;(require 'lr-macos-glass)



;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
(setq doom-font (font-spec :family "Iosevka Nerd Font" :size 14 :weight 'semi-light)
      doom-variable-pitch-font (font-spec :family "Iosevka Nerd Font" :size 14))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;;(setq doom-theme 'doom-one)
(setq doom-theme 'catppuccin)
(setq catppuccin-flavor 'mocha)
;; Specify both a dark and light theme, like so and Doom will choose which one
;; to load based on your system light/dark setting:
;;
;;   (setq doom-theme '(doom-one   . doom-one-light))   ; (DARK . LIGHT)
;;
;; If you want more pro-active theme switching based on OS light/dark mode, look
;; up the `auto-dark' package.

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; CKAN remote debugging (debugpy listening on 127.0.0.1:5678)
(after! dape
  (defun +ckan-local (subdir)
    ;; Anchor to the directory containing docker-compose.dev.yml so the
    ;; mapping is correct regardless of `default-directory' at launch.
    (concat (or (locate-dominating-file default-directory
                                        "docker-compose.dev.yml")
                "~/IGP/datos_geofisicos/pnaig-docker-setup/")
            subdir "/"))

  (add-to-list 'dape-configs
               `(ckan-attach
                 modes (python-mode python-ts-mode)
                 host "127.0.0.1"
                 port 5678
                 :type "python"
                 :request "attach"
                 :justMyCode :json-false
                 :redirectOutput t
                 :pathMappings [(:localRoot (+ckan-local "src")
                                 :remoteRoot "/srv/app/src_extensions")
                                (:localRoot (+ckan-local "ckan-core-ro")
                                 :remoteRoot "/srv/app/src/ckan")])))

;; If you use `org' and don't want your org files in the def ault location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `with-eval-after-load' block, otherwise Doom's defaults may override your
;; settings. E.g.
;;
;;   (with-eval-after-load 'PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look them up).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
(add-hook 'window-setup-hook #'toggle-frame-maximized)


;;(after! projectile
;; (add-to-list 'projectile-project-root-files-bottom-up "Cargo.toml"))
(after! lsp-rust
  (setq lsp-rust-analyzer-cargo-watch-command "clippy"))
