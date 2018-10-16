card_texts <- hscards$text

head(card_texts, 20)
str_detect(card_texts, "<.*>") %>% head(20)
str_detect(card_texts, "\\n") %>% head(20)

str_remove_all(card_texts, "<.{1,2}>") %>% 
    str_replace_all("\\n", " ") %>% 
    head(20)

hscards$mechanics %>% unlist %>% unique()
hscards$referencedTags %>% unlist %>% unique()
