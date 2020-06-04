//
//  AddOrderViewController.swift
//  MoccaCoffee
//
//  Created by Chris Stev on 04/06/20.
//  Copyright © 2020 chrizstvan. All rights reserved.
//

import UIKit

protocol AddOrderDelegate {
    func addOrderVCDidSave(order: Order, controller: UIViewController)
    func addOrderVCDidClose(controller: UIViewController)
}

class AddOrderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    var delegate: AddOrderDelegate?
    
    private var coffeSizeSegmentedControl: UISegmentedControl!

    private var vm = AddCoffeeOrderViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        setupUI()
    }
    
    private func setupUI() {
        coffeSizeSegmentedControl = UISegmentedControl(items: vm.sizes)
        coffeSizeSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(coffeSizeSegmentedControl)
        coffeSizeSegmentedControl.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 20).isActive = true
        coffeSizeSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.type.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CoffeTypeCellId", for: indexPath)
        
        cell.textLabel?.text = self.vm.type[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
    @IBAction func closeDidTapped(_ sender: Any) {
        if let delegate = self.delegate {
            delegate.addOrderVCDidClose(controller: self)
        }
    }
    
    @IBAction func saveDidTapped(_ sender: Any) {
        
        let name = nameTextField.text
        let email = emailTextField.text
        let selectedSize = coffeSizeSegmentedControl.titleForSegment(at: coffeSizeSegmentedControl.selectedSegmentIndex)
        
        guard let selectedIndexPath = tableView.indexPathForSelectedRow else {
            fatalError("error in selecting coffee")
        }
        //populate to view model
        vm.name = name
        vm.email = email
        vm.selectedSize = selectedSize
        vm.selectedType = vm.type[selectedIndexPath.row]
        
        Webservice().load(resource: Order.create(vm: vm)) { [weak self] (result) in
            guard let strSelf = self else { return }
            switch result {
            case .success(let order):
                if let order = order, let delegate = strSelf.delegate {
                    DispatchQueue.main.async {
                        delegate.addOrderVCDidSave(order: order, controller: strSelf)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
