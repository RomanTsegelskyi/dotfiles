;; Org mode configurations
(require 'org-checklist)
;; org autoindent
(require 'org-indent)
(setq org-startup-indented t)
(setq org-startup-truncated t)
;; skip scheduled and deadline tasks if they are done
(setq org-agenda-skip-scheduled-if-done t)
(setq org-agenda-skip-deadline-if-done t)
;; org-protocol setup
(server-start)
(require 'org-protocol)
;; Load bh-functions from http://doc.norang.ca/org-mode.html
(load "~/Code/dotfiles/bh.el")
;; Directory and refile location
(setq org-directory "~/Dropbox/org")
(setq org-default-notes-file "~/Dropbox/org/refile.org")
;; Shortcut for capture mode
(define-key global-map "\C-cc" 'org-capture)
;; Shortcut for org-habit-toggle-habits
(define-key global-map "\C-ch" 'org-habit-toggle-habits)
;; Wrap around lines that don't fit on the screen
(setq org-startup-truncated nil)
;; default agenda span
(setq org-agenda-span 1)
;; Resume clocking task when emacs is restarted
(org-clock-persistence-insinuate)
;; Show lot of clocking history so it's easy to pick items off the C-F11 list

(setq org-clock-history-length 23)
;; Resume clocking task on clock-in if the clock is open
(setq org-clock-in-resume t)
;; Change tasks to NEXT when clocking in
(setq org-clock-in-switch-to-state 'bh/clock-in-to-next)
;; Separate drawers for clocking and logs
(setq org-drawers (quote ("PROPERTIES" "LOGBOOK")))
;; Save clock data and state changes and notes in the LOGBOOK drawer
(setq org-clock-into-drawer t)
(setq org-clock-out-remove-zero-time-clocks t)
;; Clock out when moving task to a done state
(setq org-clock-out-when-done t)
;; Save the running clock and all clock history when exiting Emacs, load it on startup
(setq org-clock-persist t)
;; Do not prompt to resume an active clock
(setq org-clock-persist-query-resume nil)
;; Enable auto clock resolution for finding open clocks
(setq org-clock-auto-clock-resolution (quote when-no-clock-is-running))
;; Include current clocking task in clock reports
(setq org-clock-report-include-clocking-task t)
(setq bh/keep-clock-running nil)
;; dim and enforce order
(setq org-agenda-dim-blocked-tasks 'invisible)
(setq org-enforce-todo-dependencies t)
;; punch-in and punch-out
(global-set-key (kbd "C-c i") 'org-clock-in)
(global-set-key (kbd "C-c I") 'bh/punch-in)
(global-set-key (kbd "C-c L p o") 'bh/clock-in-personal-organization-task)
(global-set-key (kbd "C-c L m o") 'bh/clock-in-microsoft-organization-task)
(global-set-key (kbd "C-c L e o") 'bh/clock-in-eleken-organization-task)
(global-set-key (kbd "C-c L g o") 'bh/clock-in-globalid-organization-task)
(global-set-key (kbd "C-c O") 'bh/punch-out)
;; Agenda clock report parameters
(setq org-agenda-clockreport-parameter-plist
			(quote (:link t :maxlevel 5 :fileskip0 t :compact t :narrow 80)))
;; Set default column view headings: Task Effort Clock_Summary
(setq org-columns-default-format "%50ITEM(Task) %10Effort(Effort){:} %10CLOCKSUM")
;; global Effort estimate values
;; global STYLE property values for completion
(setq org-global-properties (quote (("Effort_ALL" . "0:05 0:15 0:30 0:45 1:00 2:00 3:00 4:00 5:00 6:00 0:00")
																		("STYLE_ALL" . "habit"))))
;; Tags with fast selection keys
(setq org-tag-alist (quote (("WAITING" . ?w)
														("HOLD" . ?h)
														("ELEKEN" . ?E)
														("PERSONAL" . ?P)
														("MICROSOFT" . ?M)
														("GLOBALID" . ?G)
														("ESTIMATE" . ?e)
														("NOTE" . ?n)
														("DOWNTIME" . ?d)
                            )))
;; Allow setting single tags without the menu
(setq org-fast-tag-selection-single-key (quote expert))
;; For tag searches ignore tasks with scheduled and deadline dates
(setq org-agenda-tags-todo-honor-ignore-options t)
;; Recursive checkbox data
(setq org-hierarchical-checkbox-statistics nil)
;; Refiling
(setq org-completion-use-ido nil)
;; Targets include this file and any file contributing to the agenda - up to 9 levels deep
(setq org-refile-targets (quote ((nil :maxlevel . 9)
																 (org-agenda-files :maxlevel . 9))))
;; Use full outline paths for refile targets - we file directly with IDO
(setq org-refile-use-outline-path t)
(setq org-outline-path-complete-in-steps nil)
;; Allow refile to create parent tasks with confirmation
(setq org-refile-allow-creating-parent-nodes (quote confirm))
;; Exclude DONE state tasks from refile targets
(setq org-refile-target-verify-function 'bh/verify-refile-target)
;; Priorities
(setq org-enable-priority-commands t)
(setq org-default-priority ?C)
;; Archiving
(setq org-archive-mark-done nil)
(setq org-archive-location "%s_archive::* Archived Tasks")
;; Save all files every hour
(run-at-time "00:59" 3600 'org-save-all-org-buffers)
;; Narrowing and widening
(global-set-key (kbd "C-c n") 'bh/org-todo)
(global-set-key (kbd "C-c w") 'bh/widen)
(setq org-show-entry-below (quote ((default))))
;; show deadline early
(setq org-deadline-warning-days 30)
;; Show all future entries for repeating tasks
(setq org-agenda-repeating-timestamp-show-all t)
;; Show all agenda dates - even if they are empty
(setq org-agenda-show-all-dates t)
;; Sorting order for tasks on the agenda
(setq org-agenda-sorting-strategy
			(quote ((agenda habit-down time-up user-defined-up priority-down effort-up category-keep)
							(todo category-up effort-up)
							(tags category-up effort-up)
							(search category-up))))
;; Start the weekly agenda on Monday
(setq org-agenda-start-on-weekday 1)
;; Enable display of the time grid so we can see the marker for the current time
;; (setq org-agenda-time-grid (quote ((daily today remove-match)
;;																	 #("----------------" 0 16 (org-heading t))
;;																	 (0900 1100 1300 1500 1700))))
;; habit aganda settings
(setq org-agenda-tags-column -90)
(setq org-habit-graph-column 45)
(setq org-habit-preceding-days 10)
;; tasks settings
;; TODO states
(setq org-todo-keywords
			(quote ((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")
							(sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)" "PHONE" "MEETING"))))
;; TODO states faces
(setq org-todo-keyword-faces
			(quote (("TODO" :foreground "red" :weight bold)
							("NEXT" :foreground "purple" :weight bold)
							("DONE" :foreground "forest green" :weight bold)
							("WAITING" :foreground "orange" :weight bold)
							("HOLD" :foreground "magenta" :weight bold)
							("CANCELLED" :foreground "forest green" :weight bold)
							("MEETING" :foreground "forest green" :weight bold)
							("PHONE" :foreground "forest green" :weight bold))))
;; TODO triggers
(setq org-todo-state-tags-triggers
			(quote (("CANCELLED" ("CANCELLED" . t))
							("WAITING" ("WAITING" . t))
							("HOLD" ("WAITING") ("HOLD" . t))
							(done ("WAITING") ("HOLD"))
							("TODO" ("WAITING") ("CANCELLED") ("HOLD"))
							("NEXT" ("WAITING") ("CANCELLED") ("HOLD"))
							("DONE" ("WAITING") ("CANCELLED") ("HOLD")))))
(setq org-use-fast-todo-selection t)
(setq org-treat-S-cursor-todo-selection-as-state-change nil)
;; Capture templates for:
;; TODO tasks, Notes, appointments, phone calls, meetings, and org-protocol
(setq org-capture-templates
			(quote (
              ("t" "todo" entry (file "~/Dropbox/org/refile.org")
							 "* TODO %?\n" :clock-in t :clock-resume t)
              ("P" "todo-personal" entry (file "~/Dropbox/org/refile.org")
							 "* TODO %? :PERSONAL:\nSCHEDULED: %t\n%U\n" :clock-in t :clock-resume t)
              ("M" "todo-microsoft" entry (file "~/Dropbox/org/refile.org")
							 "* TODO %? :MICROSOFT:\nSCHEDULED: %t\n%U\n" :clock-in t :clock-resume t)
              ("E" "todo-eleken" entry (file "~/Dropbox/org/refile.org")
							 "* TODO %? :ELEKEN:\nSCHEDULED: %t\n%U\n" :clock-in t :clock-resume t)
              ("G" "todo-globalid" entry (file "~/Dropbox/org/refile.org")
							 "* TODO %? :GLOBALID:\nSCHEDULED: %t\n%U\n" :clock-in t :clock-resume t)
							("r" "respond" entry (file "~/Dropbox/org/refile.org")
							 "* NEXT Respond to %:from on %:subject\nSCHEDULED: %t\n%U\n%a\n" :clock-in t :clock-resume t :immediate-finish t)
							("n" "note" entry (file "~/Dropbox/org/refile.org")
							 "* %? :NOTE:\n" :clock-in t :clock-resume t)
							("L" "org-protocol" entry (file "~/Dropbox/org/refile.org")
							 "* TODO Review %a\n" :immediate-finish t)
							("m" "Meeting" entry (file "~/Dropbox/org/refile.org")
							 "* MEETING with %? :MEETING:\n" :clock-in t :clock-resume t)
							("p" "Phone call" entry (file "~/Dropbox/org/refile.org")
							 "* PHONE %? :PHONE:\n" :clock-in t :clock-resume t)
							("h" "Habit" entry (file "~/Dropbox/org/refile.org")
							 "* NEXT %?\nSCHEDULED: %(format-time-string \"%<<%Y-%m-%d %a .+1d/3d>>\")\n:PROPERTIES:\n:STYLE: habit\n:REPEAT_TO_STATE: NEXT\n:END:\n"))))
;; Custom agenda command definitions
(setq org-agenda-custom-commands
			(quote (("N" "Notes" tags "NOTE"
							 ((org-agenda-overriding-header "Notes")
								(org-tags-match-list-sublevels t)))
							("w" "Weekly review"
							 ((agenda ""))
							 ((org-agenda-span 7)
								(org-agenda-log-mode 1)))
							(" " "Agenda"
							 ((agenda "" nil)
								(tags "REFILE"
											((org-agenda-overriding-header "Tasks to Refile")
											 (org-tags-match-list-sublevels nil)))
								(tags-todo "-CANCELLED/!NEXT"
													 ((org-agenda-overriding-header (concat "Project Next Tasks"
																																	(if bh/hide-scheduled-and-waiting-next-tasks
																																			""
																																		" (including WAITING and SCHEDULED tasks)")))
														(org-agenda-skip-function 'bh/skip-projects-and-habits-and-single-tasks)
														(org-tags-match-list-sublevels t)
														(org-agenda-todo-ignore-scheduled bh/hide-scheduled-and-waiting-next-tasks)
														(org-agenda-todo-ignore-deadlines bh/hide-scheduled-and-waiting-next-tasks)
														(org-agenda-todo-ignore-with-date bh/hide-scheduled-and-waiting-next-tasks)
														(org-agenda-sorting-strategy
														 '(priority-down todo-state-down effort-up))
														))
								(tags-todo "-REFILE-CANCELLED-WAITING-HOLD/!"
													 ((org-agenda-overriding-header (concat "Project Subtasks"
																																	(if bh/hide-scheduled-and-waiting-next-tasks
																																			""
																																		" (including WAITING and SCHEDULED tasks)")))
														(org-agenda-skip-function 'bh/skip-non-project-tasks)
														(org-agenda-todo-ignore-scheduled bh/hide-scheduled-and-waiting-next-tasks)
														(org-agenda-todo-ignore-deadlines bh/hide-scheduled-and-waiting-next-tasks)
														(org-agenda-todo-ignore-with-date bh/hide-scheduled-and-waiting-next-tasks)
														(org-agenda-sorting-strategy
														 '(priority-down))))
								(tags-todo "-REFILE-CANCELLED-WAITING-HOLD/!"
													 ((org-agenda-overriding-header (concat "Standalone Tasks"
																																	(if bh/hide-scheduled-and-waiting-next-tasks
																																			""
																																		" (including WAITING and SCHEDULED tasks)")))
														(org-agenda-skip-function 'bh/skip-project-tasks)
														(org-agenda-todo-ignore-scheduled bh/hide-scheduled-and-waiting-next-tasks)
														(org-agenda-todo-ignore-deadlines bh/hide-scheduled-and-waiting-next-tasks)
														(org-agenda-todo-ignore-with-date bh/hide-scheduled-and-waiting-next-tasks)
														(org-agenda-sorting-strategy
														 '(priority-down effort-up))))
								(tags-todo "-CANCELLED/!"
													 ((org-agenda-overriding-header "Stuck Projects")
														(org-agenda-skip-function 'bh/skip-non-stuck-projects)
														(org-agenda-sorting-strategy
														 '(category-keep))))
								(tags-todo "-CANCELLED+WAITING/!"
													 ((org-agenda-overriding-header "Waiting Tasks (including SCHEDULED tasks)" )
														(org-agenda-skip-function 'bh/skip-non-tasks)
														(org-tags-match-list-sublevels nil)
                            ))
								(tags-todo "-CANCELLED+HOLD/!"
													 ((org-agenda-overriding-header "Postponed Tasks (including SCHEDULED tasks)" )
														(org-agenda-skip-function 'bh/skip-non-tasks)
														(org-tags-match-list-sublevels nil)
                            ))
								(tags "-REFILE/"
											((org-agenda-overriding-header "Tasks to Archive")
											 (org-agenda-skip-function 'bh/skip-non-archivable-tasks)
											 (org-tags-match-list-sublevels nil))))
							 nil))))
