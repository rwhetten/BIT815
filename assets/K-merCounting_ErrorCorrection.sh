#!/bin/bash
# Commands to simulate reads from the Lactobacillus helvetica strain DPC4571 bacterial reference genome sequence, then 
# use the simulated reads to explore k-mer counting and error correction methods.
# NOTE - the commands to simulate the reads are commented out so they will not be executed when the script is run -
# if you are interested in simulating reads, you can uncomment the indented lines so they will be executed.

# First, create a working directory called simreads in /home/lubuntu, and change into that directory
#		mkdir simreads
#		cd simreads

# Unpack the reference genome sequence file from the data directory into the simreads directory

#		zcat /data/DPC4571/DPC4571.fasta.gz > DPC4571.fa

# Run GemReads.py to simulate 300,000 reads from the reference genome sequence - this should take about 20 min
#		GemReads.py -r DPC4571.fa -n 300000 -l 100 -m /usr/local/GemSIM_v1.6/models/ill100v5_p.gzip -c -q 33 -o simreads -u 300  -s 50 -p 

# The output files from GemReads.py were  named simreads_fir.fastq and simreads_sec.fastq; they were renamed and compressed
# to sim.r1.fq.gz and sim.r2.fq.gz in the data directory, but when you run GemReads.py for yourself, you need not rename the files.

# While the GemReads.py program is running, open another terminal window and use the top command to see 
# how much of the system's resources are being used.
# Note that the top part of the display shows a percentage of CPU use that is different from that shown in the columns.
# Why might this be so?

# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# NOTE - before proceeding, make sure the MaSuRCA package is installed, because that provides the Quorum error-correction
# program and the jellyfish-2.0 kmer-counting program.
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# Run Quorum on reads. The genome is 2.1 Mb, so according to the (genome length - k-mer length +1) formula, 
# there will be almost 2.1 million k-mers in the genome. Not all are unique, of course, and not all will be sampled
# at equal levels during sequencing (whether simulated or real).

# The sim.r1.fq.gz and sim.r2.fq.gz files contain 300,000 pairs of 100-nt paired-end reads, each of which will
# have (100 - 20 + 1)= 81 k-mers, for a total of (300,000 x 2 x 81)= 48.6 million read k-mers.

# This means the k-mer coverage of the genome should be about 48.6 million/2.1 million or about 23.1
# Another way to calculate k-mer coverage:
# The relation between k-mer coverage Ck and nucleotide coverage C is Ck = C * (L - k + 1) / L,
#  where k is k-mer length and L is read length. In our case,  (L - k + 1) / L = 0.81

# For 300,000 paired-end (2x100 nt) reads, nt coverage is (2 x 100 x 300,000)/(2.1 million) or 28.6-fold coverage. 
# Multiply that by 0.81 to get 23.1-fold k-mer coverage.

# Run the jellyfish k-mer counter to test this prediction, using the same k-mer size (20).
# NOTE: jellyfish does not read gzipped files, so the simulated read files will have to be decompressed
zcat /data/DPC4571/sim.r1.fq.gz > sim.r1.fq; zcat /data/DPC4571/sim.r2.fq.gz > sim.r2.fq
time /usr/local/masurca/bin/jellyfish count -m 20 -s 50M -t 2 sim.r?.fq

# The 'time' command results in output of the total time required for the program to run - on my laptop, it took less than 30 sec.

# The default  output filename for jellyfish count is mer_counts.jf - that file can be used as input to the jellyfish histo
# command to produce a histogram plot of the distribution of k-mer counts
/usr/local/masurca/bin/jellyfish histo mer_counts.jf 
# This dumps output to the screen - can save it to a file and produce a PNG image using an R script

/usr/local/masurca/bin/jellyfish histo mer_counts.jf > histo.out
Rscript plot_histo.R # Creates a file called histo.png - the histogram shows a peak at around 22x coverage

# Move the histo.out file to 1Mreads.histo.out to keep it from being over-written by later exercises
mv histo.out 1Mreads.histo.out

# Run error correction program Quorum, using information from histogram plot
/usr/local/masurca/bin/quorum -t 2 -p correctedr1 -k 20 -q 33 -m 13 -w 25 -e 1 --min-count 7 sim.r1.fq &
time /usr/local/masurca/bin/quorum -t 2 -p correctedr2 -k 20 -q 33 -m 13 -w 25 -e 1 --min-count 7 sim.r2.fastq


# Alignment - this will be covered in two weeks, but you can work ahead if you are interested
# Index the reference genome sequence with BWA, and align the corrected reads to the indexed reference.
bwa index -p DPCref DPC4571.fa # takes less than 6 seconds
bwa mem -t 2 DPCref correctedr1.fa correctedr2.fa > corrected.sam 

# takes about 2 min

# Count the number of aligned reads
samtools view -F4 corrected.sam | wc -l

# Count the total number of lines
wc -l corrected.sam 

# Extract the NM:i: field (column 12) and add all the mismatches observed in the aligned reads:
samtools view -SF4 corrected.sam | cut -f12 | cut -d: -f3 | paste -sd+ | bc 

# Align the uncorrected reads to the reference and count the number of aligned reads:
bwa mem -t 2 -a sim.r1.fq sim.r2.fq > rawreads.sam
samtools view -SF4 rawreads.sam | wc -l 

# Count the mismatches between uncorrected reads and the reference genome:
samtools view -SF4 rawreads.sam | cut -f12 | cut -d: -f3 | paste -sd+ | bc 


