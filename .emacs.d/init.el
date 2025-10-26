(defvar elpaca-installer-version 0.11)
(defvar elpaca-directory (expand-file-name "elpaca/" user-emacs-directory))
(defvar elpaca-builds-directory (expand-file-name "builds/" elpaca-directory))
(defvar elpaca-repos-directory (expand-file-name "repos/" elpaca-directory))
(defvar elpaca-order '(elpaca :repo "https://github.com/progfolio/elpaca.git"
                              :ref nil :depth 1 :inherit ignore
                              :files (:defaults "elpaca-test.el" (:exclude "extensions"))
                              :build (:not elpaca--activate-package)))
(let* ((repo  (expand-file-name "elpaca/" elpaca-repos-directory))
       (build (expand-file-name "elpaca/" elpaca-builds-directory))
       (order (cdr elpaca-order))
       (default-directory repo))
  (add-to-list 'load-path (if (file-exists-p build) build repo))
  (unless (file-exists-p repo)
    (make-directory repo t)
    (when (<= emacs-major-version 28) (require 'subr-x))
    (condition-case-unless-debug err
        (if-let* ((buffer (pop-to-buffer-same-window "*elpaca-bootstrap*"))
                  ((zerop (apply #'call-process `("git" nil ,buffer t "clone"
                                                  ,@(when-let* ((depth (plist-get order :depth)))
                                                      (list (format "--depth=%d" depth) "--no-single-branch"))
                                                  ,(plist-get order :repo) ,repo))))
                  ((zerop (call-process "git" nil buffer t "checkout"
                                        (or (plist-get order :ref) "--"))))
                  (emacs (concat invocation-directory invocation-name))
                  ((zerop (call-process emacs nil buffer nil "-Q" "-L" "." "--batch"
                                        "--eval" "(byte-recompile-directory \".\" 0 'force)")))
                  ((require 'elpaca))
                  ((elpaca-generate-autoloads "elpaca" repo)))
            (progn (message "%s" (buffer-string)) (kill-buffer buffer))
          (error "%s" (with-current-buffer buffer (buffer-string))))
      ((error) (warn "%s" err) (delete-directory repo 'recursive))))
  (unless (require 'elpaca-autoloads nil t)
    (require 'elpaca)
    (elpaca-generate-autoloads "elpaca" repo)
    (let ((load-source-file-function nil)) (load "./elpaca-autoloads"))))
(add-hook 'after-init-hook #'elpaca-process-queues)
(elpaca `(,@elpaca-order))

;; Install a package via the elpaca macro
;; See the "recipes" section of the manual for more details.

;; (elpaca example-package)

;; Install use-package support
(elpaca elpaca-use-package
  ;; Enable use-package :ensure support for Elpaca.
  (elpaca-use-package-mode))


;; SOME BASIC STUFF

;; Open EMACS in fullscreen on MAC

(setq ns-use-native-fullscreen :true)
(add-to-list 'default-frame-alist '(fullscreen . fullscreen))

  ;; Disable startup message
  inhibit-startup-message t

  ;; Disable the menu bar
  (menu-bar-mode -1)

  ;; Disable the tool bar
  (tool-bar-mode -1)

  ;; Disable the scroll bar
  (scroll-bar-mode -1)

  ;; LINENUMBER
  (global-display-line-numbers-mode 1) ;; Display line numbers

  ;; Disable backup files
  make-backup-files nil

  ;; enable witch-key
  (which-key-mode)  ;; To enable witch-key globaly

  ;; Anser yes to follow symbolic link
  (setq vc-follow-symlinks t)



;; Setup my theme

   (use-package doom-themes
     :ensure t
     :custom
     ;; Global settings (defaults)
     (doom-themes-enable-bold t)   ; if nil, bold is universally disabled
     (doom-themes-enable-italic t) ; if nil, italics is universally disabled
     ;; for treemacs users
     (doom-themes-treemacs-theme "doom-atom") ; use "doom-colors" for less minimal icon theme
     :config
     (load-theme 'doom-one t)

     ;; Enable flashing mode-line on errors
     (doom-themes-visual-bell-config)
     ;; Enable custom neotree theme (nerd-icons must be installed!)
     (doom-themes-neotree-config)
     ;; or for treemacs users
     (doom-themes-treemacs-config)
     ;; Corrects (and improves) org-mode's native fontification.
     (doom-themes-org-config))

;; Setup my font

  ;; Set default font
  (set-face-attribute 'default nil
  		    :family "JetBrains Mono"
  		    :height 130
  		    :weight 'normal
  		    :width 'normal)

;; Setup my startcreen

   ;; Setup a startscreen
   (use-package dashboard
     :ensure t 
     :init
     (setq initial-buffer-choice 'dashboard-open)
     (setq dashboard-set-heading-icons t)
     (setq dashboard-set-file-icons t)
     (setq dashboard-banner-logo-title "Emacs Is More Than A Text Editor!")
     (setq dashboard-startup-banner 'logo) ;; use standard emacs logo as banner
     (setq dashboard-center-content nil) ;; set to 't' for centered content
     (setq dashboard-items '((recents . 5)
                             (agenda . 5 )
                             (bookmarks . 3)
                             (projects . 3)
                             (registers . 3)))
     :custom 
     (dashboard-modify-heading-icons '((recents . "file-text")
   				      (bookmarks . "book")))
     :config
     (dashboard-setup-startup-hook))

;; EVIL MODE

  (use-package evil
  :ensure ( :wait t)
  :demand t
  :config
  (evil-mode 1))

;; INSTALL MODELINE

     ;; MODELINE
     (use-package doom-modeline
       :ensure t
       :init (doom-modeline-mode 1)
       :config
       (setq doom-modeline-height 35      ;; sets modeline height
             doom-modeline-bar-width 5    ;; sets right bar width
             doom-modeline-persp-name t   ;; adds perspective name to modeline
             doom-modeline-persp-icon t)) ;; adds folder icon next to persp name

;; VERTICO AND ORDERLESS

     (use-package vertico
       :ensure t
       :init (vertico-mode))

     (use-package orderless
     :ensure t
     :custom
     (completion-styles '(orderless basic))
     (completion-category-overrides '((file (styles basic partial-completion)))))

     (use-package consult
       :ensure t
       :bind (
              ("M-s b" . consult-buffer)
              ("M-s g" . consult-grep)
              ("M-s j" . consult-outline)
              ))

;; ORG-Roam

  (use-package org-roam
    :ensure t
    :init
    (setq org-roam-v2-ack t)
    :custom
    (org-roam-directory "~/Documents/wiki")
    :bind (("C-c n l" . org-roam-buffer-toggle)
  	 ("C-c n f" . org-roam-node-find)
  	 ("C-c n i" . org-roam-node-insert))
    :config
    (org-roam-setup))

;; MAGIT

  (use-package transient :ensure t)
  (use-package magit
      :ensure t
      :defer t)

;; WRITEROOM

  (use-package writeroom-mode 
  :ensure t
  :config
  :bind ("C-c z" . writeroom-mode))

;; GENERAL KEYBINDINGS

  (use-package general
    :ensure t
    :config
    (general-create-definer styrman/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")

    (styrman/leader-keys
     "." '(find-file :wk "Find file") 
     "TAB TAB" '(comment-line :wk "Comment lines")
     "z" '(writeroom-mode :wk "Writeroom Mode")
     "e" '(eshell :wk "Eshell"))

    (styrman/leader-keys
    "b" '(:ignore t :wk "Bookmarks/Buffers")
    "b b" '(switch-to-buffer :wk "Switch to buffer")
    "b d" '(bookmark-delete :wk "Delete bookmark")
    "b i" '(ibuffer :wk "Ibuffer")
    "b k" '(kill-current-buffer :wk "Kill current buffer")
    "b K" '(kill-some-buffers :wk "Kill multiple buffers")
    "b l" '(list-bookmarks :wk "List bookmarks")
    "b m" '(bookmark-set :wk "Set bookmark")
    "b n" '(next-buffer :wk "Next buffer")
    "b p" '(previous-buffer :wk "Previous buffer")
    "b r" '(revert-buffer :wk "Reload buffer")
    "b s" '(basic-save-buffer :wk "Save buffer")
    "b S" '(save-some-buffers :wk "Save multiple buffers"))

    (styrman/leader-keys
      "n" '(:ignore t :wk "org-roam")
      "nt" '(org-roam-buffer-toggle t :wk "org-roam-buffer-toggle")
      "nf" '(org-roam-node-find t :wk "org-roam-node-find")
      "ni" '(org-roam-node-insert t :wk "org-roam-node-insert"))


    (styrman/leader-keys
    "d" '(:ignore t :wk "Dired")
    "d d" '(dired :wk "Open dired")
    "d j" '(dired-jump :wk "Dired jump to current"))

    (styrman/leader-keys
    "w" '(:ignore t :wk "Windows")
    ;; Window splits
    "w c" '(evil-window-delete :wk "Close window")
    "w n" '(evil-window-new :wk "New window")
    "w s" '(evil-window-split :wk "Horizontal split window")
    "w v" '(evil-window-vsplit :wk "Vertical split window")
    ;; Window motions
    "w h" '(evil-window-left :wk "Window left")
    "w j" '(evil-window-down :wk "Window down")
    "w k" '(evil-window-up :wk "Window up")
    "w l" '(evil-window-right :wk "Window right")
    "w w" '(evil-window-next :wk "Goto next window"))
    )

  ;; Set a keybinding for org-agenda.
  (global-set-key (kbd "C-c a") 'org-agenda)

  ;; Keybinding for copy and paste
  (global-set-key (kbd "C-c y") 'yank-from-kill-ring)

  ;; Set a keybinding for ESHELL
  (global-set-key (kbd "C-c e") 'eshell)

  ;; Minibuffer escape
  (global-set-key [escape] 'keyboard-escape-quit)







