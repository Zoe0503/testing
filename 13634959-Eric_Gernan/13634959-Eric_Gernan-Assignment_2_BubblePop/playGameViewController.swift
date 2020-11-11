//
//  playGameViewController.swift
//  13634959-Eric_Gernan-Assignment_2_BubblePop
//
//  Created by Eric Gernan on 2/5/20.
//  Copyright © 2020 Eric Gernan. All rights reserved.
//

import UIKit

class playGameViewController: UIViewController {

    //Variables and their default values
    var copiedPlayerName: String? = ""
    var copiedStartTime: String? = ""
    var copiedBubbleSetting: Int = 1
    var timeLeft = 4
    var gameTimeLeft = 0
    var bubbles = Bubbles()
    var bubblesArray = [Bubbles]()
    var maxBubbleNumber = 15
    var trackScore: Double = 0
    var lastBubbleValue: Double = 0
    var screenWidth: UInt32 {
        return UInt32(UIScreen.main.bounds.width)
    }
    var screenHeight: UInt32 {
        return UInt32(UIScreen.main.bounds.height)
    }
    var initTimer = Timer()
    var gameTimer = Timer()
    var rankingDictionary = [String : Double]()
    var previousRankingDictionary: Dictionary? = [String : Double]()
    var sortedHighScoreArray = [(key: String, value: Double)] ()

    //Availeble UILabel fields
    @IBOutlet weak var timeRemaining: UILabel!
    @IBOutlet weak var gameNameLabel: UILabel!
    @IBOutlet weak var textScore: UILabel!
    @IBOutlet weak var preGameCountdown: UILabel!
    @IBOutlet weak var currentLeader: UILabel!
    
    //endGame used to stop game without saving
    @IBAction func endGame(_ sender: Any) {
        initTimer.invalidate()
        gameTimer.invalidate()
        preGameCountdown.isHidden = false
        preGameCountdown.text = "Game Over! Score not saved!"
        removeBubbles()
    }
    
    //saveScore used to stop game and automatically saves score and ranking
    @IBAction func saveScore(_ sender: AnyObject) {
        initTimer.invalidate()
        gameTimer.invalidate()
        preGameCountdown.isHidden = false
        preGameCountdown.text = "Game Over!"
        saveRanking()
        removeBubbles()
        
        //After game ends the Leader Board appears
        let homeView = self.storyboard?.instantiateViewController(withIdentifier: "highScoresViewController") as! highScoresViewController
        self.navigationController?.pushViewController(homeView, animated: true)
     }
    
    //Countdown Timer at the start of the game that counts 3 to 1 before the game starts
    @objc func countdownTimer(){
        timeLeft -= 1
        if (timeLeft != 0) {
            self.preGameCountdown.text = String(timeLeft)
            print(timeLeft)
        } else if (timeLeft==0){
            initTimer.invalidate()
            preGameCountdown.isHidden = true
        } else if (timeLeft < 0){
            initTimer.invalidate()
        }
    }

    //Countdown on remaining game time
    //Initial time based on selection from newGameViewController.swift
    //Also calls Bubbles.swift to generate bubbles
    @objc func gameCountdownTimer(){
        gameTimeLeft -= 1
        if (timeLeft != 0) {
            //
        } else if (timeLeft==0) {
             if gameTimeLeft != 0 {
                timeRemaining.text = "Time: \(String(gameTimeLeft))"
                print(gameTimeLeft)
                createBubbles()
                removeBubbles()
            } else if  gameTimeLeft==0 {
                timeRemaining.text = "Time: \(String(gameTimeLeft))"
                print(gameTimeLeft)
                preGameCountdown.isHidden = false
                preGameCountdown.text = "Game Over!"
                gameTimer.invalidate()
                checkHighScoreExistence()
                
                //After game ends the Leader Board appears
                let homeView = self.storyboard?.instantiateViewController(withIdentifier: "highScoresViewController") as! highScoresViewController
                self.navigationController?.pushViewController(homeView, animated: true)

            } else if (gameTimeLeft < 0){
                gameTimer.invalidate()
            }
        }
    }
    
