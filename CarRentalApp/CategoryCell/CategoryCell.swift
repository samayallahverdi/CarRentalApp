//
//  CategoryCell.swift
//  CarRentalApp
//
//  Created by BUDLCIT on 2023. 10. 24..
//

import UIKit

class CategoryCell: UICollectionViewCell {

    @IBOutlet weak var background: UIView!
    @IBOutlet weak var carImage: UIImageView!
    @IBOutlet weak var carCategoryLabel: UILabel!
    @IBOutlet weak var carCountLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        background.layer.cornerRadius = 20
        
    }

}
