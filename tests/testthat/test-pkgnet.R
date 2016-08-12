context("Basic use of pkgnet()")

test_that("pkgnet() works on built-in matrix", {
  g <- pkgnet(avpkgs)
  expect_s3_class(g, "igraph")
})

test_that("pkgnet() works with an URL", {
  skip_on_cran()
  g <- pkgnet("https://cloud.r-project.org")
  expect_s3_class(g, "igraph")
})




context("pkgnet() works with CRAN and Bioconductor")


test_that("pkgnet works with CRAN cloud", {
  skip_on_cran()
  g <- pkgnet("cran")
  expect_s3_class(g, "igraph")
  expect_gt( igraph::vcount(g), 0)
  expect_gt( igraph::ecount(g), 0)
})


test_that("pkgnet works with Bioconductor", {
  skip_on_cran()
  g <- pkgnet("bioc")
  expect_s3_class(g, "igraph")
  expect_gt( igraph::vcount(g), 0)
  expect_gt( igraph::ecount(g), 0)
})




