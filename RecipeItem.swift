//
//  RecipeItem.swift
//  Foody
//
//  Created by Tanner Macpherson on 4/3/24.
//

import Foundation

struct RecipeItem: Identifiable, Codable, Equatable, Hashable {
    
    var id: UUID = UUID()
    var foodName: String
    var selected: Bool = false
    var type: String
    
//    static var sampleItems: [RecipeItem]{
//        var tempList = [RecipeItem]()
//
//        for i in 1...20{
//            let foodName = "Food \(i)"
//            let type = "Type \(i)"
//
//            tempList.append(RecipeItem(foodName: foodName, type: type))
//        }
//        return tempList
//    }
    
    mutating func toggle(){
        selected.toggle()
    }
}
