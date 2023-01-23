#!/usr/bin/env hy
(import pyxel
        random [randint])


;; Constants (by the honor system)
(setv SCREEN [128 128]
      FOREGROUND 5
      BACKGROUND 1
      ANT-COLOUR 6
      NUM-OF-ANTS 4)


(defclass Ant []
  (defn __init__ [self x y [r 0]]
    (setv self.x x
          self.y y
          self.r r))

  (defn update [self grid]
    (if (get grid self.x self.y)
      (-= self.r 1)
      (+= self.r 1))
    (%= self.r 4)
    (setv (get grid self.x self.y) (not (get grid self.x self.y)))
    (match self.r
      0 (-= self.x 1)
      1 (+= self.y 1)
      2 (+= self.x 1)
      3 (-= self.y 1))
    (%= self.x pyxel.width)
    (%= self.y pyxel.height))

  (defn draw [self]
    (pyxel.pset self.x self.y ANT-COLOUR)))


(defclass App []
  (defn __init__ [self]
    (pyxel.init #* SCREEN :fps 60 :title "Langton's Ant")
    ;; init the grid
    (setv self.grid (lfor x (range pyxel.width)
                    (lfor y (range pyxel.height) False))
          self.ants (lfor ant (range NUM-OF-ANTS)
                      (Ant (randint 0 (- pyxel.width 1))
                           (randint 0 (- pyxel.height 1))
                           (randint 0 3))))
    (pyxel.run self.update self.draw))

  (defn update [self]
    (for [ant self.ants]
      (ant.update self.grid)))

  (defn draw [self]
    (pyxel.cls BACKGROUND)
    (for [y (range pyxel.height)]
      (for [x (range pyxel.width)]
        (if (get self.grid x y)
          (pyxel.pset x y FOREGROUND))))
    (for [ant self.ants]
      (ant.draw))))


(if (= __name__ "__main__")
  (App))

