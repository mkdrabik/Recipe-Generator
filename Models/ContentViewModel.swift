//
//  Content-ViewModel.swift
//  Foody
//
//  Created by Mason Drabik on 4/10/24.
//

import Foundation
import SwiftUI

    final class ContentViewModel: ObservableObject{
        @Published var food = [RecipeItem]()
        @Published var savedItems: Set<RecipeItem> = []
        @Published var items_used = [RecipeItem]()
                
        
        private var db = Database()
        
        init(){
            self.savedItems = db.load()
            self.food = Array(savedItems)
//            for f in savedItems{
//                let r = RecipeItem(foodName: f.foodName, type: f.type)
//                self.food.append(r)
//            }
        }
        
        func contains(_ item: RecipeItem) -> Bool{
            for s in savedItems{
                if s.foodName.compare(item.foodName, options: .caseInsensitive) == .orderedSame {
                   return true
                }
            }
            return false
        }
        
        func addItem(ri: RecipeItem){
            if !contains(ri){
                food.append(ri)
                savedItems.insert(ri)
                print(food) //added print statement to show everything in pantry when you enter a food
            }
            db.save(items: savedItems)
        }
        
        func removeItem(s : RecipeItem){
            savedItems.remove(s)
            for f in food{
                if f.foodName.compare(s.foodName, options: .caseInsensitive) == .orderedSame {
                    food.remove(at: food.firstIndex(of: f)!)
                }
            for fs in items_used{
                if fs.foodName.compare(s.foodName, options: .caseInsensitive) == .orderedSame {
                        items_used.remove(at: items_used.firstIndex(of: fs)!)
                    }
                }
            }
            db.save(items: savedItems)
        }
        
        func usingitem(ri: RecipeItem) -> Bool{
            for i in items_used{
                if i.foodName.compare(ri.foodName, options: .caseInsensitive) == .orderedSame {
                   return true
                }
            }
            return false
        }
        
        func favorite_item(ri: RecipeItem){
            if(!usingitem(ri: ri)){
                items_used.append(ri)
            } else {
                for f in items_used{
                    if f.foodName.compare(ri.foodName, options: .caseInsensitive) == .orderedSame {
                        items_used.remove(at: items_used.firstIndex(of: f)!)
                    }
                }
            }
        }
    }
