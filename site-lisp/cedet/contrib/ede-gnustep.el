;;; ede-gnustep.el --- EDE GNUstep Project file driver

;;;  Copyright (C) 2008,2009  Marco Bardelli

;; Author: Marco (Bj) Bardelli <bardelli.marco@gmail.com>
;; Keywords: project, make, gnustep, gnustep-make
;; RCS: $Id: ede-gnustep.el,v 1.8 2009/08/09 01:18:04 zappo Exp $

;; This software is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This software is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Commentary:
;;
;; GNUstep-Make is a system (a set of makefiles) to compile various object.
;; To write a functional GNUmakefile, we haven't to write any rule,
;; but only set some variables.

;; #A tipical GNUmakefile to work with GNUstep-Make:

;; ifeq ($(GNUSTEP_MAKEFILES),)
;;   GNUSTEP_MAKEFILES := $(shell gnustep-config \
;;                        --variable=GNUSTEP_MAKEFILES 2> /dev/null)
;; endif
;; INSTALLATION_DOMAIN = LOCAL
;; include $(GNUSTEP_MAKEFILES)/common.make
;; TOOL_NAME = xxx
;; APP_NAME = aaa
;; LIBRARY_NAME = lll

;; xxx_C_FILES = xxx.c
;; aaa_OBJC_FILES = aaa.m
;; lll_C_FILES = lll.c
;; lll_OBJC_FILES = lll.m

;; ...

;; -include GNUmakefile.preamble
;; include $(GNUSTEP_MAKEFILES)/tool.make
;; include $(GNUSTEP_MAKEFILES)/application.make
;; include $(GNUSTEP_MAKEFILES)/library.make
;; -include GNUmakefile.postamble

