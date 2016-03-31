;bibtex & ebib

(require 'copy-default)
(autoload 'helm-bibtex "helm-bibtex" "" t)

(defcustom default-dir "~"
  "default directory")

(defcustom init-bib-dir (concat default-dir "/bibtex")
  "directory of bibtex"
  :group 'init-bib)

(defcustom init-bib-preload-files-list nil
  "list of bibtex files, with no path, since the path is defined in init-bib-dir"
  :group 'init-bib)


;ebib链接
(org-add-link-type "ebib" 'ebib-open-org-link)

(setq bib-preload-path-file-list
      (map 'list'
           (lambda (file-name) (concat init-bib-dir "/" file-name))
           init-bib-preload-files-list))
;ebib路径
(setq ebib-preload-bib-files bib-preload-path-file-list)

;set bibtex file info
(setq helm-bibtex-bibliography bib-preload-path-file-list)

(setq helm-bibtex-library-path (list (concat init-bib-dir "/pdf")))
(setq helm-bibtex-notes-path (concat init-bib-dir "/notes"))
(setq helm-bibtex-notes-extension ".org")

;helm-bibtex 查找的网站
(setq helm-bibtex-fallback-options
    '(("Google Scholar" . "http://scholar.google.com/scholar?q=%s")
    ("ieeexplore" . "http://ieeexplore.ieee.org/search/searchresult.jsp?newsearch=true&queryText=%s")))

;bibtex citation
;添加从org中链接到helm-bibtex的方式
(defun helm-bibtex-format-citation-helm-bibtex (keys)
  "Formatter for helm-bibtex references."
  (s-join ", "
          (--map (concat
                "[[helm-bibtex:"
                it
                "]["
                (helm-bibtex-get-value "title" (helm-bibtex-get-entry it))
                "]]") keys)))


(setq helm-bibtex-format-citation-functions
  '((org-mode      . helm-bibtex-format-citation-helm-bibtex)
    (latex-mode    . helm-bibtex-format-citation-cite)
    (markdown-mode . helm-bibtex-format-citation-pandoc-citeproc)
    (default       . helm-bibtex-format-citation-default)))
;set org mode link
(org-add-link-type "helm-bibtex"
	(lambda (key)
		(helm :sources '(helm-source-bibtex)
			:full-frame t
			:input key
			:candidate-number-limit 500)))



;set icon
(setq helm-bibtex-pdf-symbol "@")
(setq helm-bibtex-notes-symbol "*")

;在状态栏显示简要的note，即note文件的第一行。
(defun helm-bibtex-show-note (&optional complete-file link-location default-description)
    (interactive "P")

    (defun read-first-line (file)
        (with-temp-buffer
            (insert-file-contents file)
            (car (split-string (buffer-string) "\n" t))))

    ;获得helm-bibtex引用的key
    (if (org-in-regexp org-bracket-link-regexp 1)
        (progn
            (setq remove (list (match-beginning 0) (match-end 0)))
            (setq link (org-link-unescape (org-match-string-no-properties 1)))
            (if (string-match org-link-re-with-space3 link)
                (progn
                    (setq type (match-string 1 link) key (match-string 2 link))
                    (if (string= type "helm-bibtex")
                        (progn
                            (setq notepath (f-join helm-bibtex-notes-path (s-concat key helm-bibtex-notes-extension)))
                            (if (file-exists-p notepath)
                                (message (read-first-line notepath))
                                (message "No note.")))
                        (user-error "NOT helm-bibtex format")))
                (user-error "NOT helm-bibtex format")))
        (user-error "no links found.")))


;向剪切板中放入bibtex entry信息
(defun helm-bibtex-copy-bibtex (_)
  "Copy BibTeX entry."
  (let ((keys (helm-marked-candidates :with-wildcard t)))
    (with-helm-current-buffer
      (kill-new (s-join "\n" (--map (helm-bibtex-make-bibtex it) keys))))))

;向剪切板放入格式化引文
(defun helm-bibtex-copy-reference (_)
  "Copy a reference for each selected entry."
  (let* ((keys (helm-marked-candidates :with-wildcard t))
         (refs (--map
                (s-word-wrap fill-column
                             (helm-bibtex-apa-format-reference it))
                keys)))
    (with-helm-current-buffer
      (kill-new (s-join "\n" refs) ))))

;打开pdf，如果文献目录中没有pdf，则检查default-dir（如桌面）中是否有pdf，如果有，则剪切到指定文件夹中。
(defun helm-bibtex-open-or-move(_)
  "Open the PDFs associated with the marked entries using the
function specified in `helm-bibtex-pdf-open-function'.  All paths
in `helm-bibtex-library-path' are searched.  If there are several
matching PDFs for an entry, the first is opened.
If there are no matching PDFs, but there is a matching PDF in `default-dir',
move the PDF into the first directory of `helm-bibtex-library-path'"
  (--if-let
      (-non-nil
       (-map 'helm-bibtex-find-pdf (helm-marked-candidates :with-wildcard t)))
      (-each it helm-bibtex-pdf-open-function)
    (if (cut-from-default (concat (car (helm-marked-candidates :with-wildcard t)) ".pdf") (car helm-bibtex-library-path))
        (--if-let
          (-non-nil
            (-map 'helm-bibtex-find-pdf (helm-marked-candidates :with-wildcard t)))
          (-each it helm-bibtex-pdf-open-function))
		(message "No PDF(s) found."))))

(defun copy-pdf-to-default-dir (_)
  "copy PDF asscociated with the marked entries to the first element
of default directory, and rename it by the `title' of bibtex"
  (let* ((key (car (helm-marked-candidates :with-wildcard t)))
         (file (helm-bibtex-find-pdf key))
         (title (helm-bibtex-get-value "title" (helm-bibtex-get-entry key)))
         (toname (concat title ".pdf")))
    (copy-to-default-dir file toname))
  )

;在执行helm-bibtex的时候，在默认选项中添加Show Entry in Ebib选项，快捷键是<f10>，可以直接link到ebib中该关键字的编辑部分
(eval-after-load 'helm-bibtex
    '(progn
        ;(helm-delete-action-from-source "Open PDF file (if present)" helm-source-bibtex)
        (helm-delete-action-from-source "Show Entry" helm-source-bibtex)
        (helm-add-action-to-source "Copy to Default Directory" 'copy-pdf-to-default-dir helm-source-bibtex 8)
        (helm-delete-action-from-source "Show Entry In Ebib" helm-source-bibtex)
        (helm-add-action-to-source "Show Entry In Ebib" 'ebib-open-org-link helm-source-bibtex 9)
        (helm-delete-action-from-source "Copy Reference to ClipBoard" helm-source-bibtex)
        (helm-add-action-to-source "Copy Reference to ClipBoard" 'helm-bibtex-copy-reference helm-source-bibtex 10)
        (helm-delete-action-from-source "Copy Bibtex Entry to ClipBoard" helm-source-bibtex)
        (helm-add-action-to-source "Copy Bibtex Entry to ClipBoard" 'helm-bibtex-copy-bibtex helm-source-bibtex 11)
        (helm-add-action-to-source "Find and copy PDF file at default directories" 'helm-bibtex-open-or-move helm-source-bibtex 12)))

;ebib导入文献信息
(defun ebib-import-and-save ()
    (interactive)
    (ebib-import)
    (ebib-save-current-database)
    )

(defun ebib-import-and-insert ()
    "将剪切板中的信息添加到bibtex数据库中，将copy-default-dir中的相应文件剪切到pdf文件夹下，并在当前位置粘贴格式化引用信息[[helm-bibtex:key][title]]"
    (interactive)
    (with-temp-buffer
        (yank)
        (beginning-of-buffer)
        (setq values (parsebib-read-entry (parsebib-find-next-item)))
        (setq key (cdr (assoc "=key=" values)))
        (setq title (subseq (cdr (assoc "title" values)) 1 (- (length (cdr (assoc "title" values))) 1)))
        (ebib-import-and-save))
	(cut-from-default (concat key ".pdf") (car helm-bibtex-library-path))
    (insert (concat "[[helm-bibtex:" key "][" title "]]")))

;set key
(global-unset-key (kbd "<f10>"))
(global-set-key (kbd "<f10> h") 'helm-bibtex)
(global-set-key (kbd "<f10> e") 'ebib)
(global-set-key (kbd "<f10> i") 'ebib-import-and-save)
(global-set-key (kbd "<f10> o") 'ebib-import-and-insert)
(global-set-key (kbd "M-n") 'helm-bibtex-show-note)

;启动一次ebib和helm-bibtex，用于初始化
(ebib)
(ebib-leave-ebib-windows)

(provide 'init-bib)
