(if window-system 2
 (set-fontset-font (frame-parameter nil 'font)
	  'unicode '("simsun" . "unicode-bmp"))
)

(set-language-environment "Chinese-GBK")
(set-keyboard-coding-system 'chinese-iso-8bit)
(setq default-buffer-file-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(prefer-coding-system 'utf-8)

(add-to-list 'load-path "~/.emacs.d/site-lisp")
;============================================
;             GLSL Mode
;============================================
(load-file"~/.emacs.d/site-lisp/glsl-mode.el")

;============================================
;             json Mode
;============================================
(load-file"~/.emacs.d/site-lisp/json-mode/json-mode.el")

;============================================
;             less Mode
;============================================
(load-file"~/.emacs.d/site-lisp/less-css-mode/less-css-mode.el")


;(load-file"~/.emacs.d/site-lisp/color-theme/themes/color-theme-library.el")
;(color-theme-arjen)

;(cua-mode t)
;(menu-bar-mode -1)
(tool-bar-mode nil)
;=============================================
;            Basic Edit Setting
;=============================================
(defun open-init-file ( )  
  (interactive)  
  (find-file "~/.emacs"))  
(global-set-key "\C-ci" 'open-init-file)  

;(global-set-key "\C-z" 'undo)
(global-set-key "\C-z" nil)
(global-set-key (kbd "C-<") 'beginning-of-buffer)
(global-set-key (kbd "C->") 'end-of-buffer)

(global-set-key "\C-cl" 'goto-line)

(setq default-tab-width 2)
(setq tab-width 2)

(global-set-key [f1] 'save-buffer)

;允许剪贴板粘贴
(global-set-key "\C-c\C-v" 'clipboard-yank)  
(global-set-key (kbd "C-`") 'ibuffer)  

;;没有提示音
(setq ring-bell-function 'ignore)

(global-font-lock-mode t)
(setq inhibit-startup-message t)

(setq x-select-enable-clipboard t)

;;显示行号
(global-linum-mode t)

(fset 'yes-or-no-p 'y-or-n-p)
(show-paren-mode t)
(gud-tooltip-mode t)
(setq column-number-mode t)

;cursor dosn't blink
(blink-cursor-mode -1)


;switch window
(global-set-key [M-left] 'windmove-left)
(global-set-key [M-right] 'windmove-right)

(global-set-key [M-up] 'windmove-up)
(global-set-key [M-down] 'windmove-down)

(global-set-key "\M-n" 'next-multiframe-window)
(global-set-key "\M-p" 'previous-multiframe-window)

;================creat pire char ==========
(defun create-pair (a b)
  (interactive)  
  (progn
	(insert-string a)
	(insert-string b)
	(backward-char (length b)))
  )
(defmacro gen-pair-handler (a b)
  (list 'lambda (list)
		 (list 'interactive)
		(list 'create-pair a b)
		)
  )

(defun create-string (string)
  (interactive)  
  (progn
	(insert-string string)
	)
  )
(defmacro gen-creat-string (string)
  (list 'lambda (list)
		 (list 'interactive)
		(list 'create-string string)
		)
 )

(global-set-key (kbd "M-{") (gen-pair-handler "{" "}"))
(global-set-key (kbd "M-(") (gen-pair-handler "(" ")"))
(global-set-key (kbd "M-\"") (gen-pair-handler "\"" "\""))
(global-set-key (kbd "M-'") (gen-pair-handler "'" "'"))
(global-set-key (kbd "M-[") (gen-pair-handler "[" "]"))
(global-set-key (kbd "M-<") (gen-pair-handler "<" ">"))

(global-set-key (kbd "M->") (gen-creat-string "->"))
(global-set-key (kbd "M-C->") (gen-creat-string "=>"))

(global-set-key (kbd "M-_") 'backward-paragraph)
(global-set-key (kbd "M-+") 'forward-paragraph)
;========================End========================

;;===================php-mode================
(add-to-list 'load-path"~/.emacs.d/site-lisp/php-mode-1.5.0")
(require 'php-mode)

;;==============yasnippet=======================
(add-to-list 'load-path"~/.emacs.d/site-lisp/yasnippet")
 (require 'yasnippet)

(yas/initialize) 
(yas/load-directory "~/.emacs.d/snippets")


;;==============coffee-mode=================
(add-to-list 'load-path"~/.emacs.d/site-lisp/coffee-mode/")
 (require 'coffee-mode)

;;==============auto-complete===================
(add-to-list 'load-path"~/.emacs.d/site-lisp/auto-complete-1.3.1/")
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/site-lisp/ac-dict")
(ac-config-default)
(auto-complete-mode t)

(define-key ac-complete-mode-map "<return>"   'nil)
(define-key ac-complete-mode-map "RET"        'nil)
(define-key ac-complete-mode-map "<C-return>" 'ac-complete)


;==========================================

(add-to-list 'load-path "~/.emacs.d/site-lisp/slime-2012-08-01")
(setq inferior-lisp-program "/usr/bin/sbcl")  ;SBCL or Clisp
(require 'slime)
(slime-setup '(slime-fancy))
;(slime) ;M-x slime

  
;;================c===================
(require 'cc-mode)
(c-set-offset 'inline-open 0)
(c-set-offset 'friend '-)
(c-set-offset 'substatement-open 0)

;;编译
(defun get-compile-command-c()
  "A quick compile funciton for C"
  (interactive)
  (setq compile-command (concat "gcc " (buffer-name (current-buffer)) " -Wall -std=c99 -g -o out"))
  (message (concat "set compile command:" compile-command))
  )

;;快捷键F9
;(define-key c-mode-base-map [(f8)] 'get-compile-command-c)
(define-key c-mode-base-map [(f9)] 'compile)
(global-set-key [(f10)] 'gdb)

;(global-set-key [(f1)] 'bookmark-set)
;(global-set-key [(f2)] 'bookmark-jump)
(global-set-key [(f1)] 'auto-complete-mode)

(global-set-key (kbd "M-.") 'semantic-ia-show-summary)
(global-set-key (kbd "M-RET") 'semantic-ia-fast-jump)
;删除到行首
(global-set-key (kbd "C-M-<backspace>") "\C-u0\C-k")

;;C-h w   C-h k
;;C-x r t 在选中行的行首添加字符，字符需要输入，可以是tab
;;C-x r k 删除选中行行首数个字符，个数由当前光标停留的列数决定
;;C-u 0 k 或 C-M-backspace 删除到行首
;;cua-mode
;;semantic-mode
;;C-x C-SPC 回到上一个位置

