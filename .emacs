;(if window-system 2
; (set-fontset-font (frame-parameter nil 'font)
;; 	  'unicode '("simsun" . "unicode-bmp"))
;; )
;; (set-language-environment "Chinese-GBK")
;; (set-keyboard-coding-system 'chinese-iso-8bit)
(setq default-buffer-file-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(prefer-coding-system 'utf-8)
;;================package=============
(require 'package)
(add-to-list 'package-archives 
    '("marmalade" .
      "http://marmalade-repo.org/packages/"))
(package-initialize)

;;===============color===============
(deftheme bubbleberry "bubbleberry")
 
;; Based on the theme used for LightTable (see: http://www.chris-granger.com/images/lightable/main.png )
 
(custom-theme-set-variables
 'bubbleberry
 '(linum-format " %3d ")
 '(fringe-mode 5 nil (fringe))
 '(powerline-color1 "#3d3d68")
 '(powerline-color2 "#292945")
 )
 
(custom-theme-set-faces
 'bubbleberry
 
 ;; basic theming.
 '(default                          ((t (:foreground "#ABAEB3" :background "grey14" ))))
 '(region                           ((t (:background "black" ))))
 '(cursor                           ((t (:background "#ffffff" ))))
 '(fringe                           ((t (:background "#2f2f2f" :foreground "#ffffff" ))))
 '(linum                            ((t (:background "#202020" :foreground "grey22" :box nil :height 110 ))))
 '(minibuffer-prompt                ((t (:foreground "#9489C4" :weight bold ))))
 '(minibuffer-message               ((t (:foreground "#ffffff" ))))
 '(mode-line                        ((t (:foreground "#FFFFFF" :background "#191919" ))))
 '(mode-line-inactive               ((t (:foreground "#777777" :background "#303030" :weight light :box nil :inherit (mode-line )))))
 
 '(font-lock-keyword-face           ((t (:foreground "#3ca380"))))
 '(font-lock-type-face              ((t (:foreground "#db7093"))))
 '(font-lock-constant-face          ((t (:foreground "#3F5C70"))))
 '(font-lock-variable-name-face     ((t (:foreground "SkyBlue3"))))
 '(font-lock-builtin-face           ((t (:foreground "#6767AE"))))
 '(font-lock-string-face            ((t (:foreground "cyan4"))))
 '(font-lock-comment-face           ((t (:foreground "#696969"))))
 '(font-lock-comment-delimiter-face ((t (:foreground "#666688"))))
 
 '(font-lock-function-name-face     ((t (:foreground "#3ca380"))))
 '(font-lock-doc-string-face        ((t (:foreground "#496B83"))))
 
 ;; easy defaults...
 '(tooltip ((default nil) (nil nil)))
 '(next-error ((t          (:inherit (region)))))
 '(query-replace ((t       (:inherit (isearch)))))
 '(button ((t              (:inherit (link)))))
 '(fixed-pitch ((t         (:family "Monospace")))) 
 '(variable-pitch ((t      (:family "Sans Serif"))))
 '(escape-glyph ((t        (:foreground "#FF6600"))))
 '(mode-line-emphasis ((t  (:weight bold))))
 '(mode-line-highlight ((t (:box nil (t (:inherit (highlight)))))))
  
 '(highlight 
   ((((class color) (min-colors 88) (background light)) (:background "#003453")) 
    (((class color) (min-colors 88) (background dark))  (:background "#003450")) 
    (((class color) (min-colors 16) (background light)) (:background "#003450")) 
    (((class color) (min-colors 16) (background dark))  (:background "#004560")) 
    (((class color) (min-colors 8))                     (:foreground "#000000" :background "#00FF00")) (t (:inverse-video t))))
 
 '(shadow 
   ((((class color grayscale) (min-colors 88) (background light)) (:foreground "#999999")) 
    (((class color grayscale) (min-colors 88) (background dark))  (:foreground "#999999"))
    (((class color) (min-colors 8) (background light))            (:foreground "#00ff00"))
    (((class color) (min-colors 8) (background dark))             (:foreground "#ffff00"))))
  
 '(trailing-whitespace
   ((((class color) (background light)) (:background "#ff0000"))
    (((class color) (background dark))  (:background "#ff0000")) (t (:inverse-video t))))
  
 '(link
   ((((class color) (min-colors 88) (background light)) (:underline t :foreground "#00b7f0")) 
    (((class color) (background light))                 (:underline t :foreground "#0044FF")) 
    (((class color) (min-colors 88) (background dark))  (:underline t :foreground "#0099aa"))
    (((class color) (background dark))                  (:underline t :foreground "#0099aa")) (t (:inherit (underline)))))
  
 '(link-visited 
   ((default                            (:inherit (link))) 
    (((class color) (background light)) (:inherit (link))) 
    (((class color) (background dark))  (:inherit (link)))))
  
 '(header-line 
   ((default                                      (:inherit (mode-line))) (((type tty)) (:underline t :inverse-video nil)) 
    (((class color grayscale) (background light)) (:box nil :foreground "#222222" :background "#bbbbbb")) 
    (((class color grayscale) (background dark))  (:box nil :foreground "#bbbbbb" :background "#222222")) 
    (((class mono) (background light))            (:underline t :box nil :inverse-video nil :foreground "#000000" :background "#ffffff")) 
    (((class mono) (background dark))             (:underline t :box nil :inverse-video nil :foreground "#ffffff" :background "#000000"))))
  
 '(isearch
   ((((class color) (min-colors 88) (background light)) (:foreground "#99ccee" :background "#444444")) 
    (((class color) (min-colors 88) (background dark))  (:foreground "#ffaaaa" :background "#444444")) 
    (((class color) (min-colors 16))                    (:foreground "#0088cc" :background "#444444"))
    (((class color) (min-colors 8))                     (:foreground "#0088cc" :background "#444444")) (t (:inverse-video t))))
  
 '(isearch-fail
   ((((class color) (min-colors 88) (background light)) (:background "#ffaaaa"))
    (((class color) (min-colors 88) (background dark))  (:background "#880000"))
    (((class color) (min-colors 16))                    (:background "#FF0000"))
    (((class color) (min-colors 8))                     (:background "#FF0000"))
    (((class color grayscale))                          (:foreground "#888888")) (t (:inverse-video t))))
  
 '(lazy-highlight
   ((((class color) (min-colors 88) (background light)) (:foreground "#000000" :background "#77bbdd"))
    (((class color) (min-colors 88) (background dark)) (:foreground "#000000" :background "#77bbdd"))
    (((class color) (min-colors 16)) (:background "#4499ee"))
    (((class color) (min-colors 8)) (:background "#4499ee")) (t (:underline t))))
  
 '(match
   ((((class color) (min-colors 88) (background light)) (:background "#3388cc"))
    (((class color) (min-colors 88) (background dark)) (:background "#3388cc"))
    (((class color) (min-colors 8) (background light)) (:foreground "#000000" :background "#FFFF00"))
    (((class color) (min-colors 8) (background dark)) (:foreground "#ffffff" :background "#0000FF")) 
    (((type tty) (class mono)) (:inverse-video t)) (t (:background "#888888"))))
)
 
