(import nrc.fuzzy.*)

(import nrc.fuzz.jess.*)

(load-package nrc.fuzzy.jess.FuzzyFunctions)


(deftemplate player
    (slot playerName)
    (slot playerAge (type INTEGER))
    (slot playerType)
    (slot matches (type INTEGER))
    (slot Average (type FLOAT))
    (slot StrikeRate (type FLOAT))
    (slot Wickets (type INTEGER))
    (slot Economy (type FLOAT))
)


(deftemplate avg_data
    "Auto-generated"
    (declare (ordered TRUE)))

(deftemplate strike_rate_data
    "Auto-generated"
    (declare (ordered TRUE)))

(deftemplate wickets_data
    "Auto-generated"
    (declare (ordered TRUE)))

(deftemplate economy_data
    "Auto-generated"
    (declare (ordered TRUE)))

(defglobal
    ;Overall rating for batsmen or bowler
    ?*rating* = 1
    ;flag for validation
    ?*invalid* = 0
    ;overall rating for allrounder
    ?*allroundRating* = 1)

(defglobal ?*avgVar* = (new FuzzyVariable "average" 0.0 100.0))

(defglobal ?*strikeRateVar* = (new FuzzyVariable "strikeRate" 0.0 300.0))

(defglobal ?*wicketsVar* = (new FuzzyVariable "wickets" 0.0 4.0))

(defglobal ?*economyVar* = (new FuzzyVariable "economy" 0.0 20.0))

(call nrc.fuzzy.FuzzyValue setMatchThreshold 0.1)

; Rule 1
; Setting up Global variables
(defrule MAIN::init-FuzzyVariables
    (declare (salience 100))
    ?player <- (player (playerName ?name))
    =>
    (?*avgVar* addTerm "low" (new ZFuzzySet 0.0 18.0))
    (?*avgVar* addTerm "medium" (new TrapezoidFuzzySet 13.8 18.0 27.0 35.0))
    (?*avgVar* addTerm "High" (new SFuzzySet 27.0 60.0))

    (?*strikeRateVar* addTerm "low" (new ZFuzzySet 35.0 100.0))
    (?*strikeRateVar* addTerm "medium" (new TrapezoidFuzzySet 85.0 100.0 130.0 150.0))
    (?*strikeRateVar* addTerm "high" (new SFuzzySet 130.0 200.0))

    (?*wicketsVar* addTerm "low" (new ZFuzzySet 0.2 1.0))
    (?*wicketsVar* addTerm "medium" (new TrapezoidFuzzySet 0.8 1.0 1.6 1.8))
    (?*wicketsVar* addTerm "high" (new SFuzzySet 1.6 2.2))

    (?*economyVar* addTerm "good" (new ZFuzzySet 3 7.5))
    (?*economyVar* addTerm "moderate" (new TrapezoidFuzzySet 6.5 7.0 9.5 10.0))
    (?*economyVar* addTerm "bad" (new SFuzzySet 8.5 15.0))

    (assert (avg_data (new FuzzyValue ?*avgVar* (new SingletonFuzzySet ?player.Average))))
    (assert (strike_rate_data (new FuzzyValue ?*strikeRateVar* (new SingletonFuzzySet ?player.StrikeRate))))
    (assert (wickets_data (new FuzzyValue ?*wicketsVar* (new SingletonFuzzySet (/ ?player.Wickets ?player.matches)))))
    (assert (economy_data (new FuzzyValue ?*economyVar* (new SingletonFuzzySet ?player.Economy))))
    )

; Rule 2
; printing asserted data
(defrule initial
    (declare (salience 99))
    ?player <- (player (playerName ?name))
    =>
    (printout t "********************Welcome to IPL Player Evaluator********************" crlf)
    (printout t "The player "?player.playerName " is being evaluated" crlf)
    (printout t "============" crlf)
    (printout t " STATISTICS" crlf)
    (printout t "============" crlf)
    (printout t "Age: " ?player.playerAge crlf)
    (printout t "Type: " ?player.playerType crlf)
    (printout t "Matches: " ?player.matches crlf)
    (printout t "Average: " ?player.Average crlf)
    (printout t "Strike Rate: " ?player.StrikeRate crlf)
    (printout t "Wickets: " ?player.Wickets  crlf)
    (printout t "Economy: " ?player.Economy crlf)
	)

