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
(setq shell-file-name (executable-find "bash"))
(setq-default vterm-shell "/run/current-system/sw/bin/fish")
(setq-default explicit-shell-file-name "/run/current-system/sw/bin/fish")

;; TODO: Gets overwritten by others, sigh
(setq-default tab-width 2)
(setq-default indent-tabs-mode t)

(setq projectile-project-search-path '("~/Projects/" "~/Desktop/"))

(with-eval-after-load 'lsp-mode (setq lsp-inlay-hint-enable t))
;; TODO: Translate this to map!
;; (define-key evil-insert-state-map (kbd "TAB") 'tab-to-tab-stop)
;; TODO: Set indent-tabs-mode to nil. How do I force evil to also use spaces or tabs?
;; TODO: Translate this to with-eval-after-load I think
;; Hope this doesn't override companys hook
(with-eval-after-load 'lsp-nix
  (setq lsp-nix-nil-formatter ["alejandra"]
        lsp-nix-nixd-formatting-command ["alejandra"]
        lsp-nix-nixd-nixos-options-expr
        (format "(builtins.getFlake \"/home/%s/Projects/nix0s-config\").nixosConfigurations.%s.options"
                (user-login-name)
                (system-name))))
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
(setq projectile-project-search-path '("~/Projects/" "~/Desktop/"))

(use-package! piper-tts
  :config
  (piper-tts-define-profile tts-piper-libritts_r "Libritts R" "piper --sentence-silence 0.5 --noise-w-scale 0.6 --noise-scale 0.6 --length_scale 1.4 -s 355 --model ~/.local/state/piper/en_US-libritts_r-medium.onnx" "22050" "LibriTTS-R")
  ;; Taken to remove missing -ac option
  (setq piper-tts-player-args-format "-nodisp -autoexit -f s16le -ar %s -af \"highpass=f=40,lowpass=f=15000\" -"  piper-tts-default-profile 'tts-piper-libritts_r)
  )

(with-eval-after-load 'gptel
  (setq gptel-backend (gptel-make-openai
      "Astarion-LiteLLM"
    :stream t
    :protocol "http"
    :host "100.74.165.55:4000"
    :models '(
              (chatgpt-gpt-6
	       :capabilities (media tool-use json url responses-api)
	       :mime-types ("image/jpeg" "image/png" "image/gif" "image/webp")
	       :description "GPT-6 via astarion"
	       :context-window 272
	       )
              (chatgpt-gpt-6.1-sol
	       :capabilities (media tool-use json url responses-api)
	       :mime-types ("image/jpeg" "image/png" "image/gif" "image/webp")
	       :description "GPT-6.1-Sol. Flagship model. Expensive, but longer and deeper reasoning."
	       :context-window 272
	       :input-cost 5.0
	       :output-cost 30.0
	       )
              (chatgpt-gpt-6.1-terra
	       :capabilities (media tool-use json url responses-api)
	       :mime-types ("image/jpeg" "image/png" "image/gif" "image/webp")
	       :description "GPT-6.1-Terra. Balanced, good all-arounder. Okayish price"
	       :context-window 272
	       :input-cost 2.0
	       :output-cost 12.0
	       )
              (chatgpt-gpt-6.1-luna
	       :capabilities (media tool-use json url responses-api)
	       :mime-types ("image/jpeg" "image/png" "image/gif" "image/webp")
	       :description "GPT-6.1-Luna. Fast and affordable. Good for e.g. data entry tasks"
	       :context-window 272
	       :input-cost 0.2
	       :output-cost 1.2
	       )))
  gptel-model 'chatgpt-gpt-6.1-terra)
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
