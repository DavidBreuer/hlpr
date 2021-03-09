#' @title List of default linter settings
#' @description List of default linter settings
#' @export
#' @author david.breuer
set_linters <- function() {
  require_namespaces("lintr")

  linters_list <- list(

    # Files
    commented_code_linter = lintr::commented_code_linter,

    # Syntax
    objectName_linter = lintr::camel_case_linter,
    object.name_linter = lintr::multiple_dots_linter,
    object_length_linter = lintr::object_length_linter(
      length = 20L
    ),

    commas_linter = lintr::commas_linter,
    spaces_left_parentheses_linter = lintr::spaces_left_parentheses_linter,

    spaces_inside_linter = lintr::spaces_inside_linter,

    open_curly_linter = lintr::open_curly_linter(
      allow_single_line = TRUE
    ),
    closed_curly_linter = lintr::closed_curly_linter(
      allow_single_line = TRUE
    ),
    no_tab_linter = lintr::no_tab_linter,
    line_length_linter = lintr::line_length_linter(
      length = 80L
    ),
    assignment_linter = lintr::assignment_linter,

    single_quotes_linter = lintr::single_quotes_linter

    # More
    # extraction_operator_linter
    # implicit_integer_linter
    # undesirable_function_linter
    # undesirable_operator_linter
    # unneeded_concatenation_linter
    # seq_linter
    # trailing_whitespace_linter
    # trailing_blank_lines_linter
    # object_usage_linter
    # equals_na_linter
    # infix_spaces_linter
    # absolute_path_linter
    # nonportable_path_linter

  )

  linters_list

}
