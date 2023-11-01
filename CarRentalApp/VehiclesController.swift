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
    var carSearch = [CarModel]()
    var search = false
    var filteredCars: [CarModel] = []
    var selectedCellIndexPath: IndexPath?
   
    var carsHeaderView = CarsHeaderView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        if let url = realm.configuration.fileURL {

            print(url)
        }
        fetchItems()
        CellRegistration()
       
//        Step 3
        carsHeaderView.categorySelectionCallback = { cars in
                   
                    self.filteredCars = cars
                    self.listCollection.reloadData()
                }
        
      
    }
    

    @IBAction func searchAction(_ sender: Any) {
        
        let searchText = searchTextField.text ?? ""
          if searchText.isEmpty {
              search = false
              listCollection.reloadData()
          } else {
              filteredCars = car.filter { $0.brand?.localizedCaseInsensitiveContains(searchText) == true }
              search = true
              listCollection.reloadData() 
          }
        
    }
    
}

extension VehiclesController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if search {
                return filteredCars.count
            } else {
                return car.count
            }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
     
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CarListCell", for: indexPath) as! CarListCell
        
        var currentCar: CarModel
        
          if search {
              currentCar = filteredCars[indexPath.item]
          } else {
              currentCar = car[indexPath.item]
          }
        
        cell.config(brand: currentCar.brand ?? "",
                        model: currentCar.model ?? "",
                        price: currentCar.price ?? "",
                        engine: currentCar.engine ?? "",
                        image: currentCar.carImage ?? "")
        
        
        return cell
        
    }
    
    
    
    // Header configuration
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
              let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CarsHeaderView", for: indexPath)
              return headerView
          }
          return UICollectionReusableView()
    }
    
}
extension VehiclesController {
    func fetchItems() {
        car.removeAll()
        let data = realm.objects(CarModel.self)
        car.append(contentsOf: data)
        listCollection?.reloadData()
    }
    
    func CellRegistration() {
        
        listCollection.register(UINib(nibName: "CarListCell", bundle: nil), forCellWithReuseIdentifier: "CarListCell")
        listCollection.register(UINib(nibName: "\(CategoryCell.self)", bundle: nil),
                            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                            withReuseIdentifier: "\(CategoryCell.self)")
    }
}

