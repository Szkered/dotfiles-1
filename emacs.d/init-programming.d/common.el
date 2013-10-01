(let ((lisp-modes '(slime-mode-hook
                    geiser-mode-hook
                    emacs-lisp-mode-hook))
      (c-like-modes '(python-mode-hook
                      c-mode-common-hook
                      puppet-mode-hook
                      sh-mode-hook
                      puppet-hook-mode
                      makefile-mode)))

  (mapc (lambda (mode)
          ;; diff hl mode
          (add-hook mode 'diff-hl-mode)

          ;; Delete whitespace on save.
          (add-hook mode
                    '(lambda ()
                       (add-hook 'write-contents-functions
                                 'delete-trailing-whitespace)))

          ;; flyspell
          (add-hook mode 'flyspell-prog-mode)
          (add-hook mode 'highlight-symbol-mode))

        (concatenate 'list lisp-modes c-like-modes))
  (mapc (lambda (mode)
          (add-hook mode '(lambda ()
                            (smartparens-mode)
                            (sp-use-paredit-bindings))))

        (concatenate 'list c-like-modes '(eshell-mode))))
