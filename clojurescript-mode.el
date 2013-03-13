(require 'clojure-mode)

;;;###autoload
(define-derived-mode clojurescript-mode clojure-mode "ClojureScript"
					 "Major mode for ClojureScript"
					 (set (make-local-variable 'inferior-lisp-program) "lein cljs-repl")
					 (evil-define-key 'normal clojurescript-mode-map "\M-e" 'lisp-eval-defun)
					 (evil-define-key 'insert clojurescript-mode-map "\M-e" 'lisp-eval-defun))

;;;###autoload
(defadvice lisp-eval-region (around lisp-eval-region-flash activate)
  "Flash any calls to lisp-eval-region."
  (let* ((start (ad-get-arg 0))
		 (end (ad-get-arg 1))
		 (flasher (nrepl-eval-sexp-fu-flash `(,start . ,end)))
		 (hi (cadr flasher))
		 (unhi (caddr flasher)))
	(nrepl-eval-sexp-fu-flash-doit-simple '(lambda () ad-do-it) hi unhi)))

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.cljs$" . clojurescript-mode))

(provide 'clojurescript-mode)
;;; clojurescript-mode.el ends here
