;matlab
(add-to-list 'load-path "~/.emacs.d/lisp/matlab-emacs")
(load-library "matlab-load")
(matlab-cedet-setup)
(setq matlab-shell-command "~/.emacs.d/plugins/matlabshell/matlabShell.exe")
(setq matlab-shell-command-switches '("10000" "20000"))
(setq matlab-shell-echoes nil)

(provide 'init-matlab)
