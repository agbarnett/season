# inyrfraction works

    Code
      invyrfraction(frac = c(0, 0.5, 1), type = "hourly", text = TRUE)
    Output
      [1] "Hour = 0"  "Hour = 12" "Hour = 24"

---

    Code
      invyrfraction(frac = c(0, 0.5, 1), type = "hourly", text = FALSE)
    Output
      [1]  0 12 24

---

    Code
      invyrfraction(frac = c(0, 0.5, 0.99), type = "daily", text = TRUE)
    Output
      [1] "Month = January , day = 1"   "Month = July , day = 2"     
      [3] "Month = December , day = 28"

---

    Code
      invyrfraction(frac = c(0, 0.5, 0.99), type = "daily", text = FALSE)
    Output
      [1]   1.0000 183.6250 362.5975

---

    Code
      invyrfraction(frac = c(0, 0.5, 1), type = "weekly", text = TRUE)
    Output
      [1] "Week = 1"  "Week = 27" "Week = 53"

---

    Code
      invyrfraction(frac = c(0, 0.5, 1), type = "weekly", text = FALSE)
    Output
      [1]  1 27 53

---

    Code
      invyrfraction(frac = c(0, 0.5, 1), type = "monthly", text = TRUE)
    Output
      [1] "Month = 1"  "Month = 7"  "Month = 13"

---

    Code
      invyrfraction(frac = c(0, 0.5, 1), type = "monthly", text = FALSE)
    Output
      [1]  1  7 13

