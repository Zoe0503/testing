//
//  GameHomeViewController.swift
//  BubblePop
//
//  Created by Radhika on 30/04/20.
//  Copyright © 2020 Radhika. All rights reserved.
//

import UIKit

class GameHomeViewController: BaseViewController{
    
    //MARK:- IBOutlets
    @IBOutlet weak var playerNameTextField: UITextField!
    
    //MARK:- View lifecycle methods
    override func viewDidLoad() {
        playerNameTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK:- Segue
    ///Based on the information retrieved here, it will get passed onto the next view controller/ screen 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let playerName = self.playerNameTextField.text, !(playerName.isEmpty) else {
            self.showAlert(message: msgEnterYourName)
            return
        }
        
        ///Checking if the entered name contains only valid characters
        if !Utils.isValidName(name: playerName){
            self.showAlert(message: msgEnterValidName)
            return
        }
        
        ///Sending player name  to StartGame screen during navigation
        if let startGameVC = segue.destination as? StartPlayingGameViewController {
            startGameVC.playerName = self.playerNameTextField.text
        }
        
        ////Sending player name to Settings screen during navigation
        if let gameSettingsVC = segue.destination as? SettingViewController {
            gameSettingsVC.playerName = self.playerNameTextField.text
        }
    }
    
    //MARK:- Unwind segue
    @IBAction func unwindToStartView(segue: UIStoryboardSegue) {
    }
}

//MARK:- UITextFieldDelegate methods
extension GameHomeViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
