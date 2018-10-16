library(ggplot2)
library(zoo)

class_colors <- c(
    "Druid" = "#FF7D0A",
    "Hunter" = "#ABD473",
    "Mage" = "#40C7EB",
    "Paladin" = "#F58CBA",
    "Priest" = "#FFFFFF",
    "Rogue" = "#FFF569",
    "Shaman" = "#0070DE",
    "Warlock" = "#8787ED",
    "Warrior" = "#C79C6E"
)

releases_filt <- c("Live Patch 4973", "Naxx Launch", "GvG Launch", "Blackrock Launch", 
  "TGT Launch", "Explorers", "Old Gods", "Karazhan", "Gadgetzan")
releases_abbr <- c("Launch", "Naxx", "GvG", "Blackrock", "TGT", 
                   "Explorers", "Old Gods", "Karazhan", "Gadgetzan")

releases <- decks %>% 
    filter(deck_set %in% releases_filt) %>% 
    group_by(deck_set) %>% 
    summarise(release = min(date)) %>%
    ungroup()

print(releases, n = Inf)

release_dates <- releases[["release"]]
names(release_dates) <- releases[["deck_set"]]

# how many ranked decks have been submitted each month?
deck_attr %>% 
    filter(deck_type == "Ranked Deck") %>% 
    ggplot(aes(x = as.yearmon(date))) + 
    geom_bar() +
    scale_x_yearmon() +
    geom_vline(xintercept = as.yearmon(release_dates), alpha = 0.2) +
    annotate("text", label = releases_abbr, 
             x = as.yearmon(release_dates), y = 16000,
             hjust = 1, angle = 60)

# how many standard and wild decks have been submitted each month?
deck_attr %>% 
    filter(deck_type == "Ranked Deck") %>% 
    ggplot(aes(x = as.yearmon(date), fill = deck_format)) + 
    geom_bar() +
    scale_x_yearmon() +
    geom_vline(xintercept = as.yearmon(release_dates), alpha = 0.2) +
    annotate("text", label = releases_abbr, 
             x = as.yearmon(release_dates), y = 16000,
             hjust = 1, angle = 60)

# side: wild decks before april 2016 (Old Gods expansion)?
decks %>% 
    filter(date < release_dates["Old Gods"],
           deck_format == "S") %>% 
    select(craft_cost:user) %>% 
    summary()
    

# proportion of decks by class over time
decks %>% 
    filter(deck_type == "Ranked Deck",
           date >= "2014-03-11") %>% 
    ggplot(aes(x = as.yearmon(date), fill = deck_class)) +
    geom_area(stat = "count", position = "fill") +
    scale_x_yearmon() +
    scale_fill_manual(values = class_colors) +
    geom_vline(xintercept = as.yearmon(release_dates), alpha = 0.2) +
    annotate("text", label = releases_abbr, 
             x = as.yearmon(release_dates) + 0.09, y = 1,
             hjust = 1, angle = 90)


    