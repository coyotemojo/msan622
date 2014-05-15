
#setwd('~/Documents/career/sling/ml-1m/')

users <- read.csv('users.dat', sep='\t', header=FALSE, strip.white=TRUE, stringsAsFactors=FALSE)
colnames(users) <- c('user_id', 'gender', 'age', 'occupation', 'raw_zip')
users$gender <- factor(users$gender) 
levels(users$gender)[levels(users$gender)=="F"] <- "Female"
levels(users$gender)[levels(users$gender)=="M"] <- "Male"


users$age <- factor(users$age, ordered=TRUE)
levels(users$age) <- c("Under 18", 
                          "18-24",
                          "25-34",
                          "35-44",
                          "45-49",
                          "50-55",
                          "56+")

users$occupation <- factor(users$occupation)
levels(users$occupation) <- c("Other",
                           "Academic/Educator",
                           "Artist",
                           "Clerical/Admin",
                           "College/Grad Student",
                           "Customer Service",
                           "Doctor/Health Care",
                           "Executive/Managerial",
                           "Farmer",
                           "Homemaker",
                           "K-12 Student",
                           "Lawyer",
                           "Programmer",
                           "Retired",
                           "Sales/Marketing",
                           "Scientist",
                           "Self-employed",
                           "Technician/Engineer",
                           "Tradesman/Craftsman",
                           "Unemployed",
                           "Writer")









