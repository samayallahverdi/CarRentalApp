//
//  CarListCell.swift
//  CarRentalApp
//
//  Created by BUDLCIT on 2023. 10. 24..
//

import UIKit

class CarListCell: UICollectionViewCell {

    @IBOutlet weak var background: UIView!
    @IBOutlet weak var carImage: UIImageView!
    @IBOutlet weak var carBrand: UILabel!
    @IBOutlet weak var carPrice: UILabel!
    @IBOutlet weak var carModel: UILabel!
    @IBOutlet weak var carEngine: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        background.layer.cornerRadius = 20
        
    }
    
    func config(brand: String, model: String, price: String, engine: String, image: String){
        
        carImage.image = UIImage(named: image)
        carBrand.text = brand
        carModel.text = model
        carPrice.text = price
        carEngine.text = engine
        
    }
}
