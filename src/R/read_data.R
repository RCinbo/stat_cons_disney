library(rprojroot)
library(tidyverse)
library(git2rdata)
datafolder <- find_root_file("data",
                             criterion = has_file("stat_cons_disney.Rproj"))
files <- list.files(
  path = paste0(datafolder, "/waiting times")) %>%
  as.list()

entities <- read.csv(file = paste0(datafolder, "/entities.csv")) %>%
  mutate(file = )
file_to_ride <-
  data.frame(file = files) %>%
  mutate(short_name = str_to_title(
    str_remove(
      str_replace_all(file, "_", " "), ".csv"))) %>%
  mutate(short_name = str_replace_all(short_name, " S ", "'s "),
         short_name = str_replace_all(short_name, " Of ", " of "),
         short_name = str_replace_all(short_name, "Philharmagic",
                                      "PhilharMagic"),
         short_name = str_replace_all(short_name, "Peoplemover",
                                      "PeopleMover"),
         short_name = str_replace_all(short_name, "Dinosaur",
                                      "DINOSAUR"),
         short_name = str_replace_all(short_name, "It's A Small World",
                                      "it's a small world"),
         short_name = str_replace_all(short_name, "  Cinderella Elena",
                                      ": Cinderella"),
         short_name = str_replace_all(short_name, "  Rapunzel Tiana",
                                      ": Tiana"),
         short_name = str_replace_all(short_name, "N Rollercoaster",
                                      "Coaster"),
         short_name = str_replace_all(short_name, "Soarin",
                                      "Soarin\'"),
         short_name = str_replace_all(short_name, "Tom Land",
                                      "Tom'land"),
         short_name = str_replace_all(short_name, "Mania",
                                      "Mania!"),
         short_name = str_replace_all(short_name, "Under The Sea",
                                      "Under the Sea"),
         short_name = str_replace_all(short_name, "Winnie The Pooh",
                                      "Winnie the Pooh")) %>%
  left_join(entities)
# #this saves all actual and posted times together. This file is 4 million records long an thus too big to work with
# waiting_times <- map(file_to_ride %>%
#               filter(!is.na(name)) %>% #only get waiting time for known rides
#               dplyr::pull(file) %>%
#               unique(),
#             function(x) {data <- read.csv(file = paste0(datafolder,
#                                                         "/waiting times/",
#                                                         x))
#             #only keep rows where SPOSTMIN changes
#             data_posted <- data %>%
#               filter(!is.na(SPOSTMIN)) %>%
#               arrange(datetime) %>%
#               filter(SPOSTMIN != lag(SPOSTMIN) | is.na(lag(SPOSTMIN)))
#             data <- data %>%
#                filter(!is.na(SACTMIN)) %>%
#                rbind(test_condensed) %>%
#                mutate(file = x) %>%
#                arrange(datetime)
#
#             return(data, data_posted)}
# )
# waiting_times <- do.call(rbind, waiting_times)#this is almost 4million rows -> better to keep only the posted waiting time when the customer started waiting? --> there are "only" 186173 ACTUAL waiting times


waiting_times <- map(file_to_ride %>%
                       filter(!is.na(name)) %>% #only get waiting time for known rides
                       dplyr::pull(file) %>%
                       unique(),
    function(x) {data <- read.csv(file = paste0(datafolder,
                                                "/waiting times/",
                                                x)) %>%
      mutate(file = x)
    #only keep rows where SPOSTMIN changes
    data_posted <- data %>%
      filter(!is.na(SPOSTMIN)) %>%
      arrange(datetime) %>%
      filter(SPOSTMIN != lag(SPOSTMIN) | is.na(lag(SPOSTMIN))) %>%
      mutate(datetime = as.POSIXct(datetime)) %>%
      dplyr::select(-SACTMIN)
    data <- data %>%
      dplyr::select(-SPOSTMIN) %>%
      filter(!is.na(SACTMIN)) %>%
      mutate(datetime = as.POSIXct(datetime)) %>%
      mutate(start_wait = datetime - as.difftime(SACTMIN, units = "mins"))
    a <- sapply(data$start_wait, FUN = function(x) {
      b <- which(data_posted$datetime <= x &
                       lead(data_posted$datetime) > x)
      c <- ifelse(length(b) == 0,
                  NA,
                  data_posted[b, "SPOSTMIN"])
      return(c)
    })
    data$posted_at_start_wait <- a
    # rbind(test_condensed) %>%
    # mutate(file = x) %>%
    # arrange(datetime)

    return(list(data, data_posted))}
)
data <- map(waiting_times, pluck, 1)
data <- do.call(rbind, data)

data_posted <- map(waiting_times, pluck, 2)
data_posted <- do.call(rbind, data_posted)
#duurde in totaal ongeveer 10min

#save clean data
write_vc(x = data,
         file = "waiting_times",
         root = datafolder,
         sorting = c("file", "datetime", "SACTMIN"))
write_vc(x = data,
         file = "waiting_times",
         root = datafolder,
         sorting = c("file", "datetime", "SACTMIN"))
write_vc(file_to_ride,
         file = "file_to_ride",
         root = datafolder,
         sorting = c("file", "opened_on"))

# Make an adjacency matrix for the different lands?
