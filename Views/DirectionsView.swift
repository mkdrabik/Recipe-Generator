//
//  DirectionsView.swift
//  Foody
//
//  Created by Tanner Macpherson on 4/18/24.
//

import SwiftUI
import Foundation

struct DirectionsView: View {
    @State var recipeName: String
    @State var directions: String
    @State var prepTime: String
    @State var cookTime: String
    var body: some View {
        ZStack {
            Color(Color.cb)
                .ignoresSafeArea()
//            ScrollView{
                VStack {
                    Text(recipeName)
                        .font(.largeTitle)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                        .fontWeight(/*@START_MENU_TOKEN@*/ .bold/*@END_MENU_TOKEN@*/)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 40)
                        
                    HStack {
                        VStack {
                            Text("Prep Time")
                                .foregroundColor(Color.black)
                            Text("\(prepTime) min")
                                .foregroundColor(Color.black)
                        }.padding(.vertical, 8)
                            .padding(.horizontal, 20)
                            .fontWeight(.semibold)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.white)
                                    .padding(.horizontal, 10)
                            )
                        VStack {
                            Text("Cook Time")
                                .foregroundColor(Color.black)
                            Text("\(cookTime) min")
                                .foregroundColor(Color.black)
                        }.padding(.vertical, 8)
                            .padding(.horizontal, 20)
                            .fontWeight(.semibold)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.white)
                                    .padding(.horizontal, 10)
                            )
                    }.padding(.bottom, 20)
                    Text("Cooking Instructions")
                        .multilineTextAlignment(.center)
                        .font(.title)
                        .fontWeight(/*@START_MENU_TOKEN@*/ .bold/*@END_MENU_TOKEN@*/)
                        .padding()
                        .foregroundColor(Color.black)
                    ScrollView{

                    VStack {
                        ForEach(ss(s: directions)) {d in
                            DirectionView(d: d.name)
                                .padding(.leading, 10)
                                .padding(.vertical, -5)
                        }.padding(.top, 10)
                    }.fontWeight(.semibold)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                    ).padding(.horizontal, 15)
                    Spacer()
                }
            }
        }
    }
}

func ss(s: String) -> [Direction]{
    let da = s.split(separator: "\n")
    var directions_array: [Direction] = []
    for item in da{
        directions_array.append(Direction(name: String(item)))
    }
    return directions_array
}

struct Direction: Identifiable {
    let name: String
    var completed: Bool = false
    var id: String { name }
}

#Preview {
    DirectionsView(recipeName: "Chicken Parmesan Pasta", directions: "1. Heat a pan over medium heat\n2. Add garlic and cook until fragrant\n3. Add chicken and cook until cooked through\n4. Stir in tomato sauce\n5. Cook pasta according to package instructions\n6. Serve chicken and sauce over pasta\n7. Top with grated cheese \n8. Dig In", prepTime: "15", cookTime: "30")
}
