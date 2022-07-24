//
//  CharacterViewController.swift
//  Resolute
//
//  Created by Forlaie on 2022-07-24.
//

import UIKit

class CharacterViewController: UIViewController {

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
