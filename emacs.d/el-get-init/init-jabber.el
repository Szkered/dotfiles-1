
(setq jabber-show-resources nil)
(setq jabber-alert-presence-hooks nil)
(setq jabber-history-enable-rotation t)
(setq jabber-history-enabled t)
(setq jabber-roster-line-format " %c %-25n %u %-8s  %S")
(setq jabber-roster-show-bindings nil)

(load "~/.jabberel")

(add-hook 'jabber-chat-mode-hook 'enable-editing-modes)