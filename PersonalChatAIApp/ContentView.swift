//
//  ContentView.swift
//  PersonalChatAIApp
//
//  Created by Aleksandr Mayyura on 01.02.2023.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = PersonalChatAIViewModel()
    @State var text = "Привет"
    @State var model = [String]()
    
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(model, id: \.self) { string in
                        
                        Text(string)
                        
                    }
                }
            
            }
            Spacer()
            
            HStack {
                TextField("Type here...", text: $text)
                Button("Send") {
                    send()
                }
            }
        }
        
        
        .onAppear{
            viewModel.setup()
        }
        .padding()
    }
    
    func send() {
        guard !text.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        
        model.append("Me:\n\(text)\n")
        viewModel.send(text: text) { response in
            DispatchQueue.main.async {
                self.model.append("ChatGPT:\n" + response + "\n")
                self.text = ""
                print(response)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
