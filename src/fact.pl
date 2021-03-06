/* Deklarasi Fakta Dynamic */
:- dynamic(inventory/2).
:- dynamic(inventoryList/2).
:- dynamic(isGameStart/1).
:- dynamic(playerLocation/2).
:- dynamic(playerStats/10).
:- dynamic(marketList/1).
:- dynamic(animal/3).
:- dynamic(animalID/1).
:- dynamic(animalList/1).
:- dynamic(date/3).
:- dynamic(diary/4).
:- dynamic(diaryID/1).
:- dynamic(cropID/1).
:- dynamic(patchDug/5).
:- dynamic(equipment/2).
:- dynamic(upgradeList/1).
:- dynamic(cropList/3).
:- dynamic(playerKoord/2).
:- dynamic(production/2).
:- dynamic(crops/3).

/* Deklarasi Fakta */

/* diary(ID, Content, Day, Month, Year) */

/* patchDug(X, Y, IsPlant, CropName, Time) */

/* cropList(ID, X, Y) */

/* animalID(ID) */
animalID(1).

/* cropID(ID) */
cropID(1).

/* diaryID(ID) */
diaryID(1).

/* date(Total, Day, Month) */
date(1, 1, 1).

/* season(Month, Season) */
season(1, 'Spring').
season(2, 'Summer').
season(3, 'Fall').
season(4, 'Winter').
season(5, 'Debt').

/* playerStats(Job, LvlPlayer, LvlFarm, ExpFarm, LvlFish, ExpFish, LvlRanch, ExpRanch, ExpTotal, Gold) */

/* job(ID, Name) */
job(1, 'Fisherman').
job(2, 'Farmer').
job(3, 'Rancher').

/* playerLvlCap(Level, Cap) */
playerLvlCap(1, 300).
playerLvlCap(2, 500).
playerLvlCap(3, 1000).
playerLvlCap(4, 0).

/* professionLvlCap(Lvl, Cap) */
professionLvlCap(1, 100).
professionLvlCap(2, 380).
professionLvlCap(3, 770).

/* fishLevelPrice(Lvl, Price) */
fishLevelPrice(1, 0).
fishLevelPrice(2, 50).
fishLevelPrice(3, 100).
fishLevelPrice(4, 150).

/* farmLevelPrice(Lvl, Price) */
farmLevelPrice(1, 0).
farmLevelPrice(2, 50).
farmLevelPrice(3, 100).
farmLevelPrice(4, 150).

/* ranchLevelPrice(Lvl, Price) */
ranchLevelPrice(1, 0).
ranchLevelPrice(2, 50).
ranchLevelPrice(3, 100).
ranchLevelPrice(4, 150).

/* inventoryCapacity (Capacity) sebagai kapasitas inventory */
inventoryCapacity(100).

/* item(Category, Name, Othername) */
item(1, 'Carrot', carrot).
item(1, 'Potato', potato).
item(1, 'Strawberry', strawberry).
item(1, 'Corn', corn).
item(1, 'Melon', melon).
item(1, 'Sunflower', sunflower).
item(1, 'Grape', grape).
item(1, 'Eggplant', eggplant).
item(1, 'Pumpkin', pumpkin).
item(2, 'Cow', cow).
item(2, 'Chicken', chicken).
item(2, 'Sheep', sheep).
item(3, 'Milk', milk).
item(3, 'Egg', egg).
item(3, 'Wool', wool).
item(4, 'Carrot Seeds', carrot).
item(4, 'Potato Seeds', potato).
item(4, 'Strawberry Seeds', strawberry).
item(4, 'Corn Seeds', corn).
item(4, 'Melon Seeds', melon).
item(4, 'Sunflower Seeds', sunflower).
item(4, 'Eggplant Seeds', eggplant).
item(4, 'Pumpkin Seeds', pumpkin).
item(4, 'Grape Starter', grape).
item(5, 'Hoe', hoe).
item(5, 'Steel Hoe', hoe).
item(5, 'Gold Hoe', hoe).
item(5, 'Fishing Rod', rod).
item(5, 'Steel Fishing Rod', rod).
item(5, 'Gold Fishing Rod', rod).
item(6, 'Small Fish', smallfish).
item(6, 'Medium Fish', mediumfish).
item(6, 'Big Fish', bigfish).

/* Item Category */
% 1 -> crops
% 2 -> animals
% 3 -> products
% 4 -> seeds
% 5 -> tools
% 6 -> fish

/* equip(ToolType, Name) */

/* toolList(ToolType, ToolLvl, ToolName) */
toolList(hoe, 1, 'Hoe').
toolList(hoe, 2, 'Steel Hoe').
toolList(hoe, 3, 'Gold Hoe').

toolList(rod, 1, 'Fishing Rod').
toolList(rod, 2, 'Steel Fishing Rod').
toolList(rod, 3, 'Gold Fishing Rod').

/* crops(CropName, Month, HarvestTime) */
crops(carrot, 1, 4).
crops(potato, 1, 6).
crops(strawberry, 1, 8).
crops(corn, 2, 6).
crops(melon, 2, 12).
crops(sunflower, 2, 8).
crops(eggplant, 3, 6).
crops(pumpkin, 3, 13).
crops(grape, 3, 8).

/* inventory(Name, Amount) */

/* inventoryList(Category, Name) */

/* price(Name, Price) */
price('Carrot Seeds', 20).
price('Potato Seeds', 50).
price('Strawberry Seeds', 100).
price('Corn Seeds', 100).
price('Melon Seeds', 80).
price('Sunflower Seeds', 100).
price('Eggplant Seeds', 20).
price('Pumpkin Seeds', 100).
price('Grape Starter', 60).
price('Carrot', 70).
price('Potato', 150).
price('Strawberry', 240).
price('Corn', 100).
price('Melon', 80).
price('Sunflower', 100).
price('Eggplant', 120).
price('Pumpkin', 640).
price('Grape', 200).
price('Chicken', 500).
price('Cow', 1000).
price('Sheep', 1500).
price('Gold Hoe', 1000).
price('Steel Hoe', 800).
price('Gold Fishing Rod', 1200).
price('Steel Fishing Rod', 900).
price('Small Fish', 10).
price('Medium Fish', 30).
price('Big Fish', 75).
price('Egg', 100).
price('Milk', 200).
price('Wool', 300).
price('Hoe', 200).
price('Fishing Rod', 200).
price('Copper Hoe', 300).
price('Iron Hoe', 500).
price('Steel Hoe', 1000).
price('Advanced Fishing Rod', 500).
price('Iron Fishing Rod', 1000).
price('Steel Fishing Rod', 1500).

/* produceType(AmimalType, ProductName, ProductString) */
produceType('Cow', milk, produce).
produceType('Chicken', egg, lay).
produceType('Sheep', wool, produce).

/* production(AnimalType, ProductionTime) */
production('Cow', 4).
production('Chicken', 3).
production('Sheep', 4).

/* animal(ID, AnimalType, Time) */

/* animalList(AnimalType) */

/* koordinat benda di Map(X,Y) */
mapSize(15,15).
playerKoord(10,9).
houseKoord(10,9).
ranchKoord(5,9).
questKoord(3,5).
marketplaceKoord(3,3).
