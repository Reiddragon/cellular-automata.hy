(import pyxel
        random [randint])

;; Constants (by the honor system)
(setv SCREEN [720 450]
      COLOURS
      {"background" 0
       "foreground" 7}
      NUM_OF_SEEDS 5)

;; Init Pyxel
(defclass App []
  (defn __init__ [self]
    (pyxel.init #* SCREEN :fps 60 :title "Rule30.hy")
    ;; Init the cells
    (setv self.new-cells (lfor x (range pyxel.width) False)
          self.old-cells []
          self.time 0)
    ;; Place the seeds
    (for [_ (range NUM_OF_SEEDS)]
      (setv (get self.new-cells (randint 0 (- pyxel.width 1))) True))
    (pyxel.cls (get COLOURS "background")) ;; init the background
    (pyxel.run self.update self.draw))

  (defn update [self]
    (setv self.old-cells (. self.new-cells (copy)))
    ;; rule: left XOR (middle OR right)
    (for [i (range pyxel.width)]
      (setv (get self.new-cells i)
            (^
              (get self.old-cells (% (- i 1) pyxel.width))
              (or
                (get self.old-cells i)
                (get self.old-cells (% (+ i 1) pyxel.width))))))
    (setv self.time (% (+ self.time 1) pyxel.height)))

  (defn draw [self]
    (pyxel.line 0 self.time pyxel.width self.time (get COLOURS "background"))
    (for [x (range pyxel.width)]
      (if (get self.new-cells x)
        (pyxel.pset x self.time (get COLOURS "foreground"))))))



(if (= __name__ "__main__")
  (App))

