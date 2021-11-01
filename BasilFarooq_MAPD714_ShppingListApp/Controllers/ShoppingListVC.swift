//  FileName : ShoppingListVC.swift
//  BasilFarooq_MAPD714_ShppingListApp
//
//  Created by Basil on 28/10/2021.
//  ID: 301201128
//

import UIKit

protocol ShoppingListVCProtocol: AnyObject {
    func saveShoppingList(shoppingList: ShoppingList)
}

class ShoppingListVC: UIViewController {

    // Outlets
    @IBOutlet weak var listNameTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    // Properties
    weak var delegate: ShoppingListVCProtocol?
    private var items: [Item] = []
    
    // LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
        setupViews()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    // Actions
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        if isValidData() {
            delegate?.saveShoppingList(shoppingList: ShoppingList(name: listNameTextField.text!, Items: items))
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
}

// Private Methods
// Initially I have put quantity and item name to empty and zero
extension ShoppingListVC {
    private func configureItems() {
        items = [Item(name: "", quantity: 0),
                 Item(name: "", quantity: 0),
                 Item(name: "", quantity: 0),
                 Item(name: "", quantity: 0),
                 Item(name: "", quantity: 0),
        ]
    }
    
    private func setupViews() {
        title = "New Shopping List"
        setupButtons()
        setupTableView()
    }
    
    private func setupButtons() {
        saveButton.layer.cornerRadius = 12
        cancelButton.layer.cornerRadius = 12
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.tableFooterView = UIView()
    }
    
    
    // Basic Validation
    // Source: www.tutorialspoi.com/generic-way-to-validate-textfield-inputs-in-swift
    private func isValidData() -> Bool {
        guard let listName = listNameTextField.text?.trimmingCharacters(in: .whitespaces), !listName.isEmpty else {
            showAlert(title: "Sorry", message: "Please enter list name!")
            return false
        }
        for item in items {
            if item.name.trimmingCharacters(in: .whitespaces).isEmpty {
                showAlert(title: "Sorry", message: "Please enter all item names!")
                return false
            } else if item.quantity == 0 {
                showAlert(title: "Sorry", message: "Please choose quantity for item: \(item.name)")
                return false
            }
        }
        return true
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

// TableView Delegate
extension ShoppingListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        cell.configure(with: items[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}

// ItemCell Delegate
extension ShoppingListVC: ItemCellProtocol {
    func itemNameChanged(name: String, cell: ItemCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        items[indexPath.row].name = name
    }
    
    func quantityChanged(quantity: Int, cell: ItemCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        items[indexPath.row].quantity = quantity
    }
}
