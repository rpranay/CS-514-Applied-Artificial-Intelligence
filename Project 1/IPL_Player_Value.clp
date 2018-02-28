;Defining the templates 
(deftemplate player 
    (slot playerName) 
    (slot playerAge (type INTEGER)) 
    (slot playerType (allowed-values batsman allrounder bowler)) 
    (slot isOverseasPlayer (allowed-values yes no)) 
    (slot matches (type INTEGER))
)

(deftemplate batsman 
    (slot batRuns (type INTEGER)) 
    (slot batAverage (type FLOAT)) 
    (slot batHundreds (type INTEGER)) 
    (slot batFifties (type INTEGER)) 
    (slot batStrikeRate (type FLOAT))
)

(deftemplate allrounder 
    (slot allRuns (type INTEGER)) 
    (slot allAverage (type FLOAT)) 
    (slot allHundreds (type INTEGER)) 
    (slot allFifties (type INTEGER)) 
    (slot allStrikeRate (type FLOAT)) 
    (slot allWickets (type INTEGER)) 
)

(deftemplate bowler 
    (slot bowlWickets (type INTEGER))  
    (slot bowlEconomy (type FLOAT))
)

;Defining the global variables
(defglobal 
    ?*name* = nil
    ?*age* = nil
    ?*type* = nil
    ?*overseasPlayer* = nil
    ?*matches* = nil
    ?*runs* = nil
    ?*average* = nil
    ?*hundreds* = nil
    ?*fifties* = nil
    ?*strikeRate* = nil
    ?*wickets* = nil
    ?*economy* = nil
    ?*validPlayer* = 0
    )

;Rule for taking the input from the command line interface
(defrule takeInput
    =>
    (printout t "Please enter player's name: " crlf)
    (bind ?*name* (read t))
    (printout t "Please enter player's age: " crlf)
    (bind ?*age* (read t))
    (printout t "Please enter type of player(batsman or allrounder or bowler): " crlf)
    (bind ?*type* (read t))
    (printout t "Overseas player(yes or no): " crlf)
    (bind ?*overseasPlayer* (read t))
	(printout t "Matches played: " crlf)
    (bind ?*matches* (read t))
    
   	(assert (player (playerName ?*name*)(playerAge ?*age*)(playerType ?*type*)(isOverseasPlayer ?*overseasPlayer*) (matches ?*matches*)))
	
    (if (= (str-compare ?*type* "batsman") 0)  then
    	(takeBatsmanInput)
    )
    (if (= (str-compare ?*type* "allrounder") 0)  then
        (takeAllrounderInput)
    )
    (if(= (str-compare ?*type* "bowler") 0)  then
        (takeBowlerInput) 
     )
)

(deffunction takeBatsmanInput()
    (printout t "Runs scored: " crlf)
    (bind ?*runs* (read t))
	(printout t "Batting average: " crlf)
    (bind ?*average* (read t))
	(printout t "No. of 100's scored: " crlf)
    (bind ?*hundreds* (read t))
	(printout t "No. of 50's scored: " crlf)
    (bind ?*fifties* (read t))
	(printout t "Batting strikerate: " crlf)
    (bind ?*strikeRate* (read t))
    (assert (batsman (batRuns ?*runs*) (batAverage ?*average*) (batHundreds ?*hundreds*) (batFifties ?*fifties*) (batStrikeRate ?*strikeRate*)))
    (validateBatsman ?*age* ?*matches* ?*runs* ?*average* ?*hundreds* ?*fifties* ?*strikeRate*)
)

(deffunction takeAllrounderInput()
    (printout t "Runs scored: " crlf)
    (bind ?*runs* (read t))
	(printout t "Batting average: " crlf)
    (bind ?*average* (read t))
	(printout t "No. of 100's scored: " crlf)
    (bind ?*hundreds* (read t))
	(printout t "No. of 50's scored: " crlf)
    (bind ?*fifties* (read t))
	(printout t "Batting strikerate: " crlf)
    (bind ?*strikeRate* (read t))
	(printout t "Wickets taken: " crlf)
    (bind ?*wickets* (read t))
    (assert (allrounder (allRuns ?*runs*) (allAverage ?*average*) (allHundreds ?*hundreds*) (allFifties ?*fifties*) (allStrikeRate ?*strikeRate*) (allWickets ?*wickets*)))
    (validateAllrounder ?*age* ?*matches* ?*runs* ?*average* ?*hundreds* ?*fifties* ?*strikeRate* ?*wickets*)
)

