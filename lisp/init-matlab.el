 ;; Edit the path in the following line to reflect the
    ;; actual location of the MATLAB root directory on your system.
    (add-to-list 'load-path "c:/matlab/java/extern/EmacsLink/lisp")
    (autoload 'matlab-eei-connect "matlab-eei"
      "Connects Emacs to MATLAB's external editor interface.")

    (autoload 'matlab-mode "matlab" "Enter Matlab mode." t)
    (setq auto-mode-alist (cons '("\\.m\\'" . matlab-mode) auto-mode-alist))
    (autoload 'matlab-shell "matlab" "Interactive Matlab mode." t)


    (setq matlab-indent-function t)        ; if you want function bodies indented
    (setq matlab-verify-on-save-flag nil)    ; turn off auto-verify on save
    (defun my-matlab-mode-hook ()
       (setq fill-column 76)
       (imenu-add-to-menubar "Find"))        ; where auto-fill should wrap
     (add-hook 'matlab-mode-hook 'my-matlab-mode-hook)

     ;; Uncomment the next two lines to enable use of the mlint package provided
     ;; with EmacsLink.
     ;; (setq matlab-show-mlint-warnings t)
     ;; (setq matlab-highlight-cross-function-variables t)

     ;; Note: The mlint package checks for common M-file coding
     ;; errors, such as omitting semicolons at the end of lines.
     ;; mlint requires Eric Ludlam's cedet package, which is not
     ;; included in the EmacsLink distribution. If you enable mlint,
     ;; you must download cedet from http://cedet.sourceforge.net/ and
     ;; install it on your system before using EmacsLink.
