//
//  CarsHeaderView.swift
//  CarRentalApp
//
//  Created by BUDLCIT on 2023. 10. 31..
//

import UIKit
import RealmSwift


class CarsHeaderView: UICollectionReusableView {
    
    @IBOutlet weak var categoryCollection: UICollectionView!
    
    let realm = try! Realm()
    let category = ["Standard", "Prestige", "SUV"]
    var search = false
    var categoryCounts = [String: Int]()
    var selectedCellIndexPath: IndexPath?
    
    //    Step 1
    var categorySelectionCallback: ((String) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if let url = realm.configuration.fileURL {
            print(url)
        }
        
        CellRegistration()
        
    }
    
    
}
extension CarsHeaderView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        for category in CarCategory.allCases {
            let categoryCars = realm.objects(CarModel.self).filter("category = %@", category.rawValue)
            categoryCounts[category.rawValue] = categoryCars.count
        }
        return category.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        let category = CarCategory.allCases[indexPath.item]
        cell.carCategoryLabel.text = category.rawValue
        cell.carImage.image = UIImage(named: category.rawValue)
        
        
        if indexPath == selectedCellIndexPath {
            cell.background.backgroundColor = UIColor.blue
            cell.carCategoryLabel.textColor = .white
            cell.carCountLabel.textColor = .white
        } else {
            cell.background.backgroundColor = UIColor.white
            cell.carCategoryLabel.textColor = .black
            cell.carCountLabel.textColor = .black
        }
        
        if let count = categoryCounts[category.rawValue] {
            cell.carCountLabel.text = "\(count)"
        } else {
            cell.carCountLabel.text = "0"
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        selectedCellIndexPath = indexPath
        categorySelectionCallback?(category[indexPath.item])
        categoryCollection.reloadData()
        
    }


}

extension CarsHeaderView {
    func CellRegistration() {
        
        categoryCollection.register(UINib(nibName: "CategoryCell", bundle: nil), forCellWithReuseIdentifier: "CategoryCell")
    }
}

