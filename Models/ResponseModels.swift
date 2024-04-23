//
//  ResponseModels.swift
//  Foody
//
//  Created by Tanner Macpherson on 4/8/24.
//

import Foundation

struct GPTResponse: Decodable {
    let choices: [GPTCompletion]
}

struct GPTCompletion: Decodable {
    let message: GPTResponseMessage
}

struct GPTResponseMessage: Decodable {
    let functionCall: GPTFunctionCall
    
    enum CodingKeys: String, CodingKey {
        case functionCall = "function_call"
    }
}

struct GPTFunctionCall: Decodable {
    let name: String
    let arguments: String
}

struct RecipeResponse: Decodable {
    let recipeName: String
    let secondRecipe: String
    let firstPrepTime: String
    let firstCookTime: String
    let firstDirections: String
    let secondDirections: String
    let secondPrepTime: String
    let secondCookTime: String
}

struct FoodTypeResponse: Decodable {
    let type: String
}
