
test_that("error", {
  expect_no_error(dropbox_downloader("https://www.dropbox.com/scl/fo/qyriu290caix39mlya8yl/AFqOwD2aND3V5hQ853eUFDY?rlkey=br087l0khtrb26y1nscj2ru37&dl=0"))
})

test_that("warning", {
  expect_no_warning(dropbox_downloader("https://www.dropbox.com/scl/fo/qyriu290caix39mlya8yl/AFqOwD2aND3V5hQ853eUFDY?rlkey=br087l0khtrb26y1nscj2ru37&dl=0"))
})

test_that("return string with filepath", {
  expect_type(dropbox_downloader("https://www.dropbox.com/scl/fo/qyriu290caix39mlya8yl/AFqOwD2aND3V5hQ853eUFDY?rlkey=br087l0khtrb26y1nscj2ru37&dl=0"),
                                 "character")
})
