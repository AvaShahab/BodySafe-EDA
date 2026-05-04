#EXPLORATORY DATA ANALYSIS — Toronto BodySafe Public Health Inspections
#Fatemeh Shahabdehkorid
# Final Project Mileston 1 

library(tidyverse)
library(lubridate)
library(scales)
library(ggthemes)
library(knitr)

ds <- read.csv('bodysafe_inspections.csv', stringsAsFactors = FALSE)

cat("--- Dataset Dimensions ---\n")
dim(ds)

cat("\n--- Structure of the Dataset ---\n")
str(ds)

cat("\n--- First 6 Rows ---\n")
head(ds)

ds$insDate <- as.Date(ds$insDate)
cat('\n--- Date column after conversion ---\n')
class(ds$insDate)
range(ds$insDate)

colwithnone <- c('observation', 'infCategory', 'defDesc', 'infType', 'actionDesc','OutcomeDesc')

ds <- ds %>%
  mutate(across(all_of(colwithnone), function(x) ifelse(x == "None", NA, x)))


cat("\n--- Missing values per column (after cleaning) ---\n")
colSums(is.na(ds))

ds <- ds %>% 
  select(-OutcomeDate, -OutcomeDesc, -fineAmount)

cat('\n---Column Remaining After Dropping Empty Ones---\n')
names(ds)

ds$insStatus <- as.factor(ds$insStatus)
ds$srvType   <- as.factor(ds$srvType)
ds$infType   <- as.factor(ds$infType)
ds$infCategory <- as.factor(ds$infCategory)

ds$year <- year(ds$insDate)
ds$month <- month(ds$insDate, label = TRUE, abbr = TRUE)

cat('\n--- Inspections by Year ---\n')
table(ds$year)

cat('\n --- Number of exact duplicate rows --- \n')
sum(duplicated(ds))

summary(ds)

cat('\n --- Inspection Status Breakdown --- \n')
status_table <- table (ds$insStatus)
print(status_table)

cat('\n--- Inspection Outcome Proportions (%) --- \n')
round(prop.table(status_table) * 100, 2)

cat('\n --- Records by Service Type --- \n')
service_table <- sort(table(ds$srvType), decreasing = TRUE)
print(service_table)

cat('\n --- Infraction Severity Counts (among non-compiant inspections --- \n ')
inf_ds <- ds %>% filter(!is.na(infType))
table(inf_ds$infType)

cat('\n --- Top 10 Infraction Categories ---\n')
ds %>%
  filter(!is.na(infCategory)) %>%
  count(infCategory, sort = TRUE ) %>%
  head(10) %>% 
  kable(col.names = c('Infraction Category' , 'count') , format = 'simple')

cat('\n --- Compliance Rate by Service Type --- \n')
ds %>%
  group_by(srvType, insStatus) %>%
  summarise(n= n(), .groups = 'drop') %>%
  group_by(srvType) %>%
  mutate(pct = round(100 * n / sum(n),1)) %>%
  arrange(srvType, desc(n)) %>%
  print(n=40)

#===========================================================================================================
#Q1 (One-sample test):"Is the true non-compliance rate in Toronto personal service shops different from 20%?"
#===========================================================================================================

prop.test(x = 2648, n = 11915, p = 0.20, 
          alternative = "two.sided", correct = FALSE)
#===========================================================================================================
#Question 2 (Two-sample test):"Do high-risk services (tattooing, body piercing, micropigmentation, injectables) 
#fail inspections more often than lower-risk services (hair, nails, aesthetics, ear piercing)?"
#===========================================================================================================

prop.test(x = c(438, 2210), 
          n = c(1473, 10442),
          alternative = "greater", 
          correct = FALSE)


#===========================================================================================================
# Question 3 Does Body Piercing have a higher proportion of Crucial infractions compared to Nails?
#===========================================================================================================

prop.test(x = c(103, 710), n = c(108,763), alternative = "greater", correct = FALSE)











  
         

         

         