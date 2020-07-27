##' .. content for \description{} (no empty lines) ..
##'
##' .. content for \details{} ..
##'
##' @title
##' @param scholar_citations
citations_summarize <- function(scholar_citations) {

  glue(
    "Total citations: {sum(scholar_citations$cites)}"
  )

}
