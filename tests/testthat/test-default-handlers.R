context("default handlers")

test_that("404 handler sets 404", {
  res <- PlumberResponse$new()
  val <- default404Handler(list(), res)
  expect_equal(res$status, 404)
  expect_match(val$error, "404")
  expect_match(val$error, "Not Found")
})

test_that("default error handler returns an object with an error property", {
  res <- PlumberResponse$new()
  capture.output(val <- defaultErrorHandler(FALSE)(list(), res, "I'm an error!"))
  expect_match(val$error, "500")
  expect_match(val$error, "Internal server error")
  expect_equal(res$status, 500)
})
test_that("error handler doesn't clobber non-200 status", {
  res <- PlumberResponse$new()
  res$status <- 403
  capture.output(val <- defaultErrorHandler(FALSE)(list(), res, "I'm an error!"))
  expect_match(val$error, "Internal error")
  expect_equal(res$status, 403)
})

test_that("error handler only includes message in debug mode.", {
  res <- PlumberResponse$new()
  capture.output(val <- defaultErrorHandler(FALSE)(list(), res, "I'm an error!"))
  expect_null(val$message)

  res <- PlumberResponse$new()
  capture.output(val <- defaultErrorHandler(TRUE)(list(), res, "I'm an error!"))
  expect_equal(val$message, "I'm an error!")
})
