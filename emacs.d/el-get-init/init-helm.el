
;; helm kill ring
(global-set-key "\M-y" 'helm-show-kill-ring)

;; helm buffer list
(global-set-key (kbd "C-x b") 'helm-buffers-list)

;; Jump to a definition in the current file. (This is awesome)
(global-set-key (kbd "C-x C-i") 'helm-imenu)

;; Find files binding
(global-set-key (kbd "C-x C-f") 'helm-find-files)

(require 'helm-match-plugin)

(define-minor-mode ido-helm-mode
  "Advices for ido-mode."
  nil nil nil :global t
  (if ido-helm-mode
      (progn
        (ad-enable-regexp "^ido-hacks-")
        (global-set-key (kbd "M-x") 'helm-M-x))
    (global-set-key (kbd "M-x") 'execute-extended-command)
    (ad-disable-regexp "^ido-hacks-"))
  (ad-activate-regexp "^ido-hacks-"))

(ido-helm-mode)

(custom-set-variables
 '(helm-ff-tramp-not-fancy t)
 '(helm-ff-skip-boring-files t)
 '(helm-boring-file-regexp-list
   '("\\.git$" "\\.hg$" "\\.svn$" "\\.CVS$" "\\._darcs$" "\\.la$" "\\.o$" "~$"
    "\\.so$" "\\.a$" "\\.elc$" "\\.fas$" "\\.fasl$" "\\.pyc$" "\\.pyo$"))
 '(helm-boring-buffer-regexp-list
   '("\\` " "\\*helm" "\\*helm-mode" "\\*Echo Area" "\\*tramp" "\\*Minibuf" "\\*epc")))

(eval-after-load 'helm-apt
  '(progn
     (require 'apt-utils)
     (defalias 'helm-apt-cache-show
       (lambda (package)
         (apt-utils-show-package-1 package t nil)))))
