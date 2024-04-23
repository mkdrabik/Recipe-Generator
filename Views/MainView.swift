//
//  MainView.swift
//  Foody
//
//  Created by Tanner Macpherson on 4/8/24.
//

import SwiftUI

struct MainView: View {
    @Binding var usedItems: [String]
    @State private var recipes: RecipeResponse?
    @State private var ingredientsString: String
    @State private var showFirstDirections = false
    @State private var showSecondDirections = false
    @State private var rotation = 0.0
    @State private var isLoading = true
    

    
    init(ingredientsString: Binding<String>, usedItems: Binding<[String]>) {
            _ingredientsString = State(initialValue: usedItems.wrappedValue.joined(separator: ", "))
            _usedItems = usedItems
        }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(Color.cb)
                    .ignoresSafeArea()
                if isLoading {
                    withAnimation {
                        Image(systemName: "fork.knife.circle")
                            .resizable()
                            .scaledToFill()
                            .foregroundColor(.white)
                            .frame(width: 80, height: 80)
                            .animation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                                $0.rotationEffect(.degrees(rotation))
                            }
                        
                    }
                }
                VStack() {
                    Button {
                        Task {
                            isLoading = true
                            do {
                                self.recipes = nil
                                self.recipes = try await OpenAIService.shared.sendPromptToChatGPT(message: ingredientsString)
                            } catch {
                                print(error.localizedDescription)
                            }
                            isLoading = false
                        }
                    } label: {
                            Text("Generate New Recipes")
                        
                    }.font(.title)
                        .padding(.vertical, 15)
                        .fontWeight(.bold)
                        .foregroundStyle(.black)
                        .padding(.horizontal, 20)
                        .background(.white)
                        .clipShape(Capsule()
                        )
                    Spacer()
                    if let recipes = recipes {
                        VStack {
                            VStack {
                                Text(recipes.recipeName)
                                    .multilineTextAlignment(.center)
                                    .font(.title)
                                    .fontWeight(.semibold)
                                    .padding(.bottom, 20)
                                    .foregroundColor(Color.black)
                                Button {
                                    showFirstDirections = true
                                } label: {
                                    Text("Cooking Instructions")
                                        .padding()
                                        .foregroundStyle(.white)
                                        .background(
                                            RoundedRectangle(cornerRadius: 20)
                                                .fill(LinearGradient(colors: [Color.purple, Color.blue], startPoint: .topLeading, endPoint: .bottomTrailing))
                                            
                                        )
                                        .shadow(radius: 2)
                                }.sheet(isPresented: $showFirstDirections, onDismiss: {
                                    showFirstDirections = false
                                }) {
                                    DirectionsView(recipeName: recipes.recipeName, directions: recipes.firstDirections, prepTime: recipes.firstPrepTime, cookTime: recipes.firstCookTime)
                                }
                            }.frame(width: 265, height: 190)
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color.white)
                                        .shadow(radius: 10, x: -5, y: 5)
                                        .shadow(radius: 5)
                                        .frame(width: 275, height: 200)
                                        .padding(.vertical, 20)
                                )
                                .padding(.bottom, 30)
                            VStack {
                                Text(recipes.secondRecipe)
                                    .multilineTextAlignment(.center)
                                    .font(.title)
                                    .fontWeight(.semibold)
                                    .padding(.bottom, 20)
                                    .foregroundColor(Color.black)
                                Button {
                                    showSecondDirections = true
                                } label: {
                                    Text("Cooking Instructions")
                                        .padding()
                                        .foregroundStyle(.white)
                                        .background(
                                            RoundedRectangle(cornerRadius: 20)
                                                .fill(LinearGradient(colors: [Color.purple, Color.blue], startPoint: .topLeading, endPoint: .bottomTrailing))
                                            
                                        )
                                        .shadow(radius: 2)
                                }.sheet(isPresented: $showSecondDirections, onDismiss: {
                                    showSecondDirections = false
                                }) {
                                    DirectionsView(recipeName: recipes.secondRecipe, directions: recipes.secondDirections, prepTime: recipes.secondPrepTime, cookTime: recipes.secondCookTime)
                                }
                            }
                            .frame(width: 265, height: 190)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.white)
                                    .shadow(radius: 10, x: -5, y: 5)
                                    .shadow(radius: 5)
                                    .frame(width: 275, height: 200)
                                    .padding(.vertical, 20)
                            )
                        }
                        Spacer()
                    }
                    
                }
            }
            .onAppear {
                rotation = 360.0
                Task {
                    do {
                        self.recipes = try await OpenAIService.shared.sendPromptToChatGPT(message: ingredientsString)
                        isLoading = false
                    } catch {
                        print(error.localizedDescription)
                    }
                }            }
        }
        
    }
    
}
//
//#Preview {
//    MainView(ingredientsString: exampleString, usedItems: exampleItems)

