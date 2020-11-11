//
//  HighScoresTableViewCell.swift
//  BubblePop
//
//  Created by Radhika on 02/05/20.
//  Copyright © 2020 Radhika. All rights reserved.
//

import UIKit

class HighScoresTableViewCell: UITableViewCell {
    
    @IBOutlet weak var serialNoLabel: UILabel!
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
