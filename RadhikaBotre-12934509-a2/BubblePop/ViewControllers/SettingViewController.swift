//
//  SettingViewController.swift
//  BubblePop
//
//  Created by Radhika on 30/04/20.
//  Copyright © 2020 Radhika. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var bubblesCountSlider: UISlider!
    @IBOutlet weak var gameTimeSlider: UISlider!
    @IBOutlet weak var gameTimeLabel: UILabel!
    @IBOutlet weak var maximumBubblesCountLabel: UILabel!
    @IBOutlet weak var gameSoundSwitch: UISwitch!
    
    //MARK:- Instance variables
    ///playerName  stores the player's name
    var playerName: String?
    
    ///gameSettings stores the settings of the game
    var gameSettings: GameSettings = GameSettings()
    
    //MARK:- View lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSliders()
        configureLabels()
        
        ///Transforming the sliders
        gameTimeSlider.transform = CGAffineTransform(scaleX: 1, y: 1.5)
        bubblesCountSlider.transform = CGAffineTransform(scaleX: 1, y: 1.5)
        
        ///Loading sound settings from userdefaults, if already set from earlier app launch
        if let gameSounds = UserDefaults.standard.value(forKey: kGameSoundOn), let gameSoundsValue = gameSounds as? Bool{
            UserDefaults.standard.set(true, forKey: kGameSoundOn)
            gameSoundSwitch.setOn(gameSoundsValue, animated: true)
        }
    }
    
    ///Configuring the sliders and setting maximum, minimum and default values
    func configureSliders(){
        self.bubblesCountSlider.maximumValue = 15
        self.bubblesCountSlider.minimumValue = 1
        self.bubblesCountSlider.value = 15
        self.gameTimeSlider.maximumValue = 60
        self.gameTimeSlider.minimumValue = 10
        self.gameTimeSlider.value = 60
    }
    
    ///Configuring labels and setting default values for game duration and maximum bubbles
    func configureLabels(){
        gameTimeLabel.text = String(Int(gameTimeSlider.value))
        maximumBubblesCountLabel.text = String(Int(bubblesCountSlider.value))
        self.gameSettings.defaultPlayTime = 60
        self.gameSettings.maxBubbles = 15
    }
    
    //MARK:- IBAction methods
    ///Updating the text of gameTimeLabel when its respective slider value is changed
    @IBAction func updateGameTime(_ sender: UISlider) {
        self.gameTimeLabel.text = String(Int(self.gameTimeSlider.value))
        self.gameSettings.defaultPlayTime = TimeInterval(Int(self.gameTimeSlider.value))
    }
    
    ///Updating the text of maximumBubblesCountLabel when its respective slider value is changed
    @IBAction func updateMaxBubbles(_ sender: Any) {
        self.maximumBubblesCountLabel.text = String(Int(self.bubblesCountSlider.value))
        self.gameSettings.maxBubbles = Int(self.bubblesCountSlider.value)
    }
    
    ///Setting sound value in UserDefaults
    @IBAction func gameSoundSettingsChanged(_ sender: Any) {
        UserDefaults.standard.set(gameSoundSwitch.isOn, forKey: kGameSoundOn)
    }
    
    //MARK:- Segue Navigation
    ///Setting instance variables of  StartPlayingGameViewController during navigation
    ///This function will enable the information should passed over to the next view/screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let gameView = segue.destination as? StartPlayingGameViewController {
            gameView.playerName = self.playerName
            gameView.gameSettings = self.gameSettings
        }
    }
}
