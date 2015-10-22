; search file in predefined directories, if exists, copy the file to the directory given.

(defcustom copy-default-dir nil
  "List of default directories for searching"
  :group 'copy-default)

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
            
(provide 'copy-default)
