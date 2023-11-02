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
        let category = CarCategory.allCases[indexPath.item]
    
        
        if let previousIndexPath = selectedCellIndexPath {         // Deselect the previously selected cell and reset its background color
            collectionView.deselectItem(at: previousIndexPath, animated: true)
            if let previousCell = collectionView.cellForItem(at: previousIndexPath) as? CategoryCell {
                previousCell.background.backgroundColor = .white // Change to the default background color
                previousCell.carCategoryLabel.textColor = .black
                previousCell.carCountLabel.textColor = .lightGray
            }
        }
        
        selectedCellIndexPath = indexPath
        if let selectedCell = collectionView.cellForItem(at: indexPath) as? CategoryCell {
           
            selectedCell.background.backgroundColor = .blue
            selectedCell.carCategoryLabel.textColor = .white
            selectedCell.carCountLabel.textColor = .white
        }
        categorySelectionCallback?(category.rawValue)
        categoryCollection.reloadData()
        
    }


}

extension CarsHeaderView {
    func CellRegistration() {
        
        categoryCollection.register(UINib(nibName: "CategoryCell", bundle: nil), forCellWithReuseIdentifier: "CategoryCell")
        
        //                categoryCollection.register(UINib(nibName: "\(CategoryCell.self)", bundle: nil),
        //                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
        //                    withReuseIdentifier: "\(CategoryCell.self)")
        
    }
}

