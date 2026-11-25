;;; init.el --- Personal Emacs setup -*- lexical-binding: t; -*-

;; Keep Emacs quiet and responsive.
(setq inhibit-startup-screen t
      ring-bell-function #'ignore
      make-backup-files t
      backup-directory-alist `(("." . ,(expand-file-name "backups/" user-emacs-directory)))
      auto-save-file-name-transforms `((".*" ,(expand-file-name "auto-save/" user-emacs-directory) t))
      create-lockfiles nil
      use-short-answers t)
(make-directory (expand-file-name "backups/" user-emacs-directory) t)
(make-directory (expand-file-name "auto-save/" user-emacs-directory) t)

(save-place-mode 1)
(savehist-mode 1)
(recentf-mode 1)
(winner-mode 1)
(global-auto-revert-mode 1)
(global-display-line-numbers-mode 1)
(show-paren-mode 1)
(electric-pair-mode 1)
(delete-selection-mode 1)
(column-number-mode 1)

(setq-default indent-tabs-mode nil
              tab-width 4
              fill-column 88)

;; Evil provides Vim-style modal editing; evil-org adapts its keys for Org.
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
(require 'evil)
(setq evil-want-C-u-scroll t
      evil-want-C-i-jump nil
      evil-undo-system 'undo-redo)
(evil-mode 1)
(evil-set-leader 'normal (kbd "SPC"))
(evil-set-leader 'visual (kbd "SPC"))

;; Org files live outside this public dotfiles repository.
(require 'org)
(setq org-directory (expand-file-name "~/org")
      org-default-notes-file (expand-file-name "inbox.org" org-directory)
      org-agenda-files (mapcar (lambda (name) (expand-file-name name org-directory))
                               '("inbox.org" "notes.org" "journal.org" "projects.org"))
      org-startup-indented t
      org-startup-folded 'content
      org-hide-emphasis-markers t
      org-log-done 'time
      org-deadline-warning-days 7
      org-todo-keywords '((sequence "TODO(t)" "NEXT(n)" "WAITING(w@/!)" "|" "DONE(d!)" "CANCELLED(c@)"))
      org-capture-templates
      `(("t" "Task" entry (file+headline ,(expand-file-name "inbox.org" org-directory) "Tasks")
         "* TODO %?\n  %U\n")
        ("n" "Note" entry (file+headline ,(expand-file-name "notes.org" org-directory) "Notes")
         "* %?\n  %U\n")
        ("j" "Journal" entry (file+datetree ,(expand-file-name "journal.org" org-directory))
         "* %U\n%?\n")
        ("p" "Project" entry (file+headline ,(expand-file-name "projects.org" org-directory) "Projects")
         "* TODO %? :project:\n  %U\n"))
      org-agenda-custom-commands
      '(("w" "Work" ((agenda "" ((org-agenda-span 7)))
                        (todo "NEXT")
                        (todo "WAITING")))))

(make-directory org-directory t)

(defvar my-notes-map (make-sparse-keymap)
  "Keymap for notes, tasks, and Org agenda commands.")
(define-key global-map (kbd "C-c n") my-notes-map)
(define-key my-notes-map (kbd "a") #'org-agenda)
(define-key my-notes-map (kbd "c") #'org-capture)
(define-key my-notes-map (kbd "t")
            (lambda () (interactive) (org-capture nil "t")))
(define-key my-notes-map (kbd "n")
            (lambda () (interactive) (org-capture nil "n")))
(define-key my-notes-map (kbd "j")
            (lambda () (interactive) (org-capture nil "j")))
(define-key my-notes-map (kbd "p")
            (lambda () (interactive) (org-capture nil "p")))

;; Keep Emacs' standard C-x and M-x keys intact. The C-c maps remain available
;; in Emacs state; Evil users get Doom-style Space leader maps below.
(require 'project)
(require 'eglot)
(require 'windmove)
(define-key global-map (kbd "C-c p") project-prefix-map)

(defmacro my/doom-leader-bind (keys command)
  "Bind COMMAND to KEYS after Doom-style Space leader in Evil states."
  `(evil-define-key '(normal visual) 'global
     (kbd (concat "<leader>" ,keys)) ,command))

;; Doom-style groups, using built-in Emacs commands where possible.
(my/doom-leader-bind ":" #'execute-extended-command)
(my/doom-leader-bind "." #'find-file)
(my/doom-leader-bind " SPC" #'project-find-file)
(my/doom-leader-bind "ff" #'find-file)
(my/doom-leader-bind "fr" #'recentf-open-files)
(my/doom-leader-bind "fs" #'save-buffer)

(my/doom-leader-bind "bb" #'switch-to-buffer)
(my/doom-leader-bind "bB" #'ibuffer)
(my/doom-leader-bind "bd" #'kill-current-buffer)

(my/doom-leader-bind "pp" #'project-switch-project)
(my/doom-leader-bind "pf" #'project-find-file)
(my/doom-leader-bind "pg" #'project-find-regexp)
(my/doom-leader-bind "pb" #'project-switch-to-buffer)
(my/doom-leader-bind "pc" #'project-compile)

(my/doom-leader-bind "ss" #'isearch-forward)
(my/doom-leader-bind "sp" #'project-find-regexp)
(my/doom-leader-bind "si" #'imenu)

(my/doom-leader-bind "cc" #'compile)
(my/doom-leader-bind "ce" #'eglot)
(my/doom-leader-bind "cr" #'eglot-rename)
(my/doom-leader-bind "ca" #'eglot-code-actions)
(my/doom-leader-bind "cf" #'eglot-format-buffer)

(my/doom-leader-bind "na" #'org-agenda)
(my/doom-leader-bind "nn" #'org-capture)
(my/doom-leader-bind "nt" (lambda () (interactive) (org-capture nil "t")))
(my/doom-leader-bind "nj" (lambda () (interactive) (org-capture nil "j")))
(my/doom-leader-bind "np" (lambda () (interactive) (org-capture nil "p")))

(my/doom-leader-bind "hf" #'describe-function)
(my/doom-leader-bind "hk" #'describe-key)
(my/doom-leader-bind "hv" #'describe-variable)
(my/doom-leader-bind "hm" #'describe-mode)
(my/doom-leader-bind "qq" #'save-buffers-kill-terminal)

(my/doom-leader-bind "wv" #'split-window-right)
(my/doom-leader-bind "ws" #'split-window-below)
(my/doom-leader-bind "wd" #'delete-window)
(my/doom-leader-bind "wo" #'delete-other-windows)
(my/doom-leader-bind "ww" #'other-window)
(my/doom-leader-bind "wh" #'windmove-left)
(my/doom-leader-bind "wj" #'windmove-down)
(my/doom-leader-bind "wk" #'windmove-up)
(my/doom-leader-bind "wl" #'windmove-right)

(when (require 'which-key nil t)
  (which-key-mode 1)
  (setq which-key-idle-delay 0.35))

(require 'evil-org)
(evil-org-set-key-theme '(navigation insert textobjects additional todo heading))
(add-hook 'org-mode-hook #'evil-org-mode)
(require 'evil-org-agenda)
(evil-org-agenda-set-keys)

;; Doom's major-mode local leader convention is SPC m.
(evil-define-key 'normal org-mode-map (kbd "<leader>ma") #'org-agenda)
(evil-define-key 'normal org-mode-map (kbd "<leader>mc") #'org-capture)
(evil-define-key 'normal org-mode-map (kbd "<leader>mt") #'org-todo)
(evil-define-key 'normal org-mode-map (kbd "<leader>ms") #'org-schedule)
(evil-define-key 'normal org-mode-map (kbd "<leader>md") #'org-deadline)
(evil-define-key 'normal org-mode-map (kbd "<leader>ml") #'org-store-link)

(with-eval-after-load 'org
  (setq org-src-fontify-natively t
        org-src-tab-acts-natively t
        org-edit-src-content-indentation 0))

;; Built-in project.el, Flymake, xref, compile, and Eglot are ready to use.
;; Run M-x eglot after installing a language server for the language you use.
(add-hook 'prog-mode-hook #'flymake-mode)
(global-set-key (kbd "M-.") #'xref-find-definitions)

(setq compilation-scroll-output 'first-error
      custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

;;; init.el ends here
