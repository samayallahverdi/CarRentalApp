//
//  DataManager.swift
//  CarRentalApp
//
//  Created by BUDLCIT on 2023. 10. 23..
//

import Foundation
import RealmSwift


class CarModel: Object {
    @Persisted var brand: String?
    @Persisted var model: String?
    @Persisted var engine: String?
    @Persisted var price: String?
    @Persisted var category: String = CarCategory.standard.rawValue
    @Persisted var carImage: String?
}
enum CarCategory: String, CaseIterable {
    case standard = "Standard"
    case prestige = "Prestige"
    case suv = "SUV"
}
