## ui.R ##
library(shinydashboard)

ui_choose_task <- tagList(
  h1("Choose a task"),
  h2("By biocView"),
  actionLink(inputId = "get_packages_by_view", label = "Find packages tagged with a biocViews term"),
  h2("By package"),
  actionLink(inputId = "get_similar_packages", label = "Find packages similar to a query package"),
)

ui_get_packages_by_view <- tagList(
  selectizeInput(inputId = "query_biocviews", label = "Query", choices = sort(biocViewsVocab@nodes), selected = NULL, multiple = TRUE),
  textOutput(outputId = "filtered_pkg_summary"),
  tableOutput(outputId = "filtered_pkg_list")
)

ui_get_similar_packages <- tagList(
  p("Page under construction")
)

get_dashboard_body <- function(which = NA) {
  uiOutput(outputId = "ui_body")
}

ui <- dashboardPage(
  dashboardHeader(),
  dashboardSidebar(),
  dashboardBody(
    get_dashboard_body()
  )
)
