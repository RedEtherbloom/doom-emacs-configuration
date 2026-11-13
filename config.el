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
(setq doom-font (font-spec :family "FiraCode Nerd Font" :size 14)
     doom-variable-pitch-font (font-spec :family "Fira Sans" :size 14))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
(setq doom-theme 'doom-rouge)
(setq doom-rouge-comment-bg t)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/SyncThing/Org")


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

;; User section
;; Avoid weirdness with scripts
(setq shell-file-name (executable-find "bash"))
;; Use my own shell for terminals
(setq-default vterm-shell "/run/current-system/sw/bin/fish")
(setq-default explicit-shell-file-name "/run/current-system/sw/bin/fish")

;; TODO: Gets overwritten by others, sigh
(setq-default tab-width 2)
(setq-default indent-tabs-mode 's)

;; TODO: Hooks don't get triggerd
;; (setq-hook! 'rustic-mode-hook lsp-inlay-hints-enable true)
(add-hook! 'rustic-mode-hook (setq lsp-inlay-hints-enable t))
;; Hope this doesn't override companys hook
(add-hook! '(nix-mode-hook nix-mode-ts-hook) :append (setq lsp-nix-nil-formatter ["alejandra"] lsp-nix-nixd-formatting-command ["alejandra"] lsp-nix-nixd-nixos-options-expr "(builtins.getFlake \"/home/inf/Projects/nix0s-config\").nixosConfigurations.neurodrive.options"))
(use-package! calibredb
  :commands calibredb calibredb-list calibredb-find-file calibredb-find-helm
  :config
  (setq calibredb-root-dir "~/Documents/Calibre Library"))

(use-package! hass
  :init
)
(setq hass-host "100.108.50.97")
(setq hass-port 8123)
(setq hass-insecure t)
(setq hass-apikey (lambda () (f-read-text "~/.config/sops-nix/secrets/hass_cli_token")))
(setq projectile-project-search-path '("~/Projects/" "~/Documents/" "~/code/" "~/Desktop/"))

(use-package! piper-tts
  :config
  (piper-tts-define-profile tts-piper-libritts_r "Libritts R" "piper --sentence-silence 0.5 --noise-w-scale 0.6 --noise-scale 0.6 --length_scale 1.4 -s 355 --model ~/.local/state/piper/en_US-libritts_r-medium.onnx" "22050" "LibriTTS-R")
  (setq piper-tts-player-args-format "-nodisp -autoexit -f s16le -ar %s -af \"highpass=f=40,lowpass=f=15000\" -") ;; Taken to remove missing -ac option
  (setq piper-tts-default-profile 'tts-piper-libritts_r)
  )
;; (("t" "Personal todo" entry (file+headline +org-capture-todo-file "Inbox") "* [ ] %?
;; %i
;; %a" :prepend t) ("n" "Personal notes" entry (file+headline +org-capture-notes-file "Inbox") "* %u %?
;; %i
;; %a" :prepend t) ("j" "Journal" entry (file+olp+datetree +org-capture-journal-file) "* %U %?
;; %i
;; %a" :prepend t) ("p" "Templates for projects") ("pt" "Project-local todo" entry (file+headline +org-capture-project-todo-file "Inbox") "* TODO %?
;; %i
;; %a" :prepend t) ("pn" "Project-local notes" entry (file+headline +org-capture-project-notes-file "Inbox") "* %U %?
;; %i
;; %a" :prepend t) ("pc" "Project-local changelog" entry (file+headline +org-capture-project-changelog-file "Unreleased") "* %U %?
;; %i
;; %a" :prepend t) ("o" "Centralized templates for projects") ("ot" "Project todo" entry #'+org-capture-central-project-todo-file "* TODO %?
;;  %i
;;  %a" :heading "Tasks" :prepend nil) ("on" "Project notes" entry #'+org-capture-central-project-notes-file "* %U %?
;;  %i
;;  %a" :heading "Notes" :prepend t) ("oc" "Project changelog" entry #'+org-capture-central-project-changelog-file "* %U %?
;;  %i
;;  %a" :heading "Changelog" :prepend t))
;; Eval expresssion is under M-: by default, M-S-; in our case of Colemak
;; Pasting of eval-expression should be under SPC-u M-S-; iirc
