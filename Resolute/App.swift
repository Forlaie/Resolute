//
//  App.swift
//  Resolute
//
//  Created by Forlaie on 2022-07-12.
//

import Foundation
import UIKit

struct Task: Equatable{
    var text: String
    var state: TaskState
    var dueDate: Date
}

enum TaskState{
    case inProgress, completed
}

struct Category{
    var text: String
    var textColor: UIColor
    var backgroundColor: UIColor
    
    var questTasks: [Task]
    var questButtons: [Int]
    var questHStacks: [UIView]
    var questButtonCount: Int
    var questDeleteButtons: [UIButton]
    var questDeleteButtonTags: [Int]
}

struct Item{
    //var image: UIImage
    var name: String
    var cost: Int
    var own: Bool
    var equip: Bool
}

struct Player{
    //var username: String
    var money: Int
    var level: Int
    var xp: Int
    var lvlupXp: Int
}

enum AppState{
    case add, delete, normal
}

func sortDailyTasks() -> [Task]{
    var sortedDailyTasks: [Task] = []
    var completedDailyTasks: [Task] = []
    for daily in dailyTasks{
        switch daily.state{
            case .inProgress: sortedDailyTasks.append(daily)
            case .completed: completedDailyTasks.append(daily)
        }
    }
    sortedDailyTasks.append(contentsOf: completedDailyTasks)
    return sortedDailyTasks
}

var appState: AppState = .normal

var dailyTasks: [Task] = [] {
    didSet{
        dailyTasks = sortDailyTasks()
    }
}
var dailyButtons: [Int] = []
var dailyHStacks: [UIView] = []
var dailyButtonCount = 0
var dailyDeleteButtons: [UIButton] = []
var dailyDeleteButtonTags: [Int] = []

var categories: [Category] = []
var categoryDeleteButtons: [UIButton] = []
var categoryDeleteButtonTags: [Int] = []
var categoryButtonCount = 0
var categoryHStacks: [UIView] = []
var categoryText = ""

var chosenCategory: Category?
var chosenCategoryIndex: Int?

//let shopItems = ["Hat", "Scarf", "Glasses", "Shirt", "Pants", "Hoodie", "Shorts", "Gloves", "Shoes", "Boots"]

let shopItems: [Item] = [
    Item(name: "Hat", cost: 10, own: false, equip: false),
    Item(name: "Shirt", cost: 50, own: false, equip: false),
    Item(name: "Pants", cost: 50, own: false, equip: false),
    Item(name: "Shoes", cost: 30, own: false, equip: false)
]

var inventory: [Item] = []

var player = Player(money: 0, level: 1, xp: 0, lvlupXp: 50)
