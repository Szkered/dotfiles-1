;; el-get
(if (file-exists-p "~/.emacs.d/el-get/el-get")
    (add-to-list 'load-path "~/.emacs.d/el-get/el-get"))
(unless (require 'el-get nil t)
  (url-retrieve
   "https://github.com/dimitri/el-get/raw/master/el-get-install.el"
   (lambda (s)
     (end-of-buffer)
     (eval-print-last-sexp))))

(require 'package)
(add-to-list 'package-archives
             '("marmalade" .
               "http://marmalade-repo.org/packages/"))
(package-initialize)

;; el-get configuration
(add-to-list 'load-path "~/.emacs.d/el-get/el-get")
(require 'el-get)
(setq el-get-verbose t)
(setq el-get-user-package-directory "~/.emacs.d/el-get-init/")
(setq el-get-sources

      '((:name magit
               :website "https://github.com/magit/magit#readme"
               :description "It's Magit! An Emacs mode for Git."
               :type github
               :pkgname "magit/magit"
               :info "."
               :build (("make" "all"))
               :after (progn (global-set-key (kbd "C-x C-z") 'magit-status))
               :build/darwin `(,(concat "make EMACS=" el-get-emacs " all")))

        (:name git-modes
               :type github
               :pkgname "magit/git-modes"
               :features (git-commit-mode git-rebase-mode gitconfig-mode gitignore-mode))

        (:name diff-hl
               :type git
               :url "git://github.com/dgutov/diff-hl.git"
               :features diff-hl)

        (:name auto-complete
               :website "http://cx4a.org/software/auto-complete/"
               :description "The most intelligent auto-completion extension."
               :type git
               :depends (fuzzy popup)
               :url "git://github.com/auto-complete/auto-complete.git"
               :load-path ".")

        (:name fuzzy
               :type git
               :url "https://github.com/auto-complete/fuzzy-el"
               :features fuzzy)

        (:name bash-completion
               :type git
               :url "https://github.com/szermatt/emacs-bash-completion.git"
               :features bash-completion
               :post-init (progn
                            (bash-completion-setup)))

        (:name peek-mode
               :type github
               :pkgname "erikriverson/peek-mode"
               :depends (elnode))

        (:name elnode
               :website "http://emacswiki.org/wiki/Elnode"
               :description "Asynchronous HttpServer framework."
               :type github
               :depends (fakir emacs-noflet kv web db s)
               :pkgname "nicferrier/elnode")

        (:name fakir
               :type github
               :depends (dash emacs-noflet)
               :pkgname "nicferrier/emacs-fakir")

        (:name emacs-noflet
               :type github
               :feature noflet
               :pkgname "nicferrier/emacs-noflet")

        (:name kv
               :type github
               :pkgname "nicferrier/emacs-kv")

        (:name web
               :type github
               :pkgname "nicferrier/emacs-web")

        (:name db
               :type github
               :pkgname "nicferrier/emacs-db")

        (:name request
               :type github
               :submodule nil
               :pkgname "tkf/emacs-request")

        (:name gerrit-download
               :type github
               :pkgname "chmouel/gerrit-download.el")

        (:name autopair
               :website "http://code.google.com/p/autopair/"
               :description "Autopair is an extension to the Emacs text editor that automatically pairs braces and quotes."
               :type http
               :url "http://autopair.googlecode.com/svn/trunk/autopair.el"
               :features autopair
               :after (progn
                        (setq autopair-blink t)))

        (:name django-mode
               :type git
               :url "https://github.com/myfreeweb/django-mode.git")

        (:name pydoc-info
               :type hg
               :url "http://bitbucket.org/jonwaltman/pydoc-info/"
               :feature pydoc-info)

        (:name python
               :type git
               :url "git://github.com/fgallina/python.el.git"
               :features (python))

        (:name ipython
               :depends (python-mode))

        (:name helm
               :type git
               :url "git://github.com/emacs-helm/helm.git"
               :depends (ido-hacks)
               :features (helm))

        (:name emms
               :description "The Emacs Multimedia System"
               :type git
               :url "http://git.sv.gnu.org/r/emms.git"
               :info "doc"
               :load-path ("./lisp")
               :features emms-setup
               :build `(,(format "mkdir -p %s/emms " user-emacs-directory)
                        ,(concat "make EMACS=" el-get-emacs
                                 " SITEFLAG=\"--no-site-file -L " el-get-dir "/emacs-w3m/ \""
                                 " autoloads lisp docs"))
               :depends emacs-w3m)

        (:name ampc
               :type git
               :url "http://ch.ristopher.com/r/ampc")

        (:name yasnippet
               :website "http://code.google.com/p/yasnippet/"
               :description "YASnippet is a template system for Emacs."
               :type git
               :url "https://github.com/capitaomorte/yasnippet.git"
               :features "yasnippet"
               :prepare (progn
                          ;; Set up the default snippets directory
                          ;;
                          ;; Principle: don't override any user settings
                          ;; for yas/snippet-dirs, whether those were made
                          ;; with setq or customize.  If the user doesn't
                          ;; want the default snippets, she shouldn't get
                          ;; them!
                          (unless (or (boundp 'yas/snippet-dirs) (get 'yas/snippet-dirs 'customized-value))
                            (setq yas/snippet-dirs
                                  (list (concat el-get-dir (file-name-as-directory "yasnippet") "snippets")))))

               :post-init (progn
                            ;; Trick customize into believing the standard
                            ;; value includes the default snippets.
                            ;; yasnippet would probably do this itself,
                            ;; except that it doesn't include an
                            ;; installation procedure that sets up the
                            ;; snippets directory, and thus doesn't know
                            ;; where those snippets will be installed.  See
                            ;; http://code.google.com/p/yasnippet/issues/detail?id=179
                            (put 'yas/snippet-dirs 'standard-value
                                 ;; as cus-edit.el specifies, "a cons-cell
                                 ;; whose car evaluates to the standard
                                 ;; value"
                                 (list (list 'quote
                                             (list (concat el-get-dir (file-name-as-directory "yasnippet") "snippets")))))
                            (yas/reload-all)
                            ;; (yas/global-mode 1)
                            )
               ;; byte-compile load vc-svn and that fails
               ;; see https://github.com/dimitri/el-get/issues/200
               :compile nil)

        (:name highlight-indentation
               :features highlight-indentation
               :type git
               :url "https://github.com/antonj/Highlight-Indentation-for-Emacs")

        (:name nginx-mode
               :features nginx-mode
               :type git
               :url "git://github.com/ajc/nginx-mode.git")

        (:name eproject
               :features (eproject eproject-extras)
               :type git
               :url "https://github.com/jrockway/eproject")

        (:name expand-region
               :features expand-region
               :type git
               :url "git://github.com/magnars/expand-region.el.git"
               :post-init (progn
                            (global-set-key (kbd "C-@") 'er/expand-region)))

        (:name flymake-python
               :type git
               :url "git@github.com:russell/flymake-python.git")

        (:name pycheckers
               :type hg
               :url "https://bitbucket.org/jek/sandbox")

        (:name ctable
               :description "Table Component for elisp"
               :type github
               :pkgname "kiwanami/emacs-ctable")

        (:name epc
               :description "An RPC stack for Emacs Lisp"
               :type github
               :pkgname "kiwanami/emacs-epc"
               :depends (deferred ctable)) ; concurrent is in deferred package

        (:name jedi
               :description "An awesome Python auto-completion for Emacs"
               :type github
               :pkgname "tkf/emacs-jedi"
               :build (("make" "requirements"))
               :depends (epc auto-complete))

        (:name po-mode
               :type http
               :url "http://cvs.savannah.gnu.org/viewvc/*checkout*/gettext/gettext/gettext-tools/misc/po-mode.el"
               :features po-mode)

        (:name po-mode+
               :type emacswiki
               :features po-mode+
               :depends po-mode
               :post-init (progn
                            (autoload 'po-mode "po-mode+"
                              "Major mode for translators to edit PO files" t)
                            ))

        (:name dash
               :description "A modern list api for Emacs. No 'cl required."
               :type github
               :pkgname "magnars/dash.el")

        (:name s
               :description "Emacs string manipulation."
               :type github
               :pkgname "magnars/s.el")

        (:name smartparens
               :description "Autoinsert pairs of defined brackets and wrap regions"
               :type github
               :pkgname "Fuco1/smartparens"
               :depends (dash))

        (:name sql-indent
               :type http
               :url "http://www.emacswiki.org/emacs/download/sql-indent.el"
               :features sql-indent)

        (:name idomenu
               :type emacswiki
               :features idomenu)

        (:name mysql
               :type emacswiki
               :features mysql)

        (:name sql-completion
               :type emacswiki
               :depends mysql
               :features sql-completion
               :post-init (progn
                            (add-hook 'sql-interactive-mode-hook
                                      '(progn
                                         (define-key sql-interactive-mode-map "\t" 'comint-dynamic-complete)
                                         (sql-mysql-completion-init)))))

        (:name dirvars
               :features dirvars
               :type emacswiki)

        (:name ctags-update
               :features ctags-update
               :type git
               :url "https://github.com/jixiuf/helm-etags-plus")

        (:name multiple-cursors
               :features multiple-cursors
               :depends (mark-multiple)
               :type git
               :url "git://github.com/magnars/multiple-cursors.el.git")

        (:name mark-multiple
               :features mark-multiple
               :type git
               :url "git://github.com/magnars/mark-multiple.el.git")

        (:name sticky-windows
               :features sticky-windows
               :type emacswiki
               :post-init (progn
                            (global-set-key [(control x) (?0)] 'sticky-window-delete-window)
                            (global-set-key [(control x) (?1)] 'sticky-window-delete-other-windows)
                            ;; In addition,
                            ;; `sticky-window-keep-window-visible'
                            ;; might be bound to the currently unused
                            ;; C-x 9 key binding:
                            (global-set-key [(control x) (?9)] 'sticky-window-keep-window-visible)))

        (:name popup
               :type git
               :url "git://github.com/auto-complete/popup-el.git")

        (:name popup-kill-ring
               :type emacswiki
               :depends (popup pos-tip)
               :features popup-kill-ring
               :post-init (progn
                            (require 'popup)
                            (global-set-key "\M-y" 'popup-kill-ring)))

        (:name active-menu
               :website "http://www.emacswiki.org/emacs/ActiveMenu"
               :description "Active Menu toggles the display of the menu bar automatically when the mouse comes close to it. Otherwise you get one more line of code."
               :type git
               :url "https://github.com/emacsmirror/active-menu.git"
               :features "active-menu")

        (:name scad-mode
               :description ""
               :type http
               :url "https://raw.github.com/openscad/openscad/master/contrib/scad-mode.el"
               :features scad)

        (:name json
               :description "JavaScript Object Notation parser / generator"
               :type http
               :url "http://cvs.savannah.gnu.org/viewvc/*checkout*/emacs/lisp/json.el?root=emacs"
               :features json)

        (:name jss
               :description "Mode for developing in browser JavaScript."
               :type github
               :pkgname "segv/jss")

        (:name fill-column-indicator
               :type git
               :url "https://github.com/alpaker/Fill-Column-Indicator.git"
               :features "fill-column-indicator")

        (:name artbollocks-mode
               :type git
               :url "git://gitorious.org/robmyers/scripts.git"
               :features "artbollocks-mode")

        (:name ldap-mode
               :type http
               :features "ldap-mode"
               :url "http://www.loveshack.ukfsn.org/emacs/ldap-mode.el")

        (:name gnus-identities
               :description "Change identity when composing a message."
               :features "gnus-identities"
               :type github
               :pkgname "renard/gnus-identities")

        (:name elscreen
               :type http-tar
               :features elscreen
               :options ("xzf")
               :url "ftp://ftp.morishima.net/pub/morishima.net/naoto/ElScreen/elscreen-1.4.6.tar.gz")

        (:name js2-mode
               :type git
               :description "An improved JavaScript editing mode"
               :url "https://github.com/mooz/js2-mode.git"
               :post-init (progn
                            (autoload 'js2-mode "js2-mode" nil t)))

        (:name flymake-node-jshint
               :type git
               :description "Emacs library providing simple
               flymake for JavaScript using JSHint through
               node-jshint."
               :url "git://github.com/jegbjerg/flymake-node-jshint.git"
               :post-init (progn
                            (require 'flymake-node-jshint)
                            (add-hook 'js-mode-hook (lambda () (flymake-mode 1)))))

        (:name hideshow-org
               :features hideshow-org
               :type git
               :url "https://github.com/secelis/hideshow-org.git")

        (:name workgroups
               :description "Workgroups for windows (for Emacs)"
               :type git
               :url "https://github.com/tlh/workgroups.el.git"
               :features "workgroups"
               :post-init (progn
                            (workgroups-mode 1)))
        (:name bbdb
               :website "http://bbdb.sourceforge.net/"
               :description "The Insidious Big Brother Database (BBDB) is a contact management utility."
               :type git
               :url "git://git.savannah.nongnu.org/bbdb.git"
               :load-path ("./lisp")
               ;; if using vm, add `--with-vm-dir=DIR' after ./configure
               :build `("autoreconf --force --install"
                        ,(concat "./configure --with-emacs=" el-get-emacs)
                        "make clean" "rm -f lisp/bbdb-autoloads.el"
                        "make")
               :features bbdb-loaddefs
               :autoloads nil
               :post-init (bbdb-initialize))

        (:name smart-operator
               :type http
               :url "https://xwl.appspot.com/ref/smart-operator.el"
               :description "Beautify the operators in codes")

        (:name oauth2
               :type git
               :url "git://github.com/emacsmirror/oauth2.git")

        (:name google-contacts
               :features google-contacts
               :depends oauth2
               :type git
               :url "git://git.naquadah.org/google-contacts.el.git")

        (:name google-maps
               :description "Access Google Maps from Emacs"
               :type git
               :url "git://git.naquadah.org/google-maps.git"
               :features (google-maps org-location-google-maps))

        (:name highlight-sexp
               :features highlight-sexp
               :type git
               :url "git://github.com/daimrod/highlight-sexp.git")

        (:name bookmark+
               :features bookmark+
               :type git
               :url "git@github.com:russell/bookmark-plus.git")

        (:name recover-buffers
               :features recover-buffers
               :type darcs
               :url "http://porkmail.org/elisp/recover-buffers/")

        (:name slime
               :description "Superior Lisp Interaction Mode for Emacs"
               :type cvs
               :module "slime"
               :url ":pserver:anonymous:anonymous@common-lisp.net:/project/slime/cvsroot"
               :info "doc"
               :features slime
               :load-path ("." "contrib")
               :compile ("\\.el$")
               :build (list "make -C doc"))

        ;; (:name slime-proxy
        ;;        :description "Slime proxy mode for Emacs and parenscript"
        ;;        :type git
        ;;        :depends (slime)
        ;;        :features slime-proxy
        ;;        :url "git://github.com/3b/slime-proxy.git"
        ;;        :load-path ("." "contrib/slime-parenscript"))

        (:name slime-js
               :description "Slime JS"
               :type git
               :depends (slime)
               :features slime-js
               :url "git://github.com/swank-js/slime-js.git")

        (:name slime-fiveam
               :description "SLIME FiveAM."
               :type git
               :depends (slime)
               :url "git@github.com:russell/slime-fiveam.git"
               :features slime-fiveam)

        (:name hyperspec-info
               :description "info lookup for hyperspec"
               :type http
               :features hyperspec-info
               :url "http://www.pentaside.org/code/hyperspec-info.el")

        (:name gnuplot-mode
               :description "Drive gnuplot from within emacs"
               :type github
               :pkgname "bruceravel/gnuplot-mode"
               :build `("./configure"
                        ,(concat "make EMACS=" el-get-emacs " gnuplot.elc gnuplot-gui.elc"))
               :info "gnuplot.info")

        (:name org-import-icalendar
               :description "Provide org-mode calendar import."
               :type http
               :depends (org-mode)
               :features org-import-icalendar
               :build (("mv" "org-import-calendar.el" "org-import-icalendar.el"))
               :url "http://ozymandias.dk/emacs/org-import-calendar.el")

        (:name anything
               :website "http://www.emacswiki.org/emacs/Anything"
               :description "Open anything / QuickSilver-like candidate-selection framework"
               :type git
               :url "http://repo.or.cz/r/anything-config.git"
               :load-path ("." "extensions")
               :depends (cedet)
               :features anything
               :after (progn
                        (require 'anything-config)))

        (:name erc
               :description "A powerful, modular, and extensible Emacs InternetRelayChat client."
               :type git
               :url "git://git.sv.gnu.org/erc.git")

        (:name restclient-mode
               :type git
               :features restclient
               :url "git://github.com/pashky/restclient.el.git")

        (:name elisp-slime-nav
               :type git
               :features elisp-slime-nav
               :url "git://github.com/purcell/elisp-slime-nav.git")

        (:name elisp-slime-expand
               :type git
               :features elisp-slime-expand
               :url "git@github.com:russell/elisp-slime-expand.git")

        (:name openstack-mode
               :type git
               :features openstack-mode
               :depends (request)
               :url "git@github.com:russell/openstack-mode.git")

        (:name erc-nick-notify
               :type emacswiki
               :features erc-nick-notify)

        (:name pyel
               :type git
               :features pyel
               :url "git@github.com:russell/pyel.git")

        (:name ibuffer-vc
               :type git
               :features ibuffer-vc
               :url "git://github.com/purcell/ibuffer-vc.git")

        (:name ibuffer-tramp
               :type git
               :features ibuffer-tramp
               :url "git://github.com/svend/ibuffer-tramp.git")

        (:name jabber
               :type git
               :load-path ("." "compat")
               :build ("autoreconf -f -i -Wall,no-obsolete" "./configure" "make")
               :features jabber-autoloads
               :url "git://emacs-jabber.git.sourceforge.net/gitroot/emacs-jabber/emacs-jabber")

        (:name puppet-flymake
               :type git
               :features flymake-puppet
               :url "git://github.com/grimradical/puppet-flymake.git")

        (:name nognus
               :description "A newsreader for GNU Emacs"
               :type git
               :url "http://git.gnus.org/gnus.git"
               :build ("./configure" "make")
               :build/windows-nt `(,(concat "\"make.bat " invocation-directory "\""))
               :build/darwin `(,(concat "./configure --with-emacs=" el-get-emacs) "make")
               :info "texi"
               :load-path ("lisp")
               :autoloads nil
               :features gnus-load)

        (:name auto-capitalize
               :type emacswiki
               :website "http://www.emacswiki.org/emacs/auto-capitalize.el"
               :features auto-capitalize)

        (:name puppet-mode
               :description "A simple mode for editing puppet manifests"
               :type git
               :url "git://github.com/puppetlabs/puppet-syntax-emacs.git"
               :after (progn
                        (autoload 'puppet-mode "puppet-mode" "Major mode for editing puppet manifests" t)
                        (add-to-list 'auto-mode-alist '("\\.pp$" . puppet-mode))))

        (:name ido-hacks
               :description "Advices for ido-mode."
               :type github
               :pkgname "scottjad/ido-hacks"
               :features ido-hacks)

        (:name free-keys
               :description "Show free bindings."
               :type github
               :pkgname "Fuco1/free-keys"
               :features free-keys)

        (:name helm-descbinds
               :description "Helm frontend to describe key bindings."
               :type github
               :pkgname "emacs-helm/helm-descbinds"
               :depends (helm)
               :features helm-descbinds)

        (:name helm-slime
               :description "Helm frontend for slime"
               :type github
               :pkgname "emacs-helm/helm-slime"
               :depends (helm slime)
               :features helm-slime)

        (:name helm-swoop
               :description "Helm Swoop"
               :type github
               :pkgname "ShingoFukuyama/helm-swoop"
               :depends (helm)
               :features helm-swoop)

        (:name sql-preset
               :description "Store SQL connections configuration."
               :type github
               :pkgname "ieure/sql-preset-el"
               :features sql-preset)

        (:name apel
               :website "http://www.kanji.zinbun.kyoto-u.ac.jp/~tomo/elisp/APEL/"
               :description "APEL (A Portable Emacs Library) is a library to support to write portable Emacs Lisp programs."
               :type git
               :module "apel"
               :url "git://github.com/emacsmirror/apel.git"
               :build
               (mapcar
                (lambda (target)
                  (list el-get-emacs
                        (split-string "-batch -q -no-site-file -l APEL-MK -f")
                        target
                        "prefix" "site-lisp" "site-lisp"))
                '("compile-apel" "install-apel"))
               :load-path ("site-lisp/apel" "site-lisp/emu"))))


(setq my-packages
      (append
       '(
         ;; C
         cedet
         ctags-update
         xcscope

         ;; elisp
         elisp-slime-expand
         elisp-slime-nav

         ;; internet
         emacs-w3m
         nxhtml
         oauth2
         restclient-mode

         ;; javascript
         js-comint
         js2-mode
         json

         ;; python
         django-mode
         highlight-indentation
         jedi
         pycheckers
         pylookup
         rst-mode

         ;; latex
         auctex

         ;; common lisp
         helm-slime
         highlight-sexp
         hyperspec-info
         paredit
         redshank
         slime
         slime-fiveam

         ;; scheme
         geiser

         ;; sql
         sql-preset

         ;; puppet
         puppet-mode

         ;; org-mode
         org-mode

         ;; other modes
         ace-jump-mode
         android-mode
         apache-mode
         artbollocks-mode
         auto-capitalize
         csv-mode
         flycheck
         git-modes
         highlight-parentheses
         highlight-symbol
         markdown-mode
         nginx-mode
         openstack-mode
         po-mode
         wgrep
         rainbow-delimiters
         twittering-mode
         yaml-mode

         ;; gnus
         bbdb
         google-contacts
         mailcrypt
         gnus-identities
         nognus

         ;; ido
         ;; idomenu
         ido-hacks

         ;; erc
         erc
         erc-nick-notify

         ;; project tools
         dirvars
         eproject
         dizzee

         ;; shell
         bash-completion

         ;; editing tools
         smartparens
         bookmark+
         diff-hl
         expand-region
         lorem-ipsum
         magit
         mark-multiple
         multiple-cursors
         undo-tree
         yasnippet

         ;; other tools
         vkill

         ;; lookup libraries
         helm
         helm-descbinds
         helm-swoop

         ;; libraries
         dired+
         dired-plus
         el-get
         emacs-noflet
         eol-conversion
         recover-buffers
         )))

(el-get nil my-packages)
