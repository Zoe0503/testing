//
//  highScoresViewController.swift
//  13634959-Eric_Gernan-Assignment_2_BubblePop
//
//  Created by Eric Gernan on 2/5/20.
//  Copyright © 2020 Eric Gernan. All rights reserved.
//

import UIKit

class highScoresViewController: UIViewController {

    //Used to store player ranking details
    var rankingDictionary = [String : Double]()
    var sortedHighScoreArray = [(key: String, value: Double)]()
    
    //Available UILabel fields
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var nameLabel2: UILabel!
    @IBOutlet weak var scoreLabel2: UILabel!
    @IBOutlet weak var nameLabel3: UILabel!
    @IBOutlet weak var scoreLabel3: UILabel!
    
    //viewDidLoad function
    override func viewDidLoad() {
        
        //Initial Text defauts
        //Will be overriddent by sortedHighScoreArray
        nameLabel.text = "Leader 1"
        scoreLabel.text = "0.0"
        nameLabel2.text = "Leader 2"
        scoreLabel2.text = "0.0"
        nameLabel3.text = "Leader 3"
        scoreLabel3.text = "0.0"
        
        //Section of code to allow the display of the sorted list of high scoring players
        //List shows top 3 players with highest scores in descending order of score value
        if let rankingDictionary = UserDefaults.standard.dictionary(forKey: "ranking") as! [String : Double]? {
            sortedHighScoreArray = rankingDictionary.sorted(by: {$0.value > $1.value})
            if sortedHighScoreArray.count == 1{
                nameLabel.text = sortedHighScoreArray[0].key
                scoreLabel.text = "\(sortedHighScoreArray[0].value)"
            } else if sortedHighScoreArray.count == 2{
                nameLabel.text = sortedHighScoreArray[0].key
                scoreLabel.text = "\(sortedHighScoreArray[0].value)"
                nameLabel2.text = sortedHighScoreArray[1].key
                scoreLabel2.text = "\(sortedHighScoreArray[1].value)"
            } else {
                nameLabel.text = sortedHighScoreArray[0].key
                scoreLabel.text = "\(sortedHighScoreArray[0].value)"
                nameLabel2.text = sortedHighScoreArray[1].key
                scoreLabel2.text = "\(sortedHighScoreArray[1].value)"
                nameLabel3.text = sortedHighScoreArray[2].key
                scoreLabel3.text = "\(sortedHighScoreArray[2].value)"
            }
        }
        super.viewDidLoad()
    }
}
