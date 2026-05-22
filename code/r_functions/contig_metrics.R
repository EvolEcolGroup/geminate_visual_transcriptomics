#' OUtputs basic stats to asses quality of de novo transcriptome
#'
#' This function takes one or more transcriptome fasta files and computes basic
#' useful statistics outputting a table with the results.
#'
#'
#'
#' @param transcriptome_one transcriptome fasta file
#' @param transcriptome_two transcriptome fasta file
#' @param transcriptome_three transcriptome fasta file
#' @param transcriptome_four transcriptome fasta file
#' @param transcriptome_five transcriptome fasta file
#' @param transcriptome_six transcriptome fasta file
#'
#' @export




contig_metrics <- function(transcriptome_one,
                        transcriptome_two = NULL,
                        transcriptome_three = NULL,
                        transcriptome_four = NULL,
                        transcriptome_five = NULL,
                        transcriptome_six = NULL){

stats <- "../p04_transcriptome_quality/s07_contig_metrics.sh"

results1 <- system2(command= "bash",
                   args= c(stats,
                          transcriptome_one),
                   stdout = TRUE)

df1 <- data.frame(results1)
res_table1 <- str_split_fixed(df1$results, ":", 2)
tb1 <-res_table1 %>% data.frame() %>%
  column_to_rownames(var="X1") %>%
  'colnames<-'("transcriptome1")


if (!is.null(transcriptome_two)) {
  results2 <- system2(command= "bash",
                     args= c(stats,
                             transcriptome_two),
                     stdout = TRUE)
  df2 <- data.frame(results2)
  res_table2 <- str_split_fixed(df2$results, ":", 2)
  tb2 <-res_table2 %>% data.frame() %>%
    column_to_rownames(var="X1") %>%
    'colnames<-'("transcriptome2")

transcriptome_all <-  cbind(tb1,tb2)


if (!is.null(transcriptome_three)) {
  results3 <- system2(command= "bash",
                     args= c("../p04_transcriptome_quality/s07_contig_metrics.sh",
                             transcriptome_three),
                     stdout = TRUE)
  df3 <- data.frame(results3)
  res_table3 <- str_split_fixed(df3$results, ":", 2)
  tb3 <-res_table3 %>% data.frame() %>%
    column_to_rownames(var="X1") %>%
    'colnames<-'("transcriptome3")

transcriptome_all <-  cbind(transcriptome_all,tb3)


if (!is.null(transcriptome_four)) {
  results4 <- system2(command= "bash",
                     args= c("../p04_transcriptome_quality/s07_contig_metrics.sh",
                             transcriptome_four),
                     stdout = TRUE)

  df4 <- data.frame(results4)
  res_table4 <- str_split_fixed(df4$results, ":", 2)
  tb4 <-res_table4 %>% data.frame() %>%
    column_to_rownames(var="X1") %>%
   'colnames<-'("transcriptome4")

transcriptome_all <-  cbind(transcriptome_all,tb4)

if (!is.null(transcriptome_five)) {
  results5 <- system2(command= "bash",
                     args= c("../p04_transcriptome_quality/s07_contig_metrics.sh",
                             transcriptome_five),
                     stdout = TRUE)

  df5 <- data.frame(results5)
  res_table5 <- str_split_fixed(df5$results, ":", 2)
  tb5 <-res_table5 %>% data.frame() %>%
    column_to_rownames(var="X1") %>%
    'colnames<-'("transcriptome5")

transcriptome_all <-  cbind(transcriptome_all,tb5)

if (!is.null(transcriptome_six)) {
  results6 <- system2(command= "bash",
                      args= c("../p04_transcriptome_quality/s07_contig_metrics.sh",
                              transcriptome_six),
                      stdout = TRUE)

  df6 <- data.frame(results6)
  res_table6 <- str_split_fixed(df6$results, ":", 2)
  tb6 <-res_table6 %>% data.frame() %>%
    column_to_rownames(var="X1") %>%
    'colnames<-'("transcriptome6")

transcriptome_all <-  cbind(transcriptome_all,tb6)

}}}}}

return(transcriptome_all)


}


