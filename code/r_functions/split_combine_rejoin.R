#' Splits, joins and recombines multiple tximport outputs for DESeq2
#'
#' This function takes the tximport (tx2gene) output from 2 or 3 species, splits 
#' them into there components (length, counts, abundance) combines them
#' based on shared gene annotations before rebuilding list object for all species.
#' Requires at least 2 species to combine but can optionally take a third. 
#' 
#'
#' @param species_one_tximport list created by tx2gene to be combined with other species.
#' @param species_two_tximport list created by tx2gene to be combined with other species.
#' @param species_three_tximport list created by tx2gene to be combined with other species.
#' @export




split_combine_rejoin <- function(species_one_tximport, species_two_tximport,
                                 species_three_tximport = NULL) {
  
 
  #extract counts as data frame
  sp1_counts <- as.data.frame(species_one_tximport$counts)
  sp2_counts <- as.data.frame(species_two_tximport$counts)
  
  
  #make the rownames (annotations) a column
  sp1_counts <- data.table::setDT(sp1_counts, keep.rownames = "name")
  sp2_counts <- data.table::setDT(sp2_counts, keep.rownames = "name")
  
  #combine using shared annotation column - keeps only rows with shared annotations
  comb_counts <- dplyr::inner_join(sp1_counts, sp2_counts)
  
  #if third add in
  if (!is.null(species_three_tximport)) { 
    sp3_counts <- as.data.frame(species_three_tximport$counts)
    sp3_counts <- data.table::setDT(sp3_counts, keep.rownames = "name")
    all_comb_counts <- dplyr::inner_join(comb_counts, sp3_counts)
  }

  
  ###
  
  #extract abundance as data frame
  sp1_abund <- as.data.frame(species_one_tximport$abundance)
  sp2_abund <- as.data.frame(species_two_tximport$abundance)
  
  
  #make the rownames (annotations) a column
  sp1_abund <- data.table::setDT(sp1_abund, keep.rownames = "name")
  sp2_abund <- data.table::setDT(sp2_abund, keep.rownames = "name")
  
  #combine using shared annotation column - keeps only rows with shared annotations
  comb_abund <- dplyr::inner_join(sp1_abund, sp2_abund)
  
  #if third add in
  if (!is.null(species_three_tximport)) { 
    sp3_abund <- as.data.frame(species_three_tximport$abundance)
    sp3_abund <- data.table::setDT(sp3_abund, keep.rownames = "name")
    all_comb_abund <- dplyr::inner_join(comb_abund, sp3_abund)
  }
  
  ###
  
  #extract length as data frame
  sp1_length <- as.data.frame(species_one_tximport$length)
  sp2_length <- as.data.frame(species_two_tximport$length)
  
  
  #make the rownames (annotations) a column
  sp1_length <- data.table::setDT(sp1_length, keep.rownames = "name")
  sp2_length <- data.table::setDT(sp2_length, keep.rownames = "name")
  
  #combine using shared annotation column - keeps only rows with shared annotations
  comb_length <- dplyr::inner_join(sp1_length, sp2_length)
  
  #if third add in
  if (!is.null(species_three_tximport)) { 
    sp3_length <- as.data.frame(species_three_tximport$length)
    sp3_length <- data.table::setDT(sp3_length, keep.rownames = "name")
    all_comb_length <- dplyr::inner_join(comb_length, sp3_length)
  }

  ####################
  
  # Now need to put back together 4 elements back into list object 
  if (!is.null(species_three_tximport)) {
  # move annotations back to being rownames 
  all_comb_abund <- tibble::column_to_rownames(all_comb_abund, "name")
  # return to matrix not d.f.
  all_m_abund <- as.matrix(all_comb_abund)
  
  #same for counts
  all_comb_counts <- tibble::column_to_rownames(all_comb_counts, "name")
  all_m_counts <- as.matrix(all_comb_counts)
  
  #same for length
  all_comb_length <- tibble::column_to_rownames(all_comb_length, "name")
  all_m_length <- as.matrix(all_comb_length)
  
  #create empty list to add elements to
  all_sg <- list()
  
  #Add each matrix to list 
  all_sg[["abundance"]] <- all_m_abund
  all_sg[["counts"]] <- all_m_counts
  all_sg[["length"]] <- all_m_length
  all_sg[["countsFromAbundance"]] <- "no"
  
  #all_sg = final ouput to be used in DESeq2
  return(all_sg)
  
  
  }  else{
    # move annotations back to being rownames 
    comb_abund <- tibble::column_to_rownames(comb_abund, "name")
    # return to matrix not d.f.
    m_abund <- as.matrix(comb_abund)
    
    #same for counts
    comb_counts <- tibble::column_to_rownames(comb_counts, "name")
    m_counts <- as.matrix(comb_counts)
    
    #same for length
    comb_length <- tibble::column_to_rownames(comb_length, "name")
    m_length <- as.matrix(comb_length)
    
    #create empty list to add elements to
    sg <- list()
    
    #Add each matrix to list 
    sg[["abundance"]] <- m_abund
    sg[["counts"]] <- m_counts
    sg[["length"]] <- m_length
    sg[["countsFromAbundance"]] <- "no"
    
    return(sg)
    #sg = final ouput to be used in DESeq2
  }
}

