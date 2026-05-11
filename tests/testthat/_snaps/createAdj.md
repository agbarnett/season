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
      

---

    Code
      adj_mat
    Output
      $num
      [1] 3 4 5 4 3
      
      $adj
       [1] 1 2 3 1 2 3 4 1 2 3 4 5 2 3 4 5 3 4 5
      
      $weight
       [1] 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
      

---

    Code
      adj_mat
    Output
      $num
      [1] 1 0 0 0 1
      
      $adj
      [1] 5 1
      
      $weight
      [1] 1 1
      

---

    Code
      adj_mat
    Output
      $num
      [1] 2 1 0 1 2
      
      $adj
      [1] 4 5 5 1 1 2
      
      $weight
      [1] 1 1 1 1 1 1
      

---

    Code
      adj_mat
    Output
      $num
      [1] 5 5 5 5 5
      
      $adj
       [1] 1 2 3 4 5 1 2 3 4 5 1 2 3 4 5 1 2 3 4 5 1 2 3 4 5
      
      $weight
       [1] 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
      

---

    Code
      adj_mat
    Output
      $num
      [1] 0 0 0 0 0
      
      $adj
      [1] 0
      
      $weight
      [1] 0
      

# adjacency matrix errors as expected

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

