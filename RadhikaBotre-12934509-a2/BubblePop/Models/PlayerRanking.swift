//
//  PlayerRanking.swift
//  BubblePop
//
//  Created by Radhika on 30/04/20.
//  Copyright © 2020 Radhika. All rights reserved.
//

import Foundation

///Model class for player ranking, containing all the records
struct PlayerRanking {
    var records: [TopScore]
}

///This is used to represent top score of a Player
struct TopScore {
    var highestScore: String
    var playerName: String
}
