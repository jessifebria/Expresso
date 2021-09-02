//
//  HompageCollectionViewCell.swift
//  Expresso
//
//  Created by Jessi Febria on 01/05/21.
//

import UIKit

class HompageCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var imagePerson: UIImageView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var imageAdd: UIImageView!
    
    var personData: Person? {
        didSet {
            self.updateCell()
        }
    }
    
    var isAdd : Bool? {
        didSet {
            self.addCell()
        }
    }

    func updateCell(){
        print("UPDATE CELL WITH VALUE")
        imageAdd.isHidden = true
        stackView.isHidden = false
        nameLabel.text = personData!.name
        imagePerson.image = ImageService.getImage(id: Int(personData!.id))
    }
    
    func addCell(){
        print("UPDATE ADD")
        imageAdd.isHidden = false
        stackView.isHidden = true
    }
    
}
