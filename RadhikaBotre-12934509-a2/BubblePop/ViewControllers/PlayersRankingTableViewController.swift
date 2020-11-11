//
//  PlayersRankingTableViewController.swift
//  BubblePop
//
//  Created by Radhika on 30/04/20.
//  Copyright © 2020 Radhika. All rights reserved.
//

import UIKit

class PlayersRankingTableViewController: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var rankingTableView: UITableView!
    
    //MARK:- Instance variables
    var rankings: [PlayerRanking] = []
    var score: Int?
    var playerName: String?
    var allPlayersRankingList: Array<Dictionary<String, String>> = []
    
    //MARK:- View lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadAllRankingsFromFile()
        self.configureNavigationBar()
        self.rankingTableView.tableFooterView = UIView()
    }
    
    //MARK:- View lifecycle methods
    override func viewWillAppear(_ animated: Bool) {
        self.updateRankingRecords()
        self.loadUpdatedPlayersRankings()
    }
    
    //MARK:- Instance methods
    ///Navigate to play game screen
    @objc func startGameAgain() {
        self.navigationController?.popViewController(animated: true)
    }
    
    ///Navigate to game home screen
    @objc func navigateToHome() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    ///Updating players rankings and reloading the table view
    func loadUpdatedPlayersRankings() {
        var playerRanking: PlayerRanking = PlayerRanking(records: [])
        for item in self.allPlayersRankingList {
            let record: TopScore = TopScore(highestScore: item["highestScore"]!, playerName: item["playerName"]!)
            playerRanking.records.append(record)
        }
        self.rankings.append(playerRanking)
        rankings[0].records.sort { (scoreOne, scoreTwo) -> Bool in
            Int(scoreOne.highestScore)! > Int(scoreTwo.highestScore)!
        }
        rankingTableView.reloadData()
    }
    
    ///Configure navigation bar and ad barbutton items
    func configureNavigationBar(){
        self.navigationItem.title = msgRankingList
        if let left = self.navigationItem.leftBarButtonItem {
            if left.title == msgPlayAgain {
                left.action = #selector(startGameAgain)
                left.target = self
            }
        }
        if let right = self.navigationItem.rightBarButtonItem {
            if right.title == msgHome {
                right.action = #selector(navigateToHome)
                right.target = self
            }
        }
    }
    
    ///Updating ranking records with new players score added at right position
    func updateRankingRecords()  {
        if let playerName = self.playerName, let score = self.score {
            for i in 0..<self.allPlayersRankingList.count {
                if allPlayersRankingList[i]["playerName"]! == playerName &&
                    Int(allPlayersRankingList[i]["highestScore"]!)! < score {
                    self.allPlayersRankingList.remove(at: i)
                    self.allPlayersRankingList.insert(["playerName": playerName, "highestScore": String(score)], at: i)
                }
            }
            
            ///Inserting new player's record at it's exact position for every cell 
            var shouldAddRecord = true
            var count = self.allPlayersRankingList.count
            for i in 0..<self.allPlayersRankingList.count {
                if allPlayersRankingList[i]["playerName"]! != playerName &&
                    Int(allPlayersRankingList[self.allPlayersRankingList.count-i-1]["highestScore"]!)! < score {
                    count = self.allPlayersRankingList.count - i - 1
                } else if allPlayersRankingList[i]["playerName"]! == playerName {
                    shouldAddRecord = false
                }
            }
            if shouldAddRecord {
                self.allPlayersRankingList.insert(["playerName": playerName, "highestScore": String(score)], at: count)
            }
            saveUpdatedRecordsTofile()
        }
    }
    
    ///Loads all the saved rankings from plist file
     func loadAllRankingsFromFile(){
         let filePath = Bundle.main.path(forResource: "ranking", ofType: ".plist")
         self.allPlayersRankingList = NSArray.init(contentsOfFile: filePath!) as! Array<Dictionary<String, String>>
     }
    
    ///Saving updated highscore records to plist file
    func saveUpdatedRecordsTofile(){
        let bundleLocation = Bundle.main.path(forResource: "ranking", ofType: ".plist")
        NSArray(array: self.allPlayersRankingList).write(toFile: bundleLocation!, atomically: true)
    }
}

//MARK:- UITableViewDataSource methods methods
extension PlayersRankingTableViewController : UITableViewDataSource, UITableViewDelegate{
    
    ///Returns the number of sections for tableview
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    ///Returns number of rows for each section of tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }else{
            if self.rankings.count > 0{
                return self.rankings[0].records.count
            }
        }
        return 0
    }
    
    ///Returns the appropriate tableviewcell for each every
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "headingCell") else {return UITableViewCell()}
            return cell
        }else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "scoreDetailCell") as? HighScoresTableViewCell else {return UITableViewCell()}
            cell.playerNameLabel.text = self.rankings[0].records[indexPath.row].playerName
            cell.scoreLabel.text = self.rankings[0].records[indexPath.row].highestScore
            cell.serialNoLabel.text = "\(indexPath.row + 1)"
            return cell
        }
    }
}
