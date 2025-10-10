library(biocViews)

which_single_term <- function(query_term, pkg_info, dag) {
  query_terms <- biocViews::getSubTerms(dag = dag, term = query_term)
  which_pkgs <- vapply(
    X = pkg_info$biocViews,
    FUN = function(pkg_terms, query_terms) {
      any(pkg_terms %in% query_terms)
    },
    FUN.VALUE = logical(1),
    query_terms = query_terms
  )
}

which_multiple_terms <- function(query_terms, pkg_info, dag) {
  which_pkgs_list <- lapply(
    X = query_terms,
    FUN = which_single_term,
    pkg_info = pkg_info,
    dag = dag
  )
  which(Reduce(f = `&`, x = which_pkgs_list))
}
