//
//  AchievementTableViewCell.swift
//  Resolute
//
//  Created by Forlaie on 2022-07-25.
//

import UIKit

class AchievementTableViewCell: UITableViewCell {

    weak var delegate: AchievementTableViewCellDelegate?
    @IBOutlet weak var achievementGraphic: UIImageView!
    @IBOutlet weak var achievementTitleLabel: UILabel!
    @IBOutlet weak var achievementDescriptionLabel: UILabel!
    @IBOutlet weak var collectButton: UIButton!
    @IBOutlet weak var XPLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    
    func update(with achievement: Achievement, index: Int){
        achievementGraphic.image = achievement.image
        achievementTitleLabel.text = achievement.title
        achievementDescriptionLabel.text = achievement.description
        
        if achievement.completed{
            collectButton.isEnabled = true
            collectButton.setTitle("Collect", for: .normal)
            XPLabel.textColor = .darkGray
            moneyLabel.textColor = .darkGray
        }
        else{
            collectButton.isEnabled = false
            collectButton.setTitle("Collect", for: .normal)
            XPLabel.textColor = .darkGray
            moneyLabel.textColor = .darkGray
        }
        
        if achievement.collected{
            collectButton.isEnabled = false
            collectButton.setTitle("Collected", for: .normal)
            XPLabel.textColor = .lightGray
            moneyLabel.textColor = .lightGray
        }
        
        collectButton.tag = index
        XPLabel.text = "\(achievement.xp) xp"
        moneyLabel.text = "\(achievement.money) money"
    }
    
    @IBAction func collectAchievement(_ sender: UIButton) {
        delegate?.collectAchievement(index: collectButton.tag)
    }
}
