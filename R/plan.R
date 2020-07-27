

the_plan <- drake_plan(
  
  # scholar id for byron c. jaeger,
  # to find yours, 
  # - go to https://scholar.google.com 
  # - click 'my profile' (then create a profile if you do not have one).
  # - If you have a profile already, your Google Scholar ID will be shown in
  #   the URL. Otherwise, please follow the registration prompts and your 
  #   Google Scholar ID will be in the URL.
  scholar_id = '4IKD_roAAAAJ&hl=en&oi=ao',
  
  # get citation info
  scholar_citations = citations_scrape(scholar_id),
  
  scholar_citations_summary = citations_summarize(scholar_citations),

  # a clean dataset ready for .Rmd docs
  data_pubs = clean_pubs(infile = 'publications.csv', 
                         scholar_citations = scholar_citations,
                         author = 'BC Jaeger'),
  
  scholar_data = bind_scholar_data(data_pubs),
  
  # build your .Rmd CV
  target_name = target(
    command = {
      rmarkdown::render(knitr_in("index.Rmd"))
      file_out("index.html")
    }
  )
  

)
