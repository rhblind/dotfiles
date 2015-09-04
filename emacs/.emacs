; Add marmalade and melpa repositories
(require 'package)
    (push '("marmalade" . "http://marmalade-repo.org/packages/")
	  package-archives)
    (push '("melpa" . "http://melpa.milkbox.net/packages/")
	  package-archives)
(package-initialize)

; Visual settings and usability
(require 'powerline)                ; Powerline for Emacs
(require 'powerline-evil)
(powerline-center-evil-theme)

(tool-bar-mode -1)                  ; Disable the Toolbar
(scroll-bar-mode -1)                ; Disable the Scrollbars
(setq scroll-margin 5               ; Smoother scrolling
      scroll-conservatively 9999
      scroll-step 1)

; Evil - Vim mode for Emacs
(require 'evil)
(evil-mode 1)

(setq evil-leader/in-all-states 1)  ; Make the evil <leader> key work in all modes
(global-evil-leader-mode)           ; Global Evil <leader> key
(evil-leader/set-leader ",")        ; Remap the <leader> key to ","

;(global-evil-tabs-mode t)           ; Use Evil tabs

(require 'evil-surround)            ; Surround plugin for Evil
(global-evil-surround-mode 1)




