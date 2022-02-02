library(aws.s3)
library(readxl)
library(paws)


s3_read <- function(server) {
  
  # params and structuring ----
  
  #my bucket
  my_bucket <- paste(server,".pepfar.data.data-extracts",sep="")
  
  # Lists all of bucket contents, fill in your bucket
  choices <- aws.s3::get_bucket(bucket = my_bucket)
  
  # get just path names
  choices <- lapply(choices, "[[", 1)
  
  # get just file names
  cleaned_choices <- lapply(choices, function(x) gsub(".*\\/", "", x))
  
  # make dataframe of file names and path names
  choices <- do.call(rbind, Map(data.frame, file_names = cleaned_choices,
                                path_names = choices, stringsAsFactors = FALSE))
  
  # filter just files that end in txt or xlsx or csv
  choices <- choices[grepl("txt$|xlsx$|csv$", choices$file_names), ]
  
  # reset row names
  rownames(choices) <- NULL
  
  # read options ----
  
  #read in data, fill in your bucket name and file name (object should hold the name of the file you want to read)
  my_data <- "MER Structured Dataset (MSD)/MER FY2021 Q4 Pre-Cleaning/Site_IM/MER_Structured_Datasets_Site_IM_FY19-22_20211112_v1_1_Angola.txt"
  data <- aws.s3::s3read_using(FUN = readr::read_delim, "\t", escape_double = FALSE,
                               trim_ws = TRUE, col_types = readr::cols(.default = readr::col_character(),
                                                                       targets = readr::col_double(), qtr1 = readr::col_double(),
                                                                       qtr2 = readr::col_double(), qtr3 = readr::col_double(), qtr4 = readr::col_double(),
                                                                       cumulative = readr::col_double()), bucket = my_bucket, object = my_data)
  return(head(data, 5))
  
  
}




