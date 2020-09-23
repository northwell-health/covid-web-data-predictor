# covid-web-data-predictor
### Prepared and shared: September 2020
This repository hosts the Jupyter Notebook Northwell Health used to create a predictor of Covid cases by using Northwell.edu web traffic data.

This repository is meant to be a jumping off point for others who would like to attempt to give an early indicator of Covid cases in their respective hospital system. 

To apply to another health system it is expected that the majority of the time would be feature engineering of another systems URL-pathting that would categorize web traffic into salient predictive categories.

## Notes
- Northwell uses Google Analytics to track web traffic.
- Google Analytics data is sent to Google Big Query and updates a partitioned table with a daily snapshot. [Using the process outlined here](https://support.google.com/analytics/answer/3416092?hl=en&ref_topic=3416089). This data set is then used for analysis.
- The Covid positive case counts comes from hospital diagnosis data, identified by ICD-10 code, using the the earliest reasonable diagnosis date for each encounter.
- The Logistic Regression model and predictions are created in Google ML and publsihed to a Big Query data set that is made available BI tools, in Northwell's case Tableau and Google Data Studio.
