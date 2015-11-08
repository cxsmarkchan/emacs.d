;authored by Chen Xiaoshuang

(defcustom init-auctex-sumatra-path nil
    "path of sumatra"
    :group 'init-auctex)
(add-to-list 'load-path
             "~/.emacs.d/auctex/share/emacs/site-lisp/site-start.d")
(load "auctex.el" nil t t)
(load "preview-latex.el" nil t t)
(if (string-equal system-type "windows-nt")
    (require 'tex-mik))


;; run latex compiler with option -shell-escape
(setq LaTeX-command-style '(("" "%(PDF)%(latex) -shell-escape %S%(PDFout)")))
;; use Sumatra PDF to preview pdf
(setq TeX-source-correlate-mode t)
(setq TeX-source-correlate-method 'synctex)
(if init-auctex-sumatra-path
    (setq TeX-view-program-list
       (list (list "Sumatra PDF" (list (concat "\"" init-auctex-sumatra-path "\"" " -reuse-instance")
                          '(mode-io-correlate " -forward-search %b %n ") " %o")))))


(eval-after-load 'tex
  '(progn
     (assq-delete-all 'output-pdf TeX-view-program-selection)
     (add-to-list 'TeX-view-program-selection '(output-pdf "Sumatra PDF"))))

(add-hook 'LaTeX-mode-hook (lambda()
                              (add-to-list 'TeX-command-list '("XeLaTeX" "%`xelatex%(mode) -synctex=-1' %t" TeX-run-TeX nil t))
                              (add-to-list 'TeX-command-list '("PDFLaTeX" "%`pdflatex%(mode) -synctex=-1' %t" TeX-run-TeX nil t))
                              (TeX-PDF-mode t)
                              (setq TeX-command-default "XeLaTeX")
                                 (setq TeX-save-query  nil)
                                  (setq TeX-show-compilation nil)))

(provide 'init-auctex)
