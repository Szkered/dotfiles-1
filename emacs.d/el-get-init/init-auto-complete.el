(require 'auto-complete)
(add-to-list 'ac-dictionary-directories (expand-file-name "dict" pdir))
(require 'auto-complete-config)
(ac-config-default)

;; custom keybindings to use tab, enter and up and down arrows
(define-key ac-complete-mode-map "\t" 'ac-expand)
(define-key ac-complete-mode-map "\r" 'ac-complete)
(define-key ac-complete-mode-map "\M-n" 'ac-next)
(define-key ac-complete-mode-map "\M-p" 'ac-previous)

;; Live completion with auto-complete
;; (see http://cx4a.org/software/auto-complete/)
(require 'auto-complete-config nil t)
;; Do What I Mean mode
(setq ac-dwim t)
