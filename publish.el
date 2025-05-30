;; -*- lexical-binding: t; -*-
(require 'package)
(package-initialize)

(require 'ox-publish)
(require 'htmlize)

(setq org-html-htmlize-output-type 'css)
(setq org-src-fontify-natively t)
(setq org-html-validation-link nil)

(global-font-lock-mode t)

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
         :html-postamble nil

        ("site-static"
         :base-directory ,(expand-file-name "assets" base-dir)
         :base-extension "css\\|js\\|png\\|jpg\\|svg\\|woff2\\|otf\\|ttf"
         :publishing-directory ,(expand-file-name "out/assets" base-dir)
         :recursive t
         :publishing-function org-publish-attachment)

        ("site" :components ("site-content" "site-static"))))

