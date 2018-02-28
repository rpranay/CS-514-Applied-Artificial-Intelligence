CS 514 – Applied Artificial Intelligence Project 1 
 
IPL Player Price Predictor 
  
Abstract: The Indian Premier League (IPL) is a professional Twenty20 cricket league in India contested during April and May of every year by 8 teams representing Indian cities. Every year an auction is held prior to the start of tournament were all the 8 IPL team owners bid for the players. IPL Player Predictor is a rule based expert system built on JESS that is designed to predict a player’s price in IPL auction. The system based on the player’s various statistics like matches, age, runs scored, batting average, strike rate, wickets and economy predicts the cost of the player. 

Rules: The 18 rules are divided into 3 sets of 6 rules each based on the player’s specialties(Batsman, Allrounder or Bowler). In each specialty the player is again rated among 6 levels with increase in level implies in a better skilled player. A price range is set for each level meaning a player belonging to a level determines his price for the auction.

Instructions: 
Copy the file “IPL_PLAYER_VALUE.clp” into the bin folder of the JESS directory. 
Run the command “(batch IPL_PLAYER_VALUE.clp)” inside the JESS  
Various statistics of the player are asked as input 
