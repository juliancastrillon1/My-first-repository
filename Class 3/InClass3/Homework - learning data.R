#SOURCE:https://epirhandbook.com/en/cleaning-data-and-core-functions.html#re-code-values

pacman::p_load(
  rio,        # importing data  
  here,       # relative file pathways  
  janitor,    # data cleaning and tables
  lubridate,  # working with dates
  epikit,     # age_categories() function
  tidyverse   # data management and visualization
)

linelist_raw <- import("./data/raw/linelist_raw.xlsx")

head(linelist_raw,20)

skimr::skim(linelist_raw)
names(linelist_raw)

### To reference a column name that includes spaces, surround the name with 
### back-ticks, for example: linelist$` '\x60infection date\x60'`

## We begin the pipe line or cleanning data with the following functions

# pipe the raw dataset through the function clean_names(), assign result as "linelist"  
linelist <- linelist_raw %>% 
  janitor::clean_names()

# see the new column names
names(linelist)

# manually re-name columns (Take of the # from rename)
# NEW name             # OLD name
#rename(date_infection       = infection_date,
       #date_hospitalisation = hosp_date,
       #date_outcome         = date_of_outcome)

# rename by column position I will give a dif name to the data set
  
linelist1 <- linelist_raw %>% 
rename(newNameForFirstColumn  = 1,
       newNameForSecondColumn = 2)

names(linelist1)

# Rename using select only keeps the selected columns ----

linelist2 <- linelist_raw %>% 
  select(# NEW name             # OLD name
    date_infection       = `infection date`,    # rename and KEEP ONLY these columns
    date_hospitalisation = `hosp date`)

view(linelist2)

# We use the same select function to select th only columns that I want to see

# linelist dataset is piped through select() command, and names() prints just the column names

linelist %>% 
  select(case_id, date_onset, hosp_date, fever) %>% 
  names()

# we can use select and everything() to re order the columns

linelist %>%
  select(date_onset, hosp_date, everything())%>%
  names()

###############################################################################
#########################USEFUL FUNCTIONS######################################
###############################################################################

# everything() - all other columns not mentioned
#last_col() - the last column
#where() - applies a function to all columns and selects those which are TRUE
#contains() - columns containing a character string
#example: select(contains("time"))
#starts_with() - matches to a specified prefix
#example: select(starts_with("date_"))
#ends_with() - matches to a specified suffix
#example: select(ends_with("_post"))
#matches() - to apply a regular expression (regex)
#example: select(matches("[pt]al"))
#num_range() - a numerical range like x01, x02, x03
#any_of() - matches IF column exists but returns no error if it is not found
#example: select(any_of(date_onset, date_death, cardiac_arrest))

#In addition, use normal operators such as c() to list several columns, : for consecutive columns, ! for opposite, & for AND, and | for OR.

#########################################################################

#Using Where() to specify criteria in select()

linelist %>%
  select(where(is.numeric))%>%
  names()

# Contains() to select columns that contain certain character string 

linelist %>%
  select(contains("date"))%>%
  names()

# Same for end_with()

linelist %>%
  select(ends_with("te"))%>%
  names()

# Same for start_with()

linelist %>%
  select(starts_with("da"))%>%
  names()

#The function matches() works similarly to contains() but can be provided a 
#regular expression , such as multiple strings separated by OR bars within the parentheses:

linelist%>%
  select(matches("date|outcome|onset"))%>%
  names()

#its better to use any_of()to void error if the name of the column does not exist
#c() is used to concatenate vectors

linelist %>% 
  select(any_of(c("date_onset", "village_origin", "village_detection", "village_residence", "village_travel"))) %>% 
  names()

### Remove columns with a minus sign - and : to select continious columns

linelist%>%
  select(-c(date_onset, fever:vomit))%>%
  names()

# Remove a column with R 

linelist$date_onset <- NULL
names(linelist)

#Creating a new list with only id and age related columns

linelist_age <- select(linelist,case_id,contains("age"))
view(linelist_age)

###############################################################################
#################### NOW WE BEGIN FROM CERO TO PRACTICE #######################
###############################################################################

#We are removing  row_num, merged_header, and x28 from the original data

linelist <- linelist_raw %>%
  janitor::clean_names() %>%
  rename(date_infection=infection_date,
         date_hospitalisation=hosp_date,
         date_outcome=date_of_outcome) %>%
  select(-c("row_num","merged_header","x28"))
  
#We use distinct() to eliminate rows that are 100% duplicate

nrow(linelist)
linelist <- linelist %>%
  distinct()

nrow(linelist)

#If we put all together it will look like this  

linelist <- linelist_raw %>%
  janitor::clean_names() %>%
  rename(date_infection=infection_date,
         date_hospitalisation=hosp_date,
         date_outcome=date_of_outcome) %>%
  select(-c("row_num","merged_header","x28"))%>%
  distinct()
nrow(linelist)

#We can add columns with the function mutate()
#We can also create new columns with the interaction of two or more columns
#As default it will go as the last column

linelist <- linelist %>%
  mutate(new_col=10)%>%
  mutate(bmi=wt_kg/(ht_cm/100)^2)

view(linelist)

#We can create multiple columns too

