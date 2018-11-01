deck_qtys <- decks_comp %>% 
    gather(card_no, card_id, card_0:card_29) %>% 
    select(-card_no) %>%
    mutate(card_id = recode(card_id, !!!mislab_recode)) %>% 
    group_by(deck_id, card_id) %>% 
    summarise(qty = n()) %>% 
    ungroup()

ranked_deck_qtys <- decks_attr %>% 
    filter(deck_type == "Ranked Deck",
           deck_format == "S") %>% 
    select(deck_id, deck_class, 
           date, hsmonth, hsyear, title,
           user, deck_set, craft_cost) %>% 
    inner_join(deck_qtys, by = "deck_id")
    
    
    
joined <- ranked_deck_qtys %>% 
    inner_join(cards_simple, by = c("card_id" = "dbfId"))

(rarity_counts <- joined %>% 
    group_by(deck_id, rarity) %>% 
    summarise(no_cards = sum(qty)) %>% 
    spread(rarity, no_cards, fill = 0L) %>% 
    select(deck_id, Free, Common, Rare, Epic, Legendary))

ggplot(rarity_counts, aes(x = Free)) +
    geom_histogram(binwidth = 1)

table(rarity_counts$Legendary)
rarity_counts %>% filter(Legendary == 30) %>% nrow
    
joined %>% filter(deck_id == 193470) %>% select(title, deck_class, date, user, name, cardClass)


joined %>% 
    group_by(deck_id) %>% 
    mutate(leg = sum(rarity == "Legendary")) %>% 
    filter(leg == 30) %>% 
    distinct(deck_id, title, user, leg, craft_cost) %>% 
    print(n = Inf)

rm(deck_qtys, ranked_deck_qtys, joined, rarity_counts)
