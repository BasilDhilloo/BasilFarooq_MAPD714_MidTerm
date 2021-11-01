//
//  BasilFarooq_MAPD714_ShppingListApp
//
//  Created by Basil on 30/10/2021.
//

import Foundation

class UserDefaultsManager {
    
    // Singleton
    static let shared = UserDefaultsManager()
    private init() {}
    
    // Public Methods for Read and Write Shopping List from Local Storage
    func save(_ shoppingLists: [ShoppingList]) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(shoppingLists)
            UserDefaults.standard.setValue(data, forKey: "ShoppingLists")
        } catch {
            print(error)
        }
    }
    
    func getShoppingLists() -> [ShoppingList] {
        guard let data = UserDefaults.standard.data(forKey: "ShoppingLists") else { return [] }
        do {
            let decoder = JSONDecoder()
            let lists = try decoder.decode([ShoppingList].self, from: data)
            return lists
        } catch {
            print(error)
        }
        return []
    }
}
