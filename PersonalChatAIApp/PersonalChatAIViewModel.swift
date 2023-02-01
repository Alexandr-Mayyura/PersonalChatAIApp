//
//  PersonalChatAIViewModel.swift
//  PersonalChatAIApp
//
//  Created by Aleksandr Mayyura on 01.02.2023.
//
import OpenAISwift
import SwiftUI

final class PersonalChatAIViewModel: ObservableObject {
    init() {}
    
    private var client: OpenAISwift?
    
    func setup() {
        client = OpenAISwift(authToken: Token.myToken.rawValue)
        
    }
    
    func send(text:String, completion: @escaping (String) -> Void) {
        client?.sendCompletion(with: text, maxTokens: 2000) { result in
            switch result {
            case .success(let model):
                let output = model.choices.first?.text ?? ""
                completion(output)
            case .failure(let error):
                print(error.localizedDescription)
                break
            }
        }
    }
}
