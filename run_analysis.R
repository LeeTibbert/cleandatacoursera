# run_analysis.R -- Transformation script for Coursera Getting & Cleaning Data
#	            Course project.
#
# Lee Tibbert
# 2016-01-27
#

## Prologue
## Define and, if necessary, set up the world.

library(assertthat)
suppressPackageStartupMessages(library(dplyr))
library(magrittr) # for forward pipe %>% operator
library(readr)

outputDir <- "./output"

# In a course/production enviroment, may need to
# specify or fix-up directory protections.

sapply(c(outputDir), function(dir) {
  if (!file.exists(dir))
    dir.create(dir)
})

# Where in the world are we? Leave tracks in log.
cat(sprintf("\nStarting course project at: %s\n\n", date()))
cat(sprintf("Current working directory:\n  %s\n\n", getwd()))

step_1 <- function()
{
# Create & return a data frame containing the data from
# the original test & training data sets. Add subject.id
# and activity.id fields using original data.


# Create unique column names from original names. Aids merging.

  xColLabels  <- read_table("features.txt",
                            col_names = "feature.label") %>%
                            mutate(feature.label =
			             sub("^([0-9]+)[ ]* ", "\\1.",
			             feature.label)) %>%
                            extract2("feature.label")

# Read Test Data
  subjectTestDf <- read_table("subject_test.txt",
                              col_names = "subject.id")

  yTestDf <- read_table("y_test.txt",
                              col_names = "activity.id")

  xTestDf  <- read_table("X_test.txt",
                         col_names = xColLabels)


  testDf <- bind_cols(subjectTestDf, yTestDf, xTestDf)

# Read Train Data

  subjectTrainDf <- read_table("subject_train.txt",
                              col_names = "subject.id")

  yTrainDf <- read_table("y_train.txt",
                              col_names = "activity.id")

  xTrainDf  <- read_table("X_train.txt",
                         col_names = xColLabels)

  trainDf <- bind_cols(subjectTrainDf, yTrainDf, xTrainDf)

# now merge test & train data frames
  mergedDf <- bind_rows(trainDf, testDf)

  mergedDf
}

step_2 <- function(inputDf)
{
# Retain only columns for subject.id, activity.id, *mean(), & *std().
# Uuse matches() rather than contains() to keep the original
# column left to right ordering. Reduce opportunities for
# confusion

  outputDf <- inputDf %>%
                select(subject.id,
                       activity.id,
                       matches("(.+mean\\(\\).*)|(.*std\\(\\).*)"))

  outputDf
}

step_3 <- function(inputDf)
{
# Create a factor named "activity" based on activity.id.
# Give column "activity" descriptive levels/names read from 
# the original data.

  outputDf <- inputDf %>%
              mutate(activity.id = as.factor(activity.id)) %>%
              rename(activity = activity.id)

  activityLevels  <- read_table("activity_labels.txt",
                            col_names = c("activity.id", "activities")) %>%
                            extract2("activities")

  levels(outputDf$activity) <- activityLevels

  outputDf
}

step_4 <- function(inputDf) {

#  inputDf <- step3Df

# Convert column names to be descriptive. Use full words, convert to
# lower case, remove parentheses, and use dots to separate words.
# Bacause of the column naming scheme in the original data,
# I still end up with anomalies such as foo.body.body.

# Might as well transform the whole mess in one go.

  s4Names <- names(inputDf) %>%
                gsub("-std\\(\\)",
                     "\\.standard\\.deviation\\.", .) %>%
                gsub("-", ".", .) %>%
                gsub("\\(\\)", "", .) %>%
                gsub("^[0-9]+\\.", "", .) %>%
                gsub("Acc", "\\.accelerometer\\.", .) %>%
                gsub("Gyro", "\\.gyroscope\\.", .) %>%
                gsub("Mag", "\\.magnitude\\.", .) %>%
                tolower() %>%
                gsub("^tbody", "time\\.domain\\.body\\.", .) %>%
                gsub("^fbody", "frequency\\.domain\\.body\\.", .) %>%
                gsub("^tgravity", "time\\.gravity\\.", .) %>%
                gsub("\\.\\.", "\\.", .)

  outputDf <- inputDf

  colnames(outputDf) <- s4Names

  outputDf
}

step_5 <- function(inputDf)
{
# Calculate the mean of each variable for each activity
# and subject. Column names will be updated to reflect
# new contents.

  outputDf <- inputDf %>%
    group_by(activity, subject.id) %>%
    summarize_each(funs(mean))

  # Update the column names to reflect the fact that
  # they are not direct observations but rather the mean of
  # such observations.

  s5Names <- names(outputDf) %>%
             sub("^([ft].*$)", "\\1\\.mean", .) %>%
             gsub("\\.\\.", "\\.", .)


  colnames(outputDf) <- s5Names

  outputDf
}

## ------------------------------------------------- ##
## Begin main program

step1Df <- step_1()
step2Df <- step_2(step1Df)
step3Df <- step_3(step2Df)
step4Df <- step_4(step3Df)

step5Df <- step_5(step4Df)

outputFile <- file.path(getwd(), sub("\\./", "", outputDir),
                        "courseProjectOutput.txt")

write.table(step5Df, outputFile, row.names = FALSE)

cat(sprintf("\nOutput data frame written to file: %s\n", outputFile))

cat(sprintf("\nEnding course project at: %s\n\n", date()))

## -30- ##


