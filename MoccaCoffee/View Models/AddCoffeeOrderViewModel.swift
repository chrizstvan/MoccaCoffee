//
//  AddCoffeeOrderViewModel.swift
//  MoccaCoffee
//
//  Created by Chris Stev on 04/06/20.
//  Copyright © 2020 chrizstvan. All rights reserved.
//

import Foundation

struct AddCoffeeOrderViewModel {
    
    var name: String?
    var email: String?
    var selectedSize: String?
    var selectedType: String?
    
    var type: [String] {
        return CoffeeType.allCases.map { $0.rawValue.capitalized }
    }
    
    var sizes: [String] {
        return CoffeeSize.allCases.map { $0.rawValue.capitalized }
    }
}
