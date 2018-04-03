# Retirement_Calc Simulator in R
---
title: "R Notebook"
output: html_notebook
---
```{r}
library(dplyr)
library(infer)
library(purrr)
```

```{r}
time <- 10

initial_capital <- 1

large_cap_weight <- 0.4
small_cap_weight <- 0.25
international_weight <- 0.2
bond_weight <- 0.10
CD_weight <- 0.05

account_for_inflation = T

reps = 100


```
Read In Historical Data
```{r}
hist_returns <- read.csv("C:/Users/Chris Baskerville/Documents/R_sessions and files/R_Projects/Index_Returns_Shiny/Index_returns.csv")
```
Bootstrap Sampling
```{r}
yearPickBoot <- hist_returns %>%
  select(Year) %>% 
  rep_sample_n(size = time, replace = TRUE, reps = reps)
```
Create simulation returns data
```{r}
sim_list <- list()
for (repl in 1:reps) {
  capital <- initial_capital
  repSet <- yearPickBoot[which(yearPickBoot$replicate == repl),]
  sim_vect <- numeric(time)
  for (obs in 1:time) {
    year <- as.numeric(repSet[obs,"Year"])
    year_return <- filter(hist_returns, Year == year)
    year_gain <-  year_return$Large_Cap*large_cap_weight*capital + year_return$Small_Cap*small_cap_weight*capital + year_return$International*international_weight*capital + year_return$Bond*bond_weight*capital + year_return$CD_Rate*CD_weight*capital
    
    if (account_for_inflation) {
      year_gain <- year_gain - year_return$Inflation * capital
    }
      
    sim_vect[obs] <- capital + year_gain
    capital <- capital + year_gain
  }
  sim_list[[repl]] <- sim_vect
}
sim_df <- do.call("cbind", sim_list)
colnames(sim_df) <- paste('sim', 1:reps, sep = "_")
#labels <- paste0("year", 1:time)
labels <- (1:time)
sim_df <- data.frame(cbind(sim_df, Year = labels))
```
Plots
```{r}
library(reshape2)
library(ggplot2)
library(ggthemes)
lot_data <- sim_df %>% 
  melt(id.vars = 'Year', variable.name = 'simulation') %>% 
  group_by(simulation)
```

```{r}
ggplot(lot_data, aes(x = Year, y = value)) + geom_line(aes(color = simulation)) +  scale_x_continuous(limits = c(0,time), expand = c(0, 0)) +
  scale_y_continuous(limits = c(0, max(lot_data$value)), expand = c(0, 0)) + theme_economist() + theme(legend.position = "none")
```
Histogram
```{r}
library(stats)
final_year <- sim_df %>% 
  filter(Year == time) %>% 
  #select(-Year) %>% 
  melt(id.vars = 'Year', variable.name = 'simulation')
  
ggplot(final_year, aes(x = value)) + geom_histogram(aes(y = ..density..), bins = 100, col = 'black')  + theme_economist() + stat_function(fun = dnorm, color = 'red', args = list(mean = median(final_year$value), sd = sd(final_year$value)))  + scale_x_continuous(name = "Value of Investment",limits = c(min(final_year$value), (mean(final_year$value) + 3*sd(final_year$value))), expand = c(0, 0)) + scale_y_continuous(name = "Fequency of Return") + geom_vline(xintercept = median(final_year$value), size = 1, colour = "#FF3721", linetype = "dashed") + ggtitle("Simultated Likelihood of Investment Outcomes")

```
```{r}
quantile(final_year$value)
```

```{r}
library(extrafont)
fill <- "#4271AE"
line <- "#1F3552"

ggplot(final_year, aes(x = value)) +
        geom_density(fill = fill, colour = line) +
        scale_x_continuous(name = "Value of Investment",
                           breaks = seq(0, 10, 1),
                           limits=c(min(final_year$value), (mean(final_year$value) + 3*sd(final_year$value)))) +
        scale_y_continuous(name = "Density of Return Likelihood") +
        ggtitle("Simultated Likelihood of Investment Outcomes") +
        theme_economist() +
        theme(legend.position = "bottom", legend.direction = "horizontal",
              legend.box = "horizontal",
              legend.key.size = unit(1, "cm"),
              plot.title = element_text(family="Tahoma"),
              text = element_text(family = "Tahoma"),
              axis.title = element_text(size = 12),
              legend.text = element_text(size = 9),
              legend.title=element_text(face = "bold", size = 9))
```

