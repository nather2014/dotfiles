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

;; Keep Evil available as an optional mode, but use Emacs bindings by default.
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

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

(require 'project)
(require 'eglot)
;; Evil and evil-org are installed for optional use, but neither is activated.
;; Run M-x evil-mode if you want to switch to Vim-style editing.
(autoload 'evil-mode "evil" "Toggle optional Vim-style editing." t)
(autoload 'evil-org-mode "evil-org" "Toggle Vim-style Org bindings." t)

(with-eval-after-load 'org
  (setq org-src-fontify-natively t
        org-src-tab-acts-natively t
        org-edit-src-content-indentation 0))

;; Built-in project.el, Flymake, xref, compile, and Eglot are ready to use.
;; Run M-x eglot after installing a language server for the language you use.
(add-hook 'prog-mode-hook #'flymake-mode)

(setq compilation-scroll-output 'first-error
      custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

;;; init.el ends here