; Rule 3
; validating type of player
(defrule checkType
    (declare (salience 98))
    ?player <- (player (playerName ?name))
    =>
    (if (and (<> ?player.playerType batsman) (<> ?player.playerType bowler) (<> ?player.playerType allrounder)) then
        (printout t "Invalid player type, Try again" crlf)
        (bind ?*invalid* 1)
        )
    )

; Rule 4
; validating age of player
(defrule checkAge
    (declare (salience 97))
    ?player <- (player (playerName ?name))
    =>
    (if (or (< ?player.playerAge 15) (> ?player.playerAge 40)) then
        (printout t "Invalid age(must be between 15 and 40), Try again" crlf)
        (bind ?*invalid* 1)
        )
    )

; Rule 5
; low average
(defrule average_low
    (declare (salience 96))
    (avg_data ?player&:(fuzzy-match ?player "low")) (player{playerType != "bowler"})
     =>
    (if (eq ?*invalid* 0) then
    	(printout t "The player's scoring rate is very low, has to work on it." crlf)
    	(bind ?*rating* (* ?*rating* 1))
    	(bind ?*allroundRating* (* ?*allroundRating* 1))
        )
)

; Rule 6
; medium average
(defrule average_medium
    (declare (salience 95))
    (avg_data ?player&:(fuzzy-match ?player "medium")) (player{playerType != "bowler"})
     =>
    (if (eq ?*invalid* 0) then
    	(printout t "The player has a good average but there can be improvement." crlf)
    (bind ?*rating* (* ?*rating* 2))
    	(bind ?*allroundRating* (* ?*allroundRating* 2))
    )
)

; Rule 7
;high average
(defrule average_high
    (declare (salience 94))
    (avg_data ?player&:(fuzzy-match ?player "high"))   (player{playerType != "bowler"})
     =>
    (if (eq ?*invalid* 0) then
    	(printout t "The player has an impressive average." crlf)
    (bind ?*rating* (* ?*rating* 3))
    	(bind ?*allroundRating* (* ?*allroundRating* 3))
    ))

; Rule 8
; low strike rate
(defrule strikeRate_low
    (declare (salience 94))
    (strike_rate_data ?player&:(fuzzy-match ?player "low")) (player{playerType != "bowler"})
     =>
    (if (eq ?*invalid* 0) then
    	(printout t "Very low strikerate, Needs to score more faster." crlf)
		(bind ?*rating* (* ?*rating* 1))
    ))

; Rule 9
; medium strike rate
(defrule strikeRate_medium
    (declare (salience 94))
    (strike_rate_data ?player&:(fuzzy-match ?player "medium")) (player{playerType != "bowler"})
     =>
    (if (eq ?*invalid* 0) then
    	(printout t "Good strikerate will be handy for T20 cricket." crlf)
    (bind ?*rating* (* ?*rating* 2))
    ))

; Rule 10
; high strike rate
(defrule strikeRate_high
    (declare (salience 93))
    (strike_rate_data ?player&:(fuzzy-match ?player "high")) (player{playerType != "bowler"})
     =>
    (if (eq ?*invalid* 0) then
    	(printout t "Spectacular strike rate,you don't wanna bowl to him." crlf)
    (bind ?*rating* (* ?*rating* 3))
    ))

; Rule 11
; low wickets
(defrule wickets_low
    (declare (salience 92))
    (wickets_data ?player&:(fuzzy-match ?player "low")) (player{playerType != "batsman"})
     =>
    (if (eq ?*invalid* 0) then
    	(printout t "The player needs to take wickets regularly." crlf)
    (bind ?*rating* (* ?*rating* 1))
    	(bind ?*allroundRating* (* ?*allroundRating* 1))
    ))

