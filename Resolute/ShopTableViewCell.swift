//
//  ShopTableViewCell.swift
//  Resolute
//
//  Created by Forlaie on 2022-07-22.
//

import UIKit

class ShopTableViewCell: UITableViewCell {

    weak var delegate: ShopTableViewCellDelegate?
    @IBOutlet weak var itemGraphic: UIImageView!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var purchaseButton: UIButton!
    
    func update(with item: Item, index: Int){
        itemGraphic.image = item.image
        itemName.text = item.name
        itemPrice.text = "\(item.cost) money"
        itemPrice.tag = item.cost
        purchaseButton.tag = index
        if item.cost > player.money{
            purchaseButton.isEnabled = false
        }
        else{
            purchaseButton.isEnabled = true
        }
    }
    
    @IBAction func buyItem(_ sender: UIButton) {
        delegate?.buyItem(name: itemName.text!, price: itemPrice.tag, index: purchaseButton.tag)
    }
}
