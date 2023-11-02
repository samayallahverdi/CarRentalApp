//
//  VehiclesController.swift
//  CarRentalApp
//
//  Created by BUDLCIT on 2023. 10. 30..
//

import UIKit
import RealmSwift

class VehiclesController: UIViewController {
    
    @IBOutlet weak var listCollection: UICollectionView!
    @IBOutlet weak var searchTextField: UITextField!
    
    let realm = try! Realm()
    let category = ["Standard", "Prestige", "SUV"]
    var car = [CarModel]()
//    var carSearch = [CarModel]()
    var search = false
    var selectedCellIndexPath: IndexPath?
    var originalCarItems = [CarModel]()
    var carsHeaderView = CarsHeaderView()
    var filteredCars: [CarModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        car = originalCarItems
        if let url = realm.configuration.fileURL {
            print(url)
        }
        fetchItems()
        CellRegistration()
        
        
    }
    
    
    @IBAction func searchAction(_ sender: Any) {
        
        let searchText = searchTextField.text ?? ""
        if searchText.isEmpty {
            car = originalCarItems
        } else {
            filteredCars = originalCarItems.filter { $0.brand?.localizedCaseInsensitiveContains(searchText) == true }
            car = filteredCars
        }
        listCollection.reloadData()
    }
}

extension VehiclesController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

            return car.count

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CarListCell", for: indexPath) as! CarListCell
        
        
        cell.config(brand: car[indexPath.item].brand ?? "",
                    model: car[indexPath.item].model ?? "",
                    price: car[indexPath.item].price ?? "",
                    engine: car[indexPath.item].engine ?? "",
                    image: car[indexPath.item].carImage ?? "")
        
        
        return cell
        
    }
    
    
    
    // Header configuration
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CarsHeaderView", for: indexPath) as! CarsHeaderView
        headerView.categorySelectionCallback = {category in
            print("aueeeee\(category)")
            let filteredCars = self.originalCarItems.filter {$0.category == category}
            print("filtered aueee\(filteredCars)")
            self.car = filteredCars
            self.listCollection.reloadData()
        }
        return headerView
    }
    
}
extension VehiclesController {
    func fetchItems() {
        car.removeAll()
        let data = realm.objects(CarModel.self)
        car.append(contentsOf: data)
        originalCarItems.append(contentsOf: data)
        listCollection.reloadData()
    }
    
    func CellRegistration() {
        
        listCollection.register(UINib(nibName: "CarListCell", bundle: nil), forCellWithReuseIdentifier: "CarListCell")
        listCollection.register(UINib(nibName: "\(CategoryCell.self)", bundle: nil),
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: "\(CategoryCell.self)")
    }
}

