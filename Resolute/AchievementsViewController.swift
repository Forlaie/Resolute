//
//  AchievementsViewController.swift
//  Resolute
//
//  Created by Forlaie on 2022-07-12.
//

import UIKit

protocol AchievementTableViewCellDelegate: AnyObject{
    func collectAchievement(index: Int)
}

class AchievementsViewController: UIViewController {

    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var XPProgressBar: UIProgressView!
    @IBOutlet weak var XPLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var completionLabel: UILabel!
    @IBOutlet weak var completionProgressBar: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.allowsSelection = false
        updateUI()
    }
    
    func updateLevelLabel(){
        if player.xp >= player.lvlupXp{
            player.xp -= player.lvlupXp
            player.level += 1
            player.lvlupXp = 50 * player.level
            //leveledUp()
            if player.level == 2{
                for index in 0..<achievements.count{
                    if achievements[index].title == "Number 2 pencil"{
                        achievements[index].completed = true
                        level2Achievement()
                    }
                }
            }
        }
        levelLabel.text = "Level \(player.level)"
    }
    
    func level2Achievement(){
        let alert = UIAlertController(title: "Achievement unlocked!", message: "Completed \"Number 2 pencil\"", preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "GG", style: .default, handler: nil)
        alert.addAction(dismiss)
        present(alert, animated: true, completion: nil)
    }
    
//    func leveledUp(){
//        let alert = UIAlertController(title: "Leveled up!", message: "\(player.username) is now level \(player.level)!", preferredStyle: .alert)
//        let dismiss = UIAlertAction(title: "GG!", style: .default, handler: nil)
//        alert.addAction(dismiss)
//        present(alert, animated: true, completion: nil)
//    }
    
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
    
    func updateCompletionLabel(){
        let number = Int(Float(player.achievementsFinished)/Float(achievements.count)*100.0)
        completionLabel.text = "\(number)%"
    }
    
    func updateCompletionProgressBar(){
        completionProgressBar.progress = Float(player.achievementsFinished)/Float(achievements.count)
    }
    
    func updateUI() {
        updateLevelLabel()
        updateXPProgressBar()
        updateXPLabel()
        updateMoneyLabel()
        updateCompletionLabel()
        updateCompletionProgressBar()
    }
}

extension AchievementsViewController: AchievementTableViewCellDelegate {
    
    func collectAchievement(index: Int){
        player.achievementsFinished += 1
        player.xp += achievements[index].xp
        player.money += achievements[index].money
        var achievement = achievements[index]
        achievement.collected = true
        achievements.remove(at: index)
        achievements.append(achievement)
        updateUI()
        tableView.reloadData()
        //collectAchievement(achievement: achievements[index])
    }

//    func collectAchievement(achievement: Achievement){
//        let alert = UIAlertController(title: "Completed \(achievement.title)", message: "Collected \(achievement.xp)XP and \(achievement.money) money!", preferredStyle: .alert)
//        let dismiss = UIAlertAction(title: "GG", style: .default, handler: nil)
//        alert.addAction(dismiss)
//        present(alert, animated: true, completion: nil)
//        tableView.reloadData()
//    }
}

extension AchievementsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return achievements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AchievementTableViewCell
        cell.update(with: achievements[indexPath.row], index: indexPath.row)
        cell.delegate = self
        return cell
    }
}
