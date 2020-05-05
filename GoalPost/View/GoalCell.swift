//
//  GoalCell.swift
//  GoalPost
//
//  Created by Mariah Baysic on 5/4/20.
//  Copyright © 2020 SpacedOut. All rights reserved.
//

import UIKit

class GoalCell: UITableViewCell {

    @IBOutlet weak var goalDescriptionLbl: UILabel!
    @IBOutlet weak var goalTypeLbl: UILabel!
    @IBOutlet weak var goalProgressLbl: UILabel!
    
    func configureCell(description: String, type: GoalType, progress: Int) {
        self.goalDescriptionLbl.text = description
        self.goalTypeLbl.text = type.rawValue
        self.goalProgressLbl.text = String(describing: progress)
    }

}
