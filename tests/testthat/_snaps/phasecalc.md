# phasecalc returns 0 when the peak is at the start of the cycle

    Code
      phasecalc(cosine = 1, sine = 0)
    Output
      [1] 0

# phasecalc returns pi/2 when the peak is a quarter cycle in

    Code
      phasecalc(cosine = 0, sine = 1)
    Output
      [1] 1.570796

# phasecalc returns pi when the peak is half a cycle in

    Code
      phasecalc(cosine = -1, sine = 0)
    Output
      [1] 3.141593

# phasecalc returns 3pi/2 when the peak is three-quarters in

    Code
      phasecalc(cosine = 0, sine = -1)
    Output
      [1] 4.712389