    //Calls Bubbles.swift to generate bubbles
    @objc func createBubbles() {
        let numberOfBubbles = arc4random_uniform(UInt32(maxBubbleNumber - bubblesArray.count)) + 1
        var i = 0
        while i < numberOfBubbles {
            bubbles = Bubbles()
            
            //Section to define which part of the screen the bubbles should appear
            bubbles.frame = CGRect(
                x: CGFloat(20 + arc4random_uniform(screenWidth - 100)),
                y: CGFloat(200 + arc4random_uniform(screenHeight - 500)),
                width: CGFloat(35),
                height: CGFloat(35))
            bubbles.layer.cornerRadius = bubbles.frame.height/2
            
            if !checkForOverlap(newBubbles: bubbles) {
                bubbles.addTarget(self, action: #selector(bubblesTapped), for: UIControl.Event.touchUpInside)
                
                //Added functionality wher the bubbles speed changes as the time decreases
                //Different pulsate options are available from Bubbles.swift and used accordingly
                if gameTimeLeft > 30 && gameTimeLeft <= 60{
                    bubbles.pulsate()
                } else if gameTimeLeft > 10 && gameTimeLeft < 30 {
                    bubbles.pulsate2()
                } else if gameTimeLeft < 10 {
                    bubbles.pulsate3()
                }
                
                self.view.addSubview(bubbles)
                i += 1
                bubblesArray += [bubbles]
            }
        }
    }
    
    //Function to check for bubbles overlap
    @objc func checkForOverlap(newBubbles: Bubbles) -> Bool {
        for existingBubbles in bubblesArray {
            if newBubbles.frame.intersects(existingBubbles.frame) {
                return true
            }
        }
        return false
    }
    
    //Function to remove bubbles once they are tapped on the screen
    //Function also used to calculate score on popped bubbles
    @IBAction func bubblesTapped(_ bubbleClicked: Bubbles) {
        bubbleClicked.removeFromSuperview()
        if lastBubbleValue == bubbleClicked.value {
            //Combo scoring for hitting the same color bubbles consecutively
            trackScore += bubbleClicked.value * 1.5
        } else  {
            trackScore += bubbleClicked.value
        }
        lastBubbleValue = bubbleClicked.value
        textScore.text = "Score: \(String(trackScore))"
    }
    
    //Function to remove bubbles from the screen
    //Called when the game ends
    @objc func removeBubbles() {
        var i = 0
        while i < bubblesArray.count {
            if arc4random_uniform(100) < 30 {
                let bubblesRemoved = bubblesArray[i]
                bubblesRemoved.removeFromSuperview()
                bubblesArray.remove(at: i)
                i += 1
            }
        }
    }
     
    //function viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Defaulting values below on loading the playGameViewController.swift
        initTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(countdownTimer), userInfo: nil, repeats: true)
        gameNameLabel.text = copiedPlayerName
        timeRemaining.text = copiedStartTime
        gameTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(gameCountdownTimer), userInfo: nil, repeats: true)
        gameTimeLeft = Int(timeRemaining.text!)! + Int(4)
        timeRemaining.text = "Time: \(timeRemaining.text!)"
        textScore.text = "Score: \(String(0))"
        maxBubbleNumber = copiedBubbleSetting
        
        //Script to check for the previous ranking
        previousRankingDictionary = UserDefaults.standard.dictionary(forKey: "ranking") as? Dictionary<String,Double>
        if previousRankingDictionary != nil {
            rankingDictionary = previousRankingDictionary!
            sortedHighScoreArray = rankingDictionary.sorted(by: {$0.value > $1.value})
        }
        
        //Script to default the current high scrore value on game play
        if let currentLeader = sortedHighScoreArray.first?.value {
            self.currentLeader?.text = "High Score: \(String(currentLeader))"
        }
        
    }

    //Function to save ranking after game completes and is saved
    func saveRanking() {
        rankingDictionary.updateValue(trackScore, forKey: "\(gameNameLabel.text!)")
        UserDefaults.standard.set(rankingDictionary, forKey: "ranking")
    }
    
    //Function to check available scores and saves them to the rankingDictionary
    func checkHighScoreExistence() {
        if previousRankingDictionary == nil {
            saveRanking()
        } else {
            rankingDictionary = previousRankingDictionary!
            if rankingDictionary.keys.contains("\(gameNameLabel.text!)") {
                let currentScore = rankingDictionary["\(gameNameLabel.text!)"]!
                if currentScore < trackScore {
                    saveRanking()
                }
            } else {
                saveRanking()
            }
        }
    }
}
