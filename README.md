# TMMoil
Táborová hra na jarní TMM 2023
## Jak to funguje
Cíl hry je jednoduchý, mít co nejvíce bodů...

- Body dostanete za kupovaní parcel ve městě...
- Parcely koupíte za peníze...
- Peníze získáte prodejem ropy...
- Ropu získáte těžbou...
- Kde těžit zjistíte hledáním...
- Budete hledat ropu...

## Dobře, ale co to znamená?
Budete hledat a těžit ropu. Pokud znáte hru Turmoil, pochopili jste 90 % mechanik v této hře. V týmu se rozdělte na mladší a starší. V jednom kole totiž budou současně probíhat dvě fáze hry.

## Čeho si povšimnout
1. **Velká mapa** - Na flipchartu na dveřích vidíte mapu území, kde budete těžit ropu. Každé políčko má předem určenou kvalitu od 5 do 20. Políčka s podobnými hodnotami najdete blízko sebe. ***(TODO: Možná ne mapu na těžbu, ale jen mesto na dveře)***

2.  **Malá mapa** - Ve středu velké mapy vidíte malá políčka, to jsou parcely ve městě, z nich se vypočítá vaše skóre v této hře.
3.  **Obrazovka** - Kromě hledací fáze na ní bude probíhat celá hra.
4.  **To tlačítko na vašem stole** - Tím se ovládá ta hra na obrazovce.

# Fáze hry

V každém proběhne těchto pět kroků v tomto pořadí:
1. **Nákup pozemku** - na začátku kola si na velké mapě koupíte pozemek, kde budete hledat. Týmy se mohou přehazovat, chtějí-li stejný pozemek.
2. **Upgrady, vážení, upgrady!** - za vydělané peníze si můžete koupit upgrady, abyste získali výhodu oproti ostatním.
3. **Dražba parcely (ve městě)** - Každé kolo se vydraží jedno (nebo více) z políček na malé mapě (těch za které dostáváte body). Vítěz každé jedné dražby může být jen jeden. Může se také vydražit ***žolík*** za který si lze vybrat libovolná z volných parcel ve městě.
4. **Upgrady, vážení, upgrady!** - Ti co nevyhráli dražbu mohou zamáčknout slzu nákupem upgradů (i ti co vyhráli, pokud jim zbývají peníze).
5. **Herní kolo** - dělí se na *hledací část* a *těžební část*.

## Nákup pozemku
Nákup pozemku probíhá tak, že si tým řekne o jaký pozemek má zájem. Pořadí výběru je od týmu s nejméně penězi po nejbohatší tým. Tým který je právě na řadě má své jméno zvýrazněno svou barvou. Týmy si mohou zabrat pozemek jiného týmu, ale tím se zvýší cena, kterou je nutné zaplatit. Nákup končí ve chvíli, kdy má každý tý vybrané jedno pole, tedy pole nejde změnit, nepřeplatí-li vás jiný tým. Pokud nemáte dostatek peněz na přehození jiného týmu, nelze to udělat. Políčka zvýrazněná světlou barvou týmů jsou pozemky vybrané minulý rok, šedě jsou zvýrazněny již vytěžená pozemky. Čísla v polích odpovídají kvalitě pozemků. 


## Upgrady, vážení, upgrady!
Upgrady lze koupit za peníze a poskytují výhody do herního kola.
- **Kůň** - rychlejší kůň zkracuje trvání prodeje ropy (doba cesty 10/7/5 dní)
- **Cisterna** - vůz s větší cisternou uveze najednou větší množství ropy (kapacita 15/20/30 barelů)
- **Silo** -  větší silo umožňuje skladovat více ropy na prodej (kapacita 150/200/250 barelů)
- **Těžební věž** - vylepšení těžební zvyšuje rychlost těžby ropy
- **Trubky** - lepší trubky snižují inteval dodávek ropy z věží do sila (interval 7/4/1 sekund)
- **Hledání** - zlepšuje vaše hledací schopnosti více úlohami v kole
## Herní kolo
Jedno herní kolo trvá 1 herní rok (ten má stejně dnů jako reálný). Dělí se na hledací a těžební část. Každá polovina týmu hraje jinou část, mezi koly se poloviny střídají v herních částech. *(tzn. jedna polovina nejdříve odehraje hledací část a v následujícím kole hraje těžební část s tím, co v minulém kole vyhledala)* 

### Hledací část
V hledací části polovina týmu hledá ropu na zakoupeném pozemku. Hledání probíhá řešením matematických úloh, vyhodnocení správnosti probíhá až na konci roku. Úloh dostanete tolik, jaká je kvalita zakoupeného pozemku **+2** za každý upgrade **hledání**. Počet správně vyřešených úloh (zásadně) ovlivňuje kolik v těžební části vytěžíte ropy.
### Těžební část
V těžební části polovina týmu těží a prodává ropu z ložisek, která našli v hledací části. Stisknutím tlačítka vyšlete vůz s nejvyšším dostupným množstvím ropy z vašeho sila. Vozu trvá nějaký čás cesta do města (do prodeje) a zpátky. Ropa se prodá ve chvíli příjezdu vozu do města.

Cena ropy se mění v čase pomocí matematické funkce. Prodej ropy dočasně sníží cenu ropy. Suma peněz za prodej ropy je určena ve chvíli, kdy dorazí vagon s ropou do města. Vůz s ropu jede do města v závislosti na úrovni vylepšení koně. Na konci roku se prodá všechna ropa na cestě za cenu z posledního dne a všechna ropa v silu propadne.
## Aukce
Hráči dostávají možnost získat v aukci jednu z parcel ve městě. Aukce probíhá formou holandské aukce, tedy cena se postupně snižuje do doby, než některý z týmů stiskne tlačítko. Cena za parcelu je cena na obrazovce ve chvíli stisknutí tlačítka.

# Konečné bodování
Body se počítají zvlášť za každý sloupec, řádek a hlavní a vedlejší diagonálu. Každé pole se tedy boduje dvakrát až třikrát. 

## Bodování segmentu

- 1 sousedící pole = 1 bod
- 2 sousedící pole = 4 body
- 3 sousedící pole = 9 bodů
- 4 sousedící pole = 16 bodů

Tímto způsobem se oboduje každý segment. Konečný počet bodů týmu je součet bodů ze všech bodovaných segmentů.