(provide-theme 'bubbleberry)


(add-to-list 'load-path "~/.emacs.d/site-lisp")
;============================================
;             Ibus Mode
;============================================
;(load-file"~/.emacs.d/site-lisp/ibus-el/ibus.el")
;(add-hook 'after-init-hook 'ibus-mode-on)

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
(tool-bar-mode 0)
(scroll-bar-mode 0)
;=============================================
;            Basic Edit Setting
;=============================================
(global-set-key "R" 'self-insert-command)
(defun open-init-file ( )  
  (interactive)  
  (find-file "~/.emacs"))  
(global-set-key "\C-ci" 'open-init-file)  
(global-set-key "\C-x\C-c" 'nil)

;(global-set-key "\C-z" 'undo)
;(global-set-key "\C-z" nil)
(global-set-key (kbd "C-<") 'beginning-of-buffer)
(global-set-key (kbd "C->") 'end-of-buffer)

(global-set-key "\C-cl" 'goto-line)
(global-set-key (kbd "C-t") 'switch-to-buffer)

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


;; ;==========================================

;; (add-to-list 'load-path "~/.emacs.d/site-lisp/slime-2012-08-01")
;; (setq inferior-lisp-program "/usr/bin/sbcl")  ;SBCL or Clisp
;; (require 'slime)
;; (slime-setup '(slime-fancy))
;; ;(slime) ;M-x slime

  
;;================c===================
;; (require 'cc-mode)
;; (c-set-offset 'inline-open 0)
;; (c-set-offset 'friend '-)
;; (c-set-offset 'substatement-open 0)

;; ;;编译
;; (defun get-compile-command-c()
;;   "A quick compile funciton for C"
;;   (interactive)
;;   (setq compile-command (concat "gcc " (buffer-name (current-buffer)) " -Wall -std=c99 -g -o out"
;;   ))
;;   (message (concat "set compile command:" compile-command))
;;   )

;;快捷键F9
;(define-key c-mode-base-map [(f8)] 'get-compile-command-c)
(define-key c-mode-base-map [(f9)] 'compile)
(global-set-key [(f10)] 'gdb)

;;=========================================

(defun current-indent-size
 ()
 "Return the horizontal position of the first non-whitespace
character on the current line. The first position is 0."
 (interactive)
 (save-excursion
   (back-to-indentation)
   (current-column)
	 ))
 
(defun indent-block-find-boundary-position
  (step)
  "Return character position of the begining of the current
indent block (step = -1), or the last character of the current
indent block (step = 1)."
  (save-excursion
    (make-local-variable 'other-indent-size)
    (let ((indent-size (current-indent-size)))
      (setq other-indent-size (save-excursion
                                (forward-line step)
                                (current-indent-size)))
      (while (and (<= indent-size other-indent-size)
                  (< (point-min) (point))
                  (< (point) (point-max)))
        (forward-line step)
        (setq other-indent-size (save-excursion
                                  (forward-line step)
                                  (current-indent-size))))
      (kill-local-variable 'other-indent-size)
      (if (< 0 step)
          (end-of-line)
        (back-to-indentation))
      (point))))
 
(defun indent-block-beginning-position
  ()
  "Return the character position of the first non-white space
character of the current indent block (a sequence of line with
same or bigger indention with respect ot the current line)."
  (indent-block-find-boundary-position -1))
 
(defun indent-block-end-position
  ()
  "Return the last character position of the last line of the
current indent block (a sequence of line with same or bigger
indention with respect ot the current line)."
  (indent-block-find-boundary-position 1))
 
(defun beginning-of-indent-block
    (&optional EXPAND)
    "Move point to the beginning of the current indent block (a
sequence of lines which indent size is not less than tat of the
current line).
 
With argument EXPAND is not nil, and point is already on the
beginning of the indent block, then move it backward to the
smaller indentatation of the parent block.
 
If point reaches the beginning of buffer, it stops there."
    (interactive "^P")
    (let ((bb (indent-block-beginning-position)))
      (if (and EXPAND
               (= (point) bb)
               (< 0 (current-indent-size))
               (< (point-min) (point)))
          (backward-to-indentation)
        (goto-char bb))))
 
(defun end-of-indent-block
    (&optional EXPAND)
    "Move point to the end of the current indent block (a
sequence of lines which indent size is not less than tat of the
current line).
 
With argument EXPAND is not nil, and point is already at the end
of the indent block, then move it further to the end of the
parent block with smaller indent size.
 
If point reaches the end of buffer, it stops there."
    (interactive "^P")
    (let ((bb (indent-block-end-position)))
      (if (and EXPAND
               (= (point) bb)
               (< (point) (point-max)))
          (progn
            (forward-line 1)
            (goto-char (indent-block-end-position)))
        (goto-char bb))))

(global-set-key (kbd "C-M-[") '(lambda ()
																 (interactive)
																 (beginning-of-indent-block 1)))
(global-set-key (kbd "C-M-]") '(lambda ()
																 (interactive)
																 (end-of-indent-block)))

;;###################################
;;junp around same indent 
;;###################################
(defun current-indent ()
	(interactive)
		(save-excursion
			(back-to-indentation)
			(current-column)
			))

(defun find-next-indent (currentIndent cursorAtBlank?)
	"判断下一行缩进是否相同，并执行相应逻辑"
	(let (nextIndent)
		(progn
			(save-excursion
				(next-line)
				(setq nextIndent (current-indent)))
			(cond ((and
							(not cursorAtBlank?)
							(= nextIndent currentIndent))
						 (progn;下行与此行缩进相同
							 (while (= currentIndent (current-indent))
								 (next-line))
							 (previous-line)
							 (back-to-indentation)))
						(t
						 (progn;下行缩进与此行不同
							 (next-line)
							 (if cursorAtBlank?;光标处于空白处，跳到缩进块尾部
								 (progn
									 (while (< currentIndent (current-indent))
										 (next-line))
									 (previous-line))
								 (progn
									 (while (/= currentIndent (current-indent))
										 (next-line))
									 (back-to-indentation))
								 )))))))

(defun find-prev-indent (currentIndent cursorAtBlank?)
	"判断下一行缩进是否相同，并执行相应逻辑"
	(let (previousIndent)
		(progn
			(save-excursion
				(previous-line)
				(setq previousIndent (current-indent)))
			(cond ((and
							(not cursorAtBlank?)
							(= previousIndent currentIndent))
						 (progn;下行与此行缩进相同
							 (while (= currentIndent (current-indent))
								 (previous-line))
							 (next-line)
							 (back-to-indentation)))
						(t
						 (progn;下行缩进与此行不同
							 (previous-line)
							 (if cursorAtBlank?;光标处于空白处，跳到缩进块首部
								 (progn
									 (while (< currentIndent (current-indent))
										 (previous-line))
									 (next-line))
								 (progn
									 (while (/= currentIndent (current-indent))
										 (previous-line))
									 (back-to-indentation))
								 )))))))

(defun jump-to-next-same-column ()
	"正常情况下会在相同缩进级的行间跳转
如果下一行是更浅的缩进级，则会跳到那一行的实际行首
如果下一行是与当前行相同的缩进级，则会跳到此局部缩进块的底部/顶部
如果光标处于空白处，则会跳转到下一个缩进浅于或等于当前光标位置的行的前一行
"
	(interactive)
	(let (currentColumn currentIndent)
		(progn
			(setq currentIndent (current-indent))
			(if (> currentIndent (current-column))
				(find-next-indent (current-column) t)
				(find-next-indent currentIndent nil)
				))))

(defun jump-to-prev-same-column ()
	"逻辑同上"
	(interactive)
	(let (currentColumn currentIndent)
		(progn
			(setq currentIndent (current-indent))
			(if (> currentIndent (current-column))
				(find-prev-indent (current-column) t)
				(find-prev-indent currentIndent nil)
				))))

(defun enter-indent-iter (currentIndent)
	"enter-indent的迭代器"
	(progn
		(next-line);向下移动光标
		(back-to-indentation)
		(cond ((< (current-indent) currentIndent);缩进比原来浅则停止于缩进块末尾
					 (progn
						 (previous-line)
						 (back-to-indentation)))
					((> (current-indent) currentIndent);缩进比原来深则停止于更深缩进块的开始
					 (return))
					(t (enter-indent-iter currentIndent)));缩进相同则继续迭代
		))

(defun enter-indent ()
	"进入一个缩进块"
	(interactive)
	(progn
		(back-to-indentation)
		(enter-indent-iter (current-indent))))

(defun exit-indent-iter (currentIndent)
	"exit-indent的迭代器"
	(progn
		(previous-line);向上移动光标
		(back-to-indentation)
		(cond ((< (current-indent) currentIndent);缩进比原来浅则停止于更浅缩进的末尾
					 (return))
					(t (exit-indent-iter currentIndent)));缩进相同或者更深则继续迭代
		))

(defun exit-indent ()
	"离开一个缩进块"
	(interactive)
	(progn
		(back-to-indentation)
		(exit-indent-iter (current-indent))))

(global-set-key (kbd "C-M-p") 'jump-to-prev-same-column)
(global-set-key (kbd "C-M-n") 'jump-to-next-same-column)
(global-set-key (kbd "C-M-a") 'exit-indent)
(global-set-key (kbd "C-M-e") 'enter-indent)
	
(defun testFunc ()
	(interactive)
	(message (string (current-indent-size)))
	)

;(global-set-key [(f1)] 'bookmark-set)
;(global-set-key [(f2)] 'bookmark-jump)
(global-set-key [(f1)] 'auto-complete-mode)

(global-set-key (kbd "M-.") 'semantic-ia-show-summary) 
(global-set-key (kbd "M-RET") 'semantic-ia-fast-jump)
;删除到行首
;(global-set-key (kbd "C-M-<backspace>") "\C-u0\C-k")
(global-set-key (kbd "C-M-<backspace>") 'delete-indentation)
(global-set-key (kbd "C-M-<down>") 'nil)
(global-set-key (kbd "C-M-<up>") 'nil)

;;******************
;; scheme
;;******************
(require 'cmuscheme)
(setq scheme-program-name "scm")         ;; 默认的scheme解释器名称

;; bypass the interactive question and start the default interpreter
(defun scheme-proc ()
  "Return the current Scheme process, starting one if necessary."
  (unless (and scheme-buffer
               (get-buffer scheme-buffer)
               (comint-check-proc scheme-buffer))
    (save-window-excursion
      (run-scheme scheme-program-name)))
  (or (scheme-get-process)
      (error "No current process. See variable `scheme-buffer'")))


(defun scheme-split-window ()
  (cond
   ((= 1 (count-windows))
    (delete-other-windows)
    (split-window-vertically (floor (* 0.68 (window-height))))
    (other-window 1)
    (switch-to-buffer "*scheme*")
    (other-window 1))
   ((not (find "*scheme*"
               (mapcar (lambda (w) (buffer-name (window-buffer w)))
                       (window-list))
               :test 'equal))
    (other-window 1)
    (switch-to-buffer "*scheme*")
    (other-window -1))))


(defun scheme-send-last-sexp-split-window ()
  (interactive)
  (scheme-split-window)
  (scheme-send-last-sexp))


(defun scheme-send-definition-split-window ()
  (interactive)
  (scheme-split-window)
  (scheme-send-definition))

(add-hook 'scheme-mode-hook
  (lambda ()
    (paredit-mode 1)
    (define-key scheme-mode-map (kbd "<f5>") 'scheme-send-last-sexp-split-window)
    (define-key scheme-mode-map (kbd "<f6>") 'scheme-send-definition-split-window)))

;;********************
;;   一些快捷键记录
;;********************

;;C-h w   C-h k(这两个用于查看快捷键对应的命令，或者是命令对应的快捷键)
;;M-; 批量注释，或取消注释
;;M-m 移动到行首第一个非空字符
;;C-x r t 在选中行的行首添加字符，字符需要输入，可以是tab(tab和空格混用会导致缩进问题，用数个空格代替)
;;C-x r k 删除选中行行首数个字符，个数由当前光标停留的列数决定
;;M-x tab 可以在选中行行首插入一个字符，配合M-(数字)的重复功能，可以快速插入缩进空格
;;C-u 0 k
;;M-^ 合并两个行
;;cua-mode
;;semantic-mode
;;C-x C-SPC 回到上一个位置
