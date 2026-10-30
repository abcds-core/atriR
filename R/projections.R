#' Generate Demographic Projections
#'
#' Retrieves current demographic data and rescales enrollment counts to a
#' target projection size, broken down by race, ethnicity, and gender.
#'
#' @param projection_no Integer. Target total enrollment count to project onto.
#'   Current observed proportions are preserved; cell counts are rescaled to
#'   sum to this value.
#' @param ... Optional parameters to filter the demographics dataset by to get
#'  a more focused projection number (e.g., site_label == "KUMC")
#' @param controls Logical. If `TRUE`, include control subjects in the
#'   demographic pull. Passed directly to `get_demographics()` and
#'   `get_disposition()`. Default `FALSE`.
#' @param include_ltfu Logical. If `TRUE`, retain subjects lost to follow-up
#'   (LTFU) in the counts. If `FALSE` (default), LTFU subjects identified via
#'   `get_disposition()` are excluded before summarising.
#'
#' @return A named list with two elements:
#'   \describe{
#'     \item{`Original`}{A data frame of observed counts cross-tabulated by
#'       ethnicity, gender, and race category, with row and column totals
#'       appended.}
#'     \item{`Projected`}{The same structure with counts rescaled to
#'       `projection_no`, rounded to whole numbers.}
#'   }
#'
#' @details
#' Race categories are treated as non-exclusive in the source data; subjects
#' endorsing more than one race category are recoded into a synthetic
#' `"More than One Race"` category and removed from all individual race columns.
#'
#' Projection scaling preserves within-column proportions:
#' each cell is multiplied by `(projection_no / column_total)`. Cells whose
#' column total is zero are left as zero. Note that independent rounding of
#' each cell may cause projected column totals to differ from `projection_no`
#' by ±1; use a largest-remainder method if exact totals are required.
#'
#' @seealso [get_demographics()], [get_disposition()]
#'
#' @examples
#' \dontrun{
#' result <- get_demographic_projections(projection_no = 500)
#' result$Original
#' result$Projected
#'
#' # Include control subjects and retain LTFU
#' result_full <- get_demographic_projections(
#'   projection_no = 500,
#'   controls      = TRUE,
#'   include_ltfu  = TRUE
#' )
#' }
#' @export
#' @importFrom dplyr filter all_of mutate group_by summarise across where
#' @importFrom tidyr pivot_longer pivot_wider

get_demographic_projections <- function(
  projection_no,
  ...,
  controls = FALSE,
  include_ltfu = FALSE
) {
  dots <- rlang::enquos(...)
  demo_vars <- c("de_gender", "de_race", "de_ethnicity")

  race_categories <- c(
    "White",
    "Black/African-American/African/Caribbean/Black British",
    "Asian/Asian British",
    "American Indian/Alaskan Native",
    "Native Hawaiian/Other Pacific Islander"
  )

  # ── Pull & recode demographics ──────────────────────────────────────────────

  demo_df <- get_demographics(
    !!!demo_vars,
    apply_labels = TRUE,
    controls = controls
  )

  # Filter out missing values
  demo_df <- demo_df |>
    dplyr::filter(!dplyr::if_any(demo_vars, is.na), !!!dots)

  demo_df$de_ethnicity <- factor(
    demo_df$de_ethnicity,
    levels = c("No", "Yes"),
    labels = c("Not Hispanic/Latino", "Hispanic/Latino")
  )

  if (!any(demo_df$de_gender == "Other")) {
    demo_df$de_gender <- factor(demo_df$de_gender, levels = c("Female", "Male"))
  }

  # ── Optionally drop LTFU subjects ──────────────────────────────────────
  if (!include_ltfu) {
    disp <- get_disposition("sdstatus", controls = controls)
    demo_df <- dplyr::filter(
      demo_df,
      !.data$subject_label %in% disp$subject_label
    )
  }

  # ── Ensure all expected race columns exist ─────────────────────────────
  all_race_columns <- c(race_categories, "Other", "Unknown or Not Reported")
  missing_cols <- setdiff(all_race_columns, colnames(demo_df))

  if (length(missing_cols) > 0) {
    demo_df[, missing_cols] <- 0
  }

  demo_df[["More than One Race"]] <- as.numeric(
    rowSums(demo_df[, race_categories]) > 1
  )

  demo_df[demo_df[["More than One Race"]] == 1, race_categories] <- 0

  # ── Summarise data ────────────────────────────────────────

  demo_tbl <- demo_df |>
    tidyr::pivot_longer(
      cols = dplyr::all_of(c(all_race_columns, "More than One Race")),
      names_to = "Category"
    ) |>
    dplyr::mutate(
      Category = factor(
        .data$Category,
        levels = c(all_race_columns, "More than One Race")
      )
    ) |>
    dplyr::group_by(.data$de_ethnicity, .data$de_gender, .data$Category) |>
    dplyr::summarise(n = sum(.data$value, na.rm = TRUE), .groups = "drop") |>
    tidyr::pivot_wider(
      names_from = c(.data$de_ethnicity, .data$de_gender),
      names_expand = TRUE,
      values_from = .data$n,
      values_fill = 0
    )

  totals <- rowSums(demo_tbl[, sapply(demo_tbl, is.numeric)])
  newtotals <- totals / sum(totals) * projection_no

  demo_tbl_adj <- demo_tbl |>
    dplyr::mutate(
      dplyr::across(
        dplyr::where(is.numeric),
        \(x) {
          ifelse(totals == 0, 0, round((x / totals) * newtotals))
        }
      )
    )

  add_totals <- function(x) {
    x$Totals <- rowSums(x[, sapply(x, is.numeric)])
    col_totals <- colSums(x[, sapply(x, is.numeric)])

    rbind(
      x,
      cbind(
        Category = "Totals",
        as.data.frame(as.list(col_totals), check.names = FALSE)
      )
    )
  }

  list(
    Original = add_totals(demo_tbl),
    Projected = add_totals(demo_tbl_adj)
  )
}
