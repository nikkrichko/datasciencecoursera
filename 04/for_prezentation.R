library(plotly)
library(readr)
library(data.table)



salary_raw <- read.csv(url("https://raw.githubusercontent.com/devua/csv/master/salaries/2016_may_final.csv"), na.strings= c("NA",""," "))

salary <- as.data.table(salary_raw[,c(2,3,4,7,12,13)])
names(salary) <- c("position", "programing_language", "specialization", "salary", "sex", "age")
salary$sex <- ifelse(salary$sex == "мужской", "men", "woman")
salary$sex <- as.factor(salary$sex)
salary <- salary[-c(876,1656)]


## most popular programming language
pl <- as.data.table(table(salary$programing_language))
pl <- pl[-2, ]
pl <- pl[order(-pl$N )]
pl$V1 <- factor(pl$V1, levels = pl$V1)
plot_ly(x = pl$V1, y = pl$N, type = "bar") %>% 
    layout(title = 'most popular programming language')

## year salary depending on programing language
salaryPL <- salary[!is.na(salary$programing_language)]
salaryPL <- salaryPL[salaryPL$programing_language != "1С"]
levels(salaryPL$sex) <- c("men", "woman")
plot_ly(y=salaryPL$salary *12, color = salaryPL$programing_language, type = "box") %>% 
    layout(title = 'year salary depending on programing language')

## year salaries depends on age
plot_ly(y=salaryPL$salary *12, x = salaryPL$age, type = "box")%>% 
    layout(title = 'year salaries depends on age')

## salaries depends on sex
plot_ly(x=salaryPL$salary *12, color =  as.factor(salaryPL$sex), type = "box", orientation = "h")%>% 
    layout(title = 'year salaries depends on sex')
