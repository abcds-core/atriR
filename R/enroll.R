#' @title Retrieve Enrollment-Related Variables from ABC-DS Data
#' @description
#' Extracts one or more enrollment-related variables from an ABC-DS
#' dataset using the specified codebook. The function supports optional
#' filtering by site and cycle and allows applying variable labels for
#' enhanced interpretability.
#'
#' @param ... One or more unquoted variable names to retrieve from the dataset.
#' @param site Optional; a site identifier or vector of site codes to
#'   subset data by site. Default is `NULL`.
#' @param cycle Optional; a cycle identifier or vector of cycles to
#'   subset data by cycle. Default is `NULL`.
#' @param apply_labels Logical; if `TRUE`, applies variable labels from
#'   the codebook to the returned data. Default is `FALSE`.
#' @param controls A boolean value that indicates whether the function
#'   should return the controls, Default is `FALSE`
#'
#' @return
#' A data frame containing the selected variables and any applied
#' filters (site and/or cycle). If `apply_labels = TRUE`, variable
#' labels are attached to the output as attributes.
#'
#' @details
#' This function provides a convenient wrapper around get_data
#' to streamline access to ABC-DS enrollment variables. Quasiquotation
#' is used to support tidy evaluation, allowing unquoted variable names
#' and symbol references.
#'
#' @examples
#' \dontrun{
#' if (interactive()) {
#'   # Retrieve selected enrollment variables
#'   enrollment_data <- get_enrollment(
#'     enroll,
#'     site = "Site01",
#'     cycle = "Cycle2",
#'     apply_labels = TRUE
#'   )
#' }
#' }
#' @rdname get_enrollment
#' @export

get_enrollment <- function(
  ...,
  site = NULL,
  cycle = NULL,
  apply_labels = FALSE,
  controls = FALSE
) {
  variables <- as.character(rlang::ensyms(...))
  get_data(
    study = "abcds",
    dataset = "enroll",
    codebook = "enroll",
    variables,
    site = site,
    cycle = cycle,
    apply_labels = apply_labels,
    controls = controls
  )
}
