//
//  ShopViewController.swift
//  Resolute
//
//  Created by Forlaie on 2022-07-12.
//

import UIKit

protocol ShopTableViewCellDelegate: AnyObject{
    func buyItem(name: String, price: Int, index: Int)
}

class ShopViewController: UIViewController {

    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var XPProgressBar: UIProgressView!
    @IBOutlet weak var XPLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.allowsSelection = false
        updateUI()
    }
    
    func updateUI() {
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
        if player.money == 1{
            moneyLabel.text = "\(player.money) starlight"
        }
        else{
            moneyLabel.text = "\(player.money) starlights"
        }
    }
}

extension ShopViewController: ShopTableViewCellDelegate {
    func buyItem(name: String, price: Int, index: Int) {
        purchaseSuccess(name: name)
        player.money -= price
        player.inventory.append(shopItems[index])
        var item = shopItems[index]
        item.own = true
        shopItems.remove(at: index)
        shopItems.append(item)
        updateUI()
        tableView.reloadData()
        //        if player.money < price{
        //            purchaseFailure(name: name)
        //        }
        //        else{
        //            purchaseSuccess(name: name)
        //            player.money -= price
        //            player.inventory.append(shopItems[index])
        //            updateMoneyLabel()
        //        }
    }
    
    func purchaseSuccess(name: String){
        let alert = UIAlertController(title: "Successful Purchase!", message: "\(name) has now been added to your inventory", preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "Sweet!", style: .default, handler: nil)
        alert.addAction(dismiss)
        present(alert, animated: true, completion: nil)
    }
    
//    func purchaseFailure(name: String){
//        let alert = UIAlertController(title: "Purchase Failure", message: "You do not have enough money to purchase \(name)", preferredStyle: .alert)
//        let dismiss = UIAlertAction(title: "Nooo", style: .default, handler: nil)
//        alert.addAction(dismiss)
//        present(alert, animated: true, completion: nil)
//    }
}

extension ShopViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shopItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ShopTableViewCell
        cell.update(with: shopItems[indexPath.row], index: indexPath.row)
        cell.delegate = self
        return cell
    }
}
