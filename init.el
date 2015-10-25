;; -*- coding: utf-8 -*-


;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(setq emacs-load-start-time (current-time))
(add-to-list 'load-path (expand-file-name "~/.emacs.d/lisp"))

;;----------------------------------------------------------------------------
;; Which functionality to enable (use t or nil for true and false)
;;----------------------------------------------------------------------------
(setq *macbook-pro-support-enabled* t)
(setq *is-a-mac* (eq system-type 'darwin))
(setq *is-carbon-emacs* (and *is-a-mac* (eq window-system 'mac)))
(setq *is-cocoa-emacs* (and *is-a-mac* (eq window-system 'ns)))
(setq *win32* (eq system-type 'windows-nt) )
(setq *cygwin* (eq system-type 'cygwin) )
(setq *linux* (or (eq system-type 'gnu/linux) (eq system-type 'linux)) )
(setq *unix* (or *linux* (eq system-type 'usg-unix-v) (eq system-type 'berkeley-unix)) )
(setq *linux-x* (and window-system *linux*) )
(setq *xemacs* (featurep 'xemacs) )
(setq *emacs24* (and (not *xemacs*) (or (>= emacs-major-version 24))) )
(setq *no-memory* (cond
                   (*is-a-mac*
                    (< (string-to-number (nth 1 (split-string (shell-command-to-string "sysctl hw.physmem")))) 4000000000))
                   (*linux* nil)
                   (t nil)))

;;----------------------------------------------------------------------------
;; Less GC, more memory
;;----------------------------------------------------------------------------
(defun my-optimize-gc (NUM PER)
"By default Emacs will initiate GC every 0.76 MB allocated (gc-cons-threshold == 800000).
@see http://www.gnu.org/software/emacs/manual/html_node/elisp/Garbage-Collection.html
We increase this to 16MB by `(my-optimize-gc 16 0.5)` "
  (setq-default gc-cons-threshold (* 1024 1024 NUM)
                gc-cons-percentage PER))


(require 'init-modeline)
(require 'cl-lib)
(require 'init-compat)
(require 'init-utils)
(require 'init-site-lisp) ;; Must come before elpa, as it may provide package.el

;; win32 auto configuration, assuming that cygwin is installed at "c:/cygwin"
;; (condition-case nil
;;     (when *win32*
;;       ;; (setq cygwin-mount-cygwin-bin-directory "c:/cygwin/bin")
;;       (setq cygwin-mount-cygwin-bin-directory "c:/cygwin64/bin")
;;       (require 'setup-cygwin)
;;       ;; better to set HOME env in GUI
;;       ;; (setenv "HOME" "c:/cygwin/home/someuser")
;;       )
;;   (error
;;    (message "setup-cygwin failed, continue anyway")
;;    ))

(require 'idle-require)
(require 'init-elpa)
(require 'init-exec-path) ;; Set up $PATH
(require 'init-frame-hooks)
;; any file use flyspell should be initialized after init-spelling.el
;; actually, I don't know which major-mode use flyspell.
(require 'init-spelling)
(require 'init-xterm)
(require 'init-gui-frames)
(require 'init-ido)
(require 'init-dired)
(require 'init-uniquify)
(require 'init-ibuffer)
(require 'init-flymake)
(require 'init-smex)
(require 'init-helm)
(require 'init-hippie-expand)
(require 'init-windows)
;(require 'init-sessions)
(require 'init-git)
(require 'init-crontab)
(require 'init-markdown)
;(require 'init-erlang)
;(require 'init-javascript)
(require 'init-org-mime)
;(require 'init-css)
;(require 'init-python-mode)
;(require 'init-haskell)
;(require 'init-ruby-mode)
;(require 'init-lisp)
;(require 'init-elisp)
;(require 'init-yasnippet)
;; Use bookmark instead
(require 'init-zencoding-mode)
(require 'init-cc-mode)
(require 'init-gud)
(require 'init-linum-mode)
;; (require 'init-gist)
(require 'init-moz)
(require 'init-gtags)
;; use evil mode (vi key binding)
(require 'init-evil)
(require 'init-sh)
(require 'init-ctags)
(require 'init-bbdb)
(require 'init-gnus)
(require 'init-lua-mode)
(require 'init-workgroups2)
(require 'init-term-mode)
(require 'init-web-mode)
;(require 'init-slime)
(require 'init-clipboard)
(require 'init-company)
(require 'init-chinese-pyim) ;; cannot be idle-required
;; need statistics of keyfreq asap
(require 'init-keyfreq)
(require 'init-httpd)

;; projectile costs 7% startup time

;; misc has some crucial tools I need immediately
(require 'init-misc)
(require 'init-color-theme)
;(require 'init-emacs-w3m) ;no need of w3m in windows

;; {{ idle require other stuff
(setq idle-require-idle-delay 10)
(setq idle-require-symbols '(init-matlab
                             init-python-mode
                             init-misc-lazy
                             init-which-func
                             init-fonts
                             init-hs-minor-mode
                             init-stripe-buffer
                             init-textile
                             init-csv
                             init-writting
                             init-doxygen
                             init-pomodoro
                             init-emacspeak
                             init-artbollocks-mode
                             init-semantic
                             init-slime
                             init-keyfreq
                             init-haskell
                             init-ruby-mode
                             init-elisp
                             init-lisp
                             init-css
                             init-javascript
                             ))
(idle-require-mode 1) ;; starts loading
;; }}

;(when (require 'time-date nil t)
;   (message "Emacs startup time: %d seconds."
;    (time-to-seconds (time-since emacs-load-start-time))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; codes of Chen Xiaoshuang

;;directories and executable files
(setq default-dir "~/materials")
(setq copy-default-dir '("C:/Users/chenxs/Desktop" "C:/Users/chenxs/Downloads"))
(setq path-to-irfanview "d:/Program Files/iview440/i_view64.exe")
;设置bibtex打开pdf的方式，有绝对路径
(setq helm-bibtex-pdf-open-function
	(lambda (fpath)
		(start-process "AcroRd32" "*AcroRd32*" "D:/Program Files (x86)/Adobe/Reader 11.0/Reader/AcroRd32.exe" fpath)))
(setq init-bib-preload-files-list '("PhD.bib"))

(setq inhibit-startup-screen t)
(run-with-idle-timer 0.5 nil 'w32-send-sys-command 61488)
(require 'init-gui)
(require 'init-org)
(require 'init-orgTommy) ;forked from https://github.com/tommyjiang
(require 'copy-default)
(require 'init-bib)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;----------------------------------------------------------------------------
;; Locales (setting them earlier in this file doesn't work in X)
;;----------------------------------------------------------------------------
;(require 'init-locales)

;; my personal setup, other major-mode specific setup need it.
;; It's dependent on init-site-lisp.el
;(if (file-exists-p "~/.custom.el") (load-file "~/.custom.el"))

;(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 ;'(safe-local-variable-values (quote ((lentic-init . lentic-orgel-org-init))))
 ;'(session-use-package t nil (session)))


;(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
; '(org-agenda-date-today ((t (:inherit org-agenda-date :weight bold))) t)
; '(org-agenda-date-weekend ((t (:inherit org-agenda-date :foreground "#F47983" :weight bold))) t)
; '(org-mode-line-clock ((t (:foreground "red" :box (:line-width -1 :style released-button)))) t)
; '(window-numbering-face ((t (:foreground "DeepPink" :underline "DeepPink" :weight bold))) t))

;(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
; '(git-gutter:handled-backends (quote (svn hg git)))
; '(package-selected-packages
;(quote
; (yaml-mode yagist writeroom-mode wgrep w3m unfill textile-mode tagedit string-edit simple-httpd session scss-mode scratch sass-mode rvm robe rinari regex-tool rainbow-delimiters quack pomodoro pointback paredit page-break-lines neotree mwe-log-commands multiple-cursors multi-term move-text markdown-mode lua-mode link less-css-mode legalese json-mode js2-mode idomenu ibuffer-vc htmlize hl-sexp helm-bibtex haskell-mode guide-key groovy-mode gitignore-mode gitconfig-mode git-timemachine git-messenger git-link git-gutter ggtags fringe-helper flyspell-lazy flymake-sass flymake-ruby flymake-lua flymake-jslint flymake-css flymake-coffee flx-ido fakir expand-region exec-path-from-shell erlang emmet-mode elpy ebib dsvn dropdown-list dired-details dired+ diminish dictionary define-word csharp-mode crontab-mode cpputils-cmake connection company-c-headers color-theme coffee-mode cmake-mode cliphist buffer-move bookmark+ bbdb auto-compile ace-window))))
 ;;; Local Variables:
;;; no-byte-compile: t
;;; End:
(put 'erase-buffer 'disabled nil)



