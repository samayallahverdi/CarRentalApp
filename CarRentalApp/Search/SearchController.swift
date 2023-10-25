//
//  SearchController.swift
//  CarRentalApp
//
//  Created by BUDLCIT on 2023. 10. 23..
//

import UIKit
import RealmSwift

class SearchController: UIViewController {

    @IBOutlet weak var searchTableCollection: UICollectionView!

    let realm = try! Realm()
    var carList = [CarModel]()
    var carSearch = [CarModel]()
    var search = false
    let searchController = UISearchController(searchResultsController: nil)



    override func viewDidLoad() {
        super.viewDidLoad()
       

        if let url = realm.configuration.fileURL {

            print(url)
        }
        fetchItems()
        configSearchController()
        
        
        searchTableCollection.register(UINib(nibName: "CarListCell", bundle: nil), forCellWithReuseIdentifier: "CarListCell")
    }



}
extension SearchController {
    func fetchItems() {
        carList.removeAll()
        let data = realm.objects(CarModel.self)
        carList.append(contentsOf: data)
        searchTableCollection.reloadData()
    }
}

// SeachBar Configuration

extension SearchController: UISearchBarDelegate, UISearchResultsUpdating {


    func configSearchController(){
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.placeholder = "Enter the car name..."
    }

    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            search = true
            carSearch = carList.filter { car in
                if let model = car.model {
                    return model.lowercased().contains(searchText.lowercased())
                }
                return false
            }
        }  else {

            search = false
            carSearch.removeAll()
            carSearch = carList

        }
        searchTableCollection.reloadData()
    }


}


extension SearchController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if search {

            return carSearch.count

        }else {

            return carList.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CarListCell", for: indexPath) as! CarListCell

        if search {

            cell.config(brand: carSearch[indexPath.item].brand ?? "", model: carSearch[indexPath.item].model ?? "", price: carSearch[indexPath.item].price ?? "", engine: carSearch[indexPath.item].engine ?? "", image: carSearch[indexPath.item].carImage ?? "")

        } else {
            cell.config(brand: carList[indexPath.item].brand ?? "", model: carList[indexPath.item].model ?? "", price: carList[indexPath.item].price ?? "", engine: carList[indexPath.item].engine ?? "", image: carList[indexPath.item].carImage ?? "")

        }
        return cell

    }

}
