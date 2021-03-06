; TRAMP
(setq password-cache-expiry 1000)
(setq tramp-default-method "rsync")
(set-default 'tramp-default-proxies-alist '())
(add-to-list 'tramp-default-proxies-alist
             '((regexp-quote (system-name)) nil nil))
(add-to-list 'tramp-default-proxies-alist
             '((regexp-quote "localhost") nil nil))
(add-to-list 'tramp-default-proxies-alist
             '(".*home" "\\`root\\'" "/ssh:%h:"))

;; Sudo
(defun sudo-edit-current-file ()
  (interactive)
  (let ((position (point)))
    (find-alternate-file
     (if (file-remote-p (buffer-file-name))
         (let ((vec (tramp-dissect-file-name (buffer-file-name))))
           (tramp-make-tramp-file-name
            "sudo"
            (tramp-file-name-user vec)
            (tramp-file-name-host vec)
            (tramp-file-name-localname vec)))
       (concat "/sudo:root@localhost:" (buffer-file-name))))
    (goto-char position)))

(require 'tramp)
