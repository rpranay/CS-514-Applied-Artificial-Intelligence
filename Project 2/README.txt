CS 514 – Applied Artificial Intelligence Project 2 
 
IPL Player Evaluator 
  
Abstract: The Indian Premier League (IPL) is a professional Twenty20 cricket league in India contested during April and May of every year by 8 teams representing Indian cities. Every year an auction is held prior to the start of tournament were all the 8 IPL team owners bid for the players. IPL Player Evaluator is a rule based expert system built on JESS that is designed to evaluate a player’s based on his statistics. The system based on the player’s various statistics like matches, age, runs scored, batting average, strike rate, wickets and economy evaluates whether player is fit for a team. Key statistics like average, strike rate, wickets and economy are used as fuzzy variables which are classified into different categories. These form the base for the evaluation report of the player. 

Rules: 
There are 20 Rules in the application • (1) The important statistics are declared as fuzzy variables with respective parameters   • (2) This rule prints all the given user input. • (3) Validates the type of player, it must be either batsman or bowler or allrounder • (4) Validates the age of the player • (5, 6, 7) These 3 rules are called based on the player’s average and they provide corresponding feedback • (8, 9, 10) These 3 rules are called based on the player’s strike rate and they provide corresponding feedback • (11, 12, 13) These 3 rules are called based on the player’s wickets and they provide corresponding feedback • (14, 15, 16) These 3 rules are called based on the player’s economy rate and they provide corresponding feedback • (17) This rule calculates the overall ability of the player type - batsman • (18) This rule calculates the overall ability of the player type - allrounder • (19) This rule calculates the overall ability of the player type - bowler • (20) This rule is used to provide the input to the program 
 
Instructions: 
1. Create a new java project in eclipse 
2. Create a new clp file 
3. Copy the contents of “IPL_PLAYER_EVALUATOR.clp” into the newly created file 
4. Include the “fuzzyJ-2.0.jar” in the library 
5. In the edit configuration change the jess main class to “nrc.fuzzy.jess.FuzzyMain” 
6. Run the file in eclipse
