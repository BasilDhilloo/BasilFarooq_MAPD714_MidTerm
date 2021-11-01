//  FileName : Item.swift
//  BasilFarooq_MAPD714_ShppingListApp
//
//  Created by Basil on 28/10/2021.
//  ID: 301201128
//

import Foundation

// Model for Item including quantity and item name
struct Item: Codable {
    var name: String
    var quantity: Int
}
