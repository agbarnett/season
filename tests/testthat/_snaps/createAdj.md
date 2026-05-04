# adjacency matrix works

    Code
      adj_mat
    Output
      $num
      [1] 1 2 2 2 1
      
      $adj
      [1] 2 1 3 2 4 3 5 4
      
      $weight
      [1] 1 1 1 1 1 1 1 1
      

# adjacency matrix errors as expectd

    Code
      createAdj(matrix = as.data.frame(V))
    Condition
      Error in `createAdj()`:
      ! Input must be a matrix

---

    Code
      createAdj(matrix = rbind(V, c(rep(0, 5))))
    Condition
      Error in `createAdj()`:
      ! Matrix must be square

---

    Code
      createAdj(matrix = V)
    Condition
      Error in `createAdj()`:
      ! Matrix must be symmetric

