# Visualizations of dvd rental data base ####

## packages ####
library(data.table)
library(ggplot2)

## directories ##
# SPECIFY DATA DIRECTORY HERE
map_data <- "/Users/marcusroesch/Downloads/"
# SPECIFY OUTPUT DIRECTORY HERE
map_output <- "/Users/marcusroesch/Downloads/"

## read data ####
insight1 <- fread(paste0(map_data, "insight1.csv"))
insight2 <- fread(paste0(map_data, "insight2.csv"))
insight3 <- fread(paste0(map_data, "insight3.csv"))
insight4 <- fread(paste0(map_data, "insight4.csv"))

## create plots #### 

### insight 1 ####
insight1[, category := factor(category, levels=insight1$category)] # fixes order of bars

ggplot(insight1, aes(x=category, y=revenue)) + 
  geom_bar(stat="identity") + 
  xlab("Top 10 genre") +
  ylab("Total revenue") +
  ggtitle("Total rental revenue of top 10 grossing genres in 2007") + 
  theme_bw()

ggsave(paste0(map_output, "insight1.pdf"), dpi = 300, scale = 0.5)


### insight 2 ####
insight2[, payment_month := paste(payment_month)]
insight2[, revenue_difference := as.numeric(revenue_difference)]

ggplot(insight2[!is.na(revenue_difference)], aes(x=payment_month, y=revenue_difference, fill=cat_family)) +
  geom_bar(stat="identity", position="dodge") +
  xlab("Month") +
  ylab("Change in revenue relative to previous month") +
  ggtitle("Change in monthly revenue across family-friendly and other films") + 
  theme_bw() + theme(legend.position = "bottom", legend.title = element_blank())

ggsave(paste0(map_output, "insight2.pdf"), dpi = 300, scale = 0.5)

### insight 3 ####
insight3 <- melt(insight3[, !c("customers")], id.vars = "payment_date")
insight3[, payment_date := paste(payment_date)]
insight3[variable == "increase_same", variable := "Increase or same"]
insight3[variable == "decrease", variable := "Decrease"]

ggplot(insight3, aes(x=payment_date, y=value, fill=variable)) +
  geom_bar(stat="identity", position="dodge") +
  xlab("Month") +
  ylab("Count") +
  ggtitle("Same or higher spendings vs. decreasing spendings, month to month") + 
  theme_bw() + theme(legend.position = "bottom", legend.title = element_blank())

ggsave(paste0(map_output, "insight3.pdf"), dpi = 300, scale = 0.5)

### insight 4 ####

insight4[, rental_rate := factor(rental_rate)]
insight4[, store_id := factor(store_id)]

ggplot(insight4, aes(x=rental_rate, y=count, fill=store_id)) +
  geom_bar(stat="identity", position="dodge") +
  xlab("Rental rate") +
  ylab("Rentals") +
  ggtitle("Rental payments per rental rate and store in April 2007") + 
  theme_bw() + theme(legend.position = "bottom") +
  guides(fill=guide_legend(title="Store ID"))

ggsave(paste0(map_output, "insight4.pdf"), dpi = 300, scale = 0.5)