; Rule 12
; medium wickets
(defrule wickets_medium
    (declare (salience 92))
    (wickets_data ?player&:(fuzzy-match ?player "medium")) (player{playerType != "batsman"})
     =>
    (if (eq ?*invalid* 0) then
    	(printout t "The player takes wickets regularly a good asset for the team." crlf)
    (bind ?*rating* (* ?*rating* 2))
    	(bind ?*allroundRating* (* ?*allroundRating* 2))
    ))

; Rule 13
; high wickets
(defrule wickets_high
    (declare (salience 92))
    (wickets_data ?player&:(fuzzy-match ?player "high")) (player{playerType != "batsman"})
     =>
    (if (eq ?*invalid* 0) then
    	(printout t "Any team would want such a prolific wicket-taker." crlf)
    (bind ?*rating* (* ?*rating* 3))
    	(bind ?*allroundRating* (* ?*allroundRating* 3))
    ))

; Rule 14
; low economy
(defrule economy_bad
    (declare (salience 91))
    (economy_data ?player&:(fuzzy-match ?player "bad")) (player{playerType != "batsman"})
     =>
    (if (eq ?*invalid* 0) then
    	(printout t "Needs to improve economy rate, its important part of the game." crlf)
    (bind ?*rating* (* ?*rating* 1))
    ))

; Rule 15
; medium economy
(defrule economy_moderate
    (declare (salience 91))
    (economy_data ?player&:(fuzzy-match ?player "moderate")) (player{playerType != "batsman"})
     =>
    (if (eq ?*invalid* 0) then
    	(printout t "The player has a good economy rate." crlf)
    (bind ?*rating* (* ?*rating* 2))
    ))

; Rule 16
; high economy
(defrule economy_good
    (declare (salience 91))
    (economy_data ?player&:(fuzzy-match ?player "good")) (player{playerType != "batsman"})
     =>
    (if (eq ?*invalid* 0) then
    	(printout t "Excellent economy rate, puts pressure on the opponent batsman." crlf)
    (bind ?*rating* (* ?*rating* 3))
    ))

; Rule 17
; evaluating batsman
(defrule evalBatsman
    (declare (salience 90))
    (player{playerType == "batsman"})
    =>
    (if (<= ?*rating* 2) then
      (printout t "With this stats, player needs a lot of improvement to make the team." crlf)
    elif(<= ?*rating* 4) then
        (printout t "The player has an overall good stats and is good fit for the team." crlf)
    else
        (printout t "The player has impressive stats, is ideal fit for the team." crlf)
        )
    )

; Rule 18
; evaluating allrounder
(defrule evalAllrounder
    (declare (salience 90))
    (player{playerType == "allrounder"})
    =>
    (if (<= ?*allroundRating* 2) then
      (printout t "With this stats, player needs a lot of improvement to make the team." crlf)
    elif(<= ?*allroundRating* 4) then
        (printout t "The player has an overall good stats and is good fit for the team." crlf)
    else
        (printout t "The player has impressive stats, is ideal fit for the team." crlf)
        )
    )

; Rule 19
; evalating bowler
(defrule evalBowler
    (declare (salience 90))
    (player{playerType == "bowler"})
    =>
    (if (<= ?*rating* 2) then
      (printout t "With this stats, player needs a lot of improvement to make the team." crlf)
    elif(<= ?*rating* 4) then
        (printout t "The player has an overall good stats and is good fit for the team." crlf)
    else
        (printout t "The player has impressive stats, is ideal fit for the team." crlf)
        )
    )

;Rule 20
;Intializing the input
(defrule init
    (declare (salience 50))
=>
(assert (player
            (playerName "Chris Jordan")
            (playerAge 29)
            (playerType "bowler");batsman/bowler/allrounder
            (matches 10)
            (Average 1.5)
            (StrikeRate 60)
            (Wickets 12)
            (Economy 9.2)))
)

(reset)
(run)
