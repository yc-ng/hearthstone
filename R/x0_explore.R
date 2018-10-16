library(tidyverse)
library(jsonlite)

hsdecks <- read_csv("data.csv")
cards <- fromJSON("refs.json")


# dataset overview --------------------------------------------------------

names(hsdecks)
glimpse(hsdecks)
length(unique(hsdecks$deck_id))
sapply(hsdecks[c(3:5, 7:8)], table)
range(hsdecks)


# pre-processing ----------------------------------------------------------

# class colors (from wowpedia) - needs to be updated for hearthstone
# paladin is yellow, rogue is black, warrior is red
# exact hexcodes... probably colorpick from the game itself
class_colors <- c(
    "Druid" = "#FF7D0A", #6A4023
    "Hunter" = "#ABD473", #236621
    "Mage" = "#40C7EB",
    "Paladin" = "#F58CBA",
    "Priest" = "#FFFFFF",
    "Rogue" = "#FFF569",
    "Shaman" = "#0070DE",
    "Warlock" = "#8787ED",
    "Warrior" = "#C79C6E"
)

# remove decks created/updated before game launch (2014-03-11)
hs_live <- hsdecks %>%
    filter(date >= "2014-03-11")

# check there are no duplicates (deck_id)
length(unique(hsdecks$deck_id)) == nrow(hsdecks)
length(unique(hs_live$deck_id)) == nrow(hs_live)

# practice asking questions -----------------------------------------------

# how are the craft costs distributed for each class?
# only interested in decks which cost less than 10,000 (dust)
ggplot(hs_live, aes(x = craft_cost, fill = deck_class)) +
    geom_histogram(color = "black", binwidth = 1000) +
    scale_x_continuous(breaks = seq(0, 10000, 2000)) +
    scale_fill_manual(values = class_colors) +
    coord_cartesian(xlim = c(0, 10000)) +
    facet_wrap(~ deck_class)

# how are the deck sets distributed across time?
ggplot(hs_live, aes(x = date, fill = deck_set)) +
    geom_bar() +
    scale_x_date(date_breaks = "3 months")

# what is the distribution of deck types across deck sets?
table(hs_live$deck_set, hs_live$deck_type)

# what is the percentage representation of deck types for all decks since launch?
round(prop.table(table(hs_live$deck_type)) * 100, 2)

# amongst ranked decks, what is the percentage representation of classes?
round(prop.table(table(hs_live$deck_class)) * 100, 2)
