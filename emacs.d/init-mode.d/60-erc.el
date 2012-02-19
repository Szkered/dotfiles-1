;; ERC
(load "~/.ercpass")

(require 'erc-services)
(erc-services-mode 1)

(setq erc-max-buffer-size 30000)
(add-hook 'erc-mode-hook
	  '(lambda ()
	     (erc-truncate-mode t)))

(setq erc-modules (quote (autojoin button completion fill irccontrols list match menu move-to-prompt netsplit networks noncommands readonly ring services stamp spelling track highlight-nicknames)))
(setq erc-prompt-for-nickserv-password nil)
(setq erc-nickserv-identify-mode 'autodetect)
(defun start-irc ()
  "Connect to IRC."
  (interactive)
  (erc-tls :server "irc.oftc.net" :port 6697
	   :nick "arrsim" :full-name "Russell Sim"
	   :password oftc-pass)
  (erc-tls :server "irc.freenode.net" :port 6697
	   :nick "arrsim" :full-name "Russell Sim"
	   :password freenode-pass)
  (setq erc-autojoin-channels-alist
	'(("freenode.net" "#emacs" "#python"
	   "#twisted" "#twisted.web" "#pylons"
	   "#pyramid" "#openstack" "#lisp" "#lispcafe")
	  ("oftc.net" "#debian" "#debian-mentors"
	   "#debian-python" "#debian-gname"))))

(setq erc-autojoin-channels-alist '())
