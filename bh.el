;; Do not dim blocked tasks
(setq org-agenda-dim-blocked-tasks nil)

(defun bh/verify-refile-target ()
	"Exclude todo keywords with a done state from refile targets"
	(not (member (nth 2 (org-heading-components)) org-done-keywords)))

;; Compact the block agenda view
(setq org-agenda-compact-blocks t)
(defun bh/hide-other ()
	(interactive)
	(save-excursion
		(org-back-to-heading 'invisible-ok)
		(hide-other)
		(org-cycle)
		(org-cycle)
		(org-cycle)))

(defun bh/set-truncate-lines ()
	"Toggle value of truncate-lines and refresh window display."
	(interactive)
	(setq truncate-lines (not truncate-lines))
	;; now refresh window display (an idiom from simple.el):
	(save-excursion
		(set-window-start (selected-window)
											(window-start (selected-window)))))

(defun bh/make-org-scratch ()
	(interactive)
	(find-file "/tmp/publish/scratch.org")
	(gnus-make-directory "/tmp/publish"))

(defun bh/switch-to-scratch ()
	(interactive)
	(switch-to-buffer "*scratch*"))

(defun bh/find-project-task ()
	"Move point to the parent (project) task if any"
	(save-restriction
		(widen)
		(let ((parent-task (save-excursion (org-back-to-heading 'invisible-ok) (point))))
			(while (org-up-heading-safe)
				(when (member (nth 2 (org-heading-components)) org-todo-keywords-1)
					(setq parent-task (point))))
			(goto-char parent-task)
			parent-task)))

(defun org-is-habit-p (&optional pom)
	"Is the task at POM or point a habit?"
	(string= "habit" (org-entry-get (or pom (point)) "STYLE")))

(defvar bh/hide-scheduled-and-waiting-next-tasks t)

(defun bh/is-project-p ()
	"Any task with a todo keyword subtask"
	(save-restriction
		(widen)
		(let ((has-subtask)
					(subtree-end (save-excursion (org-end-of-subtree t)))
					(is-a-task (member (nth 2 (org-heading-components)) org-todo-keywords-1)))
			(save-excursion
				(forward-line 1)
				(while (and (not has-subtask)
										(< (point) subtree-end)
										(re-search-forward "^\*+ " subtree-end t))
					(when (member (org-get-todo-state) org-todo-keywords-1)
						(setq has-subtask t))))
			(and is-a-task has-subtask))))

(defun bh/is-project-subtree-p ()
	"Any task with a todo keyword that is in a project subtree.
Callers of this function already widen the buffer view."
	(let ((task (save-excursion (org-back-to-heading 'invisible-ok)
															(point))))
		(save-excursion
			(bh/find-project-task)
			(if (equal (point) task)
					nil
				t))))

(defun bh/is-task-p ()
	"Any task with a todo keyword and no subtask"
	(save-restriction
		(widen)
		(let ((has-subtask)
					(subtree-end (save-excursion (org-end-of-subtree t)))
					(is-a-task (member (nth 2 (org-heading-components)) org-todo-keywords-1)))
			(save-excursion
				(forward-line 1)
				(while (and (not has-subtask)
										(< (point) subtree-end)
										(re-search-forward "^\*+ " subtree-end t))
					(when (member (org-get-todo-state) org-todo-keywords-1)
						(setq has-subtask t))))
			(and is-a-task (not has-subtask)))))

(defun bh/is-subproject-p ()
	"Any task which is a subtask of another project"
	(let ((is-subproject)
				(is-a-task (member (nth 2 (org-heading-components)) org-todo-keywords-1)))
		(save-excursion
			(while (and (not is-subproject) (org-up-heading-safe))
				(when (member (nth 2 (org-heading-components)) org-todo-keywords-1)
					(setq is-subproject t))))
		(and is-a-task is-subproject)))

(defun bh/list-sublevels-for-projects-indented ()
	"Set org-tags-match-list-sublevels so when restricted to a subtree we list all subtasks.
	This is normally used by skipping functions where this variable is already local to the agenda."
	(if (marker-buffer org-agenda-restrict-begin)
			(setq org-tags-match-list-sublevels 'indented)
		(setq org-tags-match-list-sublevels nil))
	nil)

(defun bh/list-sublevels-for-projects ()
	"Set org-tags-match-list-sublevels so when restricted to a subtree we list all subtasks.
	This is normally used by skipping functions where this variable is already local to the agenda."
	(if (marker-buffer org-agenda-restrict-begin)
			(setq org-tags-match-list-sublevels t)
		(setq org-tags-match-list-sublevels nil))
	nil)

(defvar bh/hide-scheduled-and-waiting-next-tasks t)

(defun bh/toggle-next-task-display ()
	(interactive)
	(setq bh/hide-scheduled-and-waiting-next-tasks (not bh/hide-scheduled-and-waiting-next-tasks))
	(when	 (equal major-mode 'org-agenda-mode)
		(org-agenda-redo))
	(message "%s WAITING and SCHEDULED NEXT Tasks" (if bh/hide-scheduled-and-waiting-next-tasks "Hide" "Show")))

(defun bh/skip-stuck-projects ()
	"Skip trees that are not stuck projects"
	(save-restriction
		(widen)
		(let ((next-headline (save-excursion (or (outline-next-heading) (point-max)))))
			(if (bh/is-project-p)
					(let* ((subtree-end (save-excursion (org-end-of-subtree t)))
								 (has-next ))
						(save-excursion
							(forward-line 1)
							(while (and (not has-next) (< (point) subtree-end) (re-search-forward "^\\*+ NEXT " subtree-end t))
								(unless (member "WAITING" (org-get-tags-at))
									(setq has-next t))))
						(if has-next
								nil
							next-headline)) ; a stuck project, has subtasks but no next task
				nil))))

(defun bh/skip-non-stuck-projects ()
	"Skip trees that are not stuck projects"
	;; (bh/list-sublevels-for-projects-indented)
	(save-restriction
		(widen)
		(let ((next-headline (save-excursion (or (outline-next-heading) (point-max)))))
			(if (bh/is-project-p)
					(let* ((subtree-end (save-excursion (org-end-of-subtree t)))
								 (has-next ))
						(save-excursion
							(forward-line 1)
							(while (and (not has-next) (< (point) subtree-end) (re-search-forward "^\\*+ NEXT " subtree-end t))
								(unless (member "WAITING" (org-get-tags-at))
									(setq has-next t))))
						(if has-next
								next-headline
							nil)) ; a stuck project, has subtasks but no next task
				next-headline))))

(defun bh/skip-non-archivable-tasks ()
	"Skip trees that are not available for archiving"
	(save-restriction
		(widen)
		;; Consider only tasks with done todo headings as archivable candidates
		(let ((next-headline (save-excursion (or (outline-next-heading) (point-max))))
					(subtree-end (save-excursion (org-end-of-subtree t))))
			(if (member (org-get-todo-state) org-todo-keywords-1)
					(if (member (org-get-todo-state) org-done-keywords)
							(let* ((daynr (string-to-int (format-time-string "%d" (current-time))))
										 (a-month-ago (* 60 60 24 (+ daynr 1)))
										 (last-month (format-time-string "%Y-%m-" (time-subtract (current-time) (seconds-to-time a-month-ago))))
										 (this-month (format-time-string "%Y-%m-" (current-time)))
										 (subtree-is-current (save-excursion
																					 (forward-line 1)
																					 (and (< (point) subtree-end)
																								(re-search-forward (concat last-month "\\|" this-month) subtree-end t)))))
								(if subtree-is-current
										subtree-end ; Has a date in this month or last month, skip it
									nil))	 ; available to archive
						(or subtree-end (point-max)))
				next-headline))))

(defun bh/skip-non-projects ()
	"Skip trees that are not projects"
	;; (bh/list-sublevels-for-projects-indented)
	(if (save-excursion (bh/skip-non-stuck-projects))
			(save-restriction
				(widen)
				(let ((subtree-end (save-excursion (org-end-of-subtree t))))
					(cond
					 ((bh/is-project-p)
						nil)
					 ((and (bh/is-project-subtree-p) (not (bh/is-task-p)))
						nil)
					 (t
						subtree-end))))
		(save-excursion (org-end-of-subtree t))))

(defun bh/skip-non-tasks ()
	"Show non-project tasks.
Skip project and sub-project tasks, habits, and project related tasks."
	(save-restriction
		(widen)
		(let ((next-headline (save-excursion (or (outline-next-heading) (point-max)))))
			(cond
			 ((bh/is-task-p)
				nil)
			 (t
				next-headline)))))

(defun bh/skip-project-trees-and-habits ()
	"Skip trees that are projects"
	(save-restriction
		(widen)
		(let ((subtree-end (save-excursion (org-end-of-subtree t))))
			(cond
			 ((bh/is-project-p)
				subtree-end)
			 ((org-is-habit-p)
				subtree-end)
			 (t
				nil)))))

(defun bh/skip-projects-and-habits-and-single-tasks ()
	"Skip trees that are projects, tasks that are habits, single non-project tasks"
	(save-restriction
		(widen)
		(let ((next-headline (save-excursion (or (outline-next-heading) (point-max)))))
			(cond
			 ((org-is-habit-p)
				next-headline)
			 ((and bh/hide-scheduled-and-waiting-next-tasks
						 (member "WAITING" (org-get-tags-at)))
				next-headline)
			 ((bh/is-project-p)
				next-headline)
			 ((and (bh/is-task-p) (not (bh/is-project-subtree-p)))
				next-headline)
			 (t
				nil)))))

(defun bh/skip-project-tasks-maybe ()
	"Show tasks related to the current restriction.
When restricted to a project, skip project and sub project tasks, habits, NEXT tasks, and loose tasks.
When not restricted, skip project and sub-project tasks, habits, and project related tasks."
	(save-restriction
		(widen)
		(let* ((subtree-end (save-excursion (org-end-of-subtree t)))
					 (next-headline (save-excursion (or (outline-next-heading) (point-max))))
					 (limit-to-project (marker-buffer org-agenda-restrict-begin)))
			(cond
			 ((bh/is-project-p)
				next-headline)
			 ((org-is-habit-p)
				subtree-end)
			 ((and (not limit-to-project)
						 (bh/is-project-subtree-p))
				subtree-end)
			 ((and limit-to-project
						 (bh/is-project-subtree-p)
						 (member (org-get-todo-state) (list "NEXT")))
				subtree-end)
			 (t
				nil)))))

(defun bh/skip-project-tasks ()
	"Show non-project tasks.
Skip project and sub-project tasks, habits, and project related tasks."
	(save-restriction
		(widen)
		(let* ((subtree-end (save-excursion (org-end-of-subtree t))))
			(cond
			 ((bh/is-project-p)
				subtree-end)
			 ((org-is-habit-p)
				subtree-end)
			 ((bh/is-project-subtree-p)
				subtree-end)
			 (t
				nil)))))

(defun bh/skip-non-project-tasks ()
	"Show project tasks.
Skip project and sub-project tasks, habits, and loose non-project tasks."
	(save-restriction
		(widen)
		(let* ((subtree-end (save-excursion (org-end-of-subtree t)))
					 (next-headline (save-excursion (or (outline-next-heading) (point-max)))))
			(cond
			 ((bh/is-project-p)
				next-headline)
			 ((org-is-habit-p)
				subtree-end)
			 ((and (bh/is-project-subtree-p)
						 (member (org-get-todo-state) (list "NEXT")))
				subtree-end)
			 ((not (bh/is-project-subtree-p))
				subtree-end)
			 (t
				nil)))))

(defun bh/skip-projects-and-habits ()
	"Skip trees that are projects and tasks that are habits"
	(save-restriction
		(widen)
		(let ((subtree-end (save-excursion (org-end-of-subtree t))))
			(cond
			 ((bh/is-project-p)
				subtree-end)
			 ((org-is-habit-p)
				subtree-end)
			 (t
				nil)))))

(defun bh/skip-non-subprojects ()
	"Skip trees that are not projects"
	(let ((next-headline (save-excursion (outline-next-heading))))
		(if (bh/is-subproject-p)
				nil
			next-headline)))
(defun bh/clock-in-to-next (kw)
	"Switch a task from TODO to NEXT when clocking in.
Skips capture tasks, projects, and subprojects.
Switch projects and subprojects from NEXT back to TODO"
	(when (not (and (boundp 'org-capture-mode) org-capture-mode))
		(cond
		 ((and (member (org-get-todo-state) (list "TODO"))
					 (bh/is-task-p))
			"NEXT")
		 ((and (member (org-get-todo-state) (list "NEXT"))
					 (bh/is-project-p))
			"TODO"))))

(defun bh/find-project-task ()
	"Move point to the parent (project) task if any"
	(save-restriction
		(widen)
		(let ((parent-task (save-excursion (org-back-to-heading 'invisible-ok) (point))))
			(while (org-up-heading-safe)
				(when (member (nth 2 (org-heading-components)) org-todo-keywords-1)
					(setq parent-task (point))))
			(goto-char parent-task)
			parent-task)))

(defun bh/punch-in (arg)
	"Start continuous clocking and set the default task to the
selected task.	If no task is selected set the Organization task
as the default task."
	(interactive "p")
	(setq bh/keep-clock-running t)
	(if (equal major-mode 'org-agenda-mode)
			;;
			;; We're in the agenda
			;;
			(let* ((marker (org-get-at-bol 'org-hd-marker))
						 (tags (org-with-point-at marker (org-get-tags-at))))
				(if (and (eq arg 4) tags)
						(org-agenda-clock-in '(16))
					(bh/clock-in-organization-task-as-default)))
		;;
		;; We are not in the agenda
		;;
		(save-restriction
			(widen)
			; Find the tags on the current task
			(if (and (equal major-mode 'org-mode) (not (org-before-first-heading-p)) (eq arg 4))
					(org-clock-in '(16))
				(bh/clock-in-organization-task-as-default)))))

(defun bh/punch-out ()
	(interactive)
	(setq bh/keep-clock-running nil)
	(when (org-clock-is-active)
		(org-clock-out))
	(org-agenda-remove-restriction-lock))

(defun bh/clock-in-default-task ()
	(save-excursion
		(org-with-point-at org-clock-default-task
			(org-clock-in))))

(defun bh/clock-in-parent-task ()
	"Move point to the parent (project) task if any and clock in"
	(let ((parent-task))
		(save-excursion
			(save-restriction
				(widen)
				(while (and (not parent-task) (org-up-heading-safe))
					(when (member (nth 2 (org-heading-components)) org-todo-keywords-1)
						(setq parent-task (point))))
				(if parent-task
						(org-with-point-at parent-task
							(org-clock-in))
					(when bh/keep-clock-running
						(bh/clock-in-default-task)))))))

(defvar bh/organization-task-id 123)
(defvar bh/codereview-task-id 678)
(defvar bh/personal-organization-task-id 54321)
(defvar bh/support-task-id 11111)
(defvar bh/break-task-id 13579)
(defvar bh/keep-clock-running nil)

(defun bh/clock-in-support-task ()
	(interactive)
	(org-with-point-at (org-id-find bh/support-task-id 'marker)
		(org-clock-in '(16))))

(defun bh/clock-in-organization-task-as-default ()
	(interactive)
	(org-with-point-at (org-id-find bh/organization-task-id 'marker)
		(org-clock-in '(16))))

(defun bh/clock-in-codereview-task ()
	(interactive)
	(org-with-point-at (org-id-find bh/codereview-task-id 'marker)
		(org-clock-in '(16))))

(defun bh/clock-in-personal-organization-task ()
	(interactive)
	(org-with-point-at (org-id-find bh/personal-organization-task-id 'marker)
		(org-clock-in '(16))))

(defun bh/clock-in-break-task ()
	(interactive)
	(org-with-point-at (org-id-find bh/break-task-id 'marker)
		(org-clock-in '(16))))

(defun bh/clock-out-maybe ()
	(when (and bh/keep-clock-running
						 (not org-clock-clocking-in)
						 (marker-buffer org-clock-default-task)
						 (not org-clock-resolving-clocks-due-to-idleness))
		(bh/clock-in-parent-task)))

(add-hook 'org-clock-out-hook 'bh/clock-out-maybe 'append)
(defun bh/clock-in-last-task (arg)
	"Clock in the interrupted task if there is one
Skip the default task and get the next one.
A prefix arg forces clock in of the default task."
	(interactive "p")
	(let ((clock-in-to-task
				 (cond
					((eq arg 4) org-clock-default-task)
					((and (org-clock-is-active)
								(equal org-clock-default-task (cadr org-clock-history)))
					 (caddr org-clock-history))
					((org-clock-is-active) (cadr org-clock-history))
					((equal org-clock-default-task (car org-clock-history)) (cadr org-clock-history))
					(t (car org-clock-history)))))
		(widen)
		(org-with-point-at clock-in-to-task
			(org-clock-in nil))))

(defun bh/org-todo (arg)
	(interactive "p")
	(if (equal arg 4)
			(save-restriction
				(bh/narrow-to-org-subtree)
				(org-show-todo-tree nil))
		(bh/narrow-to-org-subtree)
		(org-show-todo-tree nil)))

(defun bh/widen ()
	(interactive)
	(if (equal major-mode 'org-agenda-mode)
			(progn
				(org-agenda-remove-restriction-lock)
				(when org-agenda-sticky
					(org-agenda-redo)))
		(widen)))

(add-hook 'org-agenda-mode-hook
					'(lambda () (org-defkey org-agenda-mode-map "W" (lambda () (interactive) (setq bh/hide-scheduled-and-waiting-next-tasks t) (bh/widen))))
					'append)

(defun bh/restrict-to-file-or-follow (arg)
	"Set agenda restriction to 'file or with argument invoke follow mode.
I don't use follow mode very often but I restrict to file all the time
so change the default 'F' binding in the agenda to allow both"
	(interactive "p")
	(if (equal arg 4)
			(org-agenda-follow-mode)
		(widen)
		(bh/set-agenda-restriction-lock 4)
		(org-agenda-redo)
		(beginning-of-buffer)))

(add-hook 'org-agenda-mode-hook
					'(lambda () (org-defkey org-agenda-mode-map "F" 'bh/restrict-to-file-or-follow))
					'append)

(defun bh/narrow-to-org-subtree ()
	(widen)
	(org-narrow-to-subtree)
	(save-restriction
		(org-agenda-set-restriction-lock)))

(defun bh/narrow-to-subtree ()
	(interactive)
	(if (equal major-mode 'org-agenda-mode)
			(progn
				(org-with-point-at (org-get-at-bol 'org-hd-marker)
					(bh/narrow-to-org-subtree))
				(when org-agenda-sticky
					(org-agenda-redo)))
		(bh/narrow-to-org-subtree)))

(add-hook 'org-agenda-mode-hook
					'(lambda () (org-defkey org-agenda-mode-map "N" 'bh/narrow-to-subtree))
					'append)

(defun bh/narrow-up-one-org-level ()
	(widen)
	(save-excursion
		(outline-up-heading 1 'invisible-ok)
		(bh/narrow-to-org-subtree)))

(defun bh/get-pom-from-agenda-restriction-or-point ()
	(or (and (marker-position org-agenda-restrict-begin) org-agenda-restrict-begin)
			(org-get-at-bol 'org-hd-marker)
			(and (equal major-mode 'org-mode) (point))
			org-clock-marker))

(defun bh/narrow-up-one-level ()
	(interactive)
	(if (equal major-mode 'org-agenda-mode)
			(progn
				(org-with-point-at (bh/get-pom-from-agenda-restriction-or-point)
					(bh/narrow-up-one-org-level))
				(org-agenda-redo))
		(bh/narrow-up-one-org-level)))

(add-hook 'org-agenda-mode-hook
					'(lambda () (org-defkey org-agenda-mode-map "U" 'bh/narrow-up-one-level))
					'append)

(defun bh/narrow-to-org-project ()
	(widen)
	(save-excursion
		(bh/find-project-task)
		(bh/narrow-to-org-subtree)))

(defun bh/narrow-to-project ()
	(interactive)
	(if (equal major-mode 'org-agenda-mode)
			(progn
				(org-with-point-at (bh/get-pom-from-agenda-restriction-or-point)
					(bh/narrow-to-org-project)
					(save-excursion
						(bh/find-project-task)
						(org-agenda-set-restriction-lock)))
				(org-agenda-redo)
				(beginning-of-buffer))
		(bh/narrow-to-org-project)
		(save-restriction
			(org-agenda-set-restriction-lock))))

(add-hook 'org-agenda-mode-hook
					'(lambda () (org-defkey org-agenda-mode-map "P" 'bh/narrow-to-project))
					'append)

(defvar bh/project-list nil)

(defun bh/view-next-project ()
	(interactive)
	(let (num-project-left current-project)
		(unless (marker-position org-agenda-restrict-begin)
			(goto-char (point-min))
			; Clear all of the existing markers on the list
			(while bh/project-list
				(set-marker (pop bh/project-list) nil))
			(re-search-forward "Tasks to Refile")
			(forward-visible-line 1))

		; Build a new project marker list
		(unless bh/project-list
			(while (< (point) (point-max))
				(while (and (< (point) (point-max))
										(or (not (org-get-at-bol 'org-hd-marker))
												(org-with-point-at (org-get-at-bol 'org-hd-marker)
													(or (not (bh/is-project-p))
															(bh/is-project-subtree-p)))))
					(forward-visible-line 1))
				(when (< (point) (point-max))
					(add-to-list 'bh/project-list (copy-marker (org-get-at-bol 'org-hd-marker)) 'append))
				(forward-visible-line 1)))

		; Pop off the first marker on the list and display
		(setq current-project (pop bh/project-list))
		(when current-project
			(org-with-point-at current-project
				(setq bh/hide-scheduled-and-waiting-next-tasks nil)
				(bh/narrow-to-project))
			; Remove the marker
			(setq current-project nil)
			(org-agenda-redo)
			(beginning-of-buffer)
			(setq num-projects-left (length bh/project-list))
			(if (> num-projects-left 0)
					(message "%s projects left to view" num-projects-left)
				(beginning-of-buffer)
				(setq bh/hide-scheduled-and-waiting-next-tasks t)
				(error "All projects viewed.")))))

(add-hook 'org-agenda-mode-hook
					'(lambda () (org-defkey org-agenda-mode-map "A" 'bh/view-next-project))
					'append)

;;
;; Agenda sorting functions
;;
(setq org-agenda-cmp-user-defined 'bh/agenda-sort)

(defun org-cmp-priority (a b)
	"Compare the priorities of string A and B."
	(let ((pa (or (get-text-property 1 'priority a) 0))
	(pb (or (get-text-property 1 'priority b) 0)))
	(cond ((> pa pb) +1)
				((< pa pb) -1)
				(t nil))))
(defun bh/agenda-sort (a b)
	"Sorting strategy for agenda items.
Late deadlines first, then scheduled, then non-late deadlines"
	(let (result num-a num-b)
		(cond
		 ; time specific items are already sorted first by org-agenda-sorting-strategy

		 ; non-deadline and non-scheduled items next
		 ((bh/agenda-sort-test 'bh/is-not-scheduled-or-deadline a b))

		 ; deadlines for today next
		 ((bh/agenda-sort-test 'bh/is-due-deadline a b))

		 ; late deadlines next
		 ((bh/agenda-sort-test-num 'bh/is-late-deadline '> a b))

		 ; scheduled items for today next
		 ((bh/agenda-sort-test 'bh/is-scheduled-today a b))

		 ; late scheduled items next
		 ((bh/agenda-sort-test-num 'bh/is-scheduled-late '> a b))

		 ; pending deadlines last
		 ((bh/agenda-sort-test-num 'bh/is-pending-deadline '< a b))

		 (t (setq result nil)))
		result))

(defmacro bh/agenda-sort-test (fn a b)
	"Test for agenda sort"
	`(cond
		; if both match leave them unsorted
		((and (apply ,fn (list ,a))
					(apply ,fn (list ,b)))
		 (setq result nil))
		; if a matches put a first
		((apply ,fn (list ,a))
		 (setq result -1))
		; otherwise if b matches put b first
		((apply ,fn (list ,b))
		 (setq result 1))
		; if none match leave them unsorted
		(t nil)))

(defmacro bh/agenda-sort-test-num (fn compfn a b)
	`(cond
		((apply ,fn (list ,a))
		 (setq num-a (string-to-number (match-string 1 ,a)))
		 (if (apply ,fn (list ,b))
				 (progn
					 (setq num-b (string-to-number (match-string 1 ,b)))
					 (setq result (if (apply ,compfn (list num-a num-b))
														-1
													1)))
			 (setq result -1)))
		((apply ,fn (list ,b))
		 (setq result 1))
		(t nil)))

(defun bh/is-not-scheduled-or-deadline (date-str)
	(and (not (bh/is-deadline date-str))
			 (not (bh/is-scheduled date-str))))

(defun bh/is-due-deadline (date-str)
	(string-match "Deadline:" date-str))

(defun bh/is-late-deadline (date-str)
	(string-match "\\([0-9]*\\) d\. ago:" date-str))

(defun bh/is-pending-deadline (date-str)
	(string-match "In \\([^-]*\\)d\.:" date-str))

(defun bh/is-deadline (date-str)
	(or (bh/is-due-deadline date-str)
			(bh/is-late-deadline date-str)
			(bh/is-pending-deadline date-str)))

(defun bh/is-scheduled (date-str)
	(or (bh/is-scheduled-today date-str)
			(bh/is-scheduled-late date-str)))

(defun bh/is-scheduled-today (date-str)
	(string-match "Scheduled:" date-str))

(defun bh/is-scheduled-late (date-str)
	(string-match "Sched\.\\(.*\\)x:" date-str))

;;; org-habit.el --- The habit tracking code for Org -*- lexical-binding: t; -*-

;; Copyright (C) 2009-2016 Free Software Foundation, Inc.

;; Author: John Wiegley <johnw at gnu dot org>
;; Keywords: outlines, hypermedia, calendar, wp
;; Homepage: http://orgmode.org
;;
;; This file is part of GNU Emacs.
;;
;; GNU Emacs is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	 See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.	If not, see <http://www.gnu.org/licenses/>.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Commentary:

;; This file contains the habit tracking code for Org-mode

;;; Code:

(require 'org)
(require 'org-agenda)

(eval-when-compile
	(require 'cl))

(defgroup org-habit nil
	"Options concerning habit tracking in Org-mode."
	:tag "Org Habit"
	:group 'org-progress)

(defcustom org-habit-graph-column 40
	"The absolute column at which to insert habit consistency graphs.
Note that consistency graphs will overwrite anything else in the buffer."
	:group 'org-habit
	:type 'integer)

(defcustom org-habit-preceding-days 21
	"Number of days before today to appear in consistency graphs."
	:group 'org-habit
	:type 'integer)

(defcustom org-habit-following-days 7
	"Number of days after today to appear in consistency graphs."
	:group 'org-habit
	:type 'integer)

(defcustom org-habit-show-habits t
	"If non-nil, show habits in agenda buffers."
	:group 'org-habit
	:type 'boolean)

(defcustom org-habit-show-habits-only-for-today t
	"If non-nil, only show habits on today's agenda, and not for future days.
Note that even when shown for future days, the graph is always
relative to the current effective date."
	:group 'org-habit
	:type 'boolean)

(defcustom org-habit-show-all-today nil
	"If non-nil, will show the consistency graph of all habits on
today's agenda, even if they are not scheduled."
	:group 'org-habit
	:type 'boolean)

(defcustom org-habit-today-glyph ?!
	"Glyph character used to identify today."
	:group 'org-habit
	:version "24.1"
	:type 'character)

(defcustom org-habit-completed-glyph ?*
	"Glyph character used to show completed days on which a task was done."
	:group 'org-habit
	:version "24.1"
	:type 'character)

(defcustom org-habit-show-done-always-green nil
	"Non-nil means DONE days will always be green in the consistency graph.
It will be green even if it was done after the deadline."
	:group 'org-habit
	:type 'boolean)

(defface org-habit-clear-face
	'((((background light)) (:background "#8270f9"))
		(((background dark)) (:background "blue")))
	"Face for days on which a task shouldn't be done yet."
	:group 'org-habit
	:group 'org-faces)
(defface org-habit-clear-future-face
	'((((background light)) (:background "#d6e4fc"))
		(((background dark)) (:background "midnightblue")))
	"Face for future days on which a task shouldn't be done yet."
	:group 'org-habit
	:group 'org-faces)

(defface org-habit-ready-face
	'((((background light)) (:background "#4df946"))
		(((background dark)) (:background "forestgreen")))
	"Face for days on which a task should start to be done."
	:group 'org-habit
	:group 'org-faces)
(defface org-habit-ready-future-face
	'((((background light)) (:background "#acfca9"))
		(((background dark)) (:background "darkgreen")))
	"Face for days on which a task should start to be done."
	:group 'org-habit
	:group 'org-faces)

(defface org-habit-alert-face
	'((((background light)) (:background "#f5f946"))
		(((background dark)) (:background "gold")))
	"Face for days on which a task is due."
	:group 'org-habit
	:group 'org-faces)
(defface org-habit-alert-future-face
	'((((background light)) (:background "#fafca9"))
		(((background dark)) (:background "darkgoldenrod")))
	"Face for days on which a task is due."
	:group 'org-habit
	:group 'org-faces)

(defface org-habit-overdue-face
	'((((background light)) (:background "#f9372d"))
		(((background dark)) (:background "firebrick")))
	"Face for days on which a task is overdue."
	:group 'org-habit
	:group 'org-faces)
(defface org-habit-overdue-future-face
	'((((background light)) (:background "#fc9590"))
		(((background dark)) (:background "darkred")))
	"Face for days on which a task is overdue."
	:group 'org-habit
	:group 'org-faces)

(defun org-habit-duration-to-days (ts)
	(if (string-match "\\([0-9]+\\)\\([dwmy]\\)" ts)
			;; lead time is specified.
			(floor (* (string-to-number (match-string 1 ts))
		(cdr (assoc (match-string 2 ts)
					'(("d" . 1)		 ("w" . 7)
						("m" . 30.4) ("y" . 365.25))))))
		(error "Invalid duration string: %s" ts)))

(defun org-is-habit-p (&optional pom)
	"Is the task at POM or point a habit?"
	(string= "habit" (org-entry-get (or pom (point)) "STYLE")))

(defun org-habit-parse-todo (&optional pom)
	"Parse the TODO surrounding point for its habit-related data.
Returns a list with the following elements:

	0: Scheduled date for the habit (may be in the past)
	1: \".+\"-style repeater for the schedule, in days
	2: Optional deadline (nil if not present)
	3: If deadline, the repeater for the deadline, otherwise nil
	4: A list of all the past dates this todo was mark closed
	5: Repeater type as a string

This list represents a \"habit\" for the rest of this module."
	(save-excursion
		(if pom (goto-char pom))
		(assert (org-is-habit-p (point)))
		(let* ((scheduled (org-get-scheduled-time (point)))
		 (scheduled-repeat (org-get-repeat org-scheduled-string))
		 (end (org-entry-end-position))
		 (habit-entry (org-no-properties (nth 4 (org-heading-components))))
		 closed-dates deadline dr-days sr-days sr-type)
			(if scheduled
		(setq scheduled (time-to-days scheduled))
	(error "Habit %s has no scheduled date" habit-entry))
			(unless scheduled-repeat
	(error
	 "Habit `%s' has no scheduled repeat period or has an incorrect one"
	 habit-entry))
			(setq sr-days (org-habit-duration-to-days scheduled-repeat)
			sr-type (progn (string-match "[\\.+]?\\+" scheduled-repeat)
				 (org-match-string-no-properties 0 scheduled-repeat)))
			(unless (> sr-days 0)
	(error "Habit %s scheduled repeat period is less than 1d" habit-entry))
			(when (string-match "/\\([0-9]+[dwmy]\\)" scheduled-repeat)
	(setq dr-days (org-habit-duration-to-days
					 (match-string-no-properties 1 scheduled-repeat)))
	(if (<= dr-days sr-days)
			(error "Habit %s deadline repeat period is less than or equal to scheduled (%s)"
			 habit-entry scheduled-repeat))
	(setq deadline (+ scheduled (- dr-days sr-days))))
			(org-back-to-heading t)
			(let* ((maxdays (+ org-habit-preceding-days org-habit-following-days))
			 (reversed org-log-states-order-reversed)
			 (search (if reversed 're-search-forward 're-search-backward))
			 (limit (if reversed end (point)))
			 (count 0)
			 (re (format
			"^[ \t]*-[ \t]+\\(?:State \"%s\".*%s%s\\)"
			(regexp-opt org-done-keywords)
			org-ts-regexp-inactive
			(let ((value (cdr (assq 'done org-log-note-headings))))
				(if (not value) ""
					(concat "\\|"
						(org-replace-escapes
						 (regexp-quote value)
						 `(("%d" . ,org-ts-regexp-inactive)
				 ("%D" . ,org-ts-regexp)
				 ("%s" . "\"\\S-+\"")
				 ("%S" . "\"\\S-+\"")
				 ("%t" . ,org-ts-regexp-inactive)
				 ("%T" . ,org-ts-regexp)
				 ("%u" . ".*?")
				 ("%U" . ".*?")))))))))
	(unless reversed (goto-char end))
	(while (and (< count maxdays) (funcall search re limit t))
		(push (time-to-days
		 (org-time-string-to-time
			(or (org-match-string-no-properties 1)
					(org-match-string-no-properties 2))))
		closed-dates)
		(setq count (1+ count))))
			(list scheduled sr-days deadline dr-days closed-dates sr-type))))

(defsubst org-habit-scheduled (habit)
	(nth 0 habit))
(defsubst org-habit-scheduled-repeat (habit)
	(nth 1 habit))
(defsubst org-habit-deadline (habit)
	(let ((deadline (nth 2 habit)))
		(or deadline
	(if (nth 3 habit)
			(+ (org-habit-scheduled habit)
				 (1- (org-habit-scheduled-repeat habit)))
		(org-habit-scheduled habit)))))
(defsubst org-habit-deadline-repeat (habit)
	(or (nth 3 habit)
			(org-habit-scheduled-repeat habit)))
(defsubst org-habit-done-dates (habit)
	(nth 4 habit))
(defsubst org-habit-repeat-type (habit)
	(nth 5 habit))

(defsubst org-habit-get-priority (habit &optional moment)
	"Determine the relative priority of a habit.
This must take into account not just urgency, but consistency as well."
	(let ((pri 1000)
	(now (if moment (time-to-days moment) (org-today)))
	(scheduled (org-habit-scheduled habit))
	(deadline (org-habit-deadline habit)))
		;; add 10 for every day past the scheduled date, and subtract for every
		;; day before it
		(setq pri (+ pri (* (- now scheduled) 10)))
		;; add 50 if the deadline is today
		(if (and (/= scheduled deadline)
			 (= now deadline))
	(setq pri (+ pri 50)))
		;; add 100 for every day beyond the deadline date, and subtract 10 for
		;; every day before it
		(let ((slip (- now (1- deadline))))
			(if (> slip 0)
		(setq pri (+ pri (* slip 100)))
	(setq pri (+ pri (* slip 10)))))
		pri))

(defun org-habit-get-faces (habit &optional now-days scheduled-days donep)
	"Return faces for HABIT relative to NOW-DAYS and SCHEDULED-DAYS.
NOW-DAYS defaults to the current time's days-past-the-epoch if nil.
SCHEDULED-DAYS defaults to the habit's actual scheduled days if nil.

Habits are assigned colors on the following basis:
	Blue			Task is before the scheduled date.
	Green			Task is on or after scheduled date, but before the
			end of the schedule's repeat period.
	Yellow		If the task has a deadline, then it is after schedule's
			repeat period, but before the deadline.
	Orange		The task has reached the deadline day, or if there is
			no deadline, the end of the schedule's repeat period.
	Red				The task has gone beyond the deadline day or the
			schedule's repeat period."
	(let* ((scheduled (or scheduled-days (org-habit-scheduled habit)))
	 (s-repeat (org-habit-scheduled-repeat habit))
	 (d-repeat (org-habit-deadline-repeat habit))
	 (deadline (if scheduled-days
					 (+ scheduled-days (- d-repeat s-repeat))
				 (org-habit-deadline habit)))
	 (m-days (or now-days (time-to-days (current-time)))))
		(cond
		 ((< m-days scheduled)
			'(org-habit-clear-face . org-habit-clear-future-face))
		 ((< m-days deadline)
			'(org-habit-ready-face . org-habit-ready-future-face))
		 ((= m-days deadline)
			(if donep
		'(org-habit-ready-face . org-habit-ready-future-face)
	'(org-habit-alert-face . org-habit-alert-future-face)))
		 ((and org-habit-show-done-always-green donep)
			'(org-habit-ready-face . org-habit-ready-future-face))
		 (t '(org-habit-overdue-face . org-habit-overdue-future-face)))))

(defun org-habit-build-graph (habit starting current ending)
	"Build a graph for the given HABIT, from STARTING to ENDING.
CURRENT gives the current time between STARTING and ENDING, for
the purpose of drawing the graph.	 It need not be the actual
current time."
	(let* ((all-done-dates (sort (org-habit-done-dates habit) #'<))
	 (done-dates all-done-dates)
	 (scheduled (org-habit-scheduled habit))
	 (s-repeat (org-habit-scheduled-repeat habit))
	 (start (time-to-days starting))
	 (now (time-to-days current))
	 (end (time-to-days ending))
	 (graph (make-string (1+ (- end start)) ?\s))
	 (index 0)
	 last-done-date)
		(while (and done-dates (< (car done-dates) start))
			(setq last-done-date (car done-dates)
			done-dates (cdr done-dates)))
		(while (< start end)
			(let* ((in-the-past-p (< start now))
			 (todayp (= start now))
			 (donep (and done-dates (= start (car done-dates))))
			 (faces
				(if (and in-the-past-p
					 (not last-done-date)
					 (not (< scheduled now)))
			'(org-habit-clear-face . org-habit-clear-future-face)
		(org-habit-get-faces
		 habit start
		 (and in-the-past-p
					last-done-date
					;; Compute scheduled time for habit at the time
					;; START was current.
					(let ((type (org-habit-repeat-type habit)))
			(cond
			 ;; At the last done date, use current
			 ;; scheduling in all cases.
			 ((null done-dates) scheduled)
			 ((equal type ".+") (+ last-done-date s-repeat))
			 ((equal type "+")
				;; Since LAST-DONE-DATE, each done mark
				;; shifted scheduled date by S-REPEAT.
				(- scheduled (* (length done-dates) s-repeat)))
			 (t
				;; Compute the scheduled time after the
				;; first repeat.	This is the closest time
				;; past FIRST-DONE which can reach SCHEDULED
				;; by a number of S-REPEAT hops.
				;;
				;; Then, play TODO state change history from
				;; the beginning in order to find current
				;; scheduled time.
				(let* ((first-done (car all-done-dates))
				 (s (let ((shift (mod (- scheduled first-done)
									s-repeat)))
							(+ (if (= shift 0) s-repeat shift)
					 first-done))))
					(if (= first-done last-done-date) s
						(catch :exit
				(dolist (done (cdr all-done-dates) s)
					;; Each repeat shifts S by any
					;; number of S-REPEAT hops it takes
					;; to get past DONE, with a minimum
					;; of one hop.
					(incf s
					(* (1+ (/ (max (- done s) 0) s-repeat))
						 s-repeat))
					(when (= done last-done-date)
						(throw :exit s))))))))))
		 donep)))
			 markedp face)
	(if donep
			(let ((done-time (time-add
						starting
						(days-to-time
						 (- start (time-to-days starting))))))

				(aset graph index org-habit-completed-glyph)
				(setq markedp t)
				(put-text-property
				 index (1+ index) 'help-echo
				 (format-time-string (org-time-stamp-format) done-time) graph)
				(while (and done-dates
				(= start (car done-dates)))
		(setq last-done-date (car done-dates)
					done-dates (cdr done-dates))))
		(if todayp
				(aset graph index org-habit-today-glyph)))
	(setq face (if (or in-the-past-p todayp)
					 (car faces)
				 (cdr faces)))
	(if (and in-the-past-p
		 (not (eq face 'org-habit-overdue-face))
		 (not markedp))
			(setq face (cdr faces)))
	(put-text-property index (1+ index) 'face face graph))
			(setq start (1+ start)
			index (1+ index)))
		graph))

(defun org-habit-insert-consistency-graphs (&optional line)
	"Insert consistency graph for any habitual tasks."
	(let ((inhibit-read-only t)
	(buffer-invisibility-spec '(org-link))
	(moment (time-subtract (current-time)
						 (list 0 (* 3600 org-extend-today-until) 0))))
		(save-excursion
			(goto-char (if line (point-at-bol) (point-min)))
			(while (not (eobp))
	(let ((habit (get-text-property (point) 'org-habit-p)))
		(when habit
			(move-to-column org-habit-graph-column t)
			(delete-char (min (+ 1 org-habit-preceding-days
				 org-habit-following-days)
						(- (line-end-position) (point))))
			(insert-before-markers
			 (org-habit-build-graph
				habit
				(time-subtract moment (days-to-time org-habit-preceding-days))
				moment
				(time-add moment (days-to-time org-habit-following-days))))))
	(forward-line)))))

(defun org-habit-toggle-habits ()
	"Toggle display of habits in an agenda buffer."
	(interactive)
	(org-agenda-check-type t 'agenda)
	(setq org-habit-show-habits (not org-habit-show-habits))
	(org-agenda-redo)
	(org-agenda-set-mode-name)
	(message "Habits turned %s"
		 (if org-habit-show-habits "on" "off")))

(org-defkey org-agenda-mode-map "K" 'org-habit-toggle-habits)

(provide 'org-habit)

;;; org-habit.el ends here
(defun cal-org-agenda-cycle-blocked-visibility ()
	(interactive)
	(setq org-agenda-dim-blocked-tasks
				(cond
				 ((eq org-agenda-dim-blocked-tasks 'invisible) nil)
				 ((eq org-agenda-dim-blocked-tasks nil) t)
				 (t 'invisible)))
	(org-agenda-redo)
	(message "Blocked tasks %s"
					 (cond
						((eq org-agenda-dim-blocked-tasks 'invisible) "omitted")
						((eq org-agenda-dim-blocked-tasks nil) "included")
						(t "dimmed"))))

(eval-after-load "org-agenda"
	'(define-key org-agenda-mode-map "B" 'cal-org-agenda-cycle-blocked-visibility))
