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

;; Keep Emacs' standard C-x and M-x keys intact, and put project actions on
;; the same easy-to-reach C-c prefix used for notes.
(require 'project)
(define-key global-map (kbd "C-c p") project-prefix-map)

(defvar my-tools-map (make-sparse-keymap)
  "Keymap for common editing and coding tools.")
(define-key global-map (kbd "C-c m") my-tools-map)
(define-key my-tools-map (kbd "b") #'ibuffer)
(define-key my-tools-map (kbd "r") #'recentf-open-files)
(define-key my-tools-map (kbd "d") #'duplicate-dwim)
(define-key my-tools-map (kbd "c") #'compile)
(define-key my-tools-map (kbd "e") #'eglot)
(define-key my-tools-map (kbd "f") #'project-find-file)
(define-key my-tools-map (kbd "g") #'project-find-regexp)
(define-key my-tools-map (kbd "p") #'project-switch-project)

;; Space is a thumb-friendly leader in Evil normal/visual states, so frequent
;; commands do not need Emacs Control chords.
(evil-define-key '(normal visual) 'global (kbd "<leader>na") #'org-agenda)
(evil-define-key '(normal visual) 'global (kbd "<leader>nc") #'org-capture)
(evil-define-key '(normal visual) 'global (kbd "<leader>nt")
  (lambda () (interactive) (org-capture nil "t")))
(evil-define-key '(normal visual) 'global (kbd "<leader>nn")
  (lambda () (interactive) (org-capture nil "n")))
(evil-define-key '(normal visual) 'global (kbd "<leader>nj")
  (lambda () (interactive) (org-capture nil "j")))
(evil-define-key '(normal visual) 'global (kbd "<leader>np")
  (lambda () (interactive) (org-capture nil "p")))

(evil-define-key '(normal visual) 'global (kbd "<leader>pf") #'project-find-file)
(evil-define-key '(normal visual) 'global (kbd "<leader>pg") #'project-find-regexp)
(evil-define-key '(normal visual) 'global (kbd "<leader>pb") #'project-switch-to-buffer)
(evil-define-key '(normal visual) 'global (kbd "<leader>pc") #'project-compile)
(evil-define-key '(normal visual) 'global (kbd "<leader>pp") #'project-switch-project)

(evil-define-key '(normal visual) 'global (kbd "<leader>bb") #'ibuffer)
(evil-define-key '(normal visual) 'global (kbd "<leader>br") #'recentf-open-files)
(evil-define-key '(normal visual) 'global (kbd "<leader>cd") #'duplicate-dwim)
(evil-define-key '(normal visual) 'global (kbd "<leader>cc") #'compile)
(evil-define-key '(normal visual) 'global (kbd "<leader>ce") #'eglot)
(evil-define-key '(normal visual) 'global (kbd "<leader>cf") #'project-find-file)
(evil-define-key '(normal visual) 'global (kbd "<leader>cg") #'project-find-regexp)

(require 'evil-org)
(evil-org-set-key-theme '(navigation insert textobjects additional todo heading))
(add-hook 'org-mode-hook #'evil-org-mode)
(require 'evil-org-agenda)
(evil-org-agenda-set-keys)

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
