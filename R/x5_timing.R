system.time(
    foo <- deck_comp %>% 
        select(card_0:card_29) %>% 
        gather(card_no, card_id) %>% 
        distinct(card_id) %>%
        unlist() %>% 
        sort()
)

system.time(
    bar <- deck_comp %>%
        select(card_0:card_29) %>%
        unlist() %>%  # flatten into a vector
        unique() %>%
        sort()
)

system.time(
    bar <- deck_comp %>%
        select(card_0:card_29) %>%
        unlist(use.names = FALSE) %>%  # drop names
        unique() %>%
        sort()
)

system.time(
    moo <- deck_comp %>%
        select(card_0:card_29) %>%
        unlist() %>% 
        `[`(!duplicated(.)) %>% 
        sort()
)


system.time(
    moo <- deck_comp %>%
        select(card_0:card_29) %>%
        unlist(use.names = FALSE) %>% 
        `[`(!duplicated(.)) %>% 
        sort()
)

identical(foo, bar)
identical(bar, moo)
