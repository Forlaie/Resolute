//
//  DailiesViewController.swift
//  Resolute
//
//  Created by Forlaie on 2022-07-12.
//

import UIKit

class DailiesViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var XPProgressBar: UIProgressView!
    @IBOutlet weak var XPLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textFieldInstructions: UILabel!
    @IBOutlet weak var dailiesStack: UIStackView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var scroll: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appState = .normal
        updateUI()
        buildDailies()
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
    
    override func viewDidLayoutSubviews() {
        scroll.contentSize = CGSize(width: scroll.frame.width, height: dailiesStack.bounds.height + 60)
    }

    @IBAction func addDaily(_ sender: UIButton) {
        appState = .add
        updateUI()
    }
    
    @IBAction func deleteDaily(_ sender: UIButton) {
        appState = .delete
        updateUI()
    }
    
    func firstDailyDoneAchievement(){
        let alert = UIAlertController(title: "Achievement unlocked!", message: "Completed \"On that daily grind\"", preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "GG", style: .default, handler: nil)
        alert.addAction(dismiss)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func doneDaily(_ sender: UIButton) {
        if !firstDailyDone{
            firstDailyDone = true
            for index in 0..<achievements.count{
                if achievements[index].title == "On that daily grind"{
                    achievements[index].completed = true
                    firstDailyDoneAchievement()
                }
            }
        }
        var index = 0
        for button in dailyButtons{
            if button == sender.tag{
                dailyHStacks[index].removeFromSuperview()
                dailiesStack.removeArrangedSubview(dailyHStacks[index])
                dailyButtons.remove(at: index)
                dailyHStacks.remove(at: index)
                var completedTask = dailyTasks[index]
                completedTask.state = .completed
                dailyTasks.remove(at: index)
                dailyTasks.append(completedTask)
                dailyDeleteButtons.remove(at: index)
                dailyDeleteButtonTags.remove(at: index)
                
                buildDailies()
                appState = .normal
                
                player.xp += 10
                player.money += 5
                updateUI()
                
                break
            }
            index += 1
        }
    }
    
    @IBAction func doneAction(_ sender: UIButton) {
        appState = .normal
        updateUI()
    }
    
    func updateUI(){
        switch appState {
        case .add:
            addingDaily()
        case .delete:
            deletingDaily()
        case .normal:
            browsing()
        }
        
        updateLevelLabel()
        updateXPProgressBar()
        updateXPLabel()
        updateMoneyLabel()
    }
    
    func browsing(){
        for button in dailyDeleteButtons{
            button.isHidden = true
        }
        textField.isHidden = true
        textFieldInstructions.isHidden = true
        dailiesStack.isHidden = false
        doneButton.isHidden = true
        scroll.isScrollEnabled = true
        addButton.isHidden = false
        deleteButton.isHidden = false
    }
    
    func addingDaily(){
        for button in dailyDeleteButtons{
            button.isHidden = true
        }
        textField.isHidden = false
        textField.becomeFirstResponder()
        textField.text = ""
        textField.placeholder = "Enter a daily task here"
        textFieldInstructions.isHidden = false
        dailiesStack.isHidden = true
        doneButton.isHidden = false
        scroll.isScrollEnabled = false
        addButton.isHidden = true
        deleteButton.isHidden = true
    }
    
    func deletingDaily(){
        for button in dailyDeleteButtons{
            button.isHidden = false
        }
        textField.isHidden = true
        textFieldInstructions.isHidden = true
        dailiesStack.isHidden = false
        doneButton.isHidden = false
        scroll.isScrollEnabled = true
        addButton.isHidden = true
        deleteButton.isHidden = true
    }
    
    @IBAction func chooseDailyToDelete(_ sender: UIButton){
        var index = 0
        for button in dailyDeleteButtonTags{
            if button == sender.tag{
                dailyHStacks[index].removeFromSuperview()
                dailiesStack.removeArrangedSubview(dailyHStacks[index])
                dailyButtons.remove(at: index)
                dailyHStacks.remove(at: index)
                dailyTasks.remove(at: index)
                dailyDeleteButtons.remove(at: index)
                dailyDeleteButtonTags.remove(at: index)
                
                buildDailies()
                appState = .normal
                updateUI()
                break
            }
            index += 1
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let textFieldContents = textField.text!
        dailyTasks.append(Task(text: textFieldContents, state: .inProgress, dueDate: Date()))
        buildDailies()
        
        appState = .normal
        updateUI()
        return true
    }
    
    func createDailies(){
        for daily in dailyTasks{
            let newDailyButton = UIButton()
            let image = UIImage(systemName: "circle")
            newDailyButton.setImage(image , for: .normal)
            newDailyButton.addTarget(self, action: #selector(doneDaily), for: .touchUpInside)
            
            let newDailyLabel = UILabel()
            newDailyLabel.text = daily.text
            newDailyLabel.numberOfLines = 0
            newDailyLabel.lineBreakMode = .byWordWrapping
            
            let gainInfo = UIStackView()
            gainInfo.axis = .vertical
            gainInfo.alignment = .fill
            gainInfo.distribution = .fillEqually
            
            let newDailyXPGainLabel = UILabel()
            newDailyXPGainLabel.text = "10 xp"
            newDailyXPGainLabel.font = UIFont.systemFont(ofSize: 15.0)
            newDailyXPGainLabel.textColor = .darkGray
            
            let newDailyMoneyGainLabel = UILabel()
            newDailyMoneyGainLabel.text = "5 money"
            newDailyMoneyGainLabel.font = UIFont.systemFont(ofSize: 15.0)
            newDailyMoneyGainLabel.textColor = .darkGray
            
            gainInfo.addArrangedSubview(newDailyXPGainLabel)
            gainInfo.addArrangedSubview(newDailyMoneyGainLabel)
            
            let newDailyDeleteButton = UIButton()
            newDailyDeleteButton.layer.cornerRadius = 5
            newDailyDeleteButton.setTitle("Delete", for: .normal)
            newDailyDeleteButton.backgroundColor = .red
            newDailyDeleteButton.addTarget(self, action: #selector(chooseDailyToDelete), for: .touchUpInside)
            
            let taskStack = UIStackView()
            taskStack.axis = .horizontal
            taskStack.alignment = .fill
            taskStack.distribution = .equalSpacing
            taskStack.spacing = 10
            
            taskStack.addArrangedSubview(newDailyButton)
            taskStack.addArrangedSubview(newDailyLabel)
            taskStack.addArrangedSubview(gainInfo)
            taskStack.addArrangedSubview(newDailyDeleteButton)
            newDailyDeleteButton.isHidden = true
            dailiesStack.addArrangedSubview(taskStack)
            
            newDailyButton.tag = dailyButtonCount
            newDailyDeleteButton.tag = dailyButtonCount
            
            dailyButtons.append(dailyButtonCount)
            dailyHStacks.append(taskStack)
            dailyDeleteButtons.append(newDailyDeleteButton)
            dailyDeleteButtonTags.append(dailyButtonCount)
            dailyButtonCount += 1
            
            if daily.state == .completed{
                newDailyButton.isEnabled = false
                newDailyLabel.textColor = .gray
                newDailyXPGainLabel.textColor = .lightGray
                newDailyMoneyGainLabel.textColor = .lightGray
            }
            
            let buttonConstraint = [newDailyButton.widthAnchor.constraint(equalToConstant: 31)]
            NSLayoutConstraint.activate(buttonConstraint)
            let labelConstraint = [newDailyLabel.leadingAnchor.constraint(equalTo: newDailyButton.layoutMarginsGuide.trailingAnchor)]
            NSLayoutConstraint.activate(labelConstraint)
            let deleteButtonConstraint = [newDailyDeleteButton.widthAnchor.constraint(equalToConstant: 70)]
            NSLayoutConstraint.activate(deleteButtonConstraint)
            let stackConstraints = [taskStack.widthAnchor.constraint(equalTo: dailiesStack.layoutMarginsGuide.widthAnchor)]
            NSLayoutConstraint.activate(stackConstraints)
            newDailyDeleteButton.trailingAnchor.constraint(equalTo: taskStack.layoutMarginsGuide.trailingAnchor).isActive = true
        }
    }
    
    func resetScreen(){
        for daily in dailiesStack.subviews{
            dailiesStack.removeArrangedSubview(daily)
            daily.removeFromSuperview()
        }
    }
    
    func buildDailies() {
        resetScreen()
        dailyButtons = []
        dailyButtonCount = 0
        dailyHStacks = []
        dailyDeleteButtons = []
        dailyDeleteButtonTags = []
        createDailies()
    }
}