(deffunction takeBowlerInput()
    (printout t "Wickets taken: " crlf)
    (bind ?*wickets* (read t))
	(printout t "Bowling economy rate: " crlf)
    (bind ?*economy* (read t))
    (assert (bowler (bowlWickets ?*wickets*) (bowlEconomy ?*economy*)))
    (validateBowler ?*age* ?*matches* ?*wickets* ?*economy*)
)

;Functions that are helpful for computations
(deffunction validateBatsman(?age ?matches ?runs ?average ?hundreds ?fifties ?strikeRate)
    (if (and (>= ?age 16) (<= ?age 40) (> ?matches 0) (< ?matches 400) (>= ?runs 0) (<= ?runs 12000) (>= ?average 0) (<= ?average 100) (>= ?hundreds 0) (<= ?hundreds 20) (>= ?fifties 0) (<= ?fifties 70) (>= ?strikeRate 0) (<= ?strikeRate 400)) then
    	(bind ?*validPlayer* 1)    
    else
        (bind ?*validPlayer* 0)
        (printout t "Invalid input" crlf)
    )
)

(deffunction validateAllrounder(?age ?matches ?runs ?average ?hundreds ?fifties ?strikeRate ?wickets)
    (if (and (>= ?age 16) (<= ?age 40) (> ?matches 0) (< ?matches 400) (>= ?runs 0) (<= ?runs 12000) (>= ?average 0) (<= ?average 100) (>= ?hundreds 0) (<= ?hundreds 20) (>= ?fifties 0) (<= ?fifties 70) (>= ?strikeRate 0) (<= ?strikeRate 400) (>= ?wickets 0) (<= ?wickets 450)) then
    	(bind ?*validPlayer* 1)    
    else
        (bind ?*validPlayer* 0)
        (printout t "Invalid input" crlf)
    )
)

(deffunction validateBowler(?age ?matches ?wickets ?economy)
    (if (and (>= ?age 16) (<= ?age 40) (> ?matches 0) (< ?matches 400) (>= ?wickets 0) (<= ?wickets 450) (>= ?economy 0) (<= ?economy 12)) then
    	(bind ?*validPlayer* 1)    
    else
        (bind ?*validPlayer* 0)
        (printout t "Invalid input" crlf)
    )
)


(deffunction batsmanRatioCalc(?t1 ?t2)
    (bind ?runsRatio (/ ?*runs* (* ?*matches* 25)))
        (if (> ?runsRatio 1)then 
            (bind ?runsRatio 1))
        (bind ?avgRatio (/ ?*average* 30))
        (if (> ?avgRatio 1)then 
            (bind ?avgRatio 1))
        (bind ?strikerateRatio (/ ?*strikeRate* 200))
        (if (> ?strikerateRatio 1)then 
            (bind ?strikerateRatio 1))
        (bind ?fiftyRatio (/ ?*fifties* ?t1))
        (if (> ?fiftyRatio 1)then 
            (bind ?fiftyRatio 1))
        (bind ?hundredRatio (/ ?*hundreds* ?t2))
        (if (> ?hundredRatio 1)then 
            (bind ?hundredRatio 1))
        (bind ?ratio (+(* ?runsRatio 0.3) (* ?avgRatio 0.3) (* ?strikerateRatio 0.30) (* ?fiftyRatio 0.05) (* ?hundredRatio 0.05)))
        (if (= (str-compare ?*overseasPlayer* "yes") 0) then
            (bind ?ratio (* ?ratio 0.8))
            )
        (return ?ratio)
)


