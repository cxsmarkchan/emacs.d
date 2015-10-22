; Set default Font
;(set-face-attribute
;'default nil :font "Yahei Consolas Hybrid 18")
(set-face-attribute
'default nil :font "文泉驿等宽正黑 18")
;(set-face-attribute
;'default nil :font "Inconsolata 24")
;(when *is-mac*
;  (set-face-attribute
;    'default nil :font "Inconsolata 24"))

; (setq initial-frame-alist '((top . 0) (left . 0)))
; (add-to-list 'initial-frame-alist '(width . 120))
; (add-to-list 'initial-frame-alist '(height . 32))

; Set cursor color
;(set-cursor-color "white")

; Cyberpunk theme
;(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
;(load-theme 'cyberpunk t)

; Recent file
(require 'recentf)
(recentf-mode 1)
(setq recentf-max-menu-items 25)
(global-set-key "\C-x\ \C-r" 'recentf-open-files)

;org agenda autoload
;(org-agenda-list t)
;(delete-other-windows)

; Default encoding priority
(prefer-coding-system 'gb2312)
(prefer-coding-system 'utf-8)

; Display line number
;(global-linum-mode t)

;;
(provide 'init-gui)
