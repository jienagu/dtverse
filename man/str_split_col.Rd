% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/col_str_reshape.R
\name{str_split_col}
\alias{str_split_col}
\title{Split one column to multiple columns based on patterns}
\usage{
str_split_col(dt, by_col, by_pattern, match_to_names = NULL)
}
\arguments{
\item{dt}{input data table}

\item{by_col}{by this column}

\item{by_pattern}{split by this patter}

\item{match_to_names}{created new columns names}
}
\value{
data table with new columns
}
\description{
Split one column to multiple columns based on patterns
}
\examples{
data("dt_dates")
str_split_col(dt_dates,
              by_col = "Full_name",
              by_pattern = ", ",
              match_to_names = c("First Name", "Last Name"))
}
