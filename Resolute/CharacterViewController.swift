//
//  CharacterViewController.swift
//  Resolute
//
//  Created by Forlaie on 2022-07-24.
//

import UIKit

protocol CharacterTableViewCellDelegate: AnyObject{
    func equipItem(name: String, index: Int)
}

class CharacterViewController: UIViewController {

    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var XPProgressBar: UIProgressView!
    @IBOutlet weak var XPLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    func updateUI() {
        updateLevelLabel()
        updateXPProgressBar()
        updateXPLabel()
        updateMoneyLabel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.allowsSelection = true
        updateUI()
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
        if player.money == 1{
            moneyLabel.text = "\(player.money) starlight"
        }
        else{
            moneyLabel.text = "\(player.money) starlight"
        }
    }
}

extension CharacterViewController: CharacterTableViewCellDelegate {
    func equipItem(name: String, index: Int) {
        if player.inventory[index].equip == false{
            player.inventory[index].equip = true
            equippedItem(name: name)
        }
        else{
            player.inventory[index].equip = false
            unequippedItem(name: name)
        }
        tableView.reloadData()
    }

    func equippedItem(name: String){
        let alert = UIAlertController(title: "Equipped Item!", message: "\(name) has now been equipped onto \(player.username)", preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "Sweet!", style: .default, handler: nil)
        alert.addAction(dismiss)
        present(alert, animated: true, completion: nil)
        tableView.reloadData()
    }

    func unequippedItem(name: String){
        let alert = UIAlertController(title: "Unequipped Item!", message: "\(name) has now been unequipped from \(player.username)", preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "Thanks!", style: .default, handler: nil)
        alert.addAction(dismiss)
        present(alert, animated: true, completion: nil)
        tableView.reloadData()
    }
}

extension CharacterViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return player.inventory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CharacterTableViewCell
        cell.update(with: player.inventory[indexPath.row], index: indexPath.row)
        cell.delegate = self
        return cell
    }
}

