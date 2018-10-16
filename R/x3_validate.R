unique(ranked_qtys$quantity) # only 1 and 2 should be present
sum(is.na(ranked_qtys$quantity)) # there should be 0 NA values

# check that all cards used in ranked decks can be found the cards database
sum(!(unique(ranked_qtys$card_id) %in% simple_cards$dbfId))
# if not 0, there are missing or mislabelled cards

# vector of missing card ids
mssng <- unique(ranked_qtys$card_id)[!(unique(ranked_qtys$card_id) %in% simple_cards$dbfId)]

# retrieve missing cards from cards db
mssdf <- hscards %>% 
    select(-playRequirements) %>% 
    filter(dbfId %in% mssng) %>% 
    select(dbfId, name, cost, cardClass, rarity, type, collectible, set)

# all not collectible, some unknown rarity
arrange(mssdf, name)

# show list of mislabelled cards and their other copies
# note that for each card, only one of the copies is collectible
hscards %>% 
    select(-playRequirements) %>% 
    filter(name %in% mssdf$name) %>% 
    select(dbfId, name, cost, cardClass, rarity, type, collectible, set) %>% 
    arrange(name)

hscards %>% 
    select(dbfId, name, collectible) %>% 
    filter(collectible == TRUE) %>% 
    inner_join(mssdf, by = "name") %>% 
    arrange(name)

# pre-processing needed: join the mislabelled ids to the correct ids