;; # end of Makefile
;; in this example we define three targets (xxx,aaa,lll) of several types.
;; various variables and rules should be added in preamble and postamble
;; respectively, for convention.
;;
;; I focused on the method `ede-proj-makefile-create' to write a working
;; GNUmakefile.


(eval-and-compile 
  (require 'ede)
  (require 'ede-proj)
  (require 'makefile-edit)
  )


;;; Class Definitions:
;; Source

(defvar ede-source-gnustep-objc
  (ede-sourcecode "ede-gnustep-source-objc"
		  :name "GNUsetp ObjC"
		  :sourcepattern "\\.m$"
		  :auxsourcepattern "\\.h$"
		  :garbagepattern '("*.o" "obj/*"))
  "Objective-C source code definition (for using with GNUstep-make).")

(defvar ede-source-header-gnustep-objc
  (ede-sourcecode "ede-gnustep-source-header-objc"
		  :name "GNUsetp Header ObjC"
		  :sourcepattern "\\.h$"
;;		  :auxsourcepattern "\\.h$"
		  :garbagepattern nil)
  "Objective-C source code definition (for using with GNUstep-make).")

(defvar ede-source-gnustep-c
  (ede-sourcecode "ede-gnustep-source-c"
		  :name "GNUsetp C"
		  :sourcepattern "\\.c$"
		  :auxsourcepattern "\\.h$"
		  :garbagepattern '("*.o" "obj/*"))
  "C source code definition (for using with GNUstep-make).")

(defvar ede-source-header-gnustep-c
  (ede-sourcecode "ede-gnustep-source-header-c"
		  :name "GNUsetp Header C"
		  :sourcepattern "\\.h$"
;;		  :auxsourcepattern "\\.h$"
		  :garbagepattern nil)
  "C source code definition (for using with GNUstep-make).")

;; XXX @todo sources for C++ and Objective-C++

(defvar ede-source-gnustep-texi
  (ede-sourcecode "ede-gnustep-source-texi"
		  :name "GNUsetp Texinfo"
		  :sourcepattern "\\.texi$"
;		  :auxsourcepattern "\\.h$"
		  :garbagepattern '("*.pdf" "*.info" "*.html"))
  "Texinfo source definition (for using with GNUstep-make).")


;; Target
;(defclass ede-step-target (ede-proj-target) ;; may be don't need
(defclass ede-step-target (ede-target)
  ((makefile :initarg :makefile
	     :initform "GNUmakefile"
	     :type string
	     :custom string
	     :label "Parent Makefile"
	     :group make
	     :documentation "File name of generated Makefile.")
   (type :initarg :type
	 :initform ctool
	 :type symbol
	 :custom (choice (const ctool)(const tool)
			 (const library)(const clibrary)
			 (const application)(const documentation)
			 (const framework)(const bundle)
			 (const subproject))
	 :label "Target Type"
	 :group make
	 :documentation "Type of GNUstep-Make target.")
   (include-dirs :initarg :include-dirs
		 :initform nil
		 :type list
		 :custom (choice (const :tag "None" nil)
				 (repeat
				  (string :tag "Include dirs cpp flags")))
		 :label "Include Dirs -I flags"
		 :group make
		 :documentation "Include directories like cpp flags -I.
Include some dir via the -I preprocessor flag, for this target.")
   (auxsource :initarg :auxsource
	      :initform nil
	      :type list
	      :custom (repeat (string :tag "File"))
	      :label "Auxiliary Source Files"
	      :group (default source)
	      :documentation "Auxilliary source files included in this target.
Each of these is considered equivalent to a source file, but it is not
distributed, and each should have a corresponding rule to build it.")
   (dirty :initform nil
	  :type boolean
	  :documentation "Non-nil when generated files needs updating.")
   )
"Abstract class for ede-step targets.")

(defclass ede-step-target-ctool (ede-step-target)
  ((sourcetype :initform (ede-source-gnustep-c
			  ede-source-header-gnustep-c))
   (type :initform 'ctool)
   (cflags :initarg :cflags
	   :initform nil
	   :type list
	   :group make
	   :custom (repeat (string :tag "Compiler Flags")))
   (ldflags :initarg :ldflags
	   :initform nil
	   :type list
	   :group make
	   :custom (repeat (string :tag "Linker Flags"))))
  "Class for CTool targets.")

(defclass ede-step-target-tool (ede-step-target)
  ((sourcetype :initform (ede-source-gnustep-objc
			  ede-source-gnustep-c
			  ede-source-header-gnustep-c
			  ede-source-header-gnustep-objc))
   (type :initform 'tool)
   (cflags :initarg :cflags
	   :initform nil
	   :type list
	   :group make
	   :custom (repeat (string :tag "Compiler Flags")))
   (ldflags :initarg :ldflags
	   :initform nil
	   :type list
	   :group make
	   :custom (repeat (string :tag "Linker Flags"))))
  "Class for Tool targets.")

;; FIX XXX :  _LIBS_DEPEND
(defclass ede-step-target-clibrary (ede-step-target)
  ((sourcetype :initform (ede-source-gnustep-c
			  ede-source-header-gnustep-c))
   (type :initform 'clibrary)
;;;    (header-install-dir :initarg :header-install-dir
;;; 		       :initform ""
;;; 		       :type string
;;; 		       :group make
;;; 		       :custom string
;;; 		       :label "Header Installation Directory")
   (cflags :initarg :cflags
	   :initform nil
	   :type list
	   :group make
	   :custom (repeat (string :tag "Compiler Flags")))
   (ldflags :initarg :ldflags
	   :initform nil
	   :type list
	   :group make
	   :custom (repeat (string :tag "Linker Flags"))))
  "Class for CLib targets.")

(defclass ede-step-target-library (ede-step-target)
  ((sourcetype :initform (ede-source-gnustep-objc
			  ede-source-gnustep-c
			  ede-source-header-gnustep-objc
			  ede-source-header-gnustep-c))
   (type :initform 'library)
;;;    (header-install-dir :initarg :header-install-dir
;;; 		       :initform ""
;;; 		       :type string
;;; 		       :group make
;;; 		       :custom string
;;; 		       :label "Header Installation Directory")
   (cflags :initarg :cflags
	   :initform nil
	   :type list
	   :group make
	   :custom (repeat (string :tag "Compiler Flags")))
   (ldflags :initarg :ldflags
	   :initform nil
	   :type list
	   :group make
	   :custom (repeat (string :tag "Linker Flags"))))
  "Class for Lib targets.")

(defclass ede-step-target-application (ede-step-target)
  ((sourcetype :initform (ede-source-gnustep-objc
			  ede-source-gnustep-c
			  ede-source-header-gnustep-objc
			  ede-source-header-gnustep-c))
   (type :initform 'application)
   (cflags :initarg :cflags
	   :initform nil
	   :type list
	   :group make
	   :custom (repeat (string :tag "Compiler Flags")))
   (ldflags :initarg :ldflags
	   :initform nil
	   :type list
	   :group make
	   :custom (repeat (string :tag "Linker Flags"))))
  "Class for App targets.")

(defclass ede-step-target-documentation (ede-step-target)
  ((sourcetype :initform (ede-source-gnustep-texi))
   (type :initform 'documentation))
  "Class for Doc targets.")

;; (defclass ede-step-target-subproject (ede-step-target)
;;   ()
;;   "Class for Subproject targets.")

(defvar ede-step-target-alist
  '(("ctool" ede-step-target-ctool "CTOOL_NAME")
    ("tool" ede-step-target-tool "TOOL_NAME")
    ("app" ede-step-target-application "APP_NAME")
    ("doc" ede-step-target-documentation )
    ("clib" ede-step-target-clibrary "CLIBRARY_NAME")
    ("lib" ede-step-target-library "LIBRARY_NAME")
    ("framework" ede-step-target-library "FRAMEWORK_NAME")
    ("subproject" ede-step-project "SUBPROJECTS")
    )
  "Alist of names to class target-types available by GNUstep-Make.")

(defun ede-step-register-target (name class &optional macro)
  "Register a new target class with NAME and class symbol CLASS.
This enables the creation of your target type."
  (let ((a (assoc name ede-step-target-alist)))
    (if a
	(setcdr a (list class macro))
      (setq ede-step-target-alist
	    (cons (cons name class) ede-step-target-alist)))))

(defclass ede-step-project (ede-project)
;(defclass ede-step-project (ede-proj-project) ;; to mix several project types, but don't solve ...
  ((project-mode :initarg :project-mode :initform writer
		 :type symbol
		 :custom (choice (const :tag "Scanner Mode" scanner)
				 (const :tag "Writer Mode" writer))
		 :group (settings)
		 :documentation "In scanner mode, `ede-proj-makefile-create'
