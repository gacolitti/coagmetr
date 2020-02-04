#' Get CoAgMet Data
#' 
#' @param table A character specifying which data table to get. Can be one of 
#'   \code{"meta", "daily", "hourly", "five_minute", "soilmoisture_daily", "soilmoisture_hourly"}.
#'   When \code{table = "meta"} source must be either \code{"coag"} or \code{"coop"}.
#' @param source Currently the only supported source is \code{"coag"}.
#' @param stations An optional vector of weather station names to get data for. 
#'   See \url{https://coagmet.colostate.edu/station_index.php}. Defaults to all stations.
#' @param geo_region A numeric vector of length 4. Used to specify southwest and northwest coordinates
#'   of the geographic region (box) in which data should be retrieved. 
#' @param start_date Start date in \code{yyyy-mm-dd} format.
#' @param end_date End date in \code{yyyy-mm-dd} format.
#' @param elements A character vector of one or more elements found in table.
#'
#' @importFrom attempt stop_if_all
#' @importFrom purrr compact
#' @importFrom rvest html_text
#' @importFrom xml2 read_html
#' @importFrom httr GET
#' @importFrom readr read_csv
#' @importFrom readr read_fwf
#' @importFrom readr fwf_widths
#' @importFrom readr cols
#' @export
#' @rdname get_coagmet_data
#'
#' @return the results from the search
#' @examples 
#' \dontrun{
#' 
#' # Get station meta data
#' get_coagmet_data("meta")
#' 
#' # Get one day of daily data for all stations
#' get_coagmet_data("daily", start_date = "2011-01-01", end_date = "2012-01-01)
#' 
#' # Get hourly data beginning with January 1st, 2020
#' get_coagmet_data("hourly", start_date = "2020-01-01")
#' }

get_coagmet_data <- function(table = c("meta", "daily", "hourly", "five_minute", 
                                          "soilmoisture_daily", "soilmoisture_hourly"),
                                source = c("coag"),
                                stations = NULL,
                                geo_region = NULL,
                                start_date = NULL,
                                end_date = NULL,
                                elements = NULL) {
    if (table == "meta" & !source %in% c("coag", "coop")) {
      stop("Meta data is only available for sources coag and coop")
    }
  
    args <- list(
      type = table,
      src = source,
      sids = stations,
      bbox = geo_region,
      sdate = start_date,
      edate = end_date,
      elems = elements
    )
    # Check that at least one argument is not null
    stop_if_all(args, is.null, "You need to specify at least one argument")
    # Chek for internet
    check_internet()
    # Send the GET request
    res <- GET(base_url, query = compact(args))
    # Check the result
    check_status(res)
    # Get the content and return it as a data.frame
    html <- read_html(res)
    html_text <- html_text(html)
    
    if (table == "meta") {
      widths <- c(6, 32, 44, 9, 12, 5, 4, NA)
      cols <-
        c(
          "station_id",
          "station_name",
          "station_location",
          "latitude",
          "longitude",
          "elevation_ft",
          "data_logger_format",
          "active"
        )
      out <- read_fwf(
        html_text,
        col_positions = fwf_widths(widths, cols)
      )
    } else if (table == "daily") {
      cols <- c(
        "station_id",
        "date",
        "tave",
        "tmax",
        "mxtm",
        "tmin",
        "mntm",
        "vp",
        "rhmax",
        "rhmxtm",
        "rhmin",
        "rhmntm",
        "sr",
        "wrun",
        "pp",
        "st5mx",
        "st5mxtm",
        "st5mn",
        "st5mntm",
        "st15mx",
        "st15mxtm",
        "st15mn",
        "st15mntm",
        "volts",
        "year",
        "gust",
        "gusttm",
        "gustdir",
        "etr",
        "etr_pk",
        "etr_hly",
        "eto"
      )
      out <- read_csv(html_text,
                      col_names = cols)
    } else if (table == "hourly") {
      cols <- c(
        "station_id",
        "datetime",
        "tmean",
        "rh",
        "vp",
        "sr",
        "ws",
        "wind_vec",
        "wind_std",
        "pp",
        "st5",
        "st15",
        "gust",
        "gusttm",
        "gustdir",
        "etr",
        "eto"
      )
      out <- read_csv(html_text,
                      col_names = cols)
    } else if (table == "five_minute") {
      cols <- c(
        "station_id",
        "datetime",
        "volt",
        "tmean",
        "rh",
        "vp",
        "sr",
        "ws",
        "wind_vec",
        "wind_std",
        "pp",
        "st5",
        "st15",
        "gust",
        "gusttm",
        "gustdir"
      )
      out <- read_csv(html_text,
                      col_names = cols)
    } else if (table == "soilmoisture_daily" |
               table == "soilmoisture_hourly") {
      cols <- c("station_id", 
                "datetime",
                "vwc4",
                "ec4",
                "st4",
                "vwc24",
                "ec24",
                "st24")
      out <- read_csv(html_text,
                      col_names = cols)
    }
    return(out)
  }
