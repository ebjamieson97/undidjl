# undidjl
This Stata package acts as a wrapper for the Julia package Undid.jl. 

undidjl allows for estimation of difference-in-differences with unpoolable data, see https://arxiv.org/abs/2403.15910 for more details.

## Installation 
```stata
net install undidjl, from("https://raw.githubusercontent.com/ebjamieson97/undidjl/main/")
```
### Update
```stata
ado uninstall undidjl
net install undidjl, from("https://raw.githubusercontent.com/ebjamieson97/undidjl/main/")
```

## Requirements
* Julia 1.9.4 or later
* Stata 14.1 or later
* the julia package for Stata, see https://github.com/droodman/julia.ado

## Utility Commands
These commands allow for managing the Undid.jl package for Julia from Stata:

#### 1. `checkundidversion`

Displays the currently installed and the latest version of the Undid.jl package. If Undid.jl is not installed, installs Undid.jl.

#### 2. `updateundid`

Updates Undid.jl to the latest version if Undid.jl is already installed.

## Stage One: Initialize

### 4. `create_init_csv` - Creates an initial .csv file (init.csv), displays its filepath, and returns its contents to the active Stata dataset.

Generates an initial `.csv` file (`init.csv`) specifying the silo names, start times, end times, and treatment times. This file is then used to create the `empty_diff_df.csv`, which is sent to each silo. If `create_init_csv` is called without providing any silo names, start times, end times, or treatment times, an `init.csv` will be created with the appropriate column headers and blank columns. 

Control silos should be marked with "control" in the treatment_times column.

Covariates may be specified when calling `create_init_csv` or when calling `create_diff_df`.

