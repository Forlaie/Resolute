//
//  AchievementsViewController.swift
//  Resolute
//
//  Created by Forlaie on 2022-07-12.
//

import UIKit

class AchievementsViewController: UIViewController {
    
    /*
     // MARK: - Pseudocode
     Achievements should be in a vertical stack view
     
     they should be their own custom type with name, image, coins
     should have an enum for inProgress, completed, collected
     
     Progress Bar:
     progressView = outlet of progress bar
     let progress = Progress(totalUnitCount: #)
     self.progress.completedUnitCount += 1
     let progressFloat = Float(self.progress.fractionCompleted)
     self.progressView.setProgress(progressFloat, animated: true)
    */

    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLevelLabel()
        updateMoneyLabel()
    }
    
    func updateLevelLabel(){
        levelLabel.text = "Level \(player.level)"
    }
    
    func updateMoneyLabel(){
        moneyLabel.text = "\(player.money) money"
    }
}
