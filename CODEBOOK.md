# DATA CODEBOOK for R Analysis of UCI Human Activity Recognition Smartphone Signal Data
Edwin Seah  
22 February 2015  

> Summary

This codebook described the feature variables of the tidy data set produced by run_analysis.R as output. A total of 88 feature variables were filtered out from the original UCI data, and their means calculated from the original measurements for each Subject-Activity relationship. Therefore for every Subject-Activity relationship there is only one value (a mean of all values per Subject-Activity). The original dataset used for this study is available [here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).

> Ranges and Units

All feature variables are **bounded by a normalized range of [-1,1]**. All Acceleration-related values are denoted in standard gravity units **'g'**. All Gyroscope-related values are measurements of angular velocity and are denoted as radians/second **'rad/s'**.

> Variable Naming Convention

The general naming convention used is **Domain.Signal.Measurement.Axis (if any)**, where Domain is one of Time, Frequency or Angle. Where the measurement was originally derived or calculated from signal values there may not be any Axis (X, Y or Z) associated.

+ If a signal was derived in time from body linear acceleration and angular velocity, the format used is **Domain.SignalJerk.Measurement.Axis (if any)**.  
+ For instances when the original signal measurement was for Magnitude (calculated using the Euclidean norm) the format is **Domain.Signal.Magnitude.Measurement.Axis (if any)**.
+ Where the weighted average of frequency components were used to calculate a mean the format is **Domain.Signal.MeanFreq.Axis (if any)**, or **Domain.Signal.Magnitude.MeanFreq.Axis (if any)** where a Magnitude is involved.
+ If the original variable was a vector obtained by averaging the signals in a signal window sample and applied on the angle() variable the format is Angle **Domain.Angle.Signal.Gravity.Mean** or **Angle.Axis.Gravity.Mean**. In such cases the original values were always means. 

> Variable Listing

