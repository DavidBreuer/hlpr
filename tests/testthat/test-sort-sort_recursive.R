context("sort / sort_recursive")

test_that("recursive sorting works for nested list of lists", {
  yo <- list(b = 1, a = "c", c = 1)
  xo <- list(2, 3, 1)
  xs <- list(2, 3, 1)
  ys <- list(a = "c", b = 1, c = 1)
  source <- list(y = yo, x = xo, z = 1)
  target <- list(x = xs, y = ys, z = 1)
  expect_equal(sort_recursive(source), target)
})

