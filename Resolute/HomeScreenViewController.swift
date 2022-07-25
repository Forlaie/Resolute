//
//  ViewController.swift
//  Resolute
//
//  Created by Forlaie on 2022-07-12.
//

import UIKit

class HomeScreenViewController: UIViewController {

    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var XPProgressBar: UIProgressView!
    @IBOutlet weak var XPLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateLevelLabel()
        updateXPProgressBar()
        updateXPLabel()
        updateMoneyLabel()
    }
    
    func updateLevelLabel(){
        levelLabel.text = "Level \(player.level)"
    }
    
    func updateXPProgressBar(){
        XPProgressBar.progress = Float(player.xp)/Float(player.lvlupXp)
    }
    
    func updateXPLabel(){
        XPLabel.text = " \(player.xp)/\(player.lvlupXp)"
    }
    
    func updateMoneyLabel(){
        moneyLabel.text = "\(player.money) money"
    }
}

