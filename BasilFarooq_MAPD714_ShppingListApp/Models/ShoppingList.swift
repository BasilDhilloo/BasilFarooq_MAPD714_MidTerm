//
//  BasilFarooq_MAPD714_ShppingListApp
//
//  Created by Basil on 28/10/2021.
//

import Foundation

// Model for Shopping List including array for Items
struct ShoppingList: Codable {
    var id = UUID().uuidString
    let name: String
    var Items: [Item]
    var isFavorite = false
}
