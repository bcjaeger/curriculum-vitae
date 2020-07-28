##' .. content for \description{} (no empty lines) ..
##'
##' .. content for \details{} ..
##'
##' @title
##' @param infile
##' @param scholar_id
clean_r_packages <- function(infile = "r_packages.csv", scholar_pubs) {

  scholar_rpacks <- scholar_pubs %>%
    select(google_id = ID, cites)
  
  data_rpacks <- read_csv(file.path('data', infile)) %>% 
    separate_rows(google_id, sep = '; ') %>% 
    left_join(scholar_rpacks, by = 'google_id')
  
  stats_rpacks <- data_rpacks %>% 
    distinct(title) %>% 
    pull(title) %>% 
    cran_stats(use_cache = FALSE)
  
  years_rpacks <- stats_rpacks %>% 
    group_by(package) %>% 
    arrange(start) %>% 
    slice(1, n()) %>% 
    summarize(start = year(min(start)), 
              end = year(max(end)),
              .groups = 'drop') %>% 
    rename(title = package)
  
  total_downloads <- stats_rpacks %>% 
    group_by(package) %>% 
    summarize(downloads = sum(downloads), .groups = 'drop') %>% 
    transmute(title = as.character(package),
              downloads = tbl_val(downloads))
  
  data_rpacks %>% 
    group_by(title, link_cran, link_github, subtitle) %>% 
    summarize(cites = sum(cites), .groups = 'drop') %>% 
    left_join(years_rpacks, by = 'title') %>% 
    left_join(total_downloads, by = 'title') %>% 
    transmute(section = 'r_packages', 
              title,
              subtitle, 
              location = NA_character_,
              start, 
              end,
              description_1 = glue("[GitHub Repository]({link_github})"),
              description_2 = glue("Total downloads: {downloads}"),
              description_3 = glue("Total citations: {cites}"))
  
}