Ensure that dates are all entered in the same date format, a list of acceptable date formats can be seen [here.](#valid-date-formats)

**Parameters:**

- **silo_names** (*string, optional*):  
  A string specifying the different silo names.
  
- **start_times** (*string, optional*):  
  A string which indicates the starting time for the analysis at each silo.

- **end_times** (*string, optional*):  
  A string which indicates the starting time for the analysis at each silo.

- **treatment_times** (*string, optional*):  
  A string which indicates the treatment time at each silo. Control silos should be labelled with the treatment time `"control"`.

- **covariates** (*string, optional*):  
  A string specifying covariates to be considered at each silo.

```stata
create_init_csv, silo_names("71 73 58 46") start_times("1989 1989 1989 1989") end_times("2000 2000 2000 2000") treatment_times("1991 control 1993 control") covariates("asian black male")
# init.csv saved to
# C:/Users/User/Documents/Project Files/init.csv
```
  

3. **create_init_csv**: Creates an initial .csv file (init.csv) specifying the silos, start times, end times, and treatment (or lack thereof) times.
4. **create_diff_df**: Creates a .csv file (empty_diff_df.csv) using information from the init.csv specifying the required differences to be calculated at each silo.

##### Examples
```stata
create_init_csv, silo_names("71 73 58 46") start_times("1989 1989 1989 1989") end_times("2000 2000 2000 2000") treatment_times("1991 control 1993 control") covariates("asian black male")
# init.csv saved to
# C:/Users/User/Documents/Project Files/init.csv


create_diff_df, filepath("C:/Users/User/Documents/Project Files/init.csv") date_format("yyyy") freq("yearly")
# empty_diff_df.csv saved to
# C:/Users/User/Documents/Project Files/empty_diff_df.csv
```
##### Details
Calling `create_init_csv` will return the filepath where the created init.csv is saved and its contents will appear in the active Stata dataset. All of the options for `create_init_csv` are optional and thus `create_init_csv` can be called to create a blank init.csv file with only the appropriate headers which can then be filled out manually. Dates can be entered in a wide variety of formats shown [here](#valid-date-formats). Ensure that dates are consistently entered in the same format when creating the init.csv. Control silos should be marked with "control" in the treatment_times column (e.g. silos 73 & 46 in the above example). Covariates can either be specified when creating the init.csv or when calling `create_diff_df`.

Likewise, calling `create_diff_df` will return the filepath where the created empty_diff_df.csv is saved and its contents will appear in the active Stata dataset. The required arguments are the filepath to the init.csv, the [date_format](#valid-date-formats) used in the init.csv and the frequency of the data being considered for the unpooled difference-in-differences analysis (daily, weekly, monthly, or yearly). If the frequency of data is not monthly, but quarterly, you can specify freq("monthly") and the optional argument freq_multiplier(3). If covariates is left blank, `create_diff_df` will simply take the covariates specified in the init.csv, otherwise specifying covariates when calling `create_diff_df` will override any covariate specifications made in the init.csv. 

## Stage Two: Silo
This command is used during the second stage of the undid process at each silo:

5. **undidjl_stage_two**: Grabs information from the empty_diff_df.csv and the local silo data to fill out that silo's portion of the empty_diff_df.csv which is then saved as filled_diff_df_$local_silo_name.csv. Also computes trends data of the outcome of interest which is saved as trends_data_$local_silo_name.csv.

##### Examples
```stata
use "C:\Users\User\Data\State73.dta", clear
undidjl_stage_two, filepath("C:/Users/User/Documents/csvs/empty_diff_df.csv") local_silo_name("73") time_column("date_str") outcome_column("coll") local_date_format("ddmonyyyy") view_dataframe("trends")
# filled_diff_df_73.csv saved to
# C:/Users/User/Current Folder/filled_diff_df_73.csv
# trends_data_73.csv saved to
# C:/Users/User/Current Folder/trends_data_73.csv
```
##### Details
In order to run `undidjl_stage_two`, the local silo data must be loaded as the active dataset in Stata and any covariates specified in the empty_diff_df.csv should be renamed at the local silo to conform with the variable names used in the empty_diff_df.csv. The local_silo_name argument is used to specify how your local silo is named within the empty_diff_df.csv file and must correspond to how it is written there. The time_column and outcome_column arguments are used to indicate which variable in your active dataset is the outcome of interest and which variable indicates the date at which that outcome was recorded. It is important to note that the time_column should reference a string variable as passing a Stata date object to Julia does not work well. 

local_date_format specifies the [format](#valid-date-formats) of the date strings found in the time_column and is needed in order to parse the string to a date object within Julia. view_dataframe is set to "diff" if not specified but can be set to "trends" or "diff" and will return either the trends_data or the filled_diff_df to the active Stata dataset based on the selection, either way both dataframes are saved as .csv's. A final option is consider_covariates which is "true" by default but can be set to "false" if the covariates specified in Stage 1 do not exist at the local silo. 

## Stage Three: Analysis
These commands are used during the third and final stage of undid:

6. **undidjl_stage_three**: Computes aggregate ATT and standard error as well as ATTs by silo, g group, or gt group.
7. **plot_parallel_trends**: Plots parallel trends figures.

##### Examples
```stata
undidjl_stage_three, folder("C:/Users/User/Documents/Files From Silos") agg("g")

# Saving combined_diff_data.csv to C:\Current Working Directory
# Saving UNDID_results.csv to C:\Current Working Directory
```

```stata
plot_parallel_trends, folder("C:/Users/User/Documents/Files From Silos") outcome_variable("College Attendance") date_format("yearly")
```
![Parallel trends plot with seperated silos](./images/silos46_58_71_73.png)
```stata
plot_parallel_trends, folder("C:/Users/User/Documents/Files From Silos") outcome_variable("College Attendance") date_format("yearly") combine("true")
```
![Parallel trends plot with silos combined as one control line and one treatment line](./images/silos46_58_71_73_combined.png)
##### Details
`undidjl_stage_three` takes in a path to the folder containing all of the filled_diff_df_$silo_name.csv's as a string and returns the aggregate ATT and standard error to the active Stata dataset and saves these results to UNDID_results.csv in the current working directory. The *agg* argument specifies the aggregation method. By default it is set to "silo" so that the ATTs are aggregated by silos, but can be set to "gt" or "g" instead. Aggregating across g calculates ATTs for groups based on when the treatment time was, with each g group having equal weight. Aggregating across gt calculates ATTs for groups based on when the treatment time was and the time for which the ATT is calculated. This option is ignored in the case of a common treatment time and only takes effect in the case of staggered adoption. *covariates* can be set to "true" or "false" ("false" by default) and determines whether or not to use the diff_estimate column from the filled_diff_df's or the diff_estimate_covariates column when calculating ATTs. *save_csv* can be set to "true" or "false" ("true" by default) and saves the combined_diff_df.csv to the current working directory if set to "true". *interpolation* is set to "false" to default, but can be set to "linear_function". This is used to filled in any missing diff_estimate or diff_estimate_covariates values in the combined_diff_df. There must be at least one value for the (silo,g) group for which a missing value is being estimated in order for this to work. 

`plot_parallel_trends` takes in a filepath to the folder containing all of the trends_data_$silo_name.csv's as a string and returns timeseries plot of the variable of interest with either silos seperated or combined into a single treatment line and single control line. The *outcome_variable* argument is used to name the outcome variable that is being plotted and is used as the plot title. The *date_format* argument determines how the dates are shown along the x-axis (options are "yearly", "monthly", "day_and_month", or "full_date"). The *step* argument (defaults to 1) takes in an integer as is used to determine how many date labels should appear on the x-axis, if set to 3, for example, only every 3rd date from the dataset will be shown on the x-axis. The *silos* argument takes in a single string (e.g. "71 73") and restricts the plotting to only specified silos. Likewise the argument *omit_silos* takes in a single string (e.g. "58 46") and will omit those specified silos from the plotting. The argument *combine* can be set to "true" or "false" (defaults to "false") and if set to true takes the average at each date across treated vs control groups and then plots one line for the average across treated groups and one line for the average across control groups. Setting *save_csv* to "true" or "false" determines whether or not the combined_trends_data.csv should be saved or not (defaults to "true"). The dashed grey vertical lines on the parallel trends plot indicate treatment times. 

### Appendix

#### Valid Date Formats
- `ddmonyyyy` → 25aug1990
- `yyyym00` → 1990m8
- `yyyy/mm/dd` → 1990/08/25
- `yyyy-mm-dd` → 1990-08-25
- `yyyymmdd` → 19900825
- `yyyy/dd/mm` → 1990/25/08
- `yyyy-dd-mm` → 1990-25-08
- `yyyyddmm` → 19902508
- `dd/mm/yyyy` → 25/08/1990
- `dd-mm-yyyy` → 25-08-1990
- `ddmmyyyy` → 25081990
- `mm/dd/yyyy` → 08/25/1990
- `mm-dd-yyyy` → 08-25-1990
- `mmddyyyy` → 08251990
- `mm/yyyy` → 08/1990
- `mm-yyyy` → 08-1990
- `mmyyyy` → 081990
- `yyyy` → 1990

#### Undid Schematic 
![Diagram showing how difference-in-differences is computed with unpoolable data](./images/undid_schematic.png)

