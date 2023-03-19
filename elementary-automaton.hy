(import pyxel
        random [randint]
        sys [argv])

;; Constants (by the honor system)
(setv SCREEN #(720 450)
      COLOURS {"background" 0
               "foreground" 7}
      NUM_OF_SEEDS 5)

(defclass App []
  (defn __init__ [self]
    (pyxel.init #* SCREEN :fps 30)
    (setv self.new-cells (lfor x (range pyxel.width) 0)
          self.old-cells []
          self.time 0
          self.rule (if (> (len argv) 1) (int (get argv 1)) (randint 0 255)))
    (pyxel.title f"Elementary Automaton (Rule {self.rule})")
    (for [_ (range NUM_OF_SEEDS)]
      (setv (get self.new-cells (randint 0 (- pyxel.width 1))) 1))
    (pyxel.cls (get COLOURS "background")) ;; init the background
    (pyxel.run self.update self.draw))

  (defn update [self]
    (setv self.old-cells (. self.new-cells (copy)))
    (for [i (range pyxel.width)]
      (setv (get self.new-cells i)
            (& 1 (>>
                   self.rule
                   (+
                    (* (get self.old-cells (% (- i 1) pyxel.width)) 0b100)
                    (* (get self.old-cells i) 0b10)
                    (get self.old-cells (% (+ i 1) pyxel.width)))))))
    (setv self.time (% (+ self.time 1) pyxel.height)))

  (defn draw [self]
    (pyxel.line 0 self.time pyxel.width self.time (get COLOURS "background"))
    (for [x (range pyxel.width)]
      (when (get self.new-cells x)
        (pyxel.pset x self.time (get COLOURS "foreground"))))))


(when (= __name__ "__main__")
  (App))

