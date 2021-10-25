

the_plan <- drake_plan(
  
  # scholar id for byron c. jaeger,
  # to find yours, 
  # - go to https://scholar.google.com 
  # - click 'my profile' (then create a profile if you do not have one).
  # - If you have a profile already, your Google Scholar ID will be shown in
  #   the URL. Otherwise, please follow the registration prompts and your 
  #   Google Scholar ID will be in the URL.
  scholar_id   = '4IKD_roAAAAJ&hl=en&oi=ao',
  scholar_short = "BC Jaeger",
  scholar_long  = 'Byron C. Jaeger',
  
  # get citation info
  scholar_pubs = get_scholar_pubs(scholar_id),
  
  #total_citations = with(scholar_pubs, glue("Total citations: {sum(cites)}")),

  # each dataset represents a section in the CV
  # pubs -> Publications section
  # grants -> Grants submitted section
  
  pubs = clean_pubs(infile = 'publications.csv', 
                    scholar_pubs = scholar_pubs,
                    .author = scholar_short),
  
  pres = clean_pres(infile = 'presentations.csv',
                    scholar_pubs = scholar_pubs,
                    .author = scholar_short),
  
  grants = clean_grants(infile = 'grants.csv', 
                        .author = scholar_short),
  
  r_packages = clean_r_packages(infile = 'r_packages.csv', 
                                scholar_pubs = scholar_pubs),
  
  # build your .Rmd CV
  # this needs to be done manually now
  # and should also be cone before making the targets below
  # website_output = target(
  #   command = {
  #     rmarkdown::render(knitr_in("index.Rmd"))
  #     file_out("index.html")
  #   }
  # ),
  
  # to make the pdf version, run pagedown::chrome_print('index.html'),
  
)
