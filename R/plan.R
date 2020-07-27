

the_plan <- drake_plan(
  
  # scholar id for byron c. jaeger,
  # to find yours, 
  # - go to https://scholar.google.com 
  # - click 'my profile' (then create a profile if you do not have one).
  # - If you have a profile already, your Google Scholar ID will be shown in
  #   the URL. Otherwise, please follow the registration prompts and your 
  #   Google Scholar ID will be in the URL.
  scholar_id  = '4IKD_roAAAAJ&hl=en&oi=ao',
  author_abbr = "BC Jaeger",
  author_long = 'Byron C. Jaeger',
  
  # get citation info
  scholar_citations = citations_scrape(scholar_id),
  
  scholar_citations_summary = citations_summarize(scholar_citations),

  # each dataset represents a section in the CV
  # pubs -> Publications section
  # grants -> Grants submitted section
  
  pubs = clean_pubs(infile = 'publications.csv', 
                    scholar_citations = scholar_citations,
                    .author = author_abbr),
  
  grants = clean_grants(infile = 'grants.csv', 
                        .author = author_abbr),
  
  r_packages = clean_r_packages(infile = 'r_packages.csv', 
                                scholar_id = scholar_id),
  
  # bind selected data together
  scholar_data = bind_scholar_data(pubs, grants, r_packages),
  
  # build your .Rmd CV
  target_name = target(
    command = {
      rmarkdown::render(knitr_in("index.Rmd"))
      file_out("index.html")
    }
  )
  

)
