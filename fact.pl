:- dynamic(inventory/2).
:- dynamic(inventoryList/2).
:- dynamic(isGameStart/1).
:- dynamic(playerLocation/2).
:- dynamic(playerStats/10).
:- dynamic(marketList/1).
:- dynamic(animal/3).
:- dynamic(animalAmount/2).
:- dynamic(animalID/1).
:- dynamic(animalList/1).
:- dynamic(date/4).
:- dynamic(isWrite/1).
:- dynamic(diary/5).
:- dynamic(diaryID/1).
:- dynamic(toolLevel/3).

/* Deklarasi Fakta */
/* diary(ID, Content, Day, Month, Year) */

/* date(Total, Day, Month, Year) */
date(1, 1, 1, 1).

/* diaryID */
diaryID(1).

/* season (Month, Season) */
season(1, 'Spring').
season(2, 'Summer').
season(3, 'Fall').
season(4, 'Winter').

% playerStats(Job, LvlPlayer, LvlFarm, ExpFarm, LvlFish, ExpFish, LvlRanch, ExpRanch, ExpTotal, Gold) sebagai status player

% job(ID, Name)
job(1, 'Fisherman').
job(2, 'Farmer').
job(3, 'Rancher').

% levelCap(Level, Cap)
levelCap(1, 300).
levelCap(2, 500).
levelCap(3, 1000).

/* inventoryCapacity(Capacity) sebagai kapasitas inventory */
inventoryCapacity(100).

/* item(Category, Name, Othername) */
item(1, 'Carrot', carrot).
item(1, 'Potato', potato).
item(1, 'Strawberry', strawberry).
item(2, 'Cow', cow).
item(2, 'Chicken', chicken).
item(2, 'Sheep', sheep).
item(3, 'Milk', milk).
item(3, 'Egg', egg).
item(3, 'Wool', wool).
item(4, 'Carrot Seeds', carrot).
item(4, 'Potato Seeds', potato).
item(4, 'Strawberry Seeds', strawberry).
%% item(5, 'Hoe', hoe).
%% item(5, 'Fishing Rod', rod).
%% item(5, 'Copper Hoe', copperhoe).
%% item(5, 'Iron Hoe', ironhoe).
%% item(5, 'Steel Hoe', steelhoe).
%% item(5, 'Advanced Fishing Rod', advancedrod).
%% item(5, 'Iron Fishing Rod', ironrod).
%% item(5, 'Steel Fishing Rod', steelrod).

crops(carrot, 1, 6).
crops(potato, 1, 6).
crops(strawberry, 1, 8).
crops(corn, 2, 6).
crops(sunflower, 2, 8).
crops(eggplant, 3, 6).
crops(grape, 3, 8).


/* inventory(Name, Amount) sebagai info dari inventory */
/* inventoryList(Category, Name) sebagai list inventory */

/* Category yaitu kategori item */
% 1 -> plants
% 2 -> animals
% 3 -> products
% 4 -> seeds
% 5 -> tools
% 6 -> misc

% buyPrice(Name, Price)
buyPrice('Carrot Seeds', 50).
buyPrice('Potato Seeds', 50).
buyPrice('Strawberry Seeds', 75).
buyPrice('Chicken', 500).
buyPrice('Cow', 1000).
buyPrice('Sheep', 1500).
buyPrice('Copper Hoe', 300).
buyPrice('Iron Hoe', 500).
buyPrice('Steel Hoe', 800).
buyPrice('Advanced Fishing Rod', 250).
buyPrice('Iron Fishing Rod', 500).
buyPrice('Steel Fishing Rod', 750).

buyPrice('Carrot', 150).
buyPrice('Potato', 150).
buyPrice('Strawberry', 175).
buyPrice('Egg', 100).
buyPrice('Milk', 300).
buyPrice('Wool', 500).
buyPrice('Copper Hoe', 300).
buyPrice('Iron Hoe', 500).
buyPrice('Steel Hoe', 1000).
buyPrice('Advanced Fishing Rod', 500).
buyPrice('Iron Fishing Rod', 1000).
buyPrice('Steel Fishing Rod', 1500).


toolLevel(1, 1, 'Hoe').
toolLevel(2, 1, 'Fishing Rod').


toolList(1, 1, 'Hoe').
toolList(1, 2, 'Copper Hoe').
toolList(1, 3, 'Iron Hoe').
toolList(1, 4, 'Steel Hoe').
toolList(2, 1, 'Fishing Rod').
toolList(2, 2, 'Advanced Fishing Rod').
toolList(2, 3, 'Iron Fishing Rod').
toolList(2, 4, 'Steel Fishing Rod').


%produceType(Type, SmallName, ProdName, ProdString)
produceType('Cow', milk, produce).
produceType('Chicken', egg, lay).
produceType('Sheep', wool, produce).

%production(Type, Production)
production('Cow', 4).
production('Chicken', 3).
production('Sheep', 4).

%animal(ID, Type, Time)
animal(1, 'Cow', 4).
animal(2, 'Cow', 4).
animal(3, 'Chicken', 3).
animal(4, 'Sheep', 4).

%animalList(Type)
animalList('Cow').
animalList('Chicken').
animalList('Sheep').

%farmLevelPrice(Lvl, Price)
farmLevelPrice(1, 0).
farmLevelPrice(2, 100).
farmLevelPrice(3, 300).
farmLevelPrice(4, 500).

%ranchLevelPrice(Lvl, Price)
ranchLevelPrice(1, 0).
ranchLevelPrice(2, 100).
ranchLevelPrice(3, 300).
ranchLevelPrice(4, 500).

%animalID(ID)
animalID(1).

%koordinat benda di Map(X,Y)
mapSize(15,15).
playerKoord(10,9).
houseKoord(10,9).
ranchKoord(5,9).
questKoord(3,5).
marketplaceKoord(3,3).