(deffunction allrounderRatioCalc(?t1)
    (bind ?runsRatio (/ ?*runs* (* ?*matches* 25)))
        (if (> ?runsRatio 1)then 
            (bind ?runsRatio 1))
        (bind ?avgRatio (/ ?*average* 30))
        (if (> ?avgRatio 1)then 
            (bind ?avgRatio 1))
        (bind ?strikerateRatio (/ ?*strikeRate* 200))
        (if (> ?strikerateRatio 1)then 
            (bind ?strikerateRatio 1))
        (bind ?fiftyRatio (/ ?*fifties* ?t1))
        (if (> ?fiftyRatio 1)then 
            (bind ?fiftyRatio 1))
        (bind ?wicketsRatio (/ ?*wickets* ?*matches*))
        (if (> ?wicketsRatio 1)then 
            (bind ?wicketsRatio 1))
        (bind ?ratio (+(* ?runsRatio 0.25) (* ?avgRatio 0.25) (* ?strikerateRatio 0.2) (* ?fiftyRatio 0.05) (* ?wicketsRatio 0.25)))
        (if (= (str-compare ?*overseasPlayer* "yes") 0) then
            (bind ?ratio (* ?ratio 0.8)))
        (return ?ratio)
    
)

(deffunction bowlerRatioCalc()
    (bind ?economyRatio (/ 4.8 ?*economy*))
    (if (> ?economyRatio 1)then 
        (bind ?economyRatio 1))
    (bind ?wicketsRatio (/ ?*wickets* ?*matches*))
    (if (> ?wicketsRatio 1)then 
        (bind ?wicketsRatio 1))
    (bind ?ratio (+ (* ?economyRatio 0.5) (* ?wicketsRatio 0.5)))
    (if (= (str-compare ?*overseasPlayer* "yes") 0) then
        (bind ?ratio (* ?ratio 0.8)))
    (return ?ratio)
)

(defrule BatsmanLevelOne
    (player{matches > 0}) (player{matches <= 20}) 
 =>
    (if ( and (= (str-compare ?*type* "batsman") 0) (= ?*validPlayer* 1) ) then
    	(bind ?ratio (batsmanRatioCalc 10 2))
        (bind ?ratio (* ?ratio 120))
        (bind ?ratio (integer ?ratio))
        (bind ?usd (* ?ratio 1558))
        (bind ?usd (integer ?usd))
        (printout t "Player's value in IPL Auction : INR " ?ratio " Lakhs or USD " ?usd crlf)
    )    
)

(defrule BatsmanLevelTwo
    (player{matches > 20}) (player{matches <= 50}) 
 =>
    (if ( and (= (str-compare ?*type* "batsman") 0) (= ?*validPlayer* 1) ) then
    	(bind ?ratio (batsmanRatioCalc 20 4))
        (bind ?ratio (* ?ratio 240))
        (bind ?ratio (integer ?ratio))
        (bind ?usd (* ?ratio 1558))
        (bind ?usd (integer ?usd))
        (printout t "Player's value in IPL Auction : INR " ?ratio " Lakhs or USD " ?usd crlf)
    )    
)

(defrule BatsmanLevelThree
    (player{matches > 50}) (player{matches <= 80}) 
 =>
    (if ( and (= (str-compare ?*type* "batsman") 0) (= ?*validPlayer* 1) ) then
    	(bind ?ratio (batsmanRatioCalc 35 5))
        (bind ?ratio (* ?ratio 450))
        (bind ?ratio (integer ?ratio))
        (bind ?usd (* ?ratio 1558))
        (bind ?usd (integer ?usd))
        (printout t "Player's value in IPL Auction : INR " ?ratio " Lakhs or USD " ?usd crlf)
    )    
)

(defrule BatsmanLevelFour
    (player{matches > 80}) (player{matches <= 110}) 
 =>
    (if ( and (= (str-compare ?*type* "batsman") 0) (= ?*validPlayer* 1) ) then
    	(bind ?ratio (batsmanRatioCalc 55 6))
        (bind ?ratio (* ?ratio 900))
        (bind ?ratio (integer ?ratio))
        (bind ?usd (* ?ratio 1558))
        (bind ?usd (integer ?usd))
        (printout t "Player's value in IPL Auction : INR " ?ratio " Lakhs or USD " ?usd crlf)
    )    
)

