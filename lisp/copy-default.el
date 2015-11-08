; search file in predefined directories, if exists, copy the file to the directory given.

(defcustom copy-default-dir nil
  "List of default directories for searching"
  :group 'copy-default)

(defcustom path-to-irfanview nil
  "path to irfanview"
  :group 'copy-default)

(defun copy-to-default-dir (file default-name)
  (copy-file file
             (concat (car copy-default-dir) "/"
                     (read-string "File Name: " default-name))))

(defun cut-from-default (file todir)
    "cut from default directory defined in copy-default-dir"
    (cut-from file copy-default-dir todir))

(defun cut-from (file fromdir todir)
    "find file in a list of directory"
    (if fromdir
        (if (file-exists-p (concat (car fromdir) "/" file))
            (progn
                (copy-file (concat (car fromdir) "/" file) (concat todir "/" file))
                (delete-file (concat (car fromdir) "/" file))
				(concat (car fromdir) "/" file))
            (cut-from file (cdr fromdir) todir))))

(defun org-insert-clipboard-image-name (file-name-prefix)
  (let* ((num (random t))
         (image-file
          (concat file-name-prefix "_" (format "%d" num) ".png")))
    (if (file-exists-p image-file)
        (org-insert-clipboard-image-name file-name-prefix)
      image-file)))

 (defun org-insert-clipboard-image ()
   "将剪切板中的图像插入到org中"
   (interactive)
   (let* ((file-name-prefix
           (concat "img\\" (file-name-base (buffer-file-name))))
           (image-file (org-insert-clipboard-image-name file-name-prefix))
          (exit-status
           (call-process path-to-irfanview nil nil nil
                         (concat "/clippaste /convert=" image-file))))
     (org-insert-link nil (concat "file:" image-file) "")))

(global-unset-key (kbd "<f10>"))
(global-set-key (kbd "<f10> p") 'org-insert-clipboard-image)

(provide 'copy-default)
