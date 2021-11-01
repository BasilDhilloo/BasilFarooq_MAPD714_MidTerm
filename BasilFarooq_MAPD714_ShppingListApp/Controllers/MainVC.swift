//  FileName : MainVC.swift
//  BasilFarooq_MAPD714_ShppingListApp
//
//  Created by Basil on 28/10/2021.
//  ID: 301201128
//

import UIKit

class MainVC: UIViewController {
    
    // Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // Properties
    private var shoppingLists: [ShoppingList] = []
    
    // LifeCycle Methods will call two functions, loadShopppingLists and setupViews
    override func viewDidLoad() {
        super.viewDidLoad()
        loadShoppingLists()
        setupViews()
    }
}

// Private Methods
extension MainVC {
    private func loadShoppingLists() {
        let shoppingLists = UserDefaultsManager.shared.getShoppingLists()
        self.shoppingLists = shoppingLists
        tableView.reloadData()
    }
    
    private func setupViews() {
        setupNavigationController()
        setupTableView()
    }
    
    
    // Navigation Controller
    private func setupNavigationController() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Shopping Lists"
        let plusButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: self, action: #selector(plusButtonTapped))
        let favoriteButton = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .done, target: self, action: #selector(favoriteButtonTapped))
        navigationItem.rightBarButtonItem = plusButton
        navigationItem.leftBarButtonItem = favoriteButton
    }
    
    @objc private func plusButtonTapped() {
        let shoppingListVC = UIStoryboard(name: "ShoppingList", bundle: nil).instantiateViewController(identifier: "ShoppingListVC") as! ShoppingListVC
//        printContent(<#T##sender: Any?##Any?#>)
        shoppingListVC.delegate = self
        navigationController?.pushViewController(shoppingListVC, animated: true)
    }
    
    @objc private func favoriteButtonTapped() {
        let favoritesVC = UIStoryboard(name: "Favorites", bundle: nil).instantiateViewController(identifier: "FavoritesVC") as! FavoritesVC
        favoritesVC.shoppingLists = shoppingLists.filter({$0.isFavorite == true})
        favoritesVC.delegate = self
//        favoritesVC.delegate = self.favoriteButtonTapped()
        navigationController?.pushViewController(favoritesVC, animated: true)
        
    }
    
    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
}

// TableView Delegate
extension MainVC: UITableViewDelegate, UITableViewDataSource {
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
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completion in
            self?.shoppingLists.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            UserDefaultsManager.shared.save(self!.shoppingLists)
            completion(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let isFavoriteList = shoppingLists[indexPath.row[]].isFavorite
        let isFavoriteList = shoppingLists[indexPath.row].isFavorite
        let favoriteAction = UIContextualAction(style: .normal, title: isFavoriteList ? "Remove from Favorites": "Add to Favorites") { [weak self] _, _, completion in
            self?.shoppingLists[indexPath.row].isFavorite = !isFavoriteList
            UserDefaultsManager.shared.save(self!.shoppingLists)
            completion(true)
            
        }
        return UISwipeActionsConfiguration(actions: [favoriteAction])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension MainVC: ShoppingListVCProtocol {
    func saveShoppingList(shoppingList: ShoppingList) {
        shoppingLists.append(shoppingList)
        tableView.insertRows(at: [IndexPath(row: shoppingLists.count - 1, section: 0)], with: .automatic)
        UserDefaultsManager.shared.save(shoppingLists) // This will add this to local
        // storage
    }
}

extension MainVC: FavoritesVCProtocol {
    func listRemovedFromFavorites(id: String) {
        for (index, list) in shoppingLists.enumerated() {
            guard list.id == id else { continue }
            shoppingLists[index].isFavorite = false
            UserDefaultsManager.shared.save(shoppingLists)
            break
        }
    }
}
