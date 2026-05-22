#' Makes tx2gene object needed for Tximport
#'
#' This function creates a data.frame with two columns: 1) transcript ID 
#' and 2) gene ID required by Tximport to collapse trinity isoforms for gene-level 
#' summarization.
#' The function takes the annotation output from eggNOG and quant.sf files from
#' salmon quantification for four replicate individuals of one species.
#' Combines quant.sf files of replicates and links with annotations based on shared 
#' trinity ID's to create tx2gene object to be used by Tximport to import all
#' four replicates of one species.
#' 
#'
#' @param eggnog_annotation_file eggnog annotation output file "<species>.emapper.annotations" must
#' be pre-edited to get rid of header.
#' @param salmon_quant_file_1 salmon quantification output file "quant.sf" for replicate one, 
#' include sample folder e.g. "S1/quant.sf".
#' @param salmon_quant_file_2 salmon quantification output file "quant.sf" for replicate two,
#' include sample folder e.g. "S2/quant.sf".
#' @param salmon_quant_file_3 salmon quantification output file "quant.sf" for replicate three,
#' include sample folder e.g. "S3/quant.sf".
#' @param salmon_quant_file_4 salmon quantification output file "quant.sf" for replicate four,
#' include sample folder e.g. "S4/quant.sf".
#' @export





make_tx2gene <- function(eggnog_annotation_file, salmon_quant_file_1, salmon_quant_file_2,
                         salmon_quant_file_3, salmon_quant_file_4) {
  
  #read in quant.sf files from salmon
 # a_quant <- readr::read_tsv(salmon_quant_file_1)
#  b_quant <- readr::read_tsv(salmon_quant_file_2)
#  c_quant <- readr::read_tsv(salmon_quant_file_3)
#  d_quant <- readr::read_tsv(salmon_quant_file_4)

 #read in annotations 
  #eggnog_annotation_file <- annot_test
  #salmon_quant_file_1 <- a_quant
  #salmon_quant_file_2 <- b_quant
  #salmon_quant_file_3 <- c_quant
  #salmon_quant_file_4 <- d_quant  
  
  
  #subset to just trinity id and gene annotation
  annotations <- eggnog_annotation_file %>% 
   dplyr::select(query, actin)
  
  #bind quant tables of all 4 samples together
  all_quantification <- rbind(salmon_quant_file_1, 
                                            salmon_quant_file_2,
                                            salmon_quant_file_3, 
                                            salmon_quant_file_4)
  
  #join salmon quant and annotation based on shared trinity id
  all_anno_quant <- dplyr::inner_join(all_quantification, 
                               annotations, 
                               by = c("Name" = "query"))
  
  #finalise tx2gene object
  tx2gene_object <- all_anno_quant %>%
    dplyr::relocate(actin, .after= Name) %>% #rearrange 
    dplyr::rename(trinity_id = Name, gene_id = actin) %>% #rename 
    dplyr::select(trinity_id, gene_id) %>% #subset to only columns of interest
    dplyr::filter(gene_id != "-") 
  
  return(tx2gene_object)
  
}
  
 