Col|Variable.Name|Variable.Type|Allowable.Values|Units|Comments
---|---|---|---|---|---
1|SUBJECT|integer|1 to 30||Integer identifying the subject performing each activity
2|ACTIVITY|character|"LAYING", "SITTING", "STANDING", "WALKING", "WALKING_DOWNSTAIRS", "WALKING_UPSTAIRS"||Labels indicating activity performed
3|Time.BodyAcceleration.Mean.X|numeric|-1 to 1|g|
4|Time.BodyAcceleration.Mean.Y|numeric|-1 to 1|g|
5|Time.BodyAcceleration.Mean.Z|numeric|-1 to 1|g|
6|Time.BodyAcceleration.StandardDeviation.X|numeric|-1 to 1|g|
7|Time.BodyAcceleration.StandardDeviation.Y|numeric|-1 to 1|g|
8|Time.BodyAcceleration.StandardDeviation.Z|numeric|-1 to 1|g|
9|Time.GravityAcceleration.Mean.X|numeric|-1 to 1|g|
10|Time.GravityAcceleration.Mean.Y|numeric|-1 to 1|g|
11|Time.GravityAcceleration.Mean.Z|numeric|-1 to 1|g|
12|Time.GravityAcceleration.StandardDeviation.X|numeric|-1 to 1|g|
13|Time.GravityAcceleration.StandardDeviation.Y|numeric|-1 to 1|g|
14|Time.GravityAcceleration.StandardDeviation.Z|numeric|-1 to 1|g|
15|Time.BodyAccelerationJerk.Mean.X|numeric|-1 to 1|g|
16|Time.BodyAccelerationJerk.Mean.Y|numeric|-1 to 1|g|
17|Time.BodyAccelerationJerk.Mean.Z|numeric|-1 to 1|g|
18|Time.BodyAccelerationJerk.StandardDeviation.X|numeric|-1 to 1|g|
19|Time.BodyAccelerationJerk.StandardDeviation.Y|numeric|-1 to 1|g|
20|Time.BodyAccelerationJerk.StandardDeviation.Z|numeric|-1 to 1|g|
21|Time.BodyGyroscope.Mean.X|numeric|-1 to 1|rad/s|
22|Time.BodyGyroscope.Mean.Y|numeric|-1 to 1|rad/s|
23|Time.BodyGyroscope.Mean.Z|numeric|-1 to 1|rad/s|
24|Time.BodyGyroscope.StandardDeviation.X|numeric|-1 to 1|rad/s|
25|Time.BodyGyroscope.StandardDeviation.Y|numeric|-1 to 1|rad/s|
26|Time.BodyGyroscope.StandardDeviation.Z|numeric|-1 to 1|rad/s|
27|Time.BodyGyroscopeJerk.Mean.X|numeric|-1 to 1|rad/s|
28|Time.BodyGyroscopeJerk.Mean.Y|numeric|-1 to 1|rad/s|
29|Time.BodyGyroscopeJerk.Mean.Z|numeric|-1 to 1|rad/s|
30|Time.BodyGyroscopeJerk.StandardDeviation.X|numeric|-1 to 1|rad/s|
31|Time.BodyGyroscopeJerk.StandardDeviation.Y|numeric|-1 to 1|rad/s|
32|Time.BodyGyroscopeJerk.StandardDeviation.Z|numeric|-1 to 1|rad/s|
33|Time.BodyAcceleration.Magnitude.Mean|numeric|-1 to 1|g|
34|Time.BodyAcceleration.Magnitude.StandardDeviation|numeric|-1 to 1|g|
35|Time.GravityAcceleration.Magnitude.Mean|numeric|-1 to 1|g|
36|Time.GravityAcceleration.Magnitude.StandardDeviation|numeric|-1 to 1|g|
37|Time.BodyAccelerationJerk.Magnitude.Mean|numeric|-1 to 1|g|
38|Time.BodyAccelerationJerk.Magnitude.StandardDeviation|numeric|-1 to 1|g|
39|Time.BodyGyroscope.Magnitude.Mean|numeric|-1 to 1|rad/s|
40|Time.BodyGyroscope.Magnitude.StandardDeviation|numeric|-1 to 1|rad/s|
41|Time.BodyGyroscopeJerk.Magnitude.Mean|numeric|-1 to 1|rad/s|
42|Time.BodyGyroscopeJerk.Magnitude.StandardDeviation|numeric|-1 to 1|rad/s|
43|Frequency.BodyAcceleration.Mean.X|numeric|-1 to 1|g|
44|Frequency.BodyAcceleration.Mean.Y|numeric|-1 to 1|g|
45|Frequency.BodyAcceleration.Mean.Z|numeric|-1 to 1|g|
46|Frequency.BodyAcceleration.StandardDeviation.X|numeric|-1 to 1|g|
47|Frequency.BodyAcceleration.StandardDeviation.Y|numeric|-1 to 1|g|
48|Frequency.BodyAcceleration.StandardDeviation.Z|numeric|-1 to 1|g|
49|Frequency.BodyAcceleration.MeanFreq.X|numeric|-1 to 1|g|
50|Frequency.BodyAcceleration.MeanFreq.Y|numeric|-1 to 1|g|
51|Frequency.BodyAcceleration.MeanFreq.Z|numeric|-1 to 1|g|
52|Frequency.BodyAccelerationJerk.Mean.X|numeric|-1 to 1|g|
53|Frequency.BodyAccelerationJerk.Mean.Y|numeric|-1 to 1|g|
54|Frequency.BodyAccelerationJerk.Mean.Z|numeric|-1 to 1|g|
55|Frequency.BodyAccelerationJerk.StandardDeviation.X|numeric|-1 to 1|g|
56|Frequency.BodyAccelerationJerk.StandardDeviation.Y|numeric|-1 to 1|g|
57|Frequency.BodyAccelerationJerk.StandardDeviation.Z|numeric|-1 to 1|g|
58|Frequency.BodyAccelerationJerk.MeanFreq.X|numeric|-1 to 1|g|
59|Frequency.BodyAccelerationJerk.MeanFreq.Y|numeric|-1 to 1|g|
60|Frequency.BodyAccelerationJerk.MeanFreq.Z|numeric|-1 to 1|g|
61|Frequency.BodyGyroscope.Mean.X|numeric|-1 to 1|rad/s|
62|Frequency.BodyGyroscope.Mean.Y|numeric|-1 to 1|rad/s|
63|Frequency.BodyGyroscope.Mean.Z|numeric|-1 to 1|rad/s|
64|Frequency.BodyGyroscope.StandardDeviation.X|numeric|-1 to 1|rad/s|
65|Frequency.BodyGyroscope.StandardDeviation.Y|numeric|-1 to 1|rad/s|
66|Frequency.BodyGyroscope.StandardDeviation.Z|numeric|-1 to 1|rad/s|
67|Frequency.BodyGyroscope.MeanFreq.X|numeric|-1 to 1|rad/s|
68|Frequency.BodyGyroscope.MeanFreq.Y|numeric|-1 to 1|rad/s|
69|Frequency.BodyGyroscope.MeanFreq.Z|numeric|-1 to 1|rad/s|
70|Frequency.BodyAcceleration.Magnitude.Mean|numeric|-1 to 1|g|
71|Frequency.BodyAcceleration.Magnitude.StandardDeviation|numeric|-1 to 1|g|
72|Frequency.BodyAcceleration.Magnitude.MeanFreq|numeric|-1 to 1|g|
73|Frequency.BodyAccelerationJerk.Magnitude.Mean|numeric|-1 to 1|g|
74|Frequency.BodyAccelerationJerk.Magnitude.StandardDeviation|numeric|-1 to 1|g|
75|Frequency.BodyAccelerationJerk.Magnitude.MeanFreq|numeric|-1 to 1|g|
76|Frequency.BodyGyroscope.Magnitude.Mean|numeric|-1 to 1|rad/s|
77|Frequency.BodyGyroscope.Magnitude.StandardDeviation|numeric|-1 to 1|rad/s|
78|Frequency.BodyGyroscope.Magnitude.MeanFreq|numeric|-1 to 1|rad/s|
79|Frequency.BodyGyroscopeJerk.Magnitude.Mean|numeric|-1 to 1|rad/s|
80|Frequency.BodyGyroscopeJerk.Magnitude.StandardDeviation|numeric|-1 to 1|rad/s|
81|Frequency.BodyGyroscopeJerk.Magnitude.MeanFreq|numeric|-1 to 1|rad/s|
82|Time.Angle.BodyAcceleration.Gravity.Mean|numeric|-1 to 1|g|
83|Time.Angle.BodyAccelerationJerk.Gravity.Mean|numeric|-1 to 1|g|
84|Time.Angle.BodyGyroscope.Gravity.Mean|numeric|-1 to 1|rad/s|
85|Time.Angle.BodyGyroscopeJerk.Gravity.Mean|numeric|-1 to 1|rad/s|
86|Angle.X.Gravity.Mean|numeric|-1 to 1|g|
87|Angle.Y.Gravity.Mean|numeric|-1 to 1|g|
88|Angle.Z.Gravity.Mean|numeric|-1 to 1|g|

