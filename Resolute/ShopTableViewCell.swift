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
        if item.cost == 1{
            itemPrice.text = "\(item.cost) starlight"
        }
        else{
            itemPrice.text = "\(item.cost) starlights"
        }
        itemPrice.tag = item.cost
        purchaseButton.tag = index
        if item.own{
            purchaseButton.isEnabled = false
            purchaseButton.setTitle("Purchased", for: .normal)
        }
        else{
            if item.cost > player.money{
                purchaseButton.isEnabled = false
                purchaseButton.setTitle("Purchase", for: .normal)
            }
            else{
                purchaseButton.isEnabled = true
                purchaseButton.setTitle("Purchase", for: .normal)
            }
        }
    }
    
    @IBAction func buyItem(_ sender: UIButton) {
        delegate?.buyItem(name: itemName.text!, price: itemPrice.tag, index: purchaseButton.tag)
    }
}