(defrule BatsmanLevelFive
    (player{matches > 110}) (player{matches <= 160}) 
 =>
    (if ( and (= (str-compare ?*type* "batsman") 0) (= ?*validPlayer* 1) ) then
    	(bind ?ratio (batsmanRatioCalc 80 10))
        (bind ?ratio (* ?ratio 1200))
        (bind ?ratio (integer ?ratio))
        (bind ?usd (* ?ratio 1558))
        (bind ?usd (integer ?usd))
        (printout t "Player's value in IPL Auction : INR " ?ratio " Lakhs or USD " ?usd crlf)
    )    
)

(defrule BatsmanLevelSix
    (player{matches > 160}) (player{matches <= 350}) 
 =>
    (if ( and (= (str-compare ?*type* "batsman") 0) (= ?*validPlayer* 1) ) then
    	(bind ?ratio (batsmanRatioCalc 100 15))
        (bind ?ratio (* ?ratio 1800))
        (bind ?ratio (integer ?ratio))
        (bind ?usd (* ?ratio 1558))
        (bind ?usd (integer ?usd))
        (printout t "Player's value in IPL Auction : INR " ?ratio " Lakhs or USD " ?usd crlf)
    )    
)

(defrule AllrounderLevelOne
    (player{matches > 0}) (player{matches <= 20}) 
 =>
    (if ( and (= (str-compare ?*type* "allrounder") 0) (= ?*validPlayer* 1) ) then
    	(bind ?ratio (allrounderRatioCalc 5))
        (bind ?ratio (* ?ratio 120))
        (bind ?ratio (integer ?ratio))
        (bind ?usd (* ?ratio 1558))
        (bind ?usd (integer ?usd))
        (printout t "Player's value in IPL Auction : INR " ?ratio " Lakhs or USD " ?usd crlf)
    )    
)

(defrule AllrounderLevelTwo
    (player{matches > 20}) (player{matches <= 50}) 
 =>
    (if ( and (= (str-compare ?*type* "allrounder") 0) (= ?*validPlayer* 1) ) then
    	(bind ?ratio (allrounderRatioCalc 10))
        (bind ?ratio (* ?ratio 240))
        (bind ?ratio (integer ?ratio))
        (bind ?usd (* ?ratio 1558))
        (bind ?usd (integer ?usd))
        (printout t "Player's value in IPL Auction : INR " ?ratio " Lakhs or USD " ?usd crlf)
    )    
)

(defrule AllrounderLevelThree
    (player{matches > 50}) (player{matches <= 80}) 
 =>
    (if ( and (= (str-compare ?*type* "allrounder") 0) (= ?*validPlayer* 1) ) then
    	(bind ?ratio (allrounderRatioCalc 20))
        (bind ?ratio (* ?ratio 450))
        (bind ?ratio (integer ?ratio))
        (bind ?usd (* ?ratio 1558))
        (bind ?usd (integer ?usd))
        (printout t "Player's value in IPL Auction : INR " ?ratio " Lakhs or USD " ?usd crlf)
    )    
)

(defrule AllrounderLevelFour
    (player{matches > 80}) (player{matches <= 110}) 
 =>
    (if ( and (= (str-compare ?*type* "allrounder") 0) (= ?*validPlayer* 1) ) then
    	(bind ?ratio (allrounderRatioCalc 30))
        (bind ?ratio (* ?ratio 900))
        (bind ?ratio (integer ?ratio))
        (bind ?usd (* ?ratio 1558))
        (bind ?usd (integer ?usd))
        (printout t "Player's value in IPL Auction : INR " ?ratio " Lakhs or USD " ?usd crlf)
    )    
)

(defrule AllrounderLevelFive
    (player{matches > 110}) (player{matches <= 160}) 
 =>
    (if ( and (= (str-compare ?*type* "allrounder") 0) (= ?*validPlayer* 1) ) then
    	(bind ?ratio (allrounderRatioCalc 40))
        (bind ?ratio (* ?ratio 1200))
        (bind ?ratio (integer ?ratio))
        (bind ?usd (* ?ratio 1558))
        (bind ?usd (integer ?usd))
        (printout t "Player's value in IPL Auction : INR " ?ratio " Lakhs or USD " ?usd crlf)
    )    
)

