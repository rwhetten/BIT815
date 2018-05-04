---
layout: page
title: "ErrorCorrectionAlignment"
description: ""
---
{% include JB/setup %}

## BIT815: Deep Sequencing Data Analysis

### Error Correction and Alignment

------------------------------------------------------------------------

### Global Overview

Sequences randomly sampled from genomic DNA can be assumed to be drawn from a uniform distribution across all possible sequences in the genome, although this assumption is typically violated at least to some degree, even with PCR-free libraries ([Kozarewa et al, 2009](http://www.ncbi.nlm.nih.gov/pmc/articles/PMC2664327/)). Based on that assumption, however, it is possible to analyze the distribution of frequencies of k-mers (short oligonucleotides, often in the range from 15 to 31 bases) observed in sequence reads. The average nucleotide coverage depth for a genome is simply the total number of bases of sequence divided by the size of the genome in bases. For example, a bacterial genome of two million base pairs (2 Mb) that is sequenced to yield a total of 100 million base pairs of sequence data has an average nucleotide coverage of 50x. The relationship between k-mer coverage and nucleotide coverage is described in the [manual for the Velvet genome assembler](https://www.ebi.ac.uk/~zerbino/velvet/Manual.pdf) as **Ck = C (L-k+1)/L**, where **Ck** is k-mer coverage, **C** is nucleotide coverage, **L** is the length of the sequencing reads, and **k** is the k-mer length. For the example dataset with 50x nucleotide coverage, assuming 100-nt reads and k=31, the average 31-mer coverage for single-copy sequences in the genome is expected to be around 50((100-31+1)/100)=35x, with a sampling distribution that extends above and below that expected value. Errors in sequencing reads give rise to novel k-mers that typically appear much less frequently than the correct k-mer sequences, while k-mers drawn from sequences that are repeated in the genome (such as transposable elements) appear much more frequently than the single-copy k-mers. These differences can be used to filter out error k-mers and selectively remove reads containing sequencing errors from the dataset. The number of different k-mers detected, and the characteristics of the frequency distribution of kmers, can be used to estimate the size of the genome and the content of repetitive DNA sequences ([Li and Waterman, 2003](http://genome.cshlp.org/content/13/8/1916.full)).
The underlying assumption that all k-mers are sampled from a uniform distribution is grossly violated in RNA-seq data and some other data types, so k-mer counting for purposes of error correction is not generally applied to those data types.

### Objective

The objective of this section is to introduce concepts behind error correction algorithms, and to provide participants experience in simulating short-read sequence data, using error-correction programs, and aligning short read sequence data to a reference genome. The resulting alignment files will be compared to determine the effects of different error models during simulation, the value of error correction, and the outcomes of different alignment programs.

### Description

Ultra-high-throughput DNA sequencing platforms typically have much higher error rates than Sanger sequencing, and the sequence variation introduced by sequencing errors must be taken into consideration in downstream analysis of the DNA sequence data. Various approaches to error correction are possible, but each has disadvantages - some are too computationally-intensive for application to anything larger than a microbial genome, some make unjustified assumptions about the distribution of read coverage across the sequenced DNA template, and some lack sensitivity or specificity to resolve sequencing errors from true variants. Empirical datasets can be used to create statistical models of sequencing errors, and those error models can then be used to simulate sequencing data from a reference sequence for use in comparative analysis, so the results can be compared back to the starting genome to determine how well the error correction algorithm worked.

### Key Facts

Simulation is an important tools for development of new software and comparison of available software tools for specific purposes. The assumptions made in creating simulated datasets often determine the relative performance of different analytical approaches, so it is important to know what assumptions are made during simulation and how realistic those assumptions are for real datasets. In the exercises below,  simulated Illumina paired-end reads created from a reference bacterial genome, *Lactobacillus helveticus* [strain DPC4571](Resources/DPC4571.fasta.gz), are used.  The simulated read files (sim.r1.fq.gz and sim.r2.fq.gz) and the reference bacterial genome file are provided in the Google Drive ErrorCorrection directory.  GemReads.py (a Python script from the [GemSIM](http://bmcgenomics.biomedcentral.com/articles/10.1186/1471-2164-13-74) package) was used to create the simulated Illumina reads, and this package is installed in the VCL system, so participants can create simulated datasets from the reference genome, but this is too time-consuming to do in class. GemReads.py does not accept gzipped files as input, so the compressed genome sequence file must be gunzipped before invoking the simulation script.


### Exercises

The MaSuRCA (Maryland SuperRead - Celera Assembler) program is installed on the VCL machine image. This program uses k-mers detected in filtered and trimmed fastq sequence reads to expand typical paired-end reads from an Illumina sequencing instrument into what it calls "super-reads".

- Download the [K-merCounting\_ErrorCorrection.sh](../assets/K-merCounting_ErrorCorrection.sh) shell script, open it with the Geany or SciTE text editor (in the Applications menu under Development),  and review the commands and comments in the script file. These commands show how to use the GemReads.py simulation program to simulate short sequence reads from the reference bacterial genome sequence. Type `GemReads.py -h` at a terminal prompt to get a list of options used to specify parameters of the simulation. The reference bacterial genome is 2.1 Mb - how many paired-end 100-nt Illumina reads would be required to reach average nucleotide coverage of 50x? What nucleotide coverage would be provided by 300,000 pairs of 100-nt reads?
- The MaSuRCA installation also installed the Jellyfish k-mer counting program, and the Quorum error correction program as part of the MaSuRCA package. Use the Jellyfish k-mer counting program to produce a file with frequency data for kmers of length 20, as outlined in the K-merCounting\_ErrorCorrection.sh script, then use the [plot\_histo.R](../assets/plot_histo.R) script to produce a PNG image file with a plot of the frequency distribution.  
- Use the Quorum error correction program to correct errors in the simulated sequence data. Type the full path to the program at a terminal prompt followed by the -h option to get usage information for the Quorum program, e.g. `/usr/local/masurca/bin/quorum -h`. Run Quorum to correct the sequence reads, and save the corrected reads to new files.
- Use the [BWA](http://bio-bwa.sourceforge.net/bwa.shtml) or [Bowtie2](http://bowtie-bio.sourceforge.net/bowtie2/manual.shtml) alignment programs to align the uncorrected and corrected sequence reads to the reference genome. Manuals for these two programs are available on Sourceforge - follow the links on the program names - and both programs are already installed on the VCL system.
- Summarize the resulting SAM output files using the command-line tools `grep`, `awk`, `cut`, `sort`, and `uniq`, as described in [SAMformatAndCLtools.pdf](../assets/SAMformatAndCLtools.pdf)

### Additional Resources

-   McElroy KE, Luciani F, Thomas T. (2012) GemSIM: general, error-model based simulator of next-generation sequencing data. BMC Genomics 13: 74. [PMID 22336055](http://www.ncbi.nlm.nih.gov/pubmed/22336055)  *This paper describes software for simulation of sequence data that is useful for testing effects of error frequency on alignment and assembly*

-  Marçais G, Yorke JA, Zimin A. (2013) Quorum: an error corrector for Illumina reads. Preprint on arXiv.org, [arXiv:1307:3515](http://arxiv.org/abs/1307.3515)


-  Li H (2015) BFC: Correcting Illumina sequencing errors. Bioinformatics 31:2885. [Publisher Website](https://academic.oup.com/bioinformatics/article/31/17/2885/183855)

-  Li H, Durbin R. 2010 Fast and accurate long-read alignment with Burrows-Wheeler transform. Bioinformatics 26(5):589-95.  [PMID 20080505](http://www.ncbi.nlm.nih.gov/pubmed/20080505) *The original publication describing the BWA alignment program*

-  Li H, Handsaker B, Wysoker A, Fennell T, Ruan J, Homer N, Marth G, Abecasis G, Durbin R; 1000 Genome Project Data Processing Subgroup. 2009. The Sequence Alignment/Map format and SAMtools. Bioinformatics 25(16):2078-9.  [PMID 19505943](http://www.ncbi.nlm.nih.gov/pubmed/19505943) *The original publication describing SAM format and SAMtools software*

-  Hatem A, Bozdag D, Toland AE, Çatalyürek ÜV. 2013. Benchmarking short sequence mapping tools. BMC Bioinformatics 14:184. [PMID 23758764](http://www.ncbi.nlm.nih.gov/pubmed/23758764)  *A  publication comparing eight different open-source or proprietary read-alignment programs on simulated and real data, including BWA and Bowtie2. The conclusion was that no single tool is optimal for every purpose or any dataset; the user must make an informed decision based on experimental system and objectives*
