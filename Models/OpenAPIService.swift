//
//  OpenAPIService.swift
//  Foody
//
//  Created by Tanner Macpherson on 4/7/24.
//

import Foundation

enum HTTPMethod: String {
    case post = "POST"
    case get = "GET"
}

class OpenAIService {
    
    static let shared = OpenAIService()
    
    private init () { }
    
    private func generateURLRequest(httpMethod: HTTPMethod, message: String) throws -> URLRequest {
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
            throw URLError(.badURL)
        }
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = httpMethod.rawValue
        
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("Bearer \(Secrets.apiKey)", forHTTPHeaderField: "Authorization")
        
        let systemMessage = GPTMessage(role: "system", content: "You are an expert chef")
        let userMessage = GPTMessage(role: "user", content: message)
        
        let recipeName = GPTFunctionProperty(type: "string", description: "The name of the meal you recommend I cook with the given ingredients")
        let secondRecipe = GPTFunctionProperty(type: "string", description: "The name of the second meal you recommend I cook with the given ingredients")
        let firstPrepTime = GPTFunctionProperty(type: "string", description: "The amount of time in minutes that \(recipeName) will take to prepare before cooking. Only respond with the number, no words")
        let firstCookTime = GPTFunctionProperty(type: "string", description: "The amount of time in minutes that\(recipeName) will take to cook, not including prep time. Only respond with the number, no words")
        let firstDirections = GPTFunctionProperty(type: "string", description: "The detailed directions, including quantities, to make the first recipe in a numbered format. Make each step on a new line")
        let secondDirections = GPTFunctionProperty(type: "string", description: "The detailed directions, including quantities, to make the second recipe in a numbered format. Make each step on a new line")
        let secondPrepTime = GPTFunctionProperty(type: "string", description: "The amount of time in minutes that \(secondRecipe) will take to prepare before cooking. Only respond with the number, no words")
        let secondCookTime = GPTFunctionProperty(type: "string", description: "The amount of time in minutes that\(secondRecipe) will take to cook, not including prep time. Only respond with the number, no words")

        let params: [String: GPTFunctionProperty] = [
            "recipeName": recipeName,
            "secondRecipe": secondRecipe,
            "firstPrepTime": firstPrepTime,
            "firstCookTime": firstCookTime,
            "firstDirections": firstDirections,
            "secondDirections": secondDirections,
            "secondPrepTime": secondPrepTime,
            "secondCookTime": secondCookTime

        ]

        let functionParams = GPTFunctionParameter(type: "object", properties: params, required: ["recipeName", "secondRecipe", "firstPrepTime", "firstCookTime", "firstDirections", "secondDirections", "secondPrepTime", "secondCookTime"])
        let function = GPTFunction(name: "get_recipes", description: "Get the best recipes I can make that include some of the given food items. Use any of the items, don't prioritize the first ones in the list.", parameters: functionParams)
        let payload = GPTChatPayload(model: "gpt-3.5-turbo-0613", messages: [systemMessage, userMessage], functions: [function])
        
        let jsonData = try JSONEncoder().encode(payload)
        
        urlRequest.httpBody = jsonData
        return urlRequest

        
        }
    func sendPromptToChatGPT(message: String) async throws -> RecipeResponse {
        let urlRequest = try generateURLRequest(httpMethod: .post, message: message)
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        let result = try JSONDecoder().decode(GPTResponse.self, from: data)
        
        let args = result.choices[0].message.functionCall.arguments
        guard let argData = args.data(using: .utf8) else {
            throw URLError(.badURL)
        }
        let recipes = try JSONDecoder().decode(RecipeResponse.self, from: argData)
        
        
        print(recipes)
        
        return recipes
        
    }
    
    
    
    private func generateSecondURLRequest(httpMethod: HTTPMethod, food: String) throws -> URLRequest {
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
            throw URLError(.badURL)
        }
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = httpMethod.rawValue
        
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("Bearer \(Secrets.apiKey)", forHTTPHeaderField: "Authorization")
        
        let systemMessage = GPTMessage(role: "system", content: "You are an expert chef")
        let userMessage = GPTMessage(role: "user", content: food)
        
        let type = GPTFunctionProperty(type: "string", description: "The categorization of the food item. You options are pantry, fridge, or freezer")

        let params: [String: GPTFunctionProperty] = [
            "type": type
        ]

        let functionParams = GPTFunctionParameter(type: "object", properties: params, required: ["type"])
        let function = GPTFunction(name: "get_recipes", description: "Provide the recommended storage location for common kitchen items based on best practices or general guidelines. All meat should either go in the fridge or freezer", parameters: functionParams)
        let payload = GPTChatPayload(model: "gpt-3.5-turbo-0613", messages: [systemMessage, userMessage], functions: [function])
        
        let jsonData = try JSONEncoder().encode(payload)
        
        
        urlRequest.httpBody = jsonData
        return urlRequest

        
        }
    
    func getFoodType(foodItem: String) async throws -> FoodTypeResponse {
        let urlRequest = try generateSecondURLRequest(httpMethod: .post, food: foodItem)
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        let result = try JSONDecoder().decode(GPTResponse.self, from: data)
        
        let args = result.choices[0].message.functionCall.arguments
        guard let argData = args.data(using: .utf8) else {
            throw URLError(.badURL)
        }
        let type = try JSONDecoder().decode(FoodTypeResponse.self, from: argData)
        
        
        print(type)
        
        return type
        
    }
    
}