(defrule AllrounderLevelSix
    (player{matches > 160}) (player{matches <= 350}) 
 =>
    (if ( and (= (str-compare ?*type* "allrounder") 0) (= ?*validPlayer* 1) ) then
    	(bind ?ratio (allrounderRatioCalc 50))
        (bind ?ratio (* ?ratio 1800))
        (bind ?ratio (integer ?ratio))
        (bind ?usd (* ?ratio 1558))
        (bind ?usd (integer ?usd))
        (printout t "Player's value in IPL Auction : INR " ?ratio " Lakhs or USD " ?usd crlf)
    )    
)

(defrule BowlerLevelOne
    (player{matches > 0}) (player{matches <= 20})
 =>
    (if ( and (= (str-compare ?*type* "bowler") 0) (= ?*validPlayer* 1) ) then
    	(bind ?ratio (bowlerRatioCalc))
        (bind ?ratio (* ?ratio 120))
        (bind ?ratio (integer ?ratio))
        (bind ?usd (* ?ratio 1558))
        (bind ?usd (integer ?usd))
        (printout t "Player's value in IPL Auction : INR " ?ratio " Lakhs or USD " ?usd crlf)
    )    
)

(defrule BowlerLevelTwo
    (player{matches > 20}) (player{matches <= 50})
 =>
    (if ( and (= (str-compare ?*type* "bowler") 0) (= ?*validPlayer* 1) ) then
    	(bind ?ratio (bowlerRatioCalc))
        (bind ?ratio (* ?ratio 240))
        (bind ?ratio (integer ?ratio))
        (bind ?usd (* ?ratio 1558))
        (bind ?usd (integer ?usd))
        (printout t "Player's value in IPL Auction : INR " ?ratio " Lakhs or USD " ?usd crlf)
    )    
)

(defrule BowlerLevelThree
    (player{matches > 50}) (player{matches <= 80})
 =>
    (if ( and (= (str-compare ?*type* "bowler") 0) (= ?*validPlayer* 1) ) then
    	(bind ?ratio (bowlerRatioCalc))
        (bind ?ratio (* ?ratio 450))
        (bind ?ratio (integer ?ratio))
        (bind ?usd (* ?ratio 1558))
        (bind ?usd (integer ?usd))
        (printout t "Player's value in IPL Auction : INR " ?ratio " Lakhs or USD " ?usd crlf)
    )    
)


(defrule BowlerLevelFour
    (player{matches > 80}) (player{matches <= 110})
 =>
    (if ( and (= (str-compare ?*type* "bowler") 0) (= ?*validPlayer* 1) ) then
    	(bind ?ratio (bowlerRatioCalc))
        (bind ?ratio (* ?ratio 900))
        (bind ?ratio (integer ?ratio))
        (bind ?usd (* ?ratio 1558))
        (bind ?usd (integer ?usd))
        (printout t "Player's value in IPL Auction : INR " ?ratio " Lakhs or USD " ?usd crlf)
    )    
)

(defrule BowlerLevelFive
    (player{matches > 110}) (player{matches <= 160})
 =>
    (if ( and (= (str-compare ?*type* "bowler") 0) (= ?*validPlayer* 1) ) then
    	(bind ?ratio (bowlerRatioCalc))
        (bind ?ratio (* ?ratio 1200))
        (bind ?ratio (integer ?ratio))
        (bind ?usd (* ?ratio 1558))
        (bind ?usd (integer ?usd))
        (printout t "Player's value in IPL Auction : INR " ?ratio " Lakhs or USD " ?usd crlf)
    )    
)

(defrule BowlerLevelSix
    (player{matches > 160}) (player{matches <= 350})
 =>
    (if ( and (= (str-compare ?*type* "bowler") 0) (= ?*validPlayer* 1) ) then
    	(bind ?ratio (bowlerRatioCalc))
        (bind ?ratio (* ?ratio 1800))
        (bind ?ratio (integer ?ratio))
        (bind ?usd (* ?ratio 1558))
        (bind ?usd (integer ?usd))
        (printout t "Player's value in IPL Auction : INR " ?ratio " Lakhs or USD " ?usd crlf)
    )    
)
    
(reset)
(facts)
(run)