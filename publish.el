;; -*- lexical-binding: t; -*-
(require 'ox-publish)
(require 'htmlize)

(setq org-html-htmlize-output-type 'inline-css)
(setq org-src-fontify-natively t)

(require 'font-lock)
(let ((buf (get-buffer-create "*fontlock-init*")))
  (with-current-buffer buf
    (emacs-lisp-mode)
    (font-lock-ensure))
  (kill-buffer buf))

(setq base-dir (expand-file-name "."))

(setq org-publish-project-alist
      `(("site-content"
         :base-directory ,(expand-file-name "pages" base-dir)
         :publishing-directory ,(expand-file-name "out" base-dir)
         :recursive t
         :publishing-function org-html-publish-to-html
         :with-toc nil
         :html-head-include-default-style nil
         :html-head "<link rel=\"stylesheet\" href=\"../assets/style.css\" />")

        ("site-static"
         :base-directory ,(expand-file-name "assets" base-dir)
         :base-extension "css\\|js\\|png\\|jpg\\|svg\\|woff2\\|otf\\|ttf"
         :publishing-directory ,(expand-file-name "out/assets" base-dir)
         :recursive t
         :publishing-function org-publish-attachment)

        ("site" :components ("site-content" "site-static"))))

