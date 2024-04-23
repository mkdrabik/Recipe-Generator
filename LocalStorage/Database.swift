//
//  Database.swift
//  Foody
//
//  Created by Mason Drabik on 4/10/24.
//

import Foundation
import SwiftUI

final class Database{
    private let FOOD_KEY = "food_key"
    
    func save(items: Set<RecipeItem>) {
        let array = Array(items)
        let data = try? JSONEncoder().encode(array)
        UserDefaults.standard.set(data, forKey: FOOD_KEY)
    }
    
    func load() -> Set<RecipeItem> {
//        let array = UserDefaults.standard.array(forKey: FOOD_KEY) as? [String] ?? [String]()
//        return Set(array)
        let data = UserDefaults.standard.data(forKey: FOOD_KEY)
        
        if let data, let array = try? JSONDecoder().decode([RecipeItem].self, from: data) {
            return Set(array)
        } else {
            return []
        }
    }
}
