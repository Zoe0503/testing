//
//  newGameViewController.swift
//  13634959-Eric_Gernan-Assignment_2_BubblePop
//
//  Created by Eric Gernan on 1/5/20.
//  Copyright © 2020 Eric Gernan. All rights reserved.
//

import UIKit

class newGameViewController: UIViewController {

    //Variables and their default values
    var secondsCount:Int = 60
    var secondsCountInitial:Int = 0
    var bubblesCount:Int = 15
    var bubblesCountInitial:Int = 0
    var timer = Timer()
    var enteredPlayerName = ""
    
    //Availeble UILabel fields
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var displayTimeSelected: UILabel!
    @IBOutlet weak var displayBubblesSelected: UILabel!
    @IBOutlet weak var resetSlider: UISlider!
    @IBOutlet weak var bubblesSlider: UISlider!

    //Slider used to set initial game time. Defaulted to 60
    @IBAction func sliderSetTime(_ sender: UISlider) {
        secondsCount = Int(sender.value)
        displayTimeSelected.text = "Set Game Time: \(String(secondsCount))"
    }
      
    //Slider used to set initial number of bubbles. Defaulted to 15
    @IBAction func sliderSetBubbles(_ sender: UISlider) {
        bubblesCount = Int(sender.value)
        displayBubblesSelected.text = "Set Bubble Count: \(String(bubblesCount))"
    }
    
    @IBAction func startButton(_ sender: UIButton) {
        //Segue triggered to playGameViewController.swift
    }
    
    //Reset button used to clear selected game time and bubbles count and load defaults
    @IBAction func resetButton(_ sender: UIButton) {
        timer.invalidate()
        displayTimeSelected.text = "Set Game Time: \(String("60"))"
        secondsCount = 60
        resetSlider.setValue(60, animated: true)
        displayBubblesSelected.text = "Set Bubble Count: \(String("15"))"
        bubblesCount = 15
        bubblesSlider.setValue(15, animated: true)
    }
    
    //Segue to allow for selected values to be sent to the next view controller playGameViewController
    override func prepare (for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? playGameViewController {
            viewController.copiedPlayerName = enteredPlayerName;
            viewController.copiedStartTime = String(secondsCount);
            viewController.copiedBubbleSetting = bubblesCount
         }
     }

    //viewDidLoad function
    //Setting default values on load
    override func viewDidLoad() {
        playerNameLabel.text = enteredPlayerName
        displayTimeSelected.text = "Set Game Time: \(String("60"))"
        resetSlider.setValue(60, animated: true)
        displayBubblesSelected.text = "Set Bubble Count: \(String("15"))"
        bubblesSlider.setValue(15, animated: true)
        super.viewDidLoad()
    }
}
