//
//  StatsViewController.swift
//  Resolute
//
//  Created by Forlaie on 2022-07-12.
//

import UIKit

class CategoryViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textFieldInstructions: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var questsStack: UIStackView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var scroll: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryLabel.backgroundColor = chosenCategory!.backgroundColor
        categoryLabel.text = chosenCategory!.text
        categoryLabel.textColor = chosenCategory!.textColor
        appState = .normal
        updateUI()
        buildQuests()
    }
    
    override func viewDidLayoutSubviews() {
        scroll.contentSize = CGSize(width: scroll.frame.width, height: questsStack.bounds.height + 70)
    }

    @IBAction func addQuest(_ sender: UIButton) {
        appState = .add
        updateUI()
    }
    
    @IBAction func deleteQuest(_ sender: UIButton) {
        appState = .delete
        updateUI()
    }
    
    @IBAction func doneQuest(_ sender: UIButton) {
        var index = 0
        for button in chosenCategory!.questButtons{
            if button == sender.tag{
                chosenCategory!.questHStacks[index].removeFromSuperview()
                questsStack.removeArrangedSubview(chosenCategory!.questHStacks[index])
                chosenCategory!.questButtons.remove(at: index)
                chosenCategory!.questHStacks.remove(at: index)
                chosenCategory!.questTasks[index].state = .completed
                chosenCategory!.questTasks.remove(at: index)
                chosenCategory!.questDeleteButtons.remove(at: index)
                chosenCategory!.questDeleteButtonTags.remove(at: index)
                
                buildQuests()
                appState = .normal
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
            addingQuest()
        case .delete:
            deletingQuest()
        case .normal:
            browsing()
        }
    }
    
    func browsing(){
        for button in chosenCategory!.questDeleteButtons{
            button.isHidden = true
        }
        textField.isHidden = true
        textFieldInstructions.isHidden = true
        questsStack.isHidden = false
        doneButton.isHidden = true
        scroll.isScrollEnabled = true
        addButton.isHidden = false
        deleteButton.isHidden = false
    }
    
    func addingQuest(){
        for button in chosenCategory!.questDeleteButtons{
            button.isHidden = true
        }
        textField.isHidden = false
        textField.becomeFirstResponder()
        textField.text = ""
        textFieldInstructions.isHidden = false
        questsStack.isHidden = true
        doneButton.isHidden = false
        scroll.isScrollEnabled = false
        addButton.isHidden = true
        deleteButton.isHidden = true
    }
    
    func deletingQuest(){
        for button in chosenCategory!.questDeleteButtons{
            button.isHidden = false
        }
        textField.isHidden = true
        textFieldInstructions.isHidden = true
        questsStack.isHidden = false
        doneButton.isHidden = false
        scroll.isScrollEnabled = true
        addButton.isHidden = true
        deleteButton.isHidden = true
    }
    
    @IBAction func chooseQuestToDelete(_ sender: UIButton){
        var index = 0
        for button in chosenCategory!.questDeleteButtonTags{
            if button == sender.tag{
                chosenCategory!.questHStacks[index].removeFromSuperview()
                questsStack.removeArrangedSubview(chosenCategory!.questHStacks[index])
                chosenCategory!.questButtons.remove(at: index)
                chosenCategory!.questHStacks.remove(at: index)
                chosenCategory!.questTasks.remove(at: index)
                chosenCategory!.questDeleteButtons.remove(at: index)
                chosenCategory!.questDeleteButtonTags.remove(at: index)
                
                buildQuests()
                appState = .normal
                updateUI()
                break
            }
            index += 1
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let textFieldContents = textField.text!
        chosenCategory!.questTasks.append(Task(text: textFieldContents, state: .inProgress, dueDate: Date()))
        categories[chosenCategoryIndex!] = chosenCategory!
        
        buildQuests()
        
        appState = .normal
        updateUI()
        return true
    }
    
    func createQuests(){
        for quest in chosenCategory!.questTasks{
            let newQuestButton = UIButton()
            let image = UIImage(systemName: "circle")
            newQuestButton.setImage(image , for: .normal)
            newQuestButton.addTarget(self, action: #selector(doneQuest), for: .touchUpInside)
            
            let newQuestLabel = UILabel()
            newQuestLabel.text = quest.text
            newQuestLabel.numberOfLines = 0
            newQuestLabel.lineBreakMode = .byWordWrapping
            
            if quest.state == .completed{
                newQuestButton.isEnabled = false
                newQuestLabel.textColor = .gray
            }
            
            let newQuestDeleteButton = UIButton()
            newQuestDeleteButton.layer.cornerRadius = 5
            newQuestDeleteButton.setTitle("Delete", for: .normal)
            newQuestDeleteButton.backgroundColor = .red
            newQuestDeleteButton.addTarget(self, action: #selector(chooseQuestToDelete), for: .touchUpInside)
            
            let taskStack = UIStackView()
            taskStack.axis = .horizontal
            taskStack.alignment = .fill
            taskStack.distribution = .equalSpacing
            taskStack.spacing = 10
            
            taskStack.addArrangedSubview(newQuestButton)
            taskStack.addArrangedSubview(newQuestLabel)
            taskStack.addArrangedSubview(newQuestDeleteButton)
            newQuestDeleteButton.isHidden = true
            questsStack.addArrangedSubview(taskStack)
            
            newQuestButton.tag = chosenCategory!.questButtonCount
            newQuestDeleteButton.tag = chosenCategory!.questButtonCount
            
            chosenCategory!.questButtons.append(chosenCategory!.questButtonCount)
            chosenCategory!.questHStacks.append(taskStack)
            chosenCategory!.questDeleteButtons.append(newQuestDeleteButton)
            chosenCategory!.questDeleteButtonTags.append(chosenCategory!.questButtonCount)
            chosenCategory!.questButtonCount += 1
            
            let buttonConstraint = [newQuestButton.widthAnchor.constraint(equalToConstant: 31)]
            NSLayoutConstraint.activate(buttonConstraint)
            let labelConstraint = [newQuestLabel.leadingAnchor.constraint(equalTo: newQuestButton.layoutMarginsGuide.trailingAnchor)]
            NSLayoutConstraint.activate(labelConstraint)
            let deleteButtonConstraint = [newQuestDeleteButton.widthAnchor.constraint(equalToConstant: 70)]
            NSLayoutConstraint.activate(deleteButtonConstraint)
            let stackConstraints = [taskStack.widthAnchor.constraint(equalTo: questsStack.layoutMarginsGuide.widthAnchor)]
            NSLayoutConstraint.activate(stackConstraints)
            newQuestDeleteButton.trailingAnchor.constraint(equalTo: taskStack.layoutMarginsGuide.trailingAnchor).isActive = true
        }
    }
    
    func resetScreen(){
        for quest in questsStack.subviews{
            questsStack.removeArrangedSubview(quest)
            quest.removeFromSuperview()
        }
    }
    
    func buildQuests(){
        resetScreen()
        chosenCategory!.questButtons = []
        chosenCategory!.questButtonCount = 0
        chosenCategory!.questHStacks = []
        chosenCategory!.questDeleteButtons = []
        chosenCategory!.questDeleteButtonTags = []
        createQuests()
        categories[chosenCategoryIndex!] = chosenCategory!
    }
}
