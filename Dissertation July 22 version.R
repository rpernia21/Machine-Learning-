# Dissertation - July 21 2022 version ####

rm(list = ls())

setwd("~/Documents/Data Science/R/First Project in Mac")

#packages
library(ggplot2)
library(dplyr)
library(tidyverse)
library(dplyr)
library(haven)
library(lme4)
library(foreign)
library(psych)

#load data

load('WVS_Cross-National_Wave_7_rData_v4_0')
WVS7 <-`WVS_Cross-National_Wave_7_rData_v4_0`

#check data
names(WVS7)

#Step 1: Data preprocessing####
#select the variables you need to work with#
#look at the codebook here: https://www.worldvaluessurvey.org/WVSDocumentationWV7.jsp

dat1<-WVS7 %>% 
  select(S025, Q49, Q50, Q52, Q57, Q59, Q65, Q66, Q67, Q69, Q70, 
         Q71, Q72, Q73, Q74, Q76, Q112, Q131,
         Q142, Q143, Q146, Q147,Q148, Q150, Q172, Q199,
         Q201, Q202, Q203, Q204, Q205, Q206, Q207, Q208, Q235, 
         Q248, Q250, Q252,
         Q260, Q262, Q275, Q279, Q287, Q288, Q289) 

dat2 <-WVS7 %>% 
  select(B_COUNTRY, B_COUNTRY_ALPHA, W_WEIGHT, S025,
         v2x_libdem, regionWB, regtype, polregfh, btiruleoflaw,
         btistability, btigovindex, btigoveperform)

#work on the subsetted data
dat3 <- dat1 %>%
  mutate_all(., funs(as.numeric(.))) %>% 
  mutate(life.sat = Q49) %>%
  mutate(life.house.fin = Q50) %>% 
  mutate(unsafe = recode(Q52, '1'= 4,'2'= 3,'3'= 2,'4'= 1)) %>% 
  mutate(socialtrust = recode(Q57, '1'=2, '2'=1)) %>% 
  mutate(trust_neighbors = recode(Q59, '1'= 4,'2'= 3,'3'= 2,'4'= 1)) %>% 
  mutate(trust_army = recode(Q65, '1'= 4,'2'= 3,'3'= 2,'4'= 1)) %>% 
  mutate(trust_press = recode(Q66, '1'= 4,'2'= 3,'3'= 2,'4'= 1)) %>% 
  mutate(trust_TV = recode(Q67, '1'= 4,'2'= 3,'3'= 2,'4'= 1)) %>% 
  mutate(trust_police = recode(Q69, '1'= 4,'2'= 3,'3'= 2,'4'= 1)) %>% 
  mutate(trust_courts = recode(Q70, '1'= 4,'2'= 3,'3'= 2,'4'= 1)) %>% 
  mutate(trust_govt = recode(Q71, '1'= 4,'2'= 3,'3'= 2,'4'= 1))%>%
  mutate(trust_polparties= recode(Q72, '1'= 4,'2'= 3,'3'= 2,'4'= 1)) %>% 
  mutate(trust_congress= recode(Q73, '1'= 4,'2'= 3,'3'= 2,'4'= 1)) %>% 
  mutate(trust_civservices= recode(Q74, '1'= 4,'2'= 3,'3'= 2,'4'= 1)) %>% 
  mutate(trust_elections= recode(Q76, '1'= 4,'2'= 3,'3'= 2,'4'= 1)) %>% 
  mutate(corruption.perc = Q112) %>% 
  mutate(insecure = Q131) %>% 
  mutate(worry_war_abroad= recode(Q146, '1'= 4,'2'= 3,'3'= 2,'4'= 1)) %>% 
  mutate(worry_terror_attack= recode(Q147, '1'= 4,'2'= 3,'3'= 2,'4'= 1)) %>% 
  mutate(worry_civil_war= recode(Q148, '1'= 4,'2'= 3,'3'= 2,'4'= 1)) %>% 
  mutate(security_over_freedom = Q150) %>% 
  mutate(interest.politics = recode(Q199, '1'= 4,'2'= 3,'3'= 2,'4'= 1)) %>% 
  mutate(information.newspaper = recode(Q201, '1' = 5, '2' = 4, '4' = 2, '5'=1 )) %>% 
  mutate(information.TV = recode(Q202, '1' = 5, '2' = 4, '4' = 2, '5'=1 )) %>%
  mutate(information.radio = recode(Q203, '1' = 5, '2' = 4, '4' = 2, '5'=1 )) %>% 
  mutate(information.phone = recode(Q204, '1' = 5, '2' = 4, '4' = 2, '5'=1 )) %>%
  mutate(information.email = recode(Q205, '1' = 5, '2' = 4, '4' = 2, '5'=1 )) %>% 
  mutate(information.internet = recode(Q206, '1' = 5, '2' = 4, '4' = 2, '5'=1 )) %>%
  mutate(information.socialmedia = recode(Q207, '1' = 5, '2' = 4, '4' = 2, '5'=1 )) %>% 
  mutate(information.friends = recode(Q208, '1' = 5, '2' = 4, '4' = 2, '5'=1 )) %>% 
  mutate(strong_leaders = recode(Q235, '1'= 4,'2'= 3,'3'= 2,'4'= 1)) %>% 
  mutate(obey.rulers = Q248) %>% 
  mutate(import_demo = Q250) %>% 
  mutate(satis.polsystem = Q252) %>% 
  mutate(Sex = Q260) %>% 
  mutate(Age = Q262) %>% 
  mutate(Education = Q275) %>% 
  mutate(socialclass = recode(Q287, '1' = 5, '2' = 4, '4' = 2, '5'=1 )) %>% 
  mutate(income = Q288) %>% 
  mutate(pray = recode(Q172, '1'= 8, '2'= 7, '3'= 6, '4' = 5,
                       '5' = 4, '6'= 3, '7'= 2, '8'=1)) 

