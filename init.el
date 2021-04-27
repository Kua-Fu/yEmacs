;; ==================第1部分 配置插件源(清华源)==================

(when (>= emacs-major-version 24)
     (require 'package)
     (add-to-list 'package-archives
				  '("gnu" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/") t)
	 (add-to-list 'package-archives
			      '("melpa" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/") t)
	 (package-initialize)
)

;; ===============第2部分 加载第三方库===========================
(when (not (package-installed-p 'use-package))
  (package-refresh-contents)
  (package-install 'use-package))


;; ================第2部分 加载其他配置文件======================
(load "~/.emacs.d/initMarkdown.el")
(load "~/.emacs.d/initGolang.el")

;; cl - Common Lisp Extension
(use-package cl
  :init
  (setq inhibit-startup-message t) ;; 关闭开始帮助页面
  (setq use-package-always-ensure t) ;; 保证每个缺少的包都会被安装
  (global-linum-mode t) ;; 显示行号
  (setq linum-format " %d ")     ;;行号的显示格式
  (tool-bar-mode -1)             ;;关闭各种菜单栏
  (menu-bar-mode -1)
  
  :config
  (global-auto-revert-mode t) ;; 自动更新修改的文件
  (global-flycheck-mode t) ;; 自动检查语法
  )

;; 插件subr-x, extra Lisp functions
;; (use-package subr-x)

;; 插件自动补全
(use-package company
  :ensure t
  :config
  (progn
    (add-hook 'after-init-hook 'global-company-mode)))

;; 插件persistent-scratch
(use-package persistent-scratch
  :config
  (persistent-scratch-autosave-mode 1) ;; 自动保存*scratch* buffer
)

;; =================第4部分 界面美化===============================
(use-package vscode-dark-plus-theme
  :config
  (load-theme 'vscode-dark-plus t)
  (global-hl-line-mode 1)                       ;;高亮当前行
  (set-face-attribute 'default nil :height 160) ;;设置字体大小
  (setq cursor-type 'bar)                       ;;更改光标的样式
)


;; 快速打开配置文件
(defun open-init-file()
  (interactive)
  (find-file "~/.emacs.d/init.el"))

;; 快速重载初始脚本
(defun load-init-file()
  (interactive)
  (load-file "~/.emacs.d/init.el"))




;; ==================第5部分 快捷键的绑定====================
;; 1) 键冲突
(global-unset-key (kbd "C-SPC"))
(global-set-key (kbd "M-SPC") 'set-mark-command)

;; 2) 将打开配置文件函数，绑定到f2键
;;    将重载配置文件函数，绑定到f3键
(global-set-key (kbd "<f2>") 'open-init-file)
(global-set-key (kbd "<f3>") 'load-init-file)

;; 4) 窗口之间转换
(global-set-key (kbd "M-o") 'other-window)

;; 6) 绑定终端弹出的快捷键
(global-set-key (kbd "C-M-t") 'shell-pop)

;; ===================第6部分 设置各种语言对应的主模式==========
(use-package aggressive-indent)

;; 1) 配置markdown
(use-package markdown-mode
  :commands
  (markdown-mode gfm-mode)
  :mode
  (("README\\.md\\'" . gfm-mode)
   ("\\.md\\'" . markdown-mode)
   ("\\.markdown\\'" . markdown-mode))
  :init
  (setq markdown-command "multimarkdown"))

;; 2) 配置golang
(use-package go-mode
  :mode
  (("\\.go\\'" . go-mode))
  :config
  (global-set-key (kbd "M-,") 'godef-jump)
  (global-set-key (kbd "M-.") 'pop-tag-mark)
  (setq exec-path (append exec-path '("/usr/local/go/bin"))) ;; 设置golang的编译路径
  (setq gofmt-command "goimports")
  (add-hook 'before-save-hook 'gofmt-before-save)
  (add-hook 'go-mode-hook 'auto-complete-for-go)
  (add-hook 'go-mode-hook 'flycheck-mode))


(use-package company-go
  :init
  (progn
    (setq company-go-show-annotation t)
    (setq company-tooltip-limit 20)                      ; bigger popup window
    (add-hook 'go-mode-hook 
              (lambda ()
                (set (make-local-variable 'company-backends) '(company-go))
                (company-mode)))
    )
  )


(use-package go-complete
  :config
  (add-hook 'completion-at-point-functions 'go-complete-at-point))

;; 3) 配置python
(use-package python-mode
  :mode
  (("\\.py\\'" . python-mode))
  :config
  (setq python-shell-interpreter "ipython"))

;; 4) 配置rust
(use-package rust-mode
  :mode
  (("\\.rs\\'" . rust-mode)))

;; 5) 配置yaml
(use-package yaml-mode
  :mode
  (("\\.yaml\\'" . yaml-mode))
  (("\\.yml\\'" . yaml-mode)))

;; 6) 配置java
(use-package lsp-mode
  :init
  (setq lsp-java-server-install-dir "~/.emacs.d/jdt/")
  :mode
  (("\\.yml\\'" . java-mode))
  :config
  (add-hook 'java-mode-hook #'lsp)
  (add-hook 'java-mode-hook 'flycheck-mode)
  (add-hook 'java-mode-hook 'company-mode)
  (add-hook 'java-mode-hook (lambda ()
                            (setq c-default-style "java")
                            (setq c-basic-offset 4)
                            (display-line-numbers-mode t)
                            ;;(gradle-mode 1)
                            )))

;; ===================第7部分 各种其他工具=======================
;; 1) 谷歌翻译
(use-package go-translate
  ;; :init
  ;; (setq go-translate-base-url "https://translate.google.cn")
  ;; (setq go-translate-local-language "zh-CN")
  ;; (defun go-translate-token--extract-tkk ()
  ;;   (cons 430675 2721866130))
  :config
  (setq go-translate-base-url "https://translate.google.cn")
  (setq go-translate-local-language "zh-CN")
  (defun go-translate-token--extract-tkk ()
	(cons 430675 2721866130))
  (global-set-key (kbd "M-t") 'go-translate)
)
  
;; 2) emacs中弹出终端的配置
(setq shell-pop-shell-type "shell")
(setq shell-pop-term-shell "/bin/zsh")

;;; init.el ends here
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
	(company-go subr-x yaml-mode vscode-dark-plus-theme use-package solarized-theme smartparens shell-pop rust-mode python-mode py-autopep8 projectile persistent-scratch nodejs-repl monokai-theme molokai-theme material-theme markdown-preview-mode magit lsp-ui lsp-java js2-mode impatient-mode hungry-delete google-translate go-translate go-complete go-autocomplete flymake-go flycheck exec-path-from-shell elpy dumb-jump doom-themes dired-subtree counsel color-theme-sanityinc-solarized bug-hunter blacken autopair aggressive-indent))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
