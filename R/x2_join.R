library(tidyr)

card_qtys <- deck_attr %>%
    filter(deck_type == "Ranked Deck") %>% 
    select(deck_id) %>% 
    inner_join(deck_comp, by = "deck_id") %>% 
    gather(card, card_id, card_0:card_29) %>% 
    group_by(deck_id, card_id) %>% 
    summarise(quantity = n()) %>% 
    ungroup()

head(deck_cards)

unique(deck_cards$quantity) # only 1 and 2
sum(is.na(deck_cards$quantity)) # should be 0

sum(!(deck_cards$card_id %in% cards$dbfId)) # 0 means all card ids can be looked up in the cards db


deck_cards <- cards %>% 
    select(dbfId, name, cost, cardClass, type, set) %>% 
    right_join(card_qtys, by = c("dbfId" = "card_id"))



# quick calc --------------------------------------------------------------

# most popular cards
card_qtys %>% 
    group_by(card_id) %>% 
    summarise(n_decks = n(),
              pct_all = n_decks / nrow(decks)) %>% 
    arrange(desc(pct_all)) %>% 
    left_join(cards, by = c("card_id" = "dbfId")) %>% 
    select(name, cardClass, type, set, n_decks, pct_all)

# unused cards
cards %>%
    select(-playRequirements) %>% 
    filter(collectible,
           set != "UNGORO",
           type != "HERO") %>% 
    anti_join(card_qtys, by = c("dbfId" = "card_id")) %>% 
    select(dbfId, name, cardClass, type, set)

# 