#drop nas and below 1
dat1[dat1 < 1] <-NA

#drop nas in the country-level variables
dat2[dat2 <0] <-NA

library(dplyr)
merge <-cbind(dat2, dat3)

#Step 2: Descriptive Stats####

#check internal consistency

library(psych)
alpha(dat2[, c("trust_courts", "trust_govt", "trust_polparties",
               "trust_congress", "trust_civservices", "trust_elections")])

# Create composite variable for Political Trust - without protective institutions
dat2$PoliticalTrust_overall <-rowMeans(dat2[, c("trust_courts", "trust_govt", "trust_polparties",
                                                "trust_congress", "trust_civservices", "trust_elections")],
                                       na.rm = T)

#Step 3: Linear Modelling####
#Table 1 - Mixed level####
summary(m1 <-lmer(PoliticalTrust_overall~ unsafe +worry_terror_attack+ satis_household_finance
                  + interest_politics + socialtrust 
                  + dem_perception+ age + gender + social_class+ educationR + pray + 
                    info_newspaper + info_TV + info_radio + info_phone + info_email + info_internet +
                    info_socmedia + info_talk_peers + 
                    (1 | LibDem),
                  data = dat2)) 


#Step 4: Visualizations#####
mutate_at(c("Q49", "Q50", "Q52", "Q57", "Q59", "Q65", 
            "Q66", "Q67", "Q69", "Q70", 
            "Q71", "Q72", "Q73", "Q74", "Q76", "Q112", "Q131","Q142", "Q143", "Q146", 
            "Q147","Q148", "Q150", "Q172", "Q199",
            "Q201", "Q202", "Q203", "Q204", "Q205", "Q206", 
            "Q207", "Q208", "Q235", "Q248", "Q250", "Q252",
            "Q260", "Q262", "Q275","Q279", "Q287", "Q288", "Q289")
          

library(usethis) 
usethis::edit_r_environ()

R_MAX_VSIZE=100Gb 



https://stackoverflow.com/questions/51295402/r-on-macos-error-vector-memory-exhausted-limit-reached?answertab=trending#tab-top

