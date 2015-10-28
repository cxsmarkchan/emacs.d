;authored by Chen Xiaoshuang

(add-to-list 'load-path
             "~/.emacs.d/lisp/auctex/share/emacs/site-lisp/site-start.d")
(load "auctex.el" nil t t)
(load "preview-latex.el" nil t t)
(if (string-equal system-type "windows-nt")
    (require 'tex-mik))
(add-hook 'LaTeX-mode-hook (lambda()
                              (add-to-list 'TeX-command-list '("XeLaTeX" "%`xelatex%(mode)%' %t" TeX-run-TeX nil t))
                              (add-to-list 'TeX-command-list '("PDFLaTeX" "%`pdflatex%(mode)%' %t" TeX-run-TeX nil t))
                              (setq TeX-command-default "XeLaTeX")
                                 (setq TeX-save-query  nil)
                                  (setq TeX-show-compilation nil)))

(provide 'init-auctex)
