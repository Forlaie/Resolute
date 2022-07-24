//
//  ViewController.swift
//  Resolute
//
//  Created by Forlaie on 2022-07-12.
//

import UIKit

class HomeScreenViewController: UIViewController {

    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLevelLabel()
        updateMoneyLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
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

