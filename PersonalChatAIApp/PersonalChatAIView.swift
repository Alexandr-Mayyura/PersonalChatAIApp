//
//  PersonalChatAIView.swift
//  PersonalChatAIApp
//
//  Created by Aleksandr Mayyura on 01.02.2023.
//

import SwiftUI

struct PersonalChatAIView: View {
    @ObservedObject var viewModel = PersonalChatAIViewModel()
    @State var text = ""
    @State var model = [String]()
    
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(model.indices, id: \.self) { string in
                        Text(string % 2 == 1
                             ? "ChatGPT:\(model[string])"
                             : "Me:\(model[string])")
                        .padding()
                        .background(string % 2 == 1
                                    ? Color("BlueColor")
                                    : Color("GreenColor"))
                        .cornerRadius(20)
                    }
                }
            }
            Spacer()
            HStack {
                TextField("Type here...", text: $text)
                    .lineLimit(3)
                    .textFieldStyle(.plain)
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
        guard !text.isEmpty else { return }
        model.append("\n\(text)")
        viewModel.send(text: text) { response in
            DispatchQueue.main.async {
                self.model.append(response)
                self.text = ""
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        PersonalChatAIView()
    }
}
