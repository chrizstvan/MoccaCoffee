//
//  Order.swift
//  MoccaCoffee
//
//  Created by Chris Stev on 04/06/20.
//  Copyright © 2020 chrizstvan. All rights reserved.
//

import Foundation

enum CoffeeType: String, Codable, CaseIterable {
    case cappuccino
    case latte
    case frapucino
    case espressino
}

enum CoffeeSize: String, Codable, CaseIterable {
    case small
    case medium
    case large
}

struct Order: Codable {
    let name: String
    let email: String
    let type: CoffeeType
    let size: CoffeeSize
}

//post to web service

extension Order {
    
    init?(_ vm: AddCoffeeOrderViewModel) {
        guard let name = vm.name,
            let email = vm.email,
            let selectedType = CoffeeType(rawValue: vm.selectedType!.lowercased()),
            let selectedSize = CoffeeSize(rawValue: vm.selectedSize!.lowercased())
            else { return nil }
        
        self.name = name
        self.email = email
        self.type = selectedType
        self.size = selectedSize
    }
    
    static var all: Resource<[Order]> = {
        guard let url = URL(string: "https://guarded-retreat-82533.herokuapp.com/orders") else { fatalError("url is incorrect")}
        return Resource<[Order]>(url: url)
    }()
    
    //resource to post / persist data to web server
    static func create(vm: AddCoffeeOrderViewModel) -> Resource<Order?> {
        
        let order = Order(vm)
        guard let url = URL(string: "https://guarded-retreat-82533.herokuapp.com/orders") else { fatalError("url is incorrect")}
        
        guard let dataToPost = try? JSONEncoder().encode(order) else {
            fatalError("error encoding order")
        }
        
        var resource = Resource<Order?>(url: url)
        resource.httpMethod = .post
        resource.body = dataToPost
        
        return resource
    }
}
