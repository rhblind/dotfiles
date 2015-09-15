; Inspired by https://github.com/Gonzih/.emacs.d

; Add some load paths
(add-to-list 'load-path "~/.emacs.d/evil-config")

(require 'package)
    (push '("marmalade" . "http://marmalade-repo.org/packages/")
	  package-archives)
    (push '("melpa" . "http://melpa.milkbox.net/packages/")
	  package-archives)
(package-initialize)

(defun require-package (package)
  (setq-default highlight-tabs t)
  "Install given package."
  (unless (package-installed-p package)
    (unless (assoc package package-archive-contents)
      (package-refresh-contents))
    (package-install package)))

;(require-package 'alect-themes)
(require-package 'airline-themes)
(require-package 'autopair)
(require-package 'evil)
(require-package 'evil-leader)
(require-package 'evil-tabs)
;(require-package 'paredit)
;(require-package 'evil-paredit)
(require-package 'helm)
(require-package 'powerline-evil)
;(require-package 'rainbow-delimiters)
;(require-package 'color-theme-approximate)
;(require-package 'gruvbox-theme)
;(require-package 'evil-nerd-commenter)
;(require-package 'projectile)
;(require-package 'helm-projectile)
;(require-package 'helm-ag)
;(require-package 'web-mode)
;(require-package 'git-gutter+)
;(require-package 'fringe-helper)
;(require-package 'git-gutter-fringe+)

;(require 'alect-themes)
(require 'airline-themes)
(require 'autopair)
(require 'evil)
(require 'evil-leader)
(require 'evil-tabs)
(require 'powerline)

(evil-mode 1)
(helm-mode 1)

(setq custom-safe-themes t)         ; Mark all custom themes safe
(load-theme 'airline-papercolor)

; Change colors based on mode
;(setq evil-emacs-state-cursor '("red" box))
;(setq evil-normal-state-cursor '("green" box))
;(setq evil-visual-state-cursor '("orange" box))
;(setq evil-insert-state-cursor '("red" bar))
;(setq evil-replace-state-cursor '("red" bar))
;(setq evil-operator-state-cursor '("red" hollow))

(setq evil-motion-state-modes (append evil-emacs-state-modes evil-motion-state-modes))
(setq evil-emacs-state-modes nil)

(autopair-global-mode)              ; Enable global autopair mode
(global-evil-tabs-mode t)           ; Enable global evil tabs mode
(setq evil-leader/in-all-states 1)  ; Make the evil <leader> key work in all modes
(global-evil-leader-mode)           ; Global Evil <leader> key
(evil-leader/set-leader ",")        ; Remap the <leader> key to ","
(powerline-center-evil-theme)       ; Powerline theme
(airline-theme-base16-dark-gui)

(setq-default tab-width 4 indent-tabs-mode nil)            ; Use 4 spaces for tab
(setq-default c-basic-offset 4 c-default-style "bsd")      ; Use BSD style tabbing with 4 spaces
(setq make-backup-files nil)                               ; I don't like backup files
(setq evil-move-cursor-back nil)                           ; Don't move the cursor back when exiting edit mode
(define-key global-map (kbd "RET") 'newline-and-indent)    ; Enable auto-indenting

(tool-bar-mode -1)                  ; Disable the Toolbar
(scroll-bar-mode -1)                ; Disable the Scrollbars
(setq scroll-margin 5               ; Smoother scrolling
      scroll-conservatively 9999
      scroll-step 1)



