//
//  StartPlayingGameViewController.swift
//  BubblePop
//
//  Created by Radhika on 30/04/20.
//  Copyright © 2020 Radhika. All rights reserved.
//

import UIKit

import GameplayKit
import AVFoundation

class StartPlayingGameViewController: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var bubblePopGameView: UIView!
    @IBOutlet weak var timeRemainingLabel: UILabel!
    @IBOutlet weak var gameScoreLabel: UILabel!
    @IBOutlet weak var topScoreLabel: UILabel!
    @IBOutlet weak var firstCountDownView: UIView!
    @IBOutlet weak var firstCountDownLabel: UILabel!
    @IBOutlet weak var secondCountDownView: UIView!
    @IBOutlet weak var thirdCountDownView: UIView!
    @IBOutlet weak var thirdCountDownLabel: UILabel!
    @IBOutlet weak var secondCountDownLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var recentlyTappedBubbleButton: RoundBubbleButton!
    
    //MARK:- Instance variables
    var player : AVAudioPlayer?
    var playerName: String?
    var score: Int = 0
    let bundle = Bundle.main
    var updateGameTimer: Timer?
    var movementMonitoringTimer: Timer?
    var gameLayout: GameLayout?
    var remainingGameTime: Int?
    var gameSettings: GameSettings?
    lazy var highestScore: Int = 0
    let randomSource: GKRandomSource = GKARC4RandomSource()
    
    //MARK:- view lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpAudio()
        self.loadHighestScorefromFile()
        if self.gameSettings == nil {
            self.gameSettings = GameSettings()
        }
        self.configureUI()
        self.createGameBubbles()
        self.configureNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.hideAllBubbles()
        self.elapsedTime()
        self.perform(#selector(makeAllBubblesVisible), with: nil, afterDelay: 3)
        self.perform(#selector(beginTimer), with: nil, afterDelay: 4)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        updateGameTimer?.invalidate()
        updateGameTimer = nil
        movementMonitoringTimer?.invalidate()
        movementMonitoringTimer = nil
    }
    
    ///Configuring navigation bar
    func configureNavigationBar(){
        self.navigationItem.hidesBackButton = true
        self.view.backgroundColor = UIColor.white
    }
    
    ///Loading high score form plist file
    func loadHighestScorefromFile(){
        let filePath = self.bundle.path(forResource: "ranking", ofType: ".plist")
        let loadedRankingList: Array<Dictionary<String, String>> = NSArray.init(contentsOfFile: filePath!) as! Array<Dictionary<String, String>>
        self.highestScore = Int(loadedRankingList[0]["highestScore"]!)!
    }
    
    //MARK:- IBAction methods
    ///Cancelling timers
    @IBAction func suspendTimer() {
        updateGameTimer?.invalidate()
        updateGameTimer = nil
        movementMonitoringTimer?.invalidate()
        movementMonitoringTimer = nil
    }
    
    ///Invalidating timers
    @IBAction func stopBubblePopTimer() {
        updateGameTimer?.invalidate()
        updateGameTimer = nil
        movementMonitoringTimer?.invalidate()
        movementMonitoringTimer = nil
        configureUI()
    }
    
    ///Starting timers
    @IBAction func beginTimer() {
        if updateGameTimer == nil {
            updateGameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateUI), userInfo: nil, repeats: true)
        }
        if movementMonitoringTimer == nil {
            movementMonitoringTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { (timer: Timer) in
                self.updateMovements()
            })
        }
    }
    
    //MARK:- Instance methods
    ///This represents a countdown timer for the game
    func elapsedTime()  {
        firstCountDownView.isHidden = false
        secondCountDownView.isHidden = false
        thirdCountDownView.isHidden = false
        let views: [UIView] = [thirdCountDownView, secondCountDownView, firstCountDownView]
        let lbls: [UILabel] = [thirdCountDownLabel, secondCountDownLabel, firstCountDownLabel]
        for i in 0..<views.count {
            UIView.animate(withDuration: 1, delay: TimeInterval(i), options: [], animations: {
                lbls[i].layer.setAffineTransform(CGAffineTransform(scaleX: 5, y: 5))
            }) { (true) in
                lbls[i].layer.setAffineTransform(CGAffineTransform.identity)
                views[i].isHidden = true
            }
        }
    }
    
    ///Setting default configurations
    func configureUI() {
        self.configureLabelsAndLayouts()
        configureBubbles()
        configureMargins()
        configureRecentlyTappedBubble()
    }
    
    ///Moving all bubbles after a time period
    func updateMovements() {
        for bubbleItem in self.view.subviews {
            if bubbleItem is RoundBubbleButton {
                (bubbleItem as! RoundBubbleButton).bubbleMovingSpeed.x -= 0.01
                (bubbleItem as! RoundBubbleButton).bubbleMovingSpeed.y -= 0.01
                bubbleItem.center = CGPoint(x: bubbleItem.center.x + (bubbleItem as! RoundBubbleButton).bubbleMovingSpeed.x, y: bubbleItem.center.y + (bubbleItem as! RoundBubbleButton).bubbleMovingSpeed.y)
                
                if bubbleItem.frame.minY <= self.bubblePopGameView.bounds.height + abs((bubbleItem as! RoundBubbleButton).bubbleMovingSpeed.y) {
                    (bubbleItem as! RoundBubbleButton).bubbleMovingSpeed.y = abs((bubbleItem as! RoundBubbleButton).bubbleMovingSpeed.y)
                }
                if bubbleItem.frame.maxY >= self.view.frame.height - abs((bubbleItem as! RoundBubbleButton).bubbleMovingSpeed.y) {
                    (bubbleItem as! RoundBubbleButton).bubbleMovingSpeed.y = -abs((bubbleItem as! RoundBubbleButton).bubbleMovingSpeed.y)
                }
                if bubbleItem.frame.minX <= abs((bubbleItem as! RoundBubbleButton).bubbleMovingSpeed.x) {
                    (bubbleItem as! RoundBubbleButton).bubbleMovingSpeed.x = abs((bubbleItem as! RoundBubbleButton).bubbleMovingSpeed.x)
                }
                if bubbleItem.frame.maxX >= self.view.frame.width - abs((bubbleItem as! RoundBubbleButton).bubbleMovingSpeed.x) {
                    (bubbleItem as! RoundBubbleButton).bubbleMovingSpeed.x = -abs((bubbleItem as! RoundBubbleButton).bubbleMovingSpeed.x)
                }
                
                /// Bubble collision detection and updating views accordingly
                for item2 in self.view.subviews {
                    if item2 is RoundBubbleButton {
                        if bubbleItem.frame.intersects(item2.frame) {
                            let temp_movingSpeed = (bubbleItem as! RoundBubbleButton).bubbleMovingSpeed
                            (bubbleItem as! RoundBubbleButton).bubbleMovingSpeed = (item2 as! RoundBubbleButton).bubbleMovingSpeed
                            (item2 as! RoundBubbleButton).bubbleMovingSpeed = temp_movingSpeed
                        }
                        self.removeBubblesMovingOutOfPlayingArea()
                    }
                }
            }
        }
        self.removeBubblesMovingOutOfPlayingArea()
    }
    
    ///Configure game labels and layouts
    func configureLabelsAndLayouts(){
        if self.gameSettings == nil {self.gameSettings = GameSettings()}
        self.remainingGameTime = Int((self.gameSettings?.defaultPlayTime)!)
        self.timeRemainingLabel.text = String(self.remainingGameTime!)
        self.score = 0
        self.gameScoreLabel.text = "0"
        self.topScoreLabel.text = String(self.highestScore)
        if self.gameLayout == nil {self.gameLayout = GameLayout()}
    }
    
    ///Configure game bubbles
    func configureBubbles(){
        if self.gameLayout == nil {
            self.gameLayout = GameLayout()
        }
        var xAxixBubblesCount = Int(Float(self.view.bounds.width) / Float((self.gameLayout?.bubbleDiameter)!))
        var yAxixBubblesCountCount = Int((Float(self.view.bounds.height) - Float(bubblePopGameView.bounds.height)) / Float((self.gameLayout?.bubbleDiameter)!))
        while xAxixBubblesCount * yAxixBubblesCountCount < (self.gameSettings?.maxBubbles)! {
            self.gameLayout?.bubbleDiameter -= 1
            xAxixBubblesCount = Int(Float(self.view.bounds.width) / Float((self.gameLayout?.bubbleDiameter)!))
            yAxixBubblesCountCount = Int((Float(self.view.bounds.height) - Float(bubblePopGameView.bounds.height)) / Float((self.gameLayout?.bubbleDiameter)!))
        }
        self.gameLayout?.horizontalBubbles = xAxixBubblesCount
        self.gameLayout?.verticalBubbles = yAxixBubblesCountCount
    }
    
    ///Configuring recently tapped bubble, setting the bubble color to white by default
    func configureRecentlyTappedBubble(){
        recentlyTappedBubbleButton.bubble = RoundBubble(color: UIColor.white, points: 0)
        let imgBubble = #imageLiteral(resourceName: "bubble_white")
        recentlyTappedBubbleButton.setBackgroundImage(imgBubble, for: UIControl.State.normal)
    }
    
    ///Configure margins for layouts
    func configureMargins(){
        let leftMargin = (Int(self.view.bounds.width) % Int((self.gameLayout?.bubbleDiameter)!)) / 2
        let topMargin = Int(self.timeRemainingLabel.frame.maxY + self.bubblePopGameView.bounds.height);
        self.gameLayout?.leftMargin = Float(leftMargin)
        self.gameLayout?.topMargin = Float(topMargin)
    }
    
    ///Updating game timer and navigate to rankings screen when timer elapsed
    @objc func updateUI () {
        if self.remainingGameTime! > 0 {
            self.remainingGameTime! -= 1
            self.timeRemainingLabel.text = String(self.remainingGameTime!)
            self.updateGameBubbles()
        } else {
            self.navigationToRankingsScreen()
        }
    }
    
    ///Navigation to rankings screen
    func navigationToRankingsScreen(){
        let rankingTableViewController = storyboard?.instantiateViewController(identifier: String(describing: PlayersRankingTableViewController.self)) as! PlayersRankingTableViewController
        rankingTableViewController.playerName = self.playerName
        rankingTableViewController.score = self.score
        let playAgain: UIBarButtonItem = UIBarButtonItem.init(title: "Play Again", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        rankingTableViewController.navigationItem.leftBarButtonItem = playAgain
        let home: UIBarButtonItem = UIBarButtonItem.init(title: "Home", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        rankingTableViewController.navigationItem.rightBarButtonItem = home
        self.navigationController?.pushViewController(rankingTableViewController, animated: true)
        reConfigAfterGameTimeOver()
    }
    
    ///Update UI and timers after game time elapsed
    func reConfigAfterGameTimeOver(){
        self.stopBubblePopTimer()
        self.configureUI()
        self.createGameBubbles()
    }
    
    ///Creating random bubbles
    func createGameBubbles() {
        let gameBubblesCount = randomSource.nextInt(upperBound: (gameSettings?.maxBubbles)!)
        let positions = Positioner.getAccessiblePosition(layout: self.gameLayout!, totalCount: gameBubblesCount, exceptivePositions: [])
        for position in positions {
            generateGameBubble(at: position)
        }
    }
    
    ///Creating and updating buubles
    func updateGameBubbles() {
        let currentNumberOfBubbles = self.currentlyDisplayingBubbles().count
        let randomNumberOfRemovedBubbles = randomSource.nextInt(upperBound: currentNumberOfBubbles)
        self.removeSpecificBubble(by: randomNumberOfRemovedBubbles)
        let maxNumberOfNewBubbles = (gameSettings?.maxBubbles)! - self.currentlyDisplayingBubbles().count
        if maxNumberOfNewBubbles > 0 {
            let numberOfNewBubbles = randomSource.nextInt(upperBound: maxNumberOfNewBubbles)
            let exceptivePositions: [CGPoint] = curentlyDisplayingBubblePositions()
            let positions = Positioner.getAccessiblePosition(layout: self.gameLayout!, totalCount: numberOfNewBubbles, exceptivePositions: exceptivePositions)
            for position in positions {
                generateGameBubble(at: position)
            }
        }
    }
    
    ///Get current positions of bubbles
    func curentlyDisplayingBubblePositions() -> [CGPoint] {
        var currentlyAvailablePositions: [CGPoint] = []
        for gameItem in self.view.subviews {
            if gameItem is RoundBubbleButton {
                currentlyAvailablePositions.append(CGPoint(x: gameItem.frame.origin.x, y: gameItem.frame.origin.y))
            }
        }
        return currentlyAvailablePositions
    }
    
    ///Get current bubbles
    func currentlyDisplayingBubbles() -> [RoundBubbleButton] {
        var currentlyAvailableBubbles: [RoundBubbleButton] = []
        for gameItem in self.view.subviews {
            if gameItem is RoundBubbleButton {
                currentlyAvailableBubbles.append(gameItem as! RoundBubbleButton)
            }
        }
        return currentlyAvailableBubbles
    }
    
    ///Show all bubbles
    @objc func makeAllBubblesVisible() {
        for item in self.view.subviews {
            if item is RoundBubbleButton {
                (item as! RoundBubbleButton).isEnabled = true
                (item as! RoundBubbleButton).isHidden = false
            }
        }
    }
    
    ///Generating bubble based on it's position
    @objc func generateGameBubble(at position: CGPoint) {
        var shouldGenerateBubble = true
        for bubbleItem in self.view.subviews {
            if bubbleItem is RoundBubbleButton {
                if abs(bubbleItem.frame.origin.y - position.y) < CGFloat((self.gameLayout?.bubbleDiameter)!) &&
                    abs(bubbleItem.frame.origin.x - position.x) < CGFloat((self.gameLayout?.bubbleDiameter)!) {
                    shouldGenerateBubble = false
                }
            }
        }
        if shouldGenerateBubble{
            let bubbleButton = RoundBubbleButton(frame: CGRect(x: position.x, y: position.y, width: CGFloat((self.gameLayout?.bubbleDiameter)!), height: CGFloat((self.gameLayout?.bubbleDiameter)!)))
            bubbleButton.bubble = RoundBubble.generateRandomBubble()
            let bubbleImage = UIImage(named: BubbleImager.pathOfImage(color: (bubbleButton.bubble?.color)!))
            bubbleButton.setBackgroundImage(bubbleImage, for: UIControl.State.normal)
            let bubbleDirectionIdentifier = randomSource.nextInt(upperBound: 7)
            bubbleButton.bubbleMovingSpeed = BubbleDirection.randomDirection(with: bubbleDirectionIdentifier)
            bubbleButton.addTarget(self, action: #selector(bubblePopped(_:)), for: .touchUpInside)
            self.view.addSubview(bubbleButton)
        }
    }
    
    /// Ensuring that all bubbles are completely disabled and are hidden
    func hideAllBubbles() {
        for bubbleItem in self.view.subviews {
            if bubbleItem is RoundBubbleButton {
                (bubbleItem as! RoundBubbleButton).isEnabled = false
                (bubbleItem as! RoundBubbleButton).isHidden = true
            }
        }
    }
    
    ///This method is used to play a sound and perform animations when a bubble is tapped
    @objc func bubblePopped(_ sender: RoundBubbleButton) {
        playSound()
        if sender.bubble?.color == recentlyTappedBubbleButton.bubble?.color {
            self.score += Int(Float((sender.bubble?.points)!) * 1.5)
        } else {
            self.score += Int((sender.bubble?.points)!)
        }
        
        ///Comparing current score with highest score and updating if needed
        self.gameScoreLabel.text = String(self.score)
        UIView.animate(withDuration: 0.2, delay: 0, animations: {
            let rightTransform  = CGAffineTransform(translationX: 10, y: 10)
            self.gameScoreLabel.transform = rightTransform
            self.gameScoreLabel.layer.setAffineTransform(CGAffineTransform(scaleX: 3, y: 3))
        }) { (_) in
            UIView.animate(withDuration: 0.2, animations: {
                self.gameScoreLabel.transform = CGAffineTransform.identity
                self.gameScoreLabel.layer.setAffineTransform(CGAffineTransform.identity)
            })
        }
        if self.score > self.highestScore {
            topScoreLabel.text = String(self.score)
        }
        ///Changing bubble colors
        self.recentlyTappedBubbleButton.bubble?.color = (sender.bubble?.color)!
        let senderBubbleImage = UIImage(named: BubbleImager.pathOfImage(color: (sender.bubble?.color)!))
        self.recentlyTappedBubbleButton.setBackgroundImage(senderBubbleImage, for: UIControl.State.normal)
        self.performAnimation(sender: sender)
    }
    
    ///Adding animations to bubbles
    func performAnimation(sender: RoundBubbleButton){
        UIView.animate(withDuration: 0.1, delay: 0.1, options: [], animations: {
            sender.alpha = 0.2
            sender.layer.setAffineTransform(CGAffineTransform(scaleX: 10, y: 10))
        }) { (true) in
            sender.alpha = 1.0
            sender.layer.setAffineTransform(CGAffineTransform.identity)
            sender.removeFromSuperview()
        }
    }
    
    ///Remove all of the bubbles
    func removeAllBubbles() {
        for gameItem in self.view.subviews {
            if gameItem is RoundBubbleButton {
                gameItem.removeFromSuperview()
            }
        }
    }
    
    ///Removing bubbles which goes out of the game view
    @objc func removeBubblesMovingOutOfPlayingArea() {
        for gameItem in self.view.subviews {
            if gameItem is RoundBubbleButton && gameItem.frame.origin.y < self.bubblePopGameView.bounds.height {
                gameItem.removeFromSuperview()
            }
        }
    }
    
    ///This method removes a bubble based on a particular number
    func removeSpecificBubble(by number: Int) {
        if number >= self.currentlyDisplayingBubbles().count {
            self.removeAllBubbles()
            return
        }
        var i = 0
        for item in self.view.subviews {
            if i >= number {
                return
            }
            if (item is RoundBubbleButton) {
                item.removeFromSuperview()
                i += 1
            }
        }
    }
    
    //MARK:- BubblePop audio setup
    func setUpAudio(){
        let path = Bundle.main.path(forResource: kBubblePopSundFileName, ofType: kSoundType)!
        let url = URL(fileURLWithPath: path)
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
        } catch {
            print("Error playing sound:- \(error)")
        }
    }
    
    ///This method is responsible for playing audio, if it is enabled from settings
    func playSound(){
        if let isGameSoundOff = UserDefaults.standard.value(forKey: kGameSoundOn) as? Bool, isGameSoundOff == false{
            return
        }
        player?.play()
    }
}

