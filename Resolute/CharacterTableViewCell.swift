//
//  CharacterTableViewCell.swift
//  Resolute
//
//  Created by Forlaie on 2022-07-24.
//

import UIKit

class CharacterTableViewCell: UITableViewCell {

    weak var delegate: CharacterTableViewCellDelegate?
    @IBOutlet weak var itemGraphic: UIImageView!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var equipButton: UIButton!
    
    func update(with item: Item, index: Int){
        itemName.text = item.name
        if !item.equip{
            equipButton.setTitle("Equip", for: .normal)
        }
        else{
            equipButton.setTitle("Unequip", for: .normal)
        }
        equipButton.tag = index
    }
    
    @IBAction func equipItem(_ sender: UIButton) {
        delegate?.equipItem(name: itemName.text!, index: equipButton.tag)
    }
}
