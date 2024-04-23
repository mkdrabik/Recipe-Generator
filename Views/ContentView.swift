//
//  ContentView.swift
//  Foody
//
//  Created by Tanner Macpherson on 4/3/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var vm = ContentViewModel()
    @State var newFood: String = ""
    @State private var usedItems: [String] = []
    @State private var ingredientsString: String = ""
    @State private var selectAllClicked = false
    @State private var showingAlert = false
    @State private var foodType: FoodTypeResponse?
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(Color.cb)
                    .ignoresSafeArea()
                VStack {
                    VStack {
                        Text("Add Items")
                            .font(.largeTitle)
                            .foregroundColor(Color.black)
                            .fontWeight(/*@START_MENU_TOKEN@*/ .bold/*@END_MENU_TOKEN@*/)
                        
                        TextField("Enter a Food", text: $newFood)
                            .onSubmit {
                                Task {
                                    do {
                                        let foodType = try await fetchFoodType(item: newFood)
                                        vm.addItem(ri: RecipeItem(foodName: newFood, type: foodType))
                                        newFood = ""
                                    } catch {
                                        print("error: \(error)")
                                    }
                                    newFood = ""
                                }
                            }
                            .frame(height: 100)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .cornerRadius(16)
                            .textFieldStyle(.roundedBorder)
                            .padding(.trailing, 20)
                            .padding(.leading, 20)
                        
                        Text("Your Pantry")
                            .font(.largeTitle)
                            .foregroundColor(Color.black)
                            .fontWeight(/*@START_MENU_TOKEN@*/ .bold/*@END_MENU_TOKEN@*/)
                            .padding(.bottom, 15)
                        Spacer()
                        
                        // select all and clear buttons
                        HStack(spacing: 20) {
                            Button {
                                selectAllClicked = true
                                if selectAllClicked {
                                    usedItems = vm.food.map { $0.foodName }
                                } else {
                                    usedItems.removeAll()
                                    vm.items_used.removeAll()
                                }
                            } label: {
                                Text("Select All")
                                    .padding()
                                    .background(Color.green)
                                    .foregroundStyle(Color.black)
                                    .bold()
                                    .clipShape(Capsule())
                                    .shadow(radius: 2)
                                
                            }.padding(.leading, 20)
                            Button {
                                selectAllClicked = false
                                if selectAllClicked {
                                    usedItems = vm.food.map { $0.foodName }
                                } else {
                                    usedItems.removeAll()
                                    vm.items_used.removeAll()
                                }
                            } label: {
                                Text("Clear")
                                    .padding()
                                    .background(Color.fadedGray)
                                    .foregroundStyle(Color.black)
                                    .bold()
                                    .clipShape(Capsule())
                                    .shadow(radius: 2)
                            }
                            
                            Button {
                                showingAlert = true
                            } label: {
                                Text("Delete All")
                                    .padding()
                                    .background(Color.red)
                                    .foregroundStyle(Color.black)
                                    .bold()
                                    .clipShape(Capsule())
                                    .shadow(radius: 2)
                                
                            }.alert(isPresented: $showingAlert) {
                                Alert(
                                    title: Text("Delete All Items?"),
                                    message: Text("Are you sure you want to delete all items?"),
                                    primaryButton: .destructive(Text("Delete")) {
                                        for item in vm.food {
                                            vm.removeItem(s: item)
                                        }
                                        usedItems.removeAll()
                                    },
                                    secondaryButton: .cancel(Text("Cancel"))
                                )
                            }
                        }
                        .padding(.trailing, 25)
                        
                        HStack(spacing: 62.5) {
                            Text("Pantry")
                                .foregroundColor(Color.black)
                            Text("Fridge")
                                .foregroundColor(Color.black)
                            Text("Freezer")
                                .foregroundColor(Color.black)
                        }.padding(.vertical, 15)
                            .padding(.horizontal, 40)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.white)
                            )
                            .padding(.top, 10)
                            .fontWeight(.bold)
                            
                        HStack(spacing: 0) {
                            List(vm.food.filter { $0.type == "pantry" }.reversed()) { item in
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(item.foodName)
                                            .padding(.leading, -3)
                                            .foregroundColor(Color.black)
                                            .fontWeight(.medium)
                                            .font(.system(size: 12))
                                            .multilineTextAlignment(.center)
                                            .padding(.leading, -5)
                                            .fixedSize(horizontal: false, vertical: true)
                                            
                                    }.frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.trailing, 10)
                                    Spacer()
                                    Button {
                                        vm.favorite_item(ri: item)
                                        if !usedItems.contains(item.foodName) {
                                            usedItems.append(item.foodName)
                                        } else if let index = usedItems.firstIndex(of: item.foodName) {
                                            usedItems.remove(at: index)
                                        } else {
                                            if !selectAllClicked {
                                                usedItems.append(item.foodName)
                                            }
                                        }
                                        print(usedItems)
                                    } label: {
                                        if !usedItems.contains(item.foodName) {
                                            Image(systemName: "circle")
                                                .foregroundStyle(.green)
                                        } else if vm.usingitem(ri: item) || selectAllClicked || usedItems.contains(item.foodName) {
                                            Image(systemName: "circle.fill")
                                                .foregroundColor(.green)
                                        } else {
                                            Image(systemName: "circle")
                                                .foregroundColor(.green)
                                        }
                                    }
                                }
                                
                                .scrollContentBackground(.hidden)
                                .listRowBackground(Color.white)
                                .swipeActions {
                                    Button(role: .destructive) {
                                        Task {
                                            vm.removeItem(s: item)
                                            if let index = usedItems.firstIndex(of: item.foodName) {
                                                usedItems.remove(at: index)
                                            }
                                        }
                                    } label: {
                                        Image(systemName: "trash")
                                    }
                                }
                            }.listStyle(PlainListStyle())
                                .padding(.leading, 10)
                            
                            List(vm.food.filter { $0.type == "fridge" }.reversed()) { item in
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(item.foodName)
                                            .padding(.leading, -3)
                                            .foregroundColor(.black)
                                            .fontWeight(.medium)
                                            .font(.system(size: 12))
                                            .multilineTextAlignment(.center)
                                            .padding(.leading, -5)
                                            .fixedSize(horizontal: false, vertical: true)
                                        
                                    }.frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.trailing, 10)
                                    
                                    Spacer()
                                    Button {
                                        vm.favorite_item(ri: item)
                                        if !usedItems.contains(item.foodName) {
                                            usedItems.append(item.foodName)
                                        } else if let index = usedItems.firstIndex(of: item.foodName) {
                                            usedItems.remove(at: index)
                                        } else {
                                            if !selectAllClicked {
                                                usedItems.append(item.foodName)
                                            }
                                        }
                                        print(usedItems)
                                    } label: {
                                        if !usedItems.contains(item.foodName) {
                                            Image(systemName: "circle")
                                                .foregroundStyle(.green)
                                        } else if vm.usingitem(ri: item) || selectAllClicked || usedItems.contains(item.foodName) {
                                            Image(systemName: "circle.fill")
                                                .foregroundColor(.green)
                                        } else {
                                            Image(systemName: "circle")
                                                .foregroundColor(.green)
                                        }
                                    }
                                }
                                
                                .scrollContentBackground(.hidden)
                                .listRowBackground(Color.white)
                                .swipeActions {
                                    Button(role: .destructive) {
                                        Task {
                                            vm.removeItem(s: item)
                                            if let index = usedItems.firstIndex(of: item.foodName) {
                                                usedItems.remove(at: index)
                                            }
                                        }
                                    } label: {
                                        Image(systemName: "trash")
                                    }
                                }
                            }.listStyle(PlainListStyle())
                                .padding(.horizontal, 2)
                                
                            List(vm.food.filter { $0.type == "freezer" }.reversed()) { item in
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(item.foodName)
                                            .padding(.leading, -3)
                                            .foregroundColor(.black)
                                            .fontWeight(.medium)
                                            .font(.system(size: 12))
                                            .multilineTextAlignment(.center)
                                            .padding(.leading, -5)
                                            .fixedSize(horizontal: false, vertical: true)
                                                
                                    }.frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.trailing, 10)

                                    Spacer()
                                    Button {
                                        vm.favorite_item(ri: item)
                                        if !usedItems.contains(item.foodName) {
                                            usedItems.append(item.foodName)
                                        } else if let index = usedItems.firstIndex(of: item.foodName) {
                                            usedItems.remove(at: index)
                                        } else {
                                            if !selectAllClicked {
                                                usedItems.append(item.foodName)
                                            }
                                        }
                                        print(usedItems)
                                    } label: {
                                        if !usedItems.contains(item.foodName) {
                                            Image(systemName: "circle")
                                                .foregroundStyle(.green)
                                        } else if vm.usingitem(ri: item) || selectAllClicked || usedItems.contains(item.foodName) {
                                            Image(systemName: "circle.fill")
                                                .foregroundColor(.green)
                                        } else {
                                            Image(systemName: "circle")
                                                .foregroundColor(.green)
                                        }
                                    }
                                }
                                
                                .scrollContentBackground(.hidden)
                                .listRowBackground(Color.white)
                                .swipeActions {
                                    Button(role: .destructive) {
                                        Task {
                                            vm.removeItem(s: item)
                                            if let index = usedItems.firstIndex(of: item.foodName) {
                                                usedItems.remove(at: index)
                                            }
                                        }
                                    } label: {
                                        Image(systemName: "trash")
                                    }
                                }
                            }.listStyle(PlainListStyle())
                                .padding(.trailing, 10)
                        }
                    }
                        
                    .scrollContentBackground(.hidden)
                    NavigationLink(destination: MainView(ingredientsString: $ingredientsString, usedItems: $usedItems)) {
                        Text("Create Recipes!")
                            .bold()
                            .font(.title3)
                            .padding(.vertical, 20)
                            .padding(.horizontal, 15)
                            .foregroundColor(.black)
                            .background(Color.white)
                            .clipShape(Capsule())
                            .frame(width: 220, height: 70)
                            .shadow(radius: 10)
                    }
                }
            }
        }
    }

    func fetchFoodType(item: String) async throws -> String {
        do {
            foodType = try await OpenAIService.shared.getFoodType(foodItem: item)
        } catch {
            print("Error fetching food type: \(error)")
        }
        return foodType?.type ?? "missing"
    }
}

#Preview {
    ContentView()
}
