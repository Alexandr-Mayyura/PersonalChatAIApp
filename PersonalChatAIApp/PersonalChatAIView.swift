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
    @State var messages = ["Hello, i am ChatGPT!"]
    @State var isOn = false
    
    var body: some View {
        VStack {
            HStack {
                Text("ChatGPT")
                    .font(.largeTitle)
                    .bold()
                Image("openAi")
                    .resizable()
                    .frame(width: 50, height: 50)
            }
            ScrollView {
                ForEach(messages, id: \.self) { message in
                    if message.contains("[USER]") {
                        let newMessage = message.replacingOccurrences(
                            of: "[USER]",
                            with: ""
                        )
                        
                        HStack {
                            Spacer()
                            Text(newMessage)
                                .padding()
                                .foregroundColor(Color.black)
                                .background(Color("GreenColor"))
                                .cornerRadius(10)
                                .padding(.horizontal, 16)
                                .padding(.bottom, 10)
                                
                        }
                    } else {
                        let newMessage = message.replacingOccurrences(
                            of: "\n\n",
                            with: " "
                        )
                        HStack {
                                Text(newMessage)
                                    .padding()
                                    .foregroundColor(Color.black)
                                    .background(Color("BlueColor"))
                                    .cornerRadius(10)
                                    .padding(.horizontal, 16)
                                    .padding(.bottom, 10)
                                Spacer()
                            }
                        
                    }
                } .rotationEffect(.degrees(180))
            }
            .rotationEffect(.degrees(180))
            .textSelection(.enabled)
            VStack {
                HStack {
                    if isOn {
                        ProgressView()
                            .padding(.leading, 30)
                    }
                    Spacer()
                }
                HStack {
                    TextField("Type here...", text: $text)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        .onSubmit {
                            send(message: text)
                        }
                    Button {
                        send(message: text)
                    } label: {
                        Image(systemName: "paperplane.fill")
                    }
                    .font(.system(size: 26))
                    .padding(.horizontal, 10)
                    .disabled(isOn)
                }
                .padding()
            }
        }
        .onAppear {
            viewModel.setup()
        }
    }
    
    func send(message: String) {
        withAnimation {
            guard !message.isEmpty else { return }
            isOn = true
            messages.append("[USER]" + message)
            text = ""
            viewModel.send(text: message) { response in
                DispatchQueue.main.async {
                    withAnimation {
                        isOn.toggle()
                        messages.append(response)
                    }
                }
            }
        }
       
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        PersonalChatAIView()
    }
}
