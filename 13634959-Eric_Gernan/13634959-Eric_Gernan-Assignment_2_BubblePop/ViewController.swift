//
//  ViewController.swift
//  13634959-Eric_Gernan-Assignment_2_BubblePop
//
//  Created by Eric Gernan on 1/5/20.
//  Copyright © 2020 Eric Gernan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //Used for Player's Name
    var textName = ""
    @IBOutlet weak var playerName: UITextField!
    
    //New Game button to open the newGameViewController.swift
    //and check validation on entered Player Name
    @IBAction func newGame(_ sender: UIButton) {
        playerName.resignFirstResponder()
        textName = playerName.text!
        validate(username: playerName.text!)
    }
    
    //High Scores button to open the highScoresViewController.swift
    @IBAction func highScores(_ sender: Any) {
        playerName.resignFirstResponder()
    }
    
    //Segue to newGameViewController.swift
    override func prepare (for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? newGameViewController {
            viewController.enteredPlayerName = textName
        }
    }
    
    //Check on keyboard pop-up when typing on the Player Name field
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        playerName.resignFirstResponder()
        view.endEditing(true)
    }
    
    //enum for Player Name validation statuses
    enum playerNameCheck: Error {
        case noName
        case tooLong
    }
    
    //Function to validate entered Player Name length
    func validate(username: String)  {
        if username.count == 0 {
            let alert = UIAlertController(title: "Error", message: "Please enter Player Name", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            present(alert, animated:true)
        } else if username.count > 10 {
            let alert = UIAlertController(title: "Error", message: "Player Name is longer than 10 letters", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            present(alert, animated:true)
        }
    }
    
    //viewDidLoad function with check on keyboard pop-up
    override func viewDidLoad() {
        playerName.becomeFirstResponder()
        super.viewDidLoad()
    }
}

