

##' prints the section to markdown.
##'
##' .. content for \details{} ..
##'
##' @title print CV sections
##' @param position_data 
##' @param section_id 
##'
print_section <- function(position_data, section_id){
  position_data %>% 
    filter(section == section_id) %>% 
    arrange(desc(end)) %>% 
    mutate(
      id = 1:n(),
      description_1 = if_else(
        condition = is.na(description_1),
        true = "",
        false = as.character(description_1)
      )
    ) %>% 
    pivot_longer(
      starts_with('description'),
      names_to = 'description_num',
      values_to = 'description',
      values_drop_na = TRUE
    ) %>% 
    group_by(id) %>% 
    mutate(descriptions = list(description)) %>% 
    ungroup() %>% 
    filter(description_num == 'description_1') %>% 
    mutate(
      timeline = ifelse(
        is.na(start) | start == end,
        end,
        glue('{end} - {start}')
      ),
      description_bullets = map_chr(
        .x = descriptions, 
        .f = ~ {
          if(length(.x)==1)
            paste(.x, '\n') 
          else 
            paste('-', .x, collapse = '\n')
        }
      )
    ) %>% 
    mutate(
      location = ifelse(is.na(location), 'N/A', location),
      description_bullets = if_else(
        condition = is.na(aside),
        true = description_bullets,
        false = as.character(glue(
          "{description_bullets}",
          "\n\n", 
          ":::aside",
          "\n",
          "{aside}",
          "\n",
          ":::"
        )
        ))
    ) %>% 
    glue_data(
      "### {title}",
      "\n\n",
      "{subtitle}",
      "\n\n",
      "{location}",
      "\n\n",
      "{timeline}", 
      "\n\n",
      "{description_bullets}",
      "\n\n\n",
    )
}

