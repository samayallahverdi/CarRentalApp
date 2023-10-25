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
                return car.count
            }
            return 0
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
     
                if collectionView == listCollection {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CarListCell", for: indexPath) as! CarListCell
        
                    if search {
                        cell.config(brand: carSearch[indexPath.item].brand ?? "", model: carSearch[indexPath.item].model ?? "", price: carSearch[indexPath.item].price ?? "", engine: carSearch[indexPath.item].engine ?? "", image: carSearch[indexPath.item].carImage ?? "")
        
                    } else {
                        cell.config(brand: car[indexPath.item].brand ?? "", model: car[indexPath.item].model ?? "", price: car[indexPath.item].price ?? "", engine: car[indexPath.item].engine ?? "", image: car[indexPath.item].carImage ?? "")
                    }
                    return cell
        
                }
                    else {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
                    cell.carImage.image = UIImage(named: category[indexPath.item])
                    cell.carCategoryLabel.text = category[indexPath.item]
//                    cell.carCountLabel.text =
//                    let category = CarCategory.allCases[indexPath.item]
//                    cell.carCategoryLabel.text = category.rawValue
//
//                    if let count = categoryCounts[category.rawValue] {
//                        cell.carCategoryCount.text = "\(count)"
//                    } else {
//                        cell.carCategoryCount.text = "0"
//                    }
                    return cell
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
