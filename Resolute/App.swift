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
    var image: UIImage
    var name: String
    var cost: Int
    var own: Bool
    var equip: Bool
}

struct Player{
    var username: String
    var money: Int
    var level: Int
    var xp: Int
    var lvlupXp: Int
    var inventory: [Item]
    var achievementsFinished: Int
}

struct Achievement{
    var title: String
    var description: String
    //var image: UIImage
    var completed: Bool
    var collected: Bool
    var xp: Int
    var money: Int
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

func sortShopItems() -> [Item]{
    var sortedShopItems: [Item] = []
    var unaffordableShopItems: [Item] = []
    for item in shopItems{
        if item.cost <= player.money{
            sortedShopItems.append(item)
        }
        else{
            unaffordableShopItems.append(item)
        }
    }
    sortedShopItems.append(contentsOf: unaffordableShopItems)
    return sortedShopItems
}

func sortAchievements() -> [Achievement]{
    var sortedAchievements: [Achievement] = []
    var completedAchievements: [Achievement] = []
    var collectedAchievements: [Achievement] = []
    for achievement in achievements{
        if achievement.completed && !achievement.collected{
            sortedAchievements.append(achievement)
        }
        else if !achievement.completed{
            completedAchievements.append(achievement)
        }
        else{
            collectedAchievements.append(achievement)
        }
    }
    sortedAchievements.append(contentsOf: completedAchievements)
    sortedAchievements.append(contentsOf: collectedAchievements)
    return sortedAchievements
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

var shopItems: [Item] = [
    Item(image: UIImage(named: "Hat.png")!, name: "Hat", cost: 10, own: false, equip: false),
    Item(image: UIImage(named: "Shoe.png")!, name: "Shoes", cost: 30, own: false, equip: false),
    Item(image: UIImage(named: "Shirt.png")!, name: "Shirt", cost: 50, own: false, equip: false),
    Item(image: UIImage(named: "Pant.png")!, name: "Pants", cost: 50, own: false, equip: false)
] {
    didSet {
        shopItems = sortShopItems()
    }
}

var player = Player(username: "Forlaie", money: 0, level: 1, xp: 0, lvlupXp: 50, inventory: [], achievementsFinished: 0)

var achievements: [Achievement] = [
    Achievement(title: "On that daily grind", description: "Complete your first daily", completed: true, collected: false, xp: 20, money: 10),
    Achievement(title: "First try baby", description: "Complete your first quest", completed: true, collected: false, xp: 20, money: 10),
    Achievement(title: "Number 2 pencil", description: "Reach level 2", completed: true, collected: false, xp: 30, money: 15)
] {
    didSet {
        achievements = sortAchievements()
    }
}
