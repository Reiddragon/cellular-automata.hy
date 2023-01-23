(import pyxel)
(import random [randint])

;; Constants (by the honor system)
(setv SCREEN [720 450]
      COLOURS
      {"background" 0
       "foreground" 7}
      NUM_OF_SEEDS 5)

;; Init Pyxel
(pyxel.init #* SCREEN :fps 60 :title "Rule30.hy")

;; Init the cells
(setv new-cells (lfor x (range pyxel.width) False)
      old-cells []
      time 0)

(for [_ (range NUM_OF_SEEDS)]
  (setv (get new-cells (randint 0 (- pyxel.width 1))) True))

(defn update []
  (global time)
  (setv old-cells (. new-cells (copy)))
  ;; rule: left XOR (middle OR right)
  (for [i (range pyxel.width)]
    (setv (get new-cells i)
          (^
            (get old-cells (% (- i 1) pyxel.width))
            (or
              (get old-cells i)
              (get old-cells (% (+ i 1) pyxel.width))))))
  (setv time (% (+ time 1) pyxel.height)))

(pyxel.cls (get COLOURS "background")) ;; Draw the background initially
(defn draw []
  (pyxel.line 0 time pyxel.width time (get COLOURS "background"))
  (for [x (range pyxel.width)]
    (if (get new-cells x)
      (pyxel.pset x time (get COLOURS "foreground")))))



(if (= __name__ "__main__")
  (pyxel.run update draw))

