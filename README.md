#cleandatacoursera

__LeeT's Repository for Coursera Getting &amp; Cleaning Data course project, January 2016__

The files in this repository document a transformation of 
data described in the course projects requirements description as:

>    collected from the accelerometers from the Samsung 
>    Galaxy S smartphone. A full description is available at
>    the site where the data was obtained:
>
>    http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
>
>    Here are the data for the project:
>
>    https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

A new data frame is constructed from the original data.  First
data from training files (*_train.txt) is consolidated with
data from the corresponding test (*_text.txt) file. The 
fields corresponding to means and standard deviations are 
extracted.
    
An intermediate  data frame is constructed which comprises
activity names, subject identifiers, and the fields
extracted above. This data frame is then grouped by
activity name and subject identifier. Column names are 
changed, as described in CodeBook.md, to be more descriptive.

The final output data frame is constructed by calculating for each
group and each ungrouped column the mean of the observations      for that group on that column.  

#### Files

1. CodeBook.md describes the fields and units of the output file and their correspondence to the fields in the input files.

2. README.md is this file.

3. run_analysis.R is an R script which does the transformation.
   
    #### Input 
    
    The run_analysis.R script described below assumes and requires     that the original data has been manually downloaded and
    unzipped (with the -j junk paths option) __exactly__ into
    the current working directory, as described in the course
    project requirements. 

      Nota Bene: I would normally put the input data into a ./data
      directory,   as illustrated many times in the course videos.
      The course project requirement used the explicit term
      "current    working directory", hence the mess of input
      files in the current directory after following the
      requirements.
      
      Having a ./data directory also allows preserving the
      directory hierarchy in the orginal .zip file. I find
      that directory structure aids my understanding.

    #### Output
 
    The newly constructed data frame is written to the file
    "./output/courseProjectOutput.txt".
    The sub-directory is created if it does not exist.

    #### To run
    
    There are a number of ways to run the R script. Use what
    ever works for you. This is one simple way.
    
```
# Requires that the current working directory contains the
# R script and unzipped data files.
# Also requires write permission to the current working directory.
    
R
> source("run_analysis.R")
Starting course project at: Fri Jan 29 14:27:21 2016

Current working directory:
  /Coursera/2016/getclean_data_2016/CourseProject/Assignments

|===========================================| 100%   62 MB

Output data frame written to file: ./output/courseProjectOutput.txt

Ending course project at: Fri Jan 29 14:27:27 2016

> quit(save = "no")

```

<!--- -30- -->
