; tags
(setq org-tag-persistent-alist
      '((:startgroup . nil)
        ("@lab" . ?l) ("@dorm" . ?d) ("@outside" . ?o) ; place
        (:endgroup . nil)
        ("w_mentor" . ?m) ("w_gf" . ?g) ; with whom, {mentor, girlfriend}
        (:startgroup . nil)
        ("pc_internet" . ?i) ("pc_offnet" . ?f) ; whether internet needed
        (:endgroup . nil)
        ("phone" . ?p)
        ))
(provide 'init-orgMark)
