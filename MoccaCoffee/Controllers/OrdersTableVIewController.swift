//
//  OrdersTableVIewController.swift
//  MoccaCoffee
//
//  Created by Chris Stev on 04/06/20.
//  Copyright © 2020 chrizstvan. All rights reserved.
//

import UIKit

class OrdersTableViewController: UITableViewController, AddOrderDelegate {
    
    var orderListVM = OrderListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        populateOrders()
    }
    
    private func populateOrders() {
        
        Webservice().load(resource: Order.all) {[weak self] (result) in
            switch result {
            case .success(let orders):
                self?.orderListVM.ordersViewModel = orders.map{ OrderViewModel.init(order: $0) }
                self?.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //segue navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navC = segue.destination as? UINavigationController,
            let addCoffeOrderVC = navC.viewControllers.first as? AddOrderViewController else {
                fatalError("erorr performing segue")
        }
        
        addCoffeOrderVC.delegate = self
    }
    
    //delegate action
    func addOrderVCDidSave(order: Order, controller: UIViewController) {
        controller.dismiss(animated: true, completion: nil)
        
        let orderVM = OrderViewModel(order: order)
        self.orderListVM.ordersViewModel.append(orderVM)
        self.tableView.insertRows(at: [IndexPath.init(row: self.orderListVM.ordersViewModel.count - 1, section: 0)], with: .automatic)
        //tableView.reloadData()
    }
    
    func addOrderVCDidClose(controller: UIViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orderListVM.ordersViewModel.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let vm = self.orderListVM.orderViewModel(at: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCellId", for: indexPath)
        
        cell.textLabel?.text = vm.type
        cell.detailTextLabel?.text = vm.size
        
        return cell
    }
}
