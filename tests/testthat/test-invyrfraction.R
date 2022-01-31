test_that("inyrfraction works", {
  expect_equal(invyrfraction(c(0,0.5,1),type="hourly"),c("Hour = 0","Hour = 12","Hour = 24"))
  expect_equal(invyrfraction(c(0,0.5,1),type="monthly"),c("Month = 1","Month = 7","Month = 13"))   
  expect_equal(invyrfraction(c(0,0.5,1),type="weekly"),c("Week = 1","Week = 27","Week = 53"))
})

