---
layout: page
title: "IntroductionToLinux"
description: "A brief introduction to Linux with links to resources"
---
{% include JB/setup %}

## BIT815: Deep Sequencing Data Analysis

### Introduction to Linux and the Command-line Interface

------------------------------------------------------------------------

### Objective

The objective of these class sessions is to introduce participants to the Linux computing environment, with a particular focus on the Lubuntu 16.04 environment provided as a virtual machine through the NC State [Virtual Computing Laboratory](https://vcl.ncsu.edu). An introductory lecture on key elements of Linux system architecture and computing philosophy will be followed by hands-on computing exercises to provide experience in using command-line utilities to navigate the file system, manage files and directories, and carry out basic file processing tasks. Demonstrations of how these command-line utilities can be applied to sequence analysis tasks are integrated into the exercises.</span>

### Description

Introductory [slides](../assets/Class_Intro.pdf) provide an introduction to the course objectives and the Linux operating system in the first class session, and a [summary](../assets/GuidingPrinciplesOfUnix.pdf) of Chapter 1 from Eric Raymond’s book [The Art of Unix Programming](http://www.catb.org/esr/writings/taoup/html/)) is used as a framework for discussion of differences between the Linux command-line interface and graphical interfaces. 

### Why Linux?

Linux is the operating system of choice for computationally-intensive data analysis, because of its design and the efficiency with which it runs. Much open-source software for sequence data analysis is written for Linux, although there are an increasing number of Java-based programs that can run under Windows. A key element of the philosophy behind Unix and Linux operating systems is decomposition of tasks into simple categories – separate command-line utilities are available for separate tasks. Combining these simple individual tools into pipelines provides enormous flexibility for managing and processing data.

### Abstraction and Generalization
Abstraction is another key concept in computing - generalizing from a specific case to a larger group of cases that all meet a specific set of criteria. The use of "wildcard" or meta-characters to specify groups of files is a simple example; this process is commonly called file globbing. Regular expressions are another powerful example of use of meta-characters to specify general patterns that can match any of several different character strings. File globbing and regular expressions provide a basis for discussion of abstraction and generalization as key parts of computational thinking. Using structured naming conventions for files and directories makes it easy to use regular expressions and file globs for either serial or parallel processing of many files with a single command.

### Key facts

DNA sequence data and most results of analysis are stored in plain text format, often compressed using an open-source algorithm to reduce the size of the files stored on disk. A few dozen commands for manipulation of text files, executed either separately or in different combinations, provide an  enormous range of data manipulation and analysis capabilities. A modest investment of time in learning basic file formats and commands for text file manipulation will pay large returns by enabling you to manage large data files and carry out basic analyses on the command line, without any specialized software for sequence analysis. One advantage of this approach is the simplicity of working with the same command-line utilities over and over, rather than learning new specialized software for each new task. A second advantage is that many Unix command-line utilities have been continually optimized over the past four decades and are now extremely efficient, so using these tools can accomplish many tasks faster and with lower memory usage than custom-written applications that have not been so extensively optimized.

### Exercises

1.  An [Introduction to Linux and Lubuntu 16.04](../assets/Lubuntu16.04_Intro_BIT815.pdf) is a tutorial to guide participants through an 8-step introduction to the Lubuntu 16.04 operating system used for most class computing exercises.  
1.  A list of useful [Linux commands](../assets/LinuxCommandReference.pdf) is by no means a comprehensive list, but instead focuses on basic commands that meet common needs.
1.  Example files for a self-assessment [quiz](../assets/quiz1.txt) are at [quiz\_week1.tgz](../assets/quiz_week1.tgz)
1.  Some links to useful websites with more information about Linux and the bash shell:
  * [The BashGuide](http://mywiki.wooledge.org/BashGuide)
  * [An A-Z Index of the Bash Command Line](https://ss64.com/bash/)
  * [LinuxCommand.org](http://linuxcommand.org/index.php)

### Additional Resources

#### Background information about Linux

*  A reminiscence called [The Strange Birth and Long Life of Unix](http://faculty.salina.k-state.edu/tim/unix_sg/_downloads/The_Strange_Birth_and_Long_Life_of_Unix_IEEE_Spectrum.pdf) by Warren Toomey in 2011 commemorated the 40th anniversary of the beginning of Unix (and therefore, Linux) development.
*  The [Software Carpentry](https://software-carpentry.org/lessons/) website has a series of tutorials with introductions to many aspects of Linux computing. The lessons entitled The Unix Shell and Programming with R are particularly relevant to this course, because we use the shell a lot throughout the course, and R is important in the section on transcriptome analysis.
* Analysis of Next-Generation Sequencing Data workshops (ANGUS) have been taught at Michigan State in the past, and in 2017 moved to UC-Davis. Course materials are available [online](https://angus.readthedocs.io/en/2017/index.html). The class uses cloud computing instances that are configured differently, so the exercises won't necessarily work exactly the same on the VCL machine image we are using, but the course materials do contain useful information about bioinformatics applications and tools.
* More information on regular expressions is available at [A Brief Introduction to Regular Expressions](http://tldp.org/LDP/abs/html/regexp.html) at The Linux Documentation Project webpage.
* The [FileGlobbing.pdf](../assets/FileGlobbing.pdf) and [RegularExpressions.pdf](../assets/RegularExpressions.pdf) documents also provide more information on these pattern-matching tools.
* One aspect of command-line use is knowing when to use a particular command, and when it is not needed.  Many command-line utilities such as `<grep>`, `<cut>`, `<wc>`, `<sort>`, `<sed>`, and `<awk>` (among many others) accept filenames as arguments after the command, but will also accept input from `<stdin>` via a pipe. Other utilities, such as `<tr>`, do not accept a filename as an argument and only process data received from `<stdin>`.  Some people prefer to use the `<cat>` command to put data into a pipeline, even when the command being used could read the filename as an argument, simply for the sake of consistency and style (see this [StackOverflow discussion](https://stackoverflow.com/questions/11710552/useless-use-of-cat) as an example), while purists argue that using a command when it is not required means running two processes when one will do. This is rarely a problem, but can lead to differences in the commands used to accomplish the same result. For example, in chapter 5 of the Biostar Handbook called Ontologies, the section called Understand the GO data includes some manipulations of a file called goa\_human.gaf.gz, after downloading the file from the geneontology.org website.

* Uncompress the GO file:</span>
  * `<gunzip goa\_human.gaf.gz>`
* Remove the lines starting with ! and simplify the file name:
  * `<cat goa\_human.gaf grep -v '!' > assoc.txt>`
* The same result could be obtained in a single step using this alternative
  * `<gzip -cd goa\_human.gaf.gz | grep -v '!' > assoc.txt>`

####Windows Subsystem for Linux in Windows 10

* Windows 10 offers an optional beta-release of Windows Subsystem for Linux, which allows running any of three different Linux-like command-line environments  on Windows, although the Linux kernel itself is not installed. These provide a command-line bash shell environment with GNU utilities - see a [tutorial on set-up](https://www.howtogeek.com/249966/how-to-install-and-use-the-linux-bash-shell-on-windows-10/) or a [Microsoft page](https://docs.microsoft.com/en-us/windows/wsl/install-win10).

####Using cloud-computing services

Amazon Web Services and other commercial cloud-computing service providers offer accounts to anyone interested in using virtual computing environments (at a price), while [Cyverse.org](http://www.cyverse.org/) is a cloud-computing resource freely available under some conditions to academic researchers and students.
