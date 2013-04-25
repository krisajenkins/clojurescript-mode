;;; clojurescript-mode.el --- Major mode for ClojureScript code.

;; Copyright 2013 Kris Jenkins
;; Author: Kris Jenkins
;; URL: https://github.com/krisajenkins/clojurescript-mode
;; Package-Requires: ((clojure-mode "0") (evil-mode "0") (nrepl-eval-sexp-fu "0"))
;; Version: 0.1.0

;;; Commentary:
;;
;; A major mode for ClojureScript.  If you're reading this, be warned -
;; these are my personal preferences and will probably not suit
;; you.  Read for inspiration, but expect to have to customize...

(require 'clojure-mode)
(require 'nrepl-eval-sexp-fu)

;;; Code:
(defgroup clojurescript nil
  "A major mode for ClojureScript"
  :group 'languages)

;;;###autoload
(defcustom clojurescript-mode/file-extension ".cljs"
  "ClojureScript file extension."
  :type 'string
  :group 'clojurescript)

;;;###autoload
(define-derived-mode clojurescript-mode clojure-mode "ClojureScript"
					 "Major mode for ClojureScript"
					 (set (make-local-variable 'inferior-lisp-program) "lein cljs-repl")
					 (evil-define-key 'normal clojurescript-mode-map "\M-e" 'clojurescript-mode/eval-under-point)
					 (evil-define-key 'insert clojurescript-mode-map "\M-e" 'clojurescript-mode/eval-under-point))

;;;###autoload
(defun clojurescript-mode/eval-under-point ()
  "Evaluates the form under the point. If there is a buffer named 'afterthought', it will execute its contents immediately afterwards."
  (interactive)
  (lisp-eval-defun)
  (let ((afterthought (get-buffer "afterthought")))
	(when (and afterthought
			   (not (equal afterthought (current-buffer))))
	  (save-current-buffer
		(set-buffer afterthought)
		(lisp-eval-region (point-min) (point-max))))))

;;;###autoload
(defadvice lisp-eval-region (around lisp-eval-region-flash activate)
  "Flash any calls to lisp-eval-region."
  (let* ((start (ad-get-arg 0))
		 (end (ad-get-arg 1))
		 (flasher (nrepl-eval-sexp-fu-flash (cons start end)))
		 (hi (cadr flasher))
		 (unhi (caddr flasher)))
	(nrepl-eval-sexp-fu-flash-doit-simple '(lambda () ad-do-it) hi unhi)))

;;;###autoload
(when clojurescript-mode/file-extension
	(add-to-list 'auto-mode-alist (cons (rx-to-string clojurescript-mode/file-extension) 'clojurescript-mode)))

(provide 'clojurescript-mode)
;;; clojurescript-mode.el ends here