is useless, the project-rescan methods change their behavoir to scan
GNUmakefiles, and possibly a ProjStep.ede could be created. In writer mode,
the behavoir is the same that in any ede-proj-project, scan ProjStep.ede to
write Makefiles")

   (makefile :initarg :makefile :initform ""
	     :type string :documentation "GNUmakefile."
	     :group (make settings))
   (init-variables
    :initarg :init-variables
    :initform nil
    :type list
    :custom (repeat (cons (string :tag "Name X")
			  (string :tag "Value")))
    :group (make settings)
    :documentation "Variables to set in this Makefile, at top of file.")

   (additional-variables
    :initarg :additional-variables
    :initform nil
    :type (or null list)
    :custom (repeat
	     (cons (choice (const :tag "None" nil)
			   (string :tag "GNU Makefile preamble"))
		   (repeat (cons (string :tag "Name")
				 (string :tag "Value")))))
    :label "Additional variables"
    :group make
    :documentation
    "Arbitrary variables needed from this project.
It is safe to leave this blank.")
   (additional-rules
    :initarg :additional-rules
    :initform nil
    :type (or null list)
    :custom (repeat
	     (cons (choice (const :tag "None" nil)
			   (string :tag "GNU Makefile postamble"))
		   (repeat (object :objecttype ede-makefile-rule))))
    :label "Additional Rules"
    :group make
    :documentation
    "Arbitrary rules and dependencies needed to make this target.
It is safe to leave this blank.")

   (menu :initform
	 (
	  [ "Regenerate Makefiles" ede-proj-regenerate t ]
	  [ "Upload Distribution" ede-upload-distribution t ]
	  )
	 )

   (installation-domain :initarg :installation-domain
		       :initform user
		       :type symbol
		       :custom (choice (const user)
				       (const local)
				       ;(const network)
				       (const system))
		       :group (default make settings)
		       :documentation "Installation domain specification.
The variable GNUSTEP_INSTALLATION_DOMAIN is set at this value.")
   (preamble :initarg :preamble
	     :initform '("GNUmakefile.preamble")
	     :type (or null list)
	     :custom (repeat (string :tag "Makefile"))
	     :group make
	     :documentation "The auxilliary makefile for additional variables.
Included just before the specific target files.")
   (postamble :initarg :postamble
	     :initform '("GNUmakefile.postamble")
	     :type (or null list)
	     :custom (repeat (string :tag "Makefile"))
	     :group make
	     :documentation "The auxilliary makefile for additional rules.
Included just after the specific target files.")

   (metasubproject
    :initarg :metasubproject
    :initform nil
    :type boolean
    :custom boolean
    :group (default settings)
    :documentation
    "Non-nil if this is a metasubproject.
Usually, a subproject is determined by a parent project.  If multiple top level
projects are grouped into a large project not maintained by EDE, then you need
to set this to non-nil.  The only effect is that the `dist' rule will then avoid
making a tar file.")
   )
  "The EDE-STEP project definition class.")

(defclass ede-gnustep-project (ede-step-project)
  ()
  "EDE-GNUSTEP Project, scan GNUmakefile.")

;;; Code:
(defun ede-gnustep-load (proj &optional rootproj)
  "Load a project from GNUmakefile in PROJ directory."
  (let* ((mf (ede-gnustep-get-valid-makefile proj))
	 (pkgname (or
		   (with-temp-buffer
		     (insert-file-contents (expand-file-name mf proj))
		     (goto-char (point-min))
		     (car (makefile-macro-file-list "PACKAGE_NAME")))
		   (file-name-nondirectory
		    (directory-file-name proj))))
	 (proj-obj
	  (ede-gnustep-project pkgname
			       :name pkgname
			       :project-mode 'scanner
			       :directory proj
			       :makefile mf
			       :targets nil)))
    (project-rescan proj-obj)))
  
;(defalias 'ede-proj-load 'ede-step-load)
(defun ede-step-load (project &optional rootproj)
  "Load a project file from PROJECT directory.
If optional ROOTPROJ is provided then ROOTPROJ is the root project
for the tree being read in.  If ROOTPROJ is nil, then assume that
the PROJECT being read in is the root project."
  (save-excursion
    (let ((ret nil)
	  (subdirs (directory-files project nil "[^.].*" nil)))
      (set-buffer (get-buffer-create " *tmp proj read*"))
      (unwind-protect
	  (progn
	    (insert-file-contents (concat project "ProjStep.ede")
				  nil nil nil t)
	    (goto-char (point-min))
	    (setq ret (read (current-buffer)))
	    (if (not (eq (car ret) 'ede-step-project))
		(error "Corrupt project file"))
	    (setq ret (eval ret))
	    (oset ret file (concat project "ProjStep.ede"))
	    (oset ret directory project)
	    (oset ret rootproject rootproj)
	    )
	(kill-buffer " *tmp proj read*"))
      (while subdirs
	(let ((sd (file-name-as-directory
		   (expand-file-name (car subdirs) project))))
	  (if (and (file-directory-p sd)
		   (ede-directory-project-p sd))
	      (oset ret subproj
		    (cons (ede-proj-load sd (or rootproj ret))
			  (oref ret subproj))))
	  (setq subdirs (cdr subdirs))))
      ret)))

(defun ede-step-save (&optional project)
  "Write out object PROJECT into its file."
  (save-excursion
    (if (not project) (setq project (ede-current-project)))
    (let ((b (set-buffer (get-buffer-create " *tmp proj write*")))
	  (cfn (oref project file)))
      ;; (unless (not (string= "" (oref project name))) (oset project :name
      ;; 							   (file-name-nondirectory
      ;; 							    (directory-file-name
      ;; 							     (file-name-directory cfn)))))
      (unwind-protect
	  (save-excursion
	    (erase-buffer)
	    (let ((standard-output (current-buffer)))
	      (oset project file (file-name-nondirectory cfn))
	      (object-write project ";; EDE project file."))
	    (write-file cfn nil)
	    )
	;; Restore the :file on exit.
	(oset project file cfn)
	(kill-buffer b)))))

(defmethod ede-commit-local-variables ((proj ede-step-project))
  "Commit change to local variables in PROJ."
  (ede-step-save proj))

(defmethod eieio-done-customizing ((proj ede-step-project))
  "Call this when a user finishes customizing this object.
Argument PROJ is the project to save."
  (call-next-method)
  (ede-step-save proj))

(defmethod eieio-done-customizing ((target ede-step-target))
  "Call this when a user finishes customizing this object.
Argument TARGET is the project we are completing customization on."
  (call-next-method)
  (ede-step-save (ede-current-project)))

(defmethod ede-commit-project ((proj ede-step-project))
  "Commit any change to PROJ to its file."
  (ede-step-save proj))

(defmethod ede-buffer-mine ((this ede-step-project) buffer)
  "Return t if object THIS lays claim to the file in BUFFER."
  (let ((f (ede-convert-path this (buffer-file-name buffer))))
    (or (string= (file-name-nondirectory (oref this file)) f)
	(string= (ede-proj-dist-makefile this) f)
	(string-match "GNUmakefile\\(\\.in\\|\\.preamble\\|\\.postamble\\)?" f)
	(string-match "Makefile\\(\\.\\(preamble\\|postamble\\)\\)?" f)
;; 	(string-match "Makefile\\(\\.\\(in\\|am\\)\\)?" f)
;; 	(string-match "config\\(ure\\.in\\|\\.status\\)?" f)
	)))

(defmethod ede-buffer-mine ((this ede-step-target) buffer)
  "Return t if object THIS lays claim to the file in BUFFER."
  (or (call-next-method)
      (ede-target-buffer-in-sourcelist this buffer (oref this auxsource))))


;;; Makefile Creation
;; XXX @TODO to use better gnustep-make, using standard variables an standard rule {before,internal,after}-*::
(defmethod ede-proj-makefile-create ((this ede-step-project) mfilename)
  "Create a GNUmakefile for all Makefile targets in THIS.
MFILENAME is the makefile to generate."
  (when (eq 'writer (oref this project-mode))
    (let ((mt nil) tmp
	  (isdist (string= mfilename (ede-proj-dist-makefile this)))
	  (depth 0)
	  )
      ;;     ;; Find out how deep this project is.
      ;;     (let ((tmp this))
      ;;       (while (setq tmp (ede-parent-project tmp))
      ;; 	(setq depth (1+ depth))))
      ;;     ;; Collect the targets that belong in a makefile.
      ;;     (mapcar
      ;;      (lambda (obj)
      ;;        (if (and (obj-of-class-p obj 'ede-step-target)
      ;; 		(string= (oref obj makefile) mfilename))
      ;; 	   (setq mt (cons obj mt))))
      ;;      (oref this targets))
      ;;     ;; Fix the order so things compile in the right direction.
      ;;     (setq mt (nreverse mt))
      ;; Add in the header part of the Makefile*
      (save-excursion
	(set-buffer (find-file-noselect mfilename))
	(goto-char (point-min))
	(if (and
	     (not (eobp))
	     (not (looking-at "# Automatically Generated \\w+ by EDE.")))
	    (if (not (y-or-n-p (format "Really replace %s?" mfilename)))
		(error "Not replacing Makefile."))
	  (message "Replace EDE Makefile"))
	(erase-buffer)
	;; Insert a giant pile of stuff that is common between
	;; one of our Makefiles, and a Makefile.in
	(insert
	 "# Automatically Generated " (file-name-nondirectory mfilename)
	 " by EDE.\n"
	 "# For use with: gnustep-make"
	 "\n#\n"
	 "# DO NOT MODIFY THIS FILE OR YOUR CHANGES MAY BE LOST.\n"
	 "# EDE is the Emacs Development Environment.\n"
	 "# http://cedet.sourceforge.net/ede.shtml\n"
	 "# \n")
	(insert "\nede_FILES=" (file-name-nondirectory (oref this file)) " "
		(file-name-nondirectory (ede-proj-dist-makefile this)) "\n")
	(insert "\n\n")
	;; Standard prologe in a GNUmakefile
	(insert ;; init-variables of project
	 "ifeq ($(GNUSTEP_MAKEFILES),)\n"
	 " GNUSTEP_MAKEFILES := $(shell gnustep-config"
	 "--variable=GNUSTEP_MAKEFILES 2>/dev/null)\n"
	 "endif\n\n"
	 "include $(GNUSTEP_MAKEFILES)/common.make\n\n# Stuff\n")
	
	;; FIX XXX package,vcs repository ... variables
	;; ...
	;; Just this project's targets variables
	(ede-map-targets this
			 (lambda (tx)
			   (cond ((or (eq (oref tx type) 'ctool)(eq (oref tx type) 'tool))
				  (ede-pmake-insert-variable-shared "TOOL_NAME"
				    (insert (ede-name tx))))
		((eq (oref tx type) 'library)
		 (ede-pmake-insert-variable-shared "LIBRARY_NAME"
		   (insert (ede-name tx))))
		((eq (oref tx type) 'application)
		 (ede-pmake-insert-variable-shared "APP_NAME"
		   (insert (ede-name tx))))
		((eq (oref tx type) 'subproject)
		 (ede-pmake-insert-variable-shared "SUBPROJECTS"
		   (insert (ede-name tx)))))))

      ;; Just this target's variables, sources and flags
      (insert "\n\n")
      (ede-map-targets this
       (lambda (tx)
	 (progn
	   (let ((file (oref tx source)))
	     (while file
	       (cond ((or
		       (ede-want-file-source-p ede-source-header-gnustep-c (car file))
		       (ede-want-file-source-p ede-source-header-gnustep-objc (car file)))
		      (ede-pmake-insert-variable-shared
			  (concat (oref tx name) "_HEADER_FILES")
			(insert (car file))))
		     ((ede-want-file-source-p ede-source-gnustep-c (car file))
		      (ede-pmake-insert-variable-shared
			  (concat (oref tx name) "_C_FILES")
			(insert (car file))))
		     ((ede-want-file-source-p ede-source-gnustep-objc (car file))
		      (ede-pmake-insert-variable-shared
			  (concat (oref tx name) "_OBJC_FILES")
			(insert (car file)))))
	       (setq file (cdr file))))
	   ;; Just target's CFLAGS, LDFLAGS and INCLUDE_DIRS
	   (let ((cflags (oref tx cflags))
		 (ldflags (oref tx ldflags))
		 (incldirs (oref tx include-dirs))
		 (single t))
	     (while (and (sequencep cflags) cflags)
	       (if single
		   (or (setq single nil)
		       (insert
			(concat (oref tx name) "_CFLAGS = " (car cflags) "\n")))
		 (insert
		  (concat (oref tx name) "_CFLAGS += " (car cflags) "\n")))
	       (setq cflags (cdr cflags)))
	     (setq single t)
	     (while (and (sequencep ldflags) ldflags)
	       (if single
		   (or (setq single nil)
		       (insert
			(concat (oref tx name) "_LDFLAGS = " (car ldflags) "\n")))
		 (insert
		  (concat (oref tx name) "_LDFLAGS += " (car ldflags) "\n")))
	       (setq ldflags (cdr ldflags)))
	     (setq single t)
	     (while (and (sequencep incldirs) incldirs)
	       (if single
		   (or (setq single nil)
		       (insert
			(concat (oref tx name)
				"_INCLUDE_DIRS = " (car ldflags) "\n")))
		 (insert
		  (concat (oref tx name)
			  "_INCLUDE_DIRS += " (car ldflags) "\n")))
	       (setq incldirs (cdr incldirs))))
	   (insert "\n")
;;;XXXX
;;; 	   (if (or
;;; 		(eq (oref tx type) 'clibrary)
;;; 		(eq (oref tx type) 'library))
;;; 	       (if (oref tx header-install-dir)
;;; 		   (insert
;;; 		    (concat
;;; 		     (oref tx name)
;;; 		     "_HEADER_INSTALLATION_DIR = "
;;; 		     (oref tx header-install-dir)))))
	   ))) ;; end of `ede-targets'

      ;; Yet Other project's variables
      ;; Just Additional Variables ...
      (insert "\n")
      ;; XXX @TODO put additional variables in the preamble if specified.
      (let ((addvars (oref this additional-variables)) vars mkf)
	(while addvars
	  (if (car addvars) ;; useless ??
	      (setq mkf (caar addvars)
		    vars (cdar addvars)))
	  (while vars
	    (if mkf
		(save-excursion
		  (set-buffer (find-file-noselect mkf))
;		  (ede-pmake-insert-variable-shared (caar vars)(cdar vars))
		  (insert (caar vars) " += " (cdar vars) "\n")
		  (save-buffer))
;	      (ede-pmake-insert-variable-shared (caar vars)(cdar vars)))
	      (insert (caar vars) " += " (cdar vars) "\n"))
	    (setq vars (cdr vars)))
	  (setq addvars (cdr addvars))))

      ;; Include Preambles
      (insert "\n\n")
      (let ((preambles (oref this preamble)))
	(while preambles
	  (insert "-include " (car preambles) "\n")
	  (setq preambles (cdr preambles))))
      ;; Include target type specific Makefile
      (insert "\n")
      (let (types)
	(ede-map-targets this (lambda (x) (add-to-list 'types (oref x type))))
	(while types
	  (if (eq (car types) 'subproject)
	      (insert "include $(GNUSTEP_MAKEFILES)/aggregate.make\n")
	    (insert "include $(GNUSTEP_MAKEFILES)/" (symbol-name (car types)) ".make\n"))
	  (setq types (cdr types))))
      ;; Include Postambles
      (insert "\n")
      (let ((postambles (oref this postamble)))
	(while postambles
	  (insert "-include " (car postambles) "\n")
	  (setq postambles (cdr postambles))))

      ;; Just Additional Rules ...
      ;; XXX @TODO put additional rules in the postamble if specified.

      ;; END
      (save-buffer)
      (goto-char (point-min))))))

;;; EDE command functions
;;
(defvar ede-step-target-history nil
  "History when querying for a target type.")

(defmethod project-new-target ((this ede-step-project)
			       &optional name type autoadd)
  "Create a new target in THIS based on the current buffer."
  (if (eq (oref this :project-mode) 'scanner)
      (warn "This ProjStep is in Scanner Mode, are u sure what are u doing?"))
  (let* ((name (or name (read-string "Name: " "")))
	 (type (or type
		   (completing-read "Type: " ede-step-target-alist
				    nil t nil '(ede-step-target-history . 1))))
	 (ot nil)
	 (src (if (and (buffer-file-name)
		       (if (and autoadd (stringp autoadd))
			   (string= autoadd "y")
			 (y-or-n-p (format "Add %s to %s? " (buffer-name) name))))
		  (buffer-file-name))))
    (setq ot (funcall (nth 1 (assoc type ede-step-target-alist)) name :name name
		      :path (ede-convert-path this default-directory)
		      :source (if src
				  (list (file-name-nondirectory src))
				nil)))
    ;; If we added it, set the local buffer's object.
    (if src (progn
	      (setq ede-object ot)
	      (ede-apply-object-keymap)))
    ;; Add it to the project object
    ;;(oset this targets (cons ot (oref this targets)))
    ;; New form: Add to the end using fancy eieio function.
    ;; @todone - Some targets probably want to be in the front.
    ;;           How to do that?
    ;; @ans - See elisp autoloads for answer
    (object-add-to-list this 'targets ot t)
    ;; And save
    (ede-step-save this)))

(defmethod project-new-target-custom ((this ede-step-project))
  "Create a new target in THIS for custom."
  (if (eq (oref this :project-mode) 'scanner)
      (warn "This ProjStep is in Scanner Mode, are u sure what are u doing?"))
  (let* ((name (read-string "Name: " ""))
	 (type (completing-read "Type: " ede-step-target-alist
				nil t nil '(ede-step-target-history . 1))))
    (funcall (nth 1 (assoc type ede-step-target-alist)) name :name name
	     :path (ede-convert-path this default-directory)
	     :source nil)))

(defmethod project-delete-target ((this ede-step-target))
  "Delete the current target THIS from it's parent project."
  (if (eq (oref (ede-current-project (oref this :path)) :project-mode) 'scanner)
      (warn "This ProjStep is in Scanner Mode, are u sure what are u doing?"))
  (let ((p (ede-current-project))
	(ts (oref this source)))
    ;; Loop across all sources.  If it exists in a buffer,
    ;; clear it's object.
    (while ts
      (let* ((default-directory (oref this path))
	     (b (get-file-buffer (car ts))))
	(if b
	    (save-excursion
	      (set-buffer b)
	      (if (eq ede-object this)
		  (progn
		    (setq ede-object nil)
		    (ede-apply-object-keymap))))))
      (setq ts (cdr ts)))
    ;; Remove THIS from it's parent.
    ;; The two vectors should be pointer equivalent.
    (oset p targets (delq this (oref p targets)))
    (ede-step-save (ede-current-project))))

(defmethod project-add-file ((this ede-step-target) file)
  "Add to target THIS the current buffer represented as FILE."
  (if (eq (oref (ede-current-project (oref this :path)) :project-mode) 'scanner)
      (warn "This ProjStep is in Scanner Mode, are u sure what are u doing?"))
  (let ((file (ede-convert-path this file))
	(src (ede-target-sourcecode this))
	(aux nil))
    (while (and src (not (ede-want-file-p (car src) file)))
      (setq src (cdr src)))
    (when src
      (setq src (car src))
      (cond ((ede-want-file-source-p this file)
	     (object-add-to-list this 'source file t))
	    ((ede-want-file-auxiliary-p this file)
	     (object-add-to-list this 'auxsource file t))
	    (t (error "`project-add-file(ede-target)' source mismatch error")))
      (ede-step-save))))

(defmethod project-remove-file ((target ede-step-target) file)
  "For TARGET, remove FILE.
FILE must be massaged by `ede-convert-path'."
  (if (eq (oref (ede-current-project (oref this :path)) :project-mode) 'scanner)
      (warn "This ProjStep is in Scanner Mode, are u sure what are u doing?"))
  ;; Speedy delete should be safe.
  (object-remove-from-list target 'source (ede-convert-path target file))
  (object-remove-from-list target 'auxsource (ede-convert-path target file))
  (ede-step-save))

(defmethod project-update-version ((this ede-step-project))
  "The :version of project THIS has changed."
  (ede-step-save))

(defmethod project-make-dist ((this ede-step-project))
  "Build a distribution for the project based on THIS target."
  ;; I'm a lazy bum, so I'll make a makefile for doing this sort
  ;; of thing, and rely only on that small section of code.
  (let ((pm (ede-proj-dist-makefile this))
	(df (project-dist-files this)))
    (if (and (file-exists-p (car df))
	     (not (y-or-n-p "Dist file already exists.  Rebuild? ")))
	(error "Try `ede-update-version' before making a distribution"))
    (ede-proj-setup-buildenvironment this)
    (if (string= pm "Makefile.am") (setq pm "Makefile"))
    (compile (concat "make -f " pm " dist"))
    ))

(defmethod project-dist-files ((this ede-step-project))
  "Return a list of files that constitutes a distribution of THIS project."
  (list
   ;; Note to self, keep this first for the above fn to check against.
   (concat (oref this name) "-" (oref this version) ".tar.gz")
   ))

(defmethod project-compile-project ((proj ede-step-project) &optional command)
  "Compile the entire current project PROJ.
Argument COMMAND is the command to use when compiling."
  (let ((pm (ede-proj-dist-makefile proj))
	(default-directory (file-name-directory (oref proj file))))
    (ede-proj-setup-buildenvironment proj)
;    (if (string= pm "Makefile.am") (setq pm "Makefile"))
    (compile (concat "make -f " pm " all"))))

;;; Target type specific compilations/debug
;;
(defmethod project-compile-target ((obj ede-step-target) &optional command)
  "Compile the current target OBJ.
Argument COMMAND is the command to use for compiling the target."
  (ede-proj-setup-buildenvironment (ede-current-project))
  (compile (concat "make -f " (oref obj makefile) " "
		   (ede-proj-makefile-target-name obj))))

(defmethod project-debug-target ((obj ede-step-target))
  "Run the current project target OBJ in a debugger."
  (error "Debug-target not supported by %s" (object-name obj)))

(defmethod ede-proj-makefile-target-name ((this ede-step-target))
  "Return the name of the main target for THIS target."
  (ede-name this))

;;; Compiler and source code generators
;;
(defmethod ede-want-file-auxiliary-p ((this ede-target) file)
  "Return non-nil if THIS target wants FILE."
  ;; By default, all targets reference the source object, and let it decide.
  (let ((src (ede-target-sourcecode this)))
    (while (and src (not (ede-want-file-auxiliary-p (car src) file)))
      (setq src (cdr src)))
    src))


;;; Target type specific autogenerating gobbldegook.
;; I would implement the ede-proj interface.
(eval-when-compile
  (require 'ede-pmake "ede-pmake.el")
  (require 'ede-pconf "ede-pconf.el"))

;; FIX XXX
(defmethod ede-proj-dist-makefile ((this ede-step-project))
  "Return the name of the Makefile with the DIST target in it for THIS."
  (concat (file-name-directory (oref this file)) "GNUmakefile"))

;; (defun ede-proj-regenerate ()
;;   "Regenerate Makefiles for and edeproject project."
;;   (interactive)
;;   (ede-proj-setup-buildenvironment (ede-current-project) t))

(defmethod ede-proj-makefile-create-maybe ((this ede-step-project) mfilename)
  "Create a Makefile for all Makefile targets in THIS if needed.
MFILENAME is the makefile to generate."
  ;; For now, pass through until dirty is implemented.
  (require 'ede-pmake)
  (if (or (not (file-exists-p mfilename))
	  (file-newer-than-file-p (oref this file) mfilename))
      (ede-proj-makefile-create this mfilename)))

(defmethod ede-proj-setup-buildenvironment ((this ede-step-project)
					    &optional force)
  "Setup the build environment for project THIS.
Handles the Makefile, or a Makefile.am configure.in combination.
Optional argument FORCE will force items to be regenerated."
  (if (not force)
      (ede-proj-makefile-create-maybe this (ede-proj-dist-makefile this))
;    (require 'ede-pmake)
    (ede-proj-makefile-create this (ede-proj-dist-makefile this)))
  ;; Rebuild all subprojects
  (ede-map-subprojects
   this (lambda (sproj) (ede-proj-setup-buildenvironment sproj force)))
  )


;;; Lower level overloads
;;
;; maybe require some makefile utils

;; (defmethod project-rescan ((this ede-gnustep-project))
;;   "Rescan the EDE proj project THIS."
;;   (when (eq 'scanner (oref this project-mode))
;;     (let ((mf (or (and (not (string= "" (oref this :makefile)))
;; 		       (oref this :makefile))
;; 		  (ede-gnustep-get-valid-makefile (oref this :directory))))
;; 	  (otargets (oref this targets))
;; 	  (pn (oref this :name)) (ntargets nil))
;;       (when mf
;; 	(oset this :makefile mf)
;; 	(with-temp-buffer
;; 	  (insert-file-contents 
;; 	   (expand-file-name mf (oref this :directory)))
;; 	  (goto-char (point-min))
;; 	  ;; (setq pn (car (makefile-macro-file-list "PACKAGE_NAME")))
;; 	  ;; (and pn (oset this :name pn))
;; 	  (mapc
;; 	   ;; Map all the different types
;; 	   (lambda (typecar)
;; 	     (let ((macro (nth 2 typecar))
;; 		   (class (nth 1 typecar))
;; 		   )
;; 	       (let ((tmp nil)(targets (makefile-macro-file-list macro)))
;; 		 (while targets
;; 		   (setq tmp (object-assoc (car targets) 'name otargets))
;; 		   (when (not tmp)
;; 		     (if (eq class 'ede-step-project)
;; 			 (setq tmp (apply ede-gnustep-project
;; 					  (car targets) :name (car targets)
;; 					  :directory (concat
;; 						      (file-name-as-directory
;; 						       (oref this :directory))
;; 						      (car targets))
;; 					  :metasubproject t
;; 					  :targets nil
;; 					  nil))
;; 		       (setq tmp (apply class (car targets) :name (car targets)
;; 					:path (oref this :directory) nil))))
;; 		   (project-rescan tmp)
;; 		   ;; (unless ;; prevent duplication by custom
;; 		   ;;     (memq tmp ntargets) 
;; 		   (setq ntargets (cons tmp ntargets))
;; 		   ;; )
;; 		   (setq targets (cdr targets)))
;; 		 )))
;; 	   ede-step-target-alist)))
;;       (oset this :targets ntargets))))


(defmethod project-rescan ((this ede-step-project))
  "Rescan the EDE proj project THIS."
  (cond ((eq 'writer (oref this project-mode))
	 (ede-with-projectfile this
	   (goto-char (point-min))
	   (let ((l (read (current-buffer)))
		 (fields (object-slots this))
		 (targets (oref this targets)))
	     (setq l (cdr (cdr l))) ;; objtype and name skip
	     (while fields ;  reset to defaults those that dont appear.
	       (if (and (not (assoc (car fields) l))
			(not (eq (car fields) 'file)))
		   (let ((eieio-skip-typecheck t))
		     ;; This is a hazardous thing, for some elements
		     ;; might not be bound.  Skip typechecking and duplicate
		     ;; unbound slots along the way.
		     (eieio-oset this (car fields)
				 (eieio-oref-default this (car fields)))))
	       (setq fields (cdr fields)))
	     (while l
	       (let ((field (car l)) (val (car (cdr l))))
		 (cond ((eq field targets)
			(let ((targets (oref this targets))
			      (newtarg nil))
			  (setq val (cdr val)) ;; skip the `list'
			  (while val
			    (let ((o (object-assoc (car (cdr (car val))) ; name
						   'name targets)))
			      (if o
				  (project-rescan o (car val))
				(setq o (eval (car val))))
			      (setq newtarg (cons o newtarg)))
			    (setq val (cdr val)))
			  (oset this targets newtarg)))
		       (t
			(eieio-oset this field val))))
	       (setq l (cdr (cdr l))))))) ;; field/value
	((eq 'scanner (oref this project-mode))
	 (let ((mf (or (and (not (string= "" (oref this :makefile)))
			    (oref this :makefile))
		       (ede-gnustep-get-valid-makefile (oref this :directory))))
	       (otargets (oref this targets))
	       (pn (oref this :name)) (ntargets nil))
	   (when mf
	     (oset this :makefile mf)
	     (with-temp-buffer
	       (insert-file-contents 
		(expand-file-name mf (oref this :directory)))
	       (goto-char (point-min))
	       ;; (setq pn (car (makefile-macro-file-list "PACKAGE_NAME")))
	       ;; (and pn (oset this :name pn))
	       (mapc
		;; Map all the different types
		(lambda (typecar)
		  (let ((macro (nth 2 typecar))
			(class (nth 1 typecar))
			)
		    (let ((tmp nil)(targets (makefile-macro-file-list macro)))
		      (while targets
			(setq tmp (object-assoc macro 'name otargets))
			(when (not tmp)
			  (if (eq class 'ede-step-project)
			      (setq tmp (apply (class-name this) (car targets) :name (car targets)
					       :directory (concat
							   (oref this :directory)
							   (car targets))
					       :metasubproject t
					       nil))
			    (setq tmp (apply class (car targets) :name (car targets)
					     :path (oref this :directory) nil))))
			(project-rescan tmp)
			;; (unless ;; prevent duplication by custom
			;;     (memq tmp ntargets) 
			(setq ntargets (cons tmp ntargets))
			;; )
			(setq targets (cdr targets)))
		      )))
		ede-step-target-alist)))
	   (oset this :targets ntargets)))))
	       

(defmethod project-rescan ((this ede-step-target) &optional readstream)
  "Rescan target THIS from the read list READSTREAM."
  (cond ((eq 'writer (oref (ede-current-project (oref this :path)) :project-mode))
	 (progn
	   (setq readstream (cdr (cdr readstream))) ;; constructor/name
	   (while readstream
	     (let ((tag (car readstream))
		   (val (car (cdr readstream))))
	       (eieio-oset this tag val))
	     (setq readstream (cdr (cdr readstream))))))
	((eq 'scanner (oref (ede-current-project (oref this :path)) :project-mode))
	 (let ((mf (ede-gnustep-get-valid-makefile (oref this :path))))
	   (oset this :source nil)
	   (with-temp-buffer
	     (insert-file-contents mf)(goto-char (point-min))
	     (oset this :source
		   (cons
		    (makefile-macro-file-list
		     (concat (oref this :name) "_C_FILES"))
		    (oref this :source)))
	     (oset this :source
		   (cons
		    (makefile-macro-file-list
		     (concat (oref this :name) "_OBJC_FILES"))
		    (oref this :source)))
	     (oset this :source
		   (cons
		    (makefile-macro-file-list
		     (concat (oref this :name) "_HEADER_FILES"))
		    (oref this :source))))))))


(defun ede-gnustep-get-valid-makefile (dir)
  (let ((mfs (directory-files dir nil "GNUmakefile*")) (found nil))
    (while (and (not found) mfs)
      (if (string= "" 
		   (shell-command-to-string
		    (concat "grep ^"
			    (regexp-quote "include $(GNUSTEP_MAKEFILES)/common.make")
			    " " (car mfs))))
	  (setq mfs (cdr mfs))
	(setq found t)))
    (car mfs)))


;;;###autoload
;; @todo - below is not compatible w/ Emacs 20!
(add-to-list 'ede-project-class-files
	     (ede-project-autoload "edegnustep"
	      :name "GNUstep-Make" :file 'ede-gnustep
	      :proj-file "ProjStep.ede"
	      :load-type 'ede-step-load
	      :class-sym 'ede-step-project)
	     t)

;;;###autoload
;; ;; @todo - below is not compatible w/ Emacs 20!
;; (add-to-list 'ede-project-class-files
;; 	     (ede-project-autoload "gnustep"
;; 	      :name "gnustep-make" :file 'ede-gnustep
;; 	      :proj-file "GNUmakefile"
;; 	      :load-type 'ede-gnustep-load
;; 	      :class-sym 'ede-gnustep-project)
;; 	     t)

;;;###autoload
(add-to-list 'auto-mode-alist '("ProjStep\\.ede" . emacs-lisp-mode))

;; (assoc "gnustep-make" (object-assoc-list 'name ede-project-class-files))


(provide 'ede-gnustep)

;;; ede-proj.el ends here



