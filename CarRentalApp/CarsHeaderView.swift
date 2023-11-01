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
    var car = [CarModel]()
    var carSearch = [CarModel]()
    var search = false

    var filteredCars: [CarModel] = []
    var selectedCellIndexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        if let url = realm.configuration.fileURL {

            print(url)
        }
        
        fetchItems()
        CellRegistration()
        
    }
    
  
    
}
extension CarsHeaderView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        category.count
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
    
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        cell.carCategoryLabel.text = category[indexPath.item]
        
        if indexPath == selectedCellIndexPath {
            cell.background.backgroundColor = UIColor.blue
        } else {
            cell.background.backgroundColor = UIColor.white
            
            
            
            let standardCarCount = car.filter { $0.category == CarCategory.standard.rawValue }.count
            let prestigeCarCount = car.filter { $0.category == CarCategory.prestige.rawValue }.count
            let suvCarCount = car.filter { $0.category == CarCategory.suv.rawValue }.count
            
            
            cell.carImage.image = UIImage(named: category[indexPath.item])
            cell.carCategoryLabel.text = category[indexPath.item]
            
            switch category[indexPath.item] {
            case CarCategory.standard.rawValue:
                cell.carCountLabel.text = "\(standardCarCount)"
            case CarCategory.prestige.rawValue:
                cell.carCountLabel.text = "\(prestigeCarCount)"
            case CarCategory.suv.rawValue:
                cell.carCountLabel.text = "\(suvCarCount)"
            default:
                cell.carCountLabel.text = "0"
            }
//            cell.background.backgroundColor = UIColor.white
        }
        
        
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let previousSelectedIndexPath = selectedCellIndexPath {
              
                let previousSelectedCell = collectionView.cellForItem(at: previousSelectedIndexPath) as? CategoryCell
                previousSelectedCell?.background.backgroundColor = UIColor.white
            }

            selectedCellIndexPath = indexPath

            let selectedCell = collectionView.cellForItem(at: indexPath) as? CategoryCell
            selectedCell?.background.backgroundColor = UIColor.blue
        
       print("basanda isleyir ama sekiller gelmir")
        print(filteredCars)
        

        
        if collectionView == categoryCollection {
            
            
            selectedCellIndexPath = indexPath
                       let selectedCategory = category[indexPath.item]
                       filteredCars = car.filter { $0.category == selectedCategory }
                       categoryCollection.reloadData()
                

            }
    }
}

extension CarsHeaderView {
    func fetchItems() {
        car.removeAll()
        let data = realm.objects(CarModel.self)
        car.append(contentsOf: data)
        categoryCollection?.reloadData()
        
              }
          

    func CellRegistration() {

        categoryCollection.register(UINib(nibName: "CategoryCell", bundle: nil), forCellWithReuseIdentifier: "CategoryCell")

//                categoryCollection.register(UINib(nibName: "\(CategoryCell.self)", bundle: nil),
//                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
//                    withReuseIdentifier: "\(CategoryCell.self)")

    }
}
