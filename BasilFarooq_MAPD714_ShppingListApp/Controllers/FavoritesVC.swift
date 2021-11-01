//
//  BasilFarooq_MAPD714_ShppingListApp
//
//  Created by Basil on 30/10/2021.
//

import UIKit

protocol FavoritesVCProtocol: AnyObject {
    func listRemovedFromFavorites(id: String)
}

class FavoritesVC: UIViewController {

    // Outlets
    @IBOutlet weak var tableView: UITableView!

    // Properties
    var shoppingLists: [ShoppingList] = []
    weak var delegate: FavoritesVCProtocol?
    
    // LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
}

// Private Methods
extension FavoritesVC {
    private func setupViews() {
        setupNavigationController()
        setupTableView()
    }
    
    private func setupNavigationController() {
        title = "Favorites"
    }
    
    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
}

// TableView Delegate
extension FavoritesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        shoppingLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = shoppingLists[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Remove From Favorites") { [weak self] _, _, completion in
            self?.delegate?.listRemovedFromFavorites(id: self!.shoppingLists[indexPath.row].id)
            self?.shoppingLists.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
