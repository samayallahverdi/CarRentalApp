//
//  VehicleController.swift
//  CarRentalApp
//
//  Created by BUDLCIT on 2023. 10. 23..
//

import UIKit
import RealmSwift

class VehicleController: UIViewController {
    
    
    @IBOutlet weak var categoryCollection: UICollectionView!
    @IBOutlet weak var listCollection: UICollectionView!
    
    let realm = try! Realm()
    let category = ["Standard", "Prestige", "SUV"]
    var car = [CarModel]()
    var carSearch = [CarModel]()
    var search = false
    let searchController = UISearchController(searchResultsController: nil)
    var categoryCounts: [String: Int] = [:]
    var filteredCars: [CarModel] = []
    var carListDataSource: [CarModel] = []
    var selectedCellIndexPath: IndexPath?
    var filteredCarsDataSource: [CarModel] = []
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = realm.configuration.fileURL {
            
            print(url)
        }
        fetchItems()
        configureSearchController()
        CellRegistration()
        
        
        
    }
}

extension VehicleController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if search {
            return carSearch.count
        } else {
            if collectionView == categoryCollection {
                return category.count
            } else if collectionView == listCollection {
               
                    return filteredCars.count
                
            }
            return 0
        }
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == listCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CarListCell", for: indexPath) as! CarListCell
            
            if search {
                cell.config(brand: carSearch[indexPath.item].brand ?? "",
                            model: carSearch[indexPath.item].model ?? "",
                            price: carSearch[indexPath.item].price ?? "",
                            engine: carSearch[indexPath.item].engine ?? "",
                            image: carSearch[indexPath.item].carImage ?? "")
                
            } else {
                cell.config(brand: filteredCars[indexPath.item].brand ?? "",
                            model: filteredCars[indexPath.item].model ?? "",
                            price: filteredCars[indexPath.item].price ?? "",
                            engine: filteredCars[indexPath.item].engine ?? "",
                            image: filteredCars[indexPath.item].carImage ?? "")
                
            }
            return cell
            
        }
        else {
            
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
                   cell.background.backgroundColor = UIColor.white
                }

               
            
            
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Background configure
        
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
                       listCollection.reloadData()
                

            }

    }
        

}



//SearchBar Configuration
extension VehicleController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            carSearch = car.filter { car in
                if let model = car.model {
                    return model.lowercased().contains(searchText.lowercased())
                }
                return false
            }
            search = true
        } else {
            carSearch.removeAll()
            search = false
        }
        listCollection.reloadData()
    }
    
    func configureSearchController() {
        searchController.searchBar.placeholder = "Search for a car"
        searchController.searchBar.layer.masksToBounds = true
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
}


// Other functions
extension VehicleController {
    func fetchItems() {
        car.removeAll()
        let data = realm.objects(CarModel.self)
        car.append(contentsOf: data)
        categoryCollection?.reloadData()
    }
    
    func CellRegistration() {
        categoryCollection.register(UINib(nibName: "CategoryCell", bundle: nil), forCellWithReuseIdentifier: "CategoryCell")
        listCollection.register(UINib(nibName: "CarListCell", bundle: nil), forCellWithReuseIdentifier: "CarListCell")
    }
    
}
