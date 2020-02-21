
context("Get Coagmet Data")

library(coagmetr)

test_that("meta-data-is-unchanged", {
  expect_equal(nrow(get_coagmet_data(table = "meta")), 115)
  expect_equal(ncol(get_coagmet_data(table = "meta")), 8)
})

test_that("five-minute-data-is-returned", {
  expect_equal(nrow(get_coagmet_data("five_minute", start_date = "2012-01-01", end_date = "2012-02-01")),
            17858)
})

test_that("hourly-data-is-returned", {
  expect_equal(nrow(get_coagmet_data("hourly", start_date = "2011-07-01", end_date = "2011-07-03")),
            3136)
})

test_that("daily-data-is-returned", {
  expect_equal(nrow(get_coagmet_data("daily", start_date = "2015-02-21", end_date = "2015-04-03")),
            3043)
})

test_that("soil-moisture-daily-data-is-returned", {
  expect_equal(nrow(get_coagmet_data("soilmoisture_daily", start_date = "2017-04-11", end_date = "2017-04-18")),
            120)
})

test_that("soil-moisture-hourly-data-is-returned", {
  expect_equal(nrow(get_coagmet_data("soilmoisture_hourly", start_date = "2017-04-11", end_date = "2017-04-18")),
            2537)
})
