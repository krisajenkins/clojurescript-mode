;;; clojurescript-mode.el --- Major mode for ClojureScript code.

;; Copyright 2013 Kris Jenkins
;; Author: Kris Jenkins
;; URL: https://github.com/krisajenkins/clojurescript-mode
;; Package-Requires: ((clojure-mode "0") (evil-mode "0"))
;; Version: 0.1.0

;;; Commentary:
;;
;; A major mode for ClojureScript.  If you're reading this, be warned -
;; these are my personal preferences and will probably not suit
;; you.  Read for inspiration, but expect to have to customize...

;;; Code:

(require 'clojure-mode)
(require 'evil)

;;;###autoload
(defun clojurescript-mode/eval-under-point ()
  "Evaluate the form under the point.
If there is a buffer named 'afterthought', it will execute its contents immediately afterwards."
  (interactive)
  (lisp-eval-defun)
  (let ((afterthought (get-buffer "afterthought")))
    (when (and afterthought
	       (not (equal afterthought (current-buffer))))
      (save-current-buffer
	(set-buffer afterthought)
	(lisp-eval-region (point-min) (point-max))))))

;;;###autoload
(defvar clojurescript-mode-map
  (let ((map (make-sparse-keymap)))
    (evil-define-key 'normal clojurescript-mode-map "\M-e" 'clojurescript-mode/eval-under-point)
    (evil-define-key 'normal clojurescript-mode-map "\M-e" 'clojurescript-mode/eval-under-point)
    map)
  "Keymap for ClojureScript mode.  Inherits from `clojure-mode-map'.")

;;;###autoload
(define-derived-mode clojurescript-mode clojure-mode "ClojureScript"
  "Major mode for ClojureScript"
  (setq-local inferior-lisp-program "lein cljs-repl"))

;;;###autoload
(add-to-list 'auto-mode-alist (cons "\\.cljs$" 'clojurescript-mode))

(provide 'clojurescript-mode)
;;; clojurescript-mode.el ends here
