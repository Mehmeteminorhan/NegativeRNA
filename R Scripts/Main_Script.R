
s = getOption("repos") # hard code the UK repo for CRAN
s["CRAN"] = "http://cran.uk.r-project.org"
options(repos = s)
rm(s)

if(!require('seqinr')) {
  install.packages('seqinr')
  library('seqinr')
}

Seqs <- read.fasta(file = knime.flow.in[["file-upload-sequence"]])

RNAfold.path <- knime.flow.in[["file-upload-exe"]]

run_RNAfold <- function(Sequences, RNAfold.path = "RNAfold",
                        parallel.cores = 2){
  Seqs.validate <- Sequences[which(lengths(Sequences) < 30000)]
  if(length(Seqs.validate) < length(Sequences)){
    packageStartupMessage("Due to the limitation of RNAfold,")
    packageStartupMessage("Sequences with length more than 30000 nt will be omitted.")
    packageStartupMessage(length(Sequences) - length(Seqs.validate), " sequences have been removed.", "\n")
    Sequences <- Seqs.validate
  }
  
  if (parallel.cores == 2) message("Users can try to set parallel.cores = -1 to use all cores!", "\n")
  parallel.cores = -1
  parallel.cores <- ifelse(parallel.cores == -1, parallel::detectCores(), parallel.cores)
  cl <- parallel::makeCluster(parallel.cores, outfile = "")
  message("\n", "Sequences Number: ", length(Sequences), "\n")
  message("Processing...", "\n")
  index <- 1
  info <- paste(ceiling(length(Seqs)), ",", sep = "")
  parallel::clusterExport(cl, varlist = c("info", "index"), envir = environment())
  sec.seq <- parallel::parLapply(cl, Sequences, secondary_seq, info = info,
                                 RNAfold.path = RNAfold.path)
  parallel::stopCluster(cl)
  sec.seq <- data.frame(sec.seq, stringsAsFactors = FALSE,check.names=FALSE)
  message("\n", "Completed.", "\n")
  sec.seq
}

secondary_seq <- function(OneSeq, info, RNAfold.path){
  seq.string <- unlist(seqinr::getSequence(OneSeq, TRUE))
  index <- get("index")
  showMessage <- paste(index, "of", info, "length:", nchar(seq.string), "nt", "\n")
  cat(showMessage)
  RNAfold.command <- paste(RNAfold.path, "--noPS") #--circ option is used for circRNA
  seq.ss <- system(RNAfold.command, intern = TRUE, input = seq.string)
  index <<- index + 1
  seq.ss2 <- paste(seq.ss, collapse = '')
  seq.ss3 <- ""
  seq.ss3[[1]] <- substr(seq.ss2[1],1,nchar(seq.string))
  seq.ss3[[2]] <- substr(seq.ss2[1],nchar(seq.string)+1,nchar(seq.ss2))
  seq.ss3[[3]] <- as.numeric(substr(seq.ss3[[2]], nchar(seq.string) + 3, nchar(seq.ss3[[2]]) - 1))
  seq.ss3[[2]] <- substr(seq.ss3[[2]], 1, nchar(seq.string))
  seq.ss3
}

SS.seq <- run_RNAfold(Seqs, RNAfold.path = RNAfold.path, parallel.cores = -1)
SS.seq <- SS.seq[!(SS.seq[3,] %in% NA)]



if (all(names(Seqs) == names(SS.seq))){
  message("All Sequences Folded.")
}
if (all(names(Seqs) == names(SS.seq)) == FALSE){
  removed_seq <- setdiff(names(Seqs),names(SS.seq))
  message("Some Sequences Removed. Check Std Output")
  removed_seq
}

SS.seq <- t(SS.seq)
colnames(SS.seq) <- c('seq','fold','mfe')

knime.out <- as.data.frame(SS.seq)