new_col_demo <- linelist %>%                       
  mutate(
    new_var_dup    = case_id,             # new column = duplicate/copy another existing column
    new_var_static = 7,                   # new column = all values the same
    new_var_static = new_var_static + 5,  # you can overwrite a column, and it can be a calculation using other variables
    new_var_paste  = stringr::str_glue("{hospital} on ({date_hospitalisation})") # new column = pasting together values from other columns
  ) %>% 
  select(case_id, hospital, date_hospitalisation, contains("new"))        # show only new columns, for demonstration purposes
  
#TIP: A variation on mutate() is the function transmute(). This function adds a new column just like mutate(), but also drops/removes all other columns that you do not mention within its parentheses.

# HIDDEN FROM READER (If we want to eliminate the columns we created before)
# removes new demo columns created above
# linelist <- linelist %>% 
#   select(-contains("new_var"))

### Changing classes in the dataset

class(linelist$age)

linelist <- linelist %>%
  mutate(age=as.numeric(age))

class(linelist$age)

### Grouping data by hospital for normalization

linelist %>%
  group_by(hospital)%>%
  mutate(age_norm = age / mean(age, na.rm=T))%>%
  view()

### Transform multiple columns at the same
#Specify the columns to the argument .cols =. You can name them individually, or use “tidyselect” helper functions. Specify the function to .fns =. 
#Continuation: Note that using the function mode demonstrated below, the function is written without its parentheses ( ).

linelist <- linelist %>%
  mutate(across(.col=c(temp,ht_cm,wt_kg),.fns=as.character))

### If we would like to change everything into character

#linelist <- linelist %>% 
  #mutate(across(.cols = everything(), .fns = as.character))

#to change all columns to character class
#linelist <- linelist %>% 
  #mutate(across(.cols = contains("date"), .fns = as.character))

#################

# Coalese()----
# it is used to find empty values in a variable a fill it with the answer in other variables
#linelist <- linelist %>% 
  #mutate(village = coalesce(village_detection, village_residence))

###Cumulative Math ----
##### We use the function cumsum() to get the cumulative sum as the data goes down

cumulative_case_counts <- linelist %>%  # begin with case linelist
  count(date_onset) %>%                 # count of rows per day, as column 'n'   
  mutate(cumulative_cases = cumsum(n)) %>% # new column, of the cumulative sum at each row
  view()

### Using Base R ----
# used to create a new column

linelist <- linelist %>%
  mutate(across(.col=c(temp,ht_cm,wt_kg),.fns=as.numeric))

linelist$bmi = linelist$wt_kg / (linelist$ht_cm / 100) ^ 2

#THIS IS HOW THE PIPELINE IS GOING----

linelist <- linelist_raw %>%
  janitor::clean_names() %>%
  rename(date_infection=infection_date,
         date_hospitalisation=hosp_date,
         date_outcome=date_of_outcome) %>%
  select(-c("row_num","merged_header","x28"))%>%
  distinct()%>%
  mutate(bmi = wt_kg / (ht_cm/100)^2) %>% 
  mutate(across(contains("date"), as.Date), 
         generation = as.numeric(generation),
         age        = as.numeric(age)) 

# RECODING VALUES ----
## SPECIFIC VALUES ====

##### fix incorrect values              # old value       # new value

linelist <- linelist %>% 
  mutate(date_onset=as.character(date_onset)) %>% 
  mutate(date_onset = recode(date_onset, "2014-14-15" = "2014-04-15"))%>%
  mutate(date_onset=as.Date(date_onset))

###Checking columns for errors we can identify spelling errors

table(linelist$hospital, useNA = "always")

### then we modify them

linelist <- linelist %>% 
  mutate(hospital = recode(hospital,
                           # for reference: OLD = NEW
                           "Mitylira Hopital"  = "Military Hospital",
                           "Mitylira Hospital" = "Military Hospital",
                           "Military Hopital"  = "Military Hospital",
                           "Port Hopital"      = "Port Hospital",
                           "Central Hopital"   = "Central Hospital",
                           "other"             = "Other",
                           "St. Marks Maternity Hopital (SMMH)" = "St. Mark's Maternity Hospital (SMMH)"
  ))

## BY LOGIC RECODING====
### REPLACE FUNCTION ############################

linelist <- linelist%>%
  mutate(gender=replace(gender,case_id == "2195","Female"))

#### Using basic R
#### linelist$gender[linelist$case_id == "2195"] <- "Female"

### ifelse() and if_else() functions #################
#### is.na()means there are empty values or 

linelist <- linelist %>% 
  mutate(source_known = ifelse(!is.na(source), "known", "unknown"))%>%
  mutate(date_death = if_else(outcome == "Death", date_outcome, NA_real_))

##### Avoid stringing together many ifelse commands… use case_when() instead! 
#### case_when() is much easier to read and you’ll make fewer errors.

## COMPLEX LOGIC =====

linelist <- linelist %>% 
  mutate(age_years = case_when(
    age_unit == "years"  ~ age,       # if age is given in years
    age_unit == "months" ~ age/12,    # if age is given in months
    is.na(age_unit)      ~ age,       # if age unit is missing, assume years
    TRUE                 ~ NA_real_)) # any other circumstance, assign missing

## MISSING VALUES ====

### Function REPLACE_NA() It helps to replace missing values with a string

linelist <- linelist %>% 
  mutate(hospital = replace_na(hospital, "Missing"))

### When we try to use the previous function with factors you will get an error 
### to avoid it use fct_explicit_na()

linelist %>% 
  mutate(hospital = fct_explicit_na(hospital))









