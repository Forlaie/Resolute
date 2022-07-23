//
//  QuestsViewController.swift
//  Resolute
//
//  Created by Forlaie on 2022-07-12.
//

import UIKit

class QuestsViewController: UIViewController, UITextFieldDelegate, UIColorPickerViewControllerDelegate {
    
    @IBOutlet weak var categoryStack: UIStackView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textFieldInstructions: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var scroll: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appState = .normal
        updateUI()
        buildCategories()
    }
    
    override func viewDidLayoutSubviews() {
        scroll.contentSize = CGSize(width: scroll.frame.width, height: categoryStack.bounds.height + 150)
    }

    @IBAction func addCategory(_ sender: UIButton) {
        appState = .add
        updateUI()
    }
    
    @IBAction func deleteCategory(_ sender: UIButton) {
        appState = .delete
        updateUI()
    }
    
    @IBAction func switchScreens(_ sender: UIButton) {
        var index = 0
        for category in categories{
            if category.text == sender.currentTitle! && category.backgroundColor == sender.backgroundColor{
                chosenCategory = category
                chosenCategoryIndex = index
            }
            index += 1
        }
        performSegue(withIdentifier: "goToCategoryQuests", sender: self)
    }
    
    @IBAction func doneAction(_ sender: UIButton) {
        if appState == .add{
            categories.removeLast()
            buildCategories()
        }
        appState = .normal
        updateUI()
    }
    
    func updateUI(){
        switch appState {
        case .add:
            addingCategory()
        case .delete:
            deletingCategory()
        case .normal:
            browsing()
        }
    }
    
    func browsing(){
        for button in categoryDeleteButtons{
            button.isHidden = true
        }
        textField.isHidden = true
        textFieldInstructions.isHidden = true
        categoryStack.isHidden = false
        doneButton.isHidden = true
        scroll.isScrollEnabled = true
        addButton.isHidden = false
        deleteButton.isHidden = false
    }
    
    func addingCategory(){
        for button in categoryDeleteButtons{
            button.isHidden = true
        }
        textField.isHidden = false
        textField.becomeFirstResponder()
        textField.text = ""
        textFieldInstructions.isHidden = false
        categoryStack.isHidden = true
        doneButton.isHidden = false
        scroll.isScrollEnabled = false
        addButton.isHidden = true
        deleteButton.isHidden = true
        appState = .normal
    }
    
    func deletingCategory(){
        for button in categoryDeleteButtons{
            button.isHidden = false
        }
        textField.isHidden = true
        textFieldInstructions.isHidden = true
        categoryStack.isHidden = false
        doneButton.isHidden = false
        scroll.isScrollEnabled = true
        addButton.isHidden = true
        deleteButton.isHidden = true
    }
    
    @IBAction func chooseCategoryToDelete(_ sender: UIButton){
        var index = 0
        for button in categoryDeleteButtonTags{
            if button == sender.tag{
                categoryHStacks[index].removeFromSuperview()
                categoryStack.removeArrangedSubview(categoryHStacks[index])
                categoryHStacks.remove(at: index)
                categories.remove(at: index)
                categoryDeleteButtons.remove(at: index)
                categoryDeleteButtonTags.remove(at: index)
                
                buildCategories()
                appState = .normal
                updateUI()
                break
            }
            index += 1
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let textFieldContents = textField.text!
        categories.append(Category(text: textFieldContents, textColor: .white, backgroundColor: .blue, questTasks: [], questButtons: [], questHStacks: [], questButtonCount: 0, questDeleteButtons: [], questDeleteButtonTags: []))
        doneButton.isHidden = false
        appState = .add
        buildCategories()
        
        let colourPickerVC = UIColorPickerViewController()
        colourPickerVC.delegate = self
        present(colourPickerVC, animated: true)
        return true
    }
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        categories[categories.count-1].backgroundColor = viewController.selectedColor
        buildCategories()
        appState = .normal
        updateUI()
    }
    
    func createCategories(){
        for category in categories{
            let newCategory = UIButton()
            newCategory.layer.cornerRadius = 5
            newCategory.backgroundColor = category.backgroundColor
            newCategory.setTitle(category.text, for: .normal)
            newCategory.titleLabel?.font = .systemFont(ofSize: 30)
            newCategory.titleLabel?.numberOfLines = 1
            newCategory.titleLabel?.adjustsFontSizeToFitWidth = true
            let constraint = [newCategory.heightAnchor.constraint(equalToConstant: 70), newCategory.widthAnchor.constraint(equalToConstant: 300)]
            NSLayoutConstraint.activate(constraint)
            newCategory.addTarget(self, action: #selector(switchScreens), for: .touchUpInside)
            
            let newCategoryDeleteButton = UIButton()
            newCategoryDeleteButton.layer.cornerRadius = 5
            newCategoryDeleteButton.setTitle("Delete", for: .normal)
            newCategoryDeleteButton.backgroundColor = .red
            let deleteButtonConstraint = [newCategoryDeleteButton.widthAnchor.constraint(equalToConstant: 70)]
            NSLayoutConstraint.activate(deleteButtonConstraint)
            newCategoryDeleteButton.addTarget(self, action: #selector(chooseCategoryToDelete), for: .touchUpInside)
            
            let stack = UIStackView()
            stack.axis = .horizontal
            stack.alignment = .fill
            stack.distribution = .equalSpacing
            stack.spacing = 10
            
            stack.addArrangedSubview(newCategory)
            stack.addArrangedSubview(newCategoryDeleteButton)
            newCategoryDeleteButton.isHidden = true
            categoryStack.addArrangedSubview(stack)

            newCategoryDeleteButton.tag = categoryButtonCount

            categoryHStacks.append(stack)
            categoryDeleteButtons.append(newCategoryDeleteButton)
            categoryDeleteButtonTags.append(categoryButtonCount)
            categoryButtonCount += 1
        }
    }
    
    func resetScreen(){
        for category in categoryStack.subviews{
            categoryStack.removeArrangedSubview(category)
            category.removeFromSuperview()
        }
    }
    
    func buildCategories() {
        resetScreen()
        categoryButtonCount = 0
        categoryHStacks = []
        categoryDeleteButtons = []
        categoryDeleteButtonTags = []
        createCategories()
    }
    
}
