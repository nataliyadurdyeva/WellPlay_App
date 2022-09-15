//
//  ChatLogView.swift
//  WellPlay
//
//  Created by Nataliya Durdyeva on 8/14/22.
//

import Foundation
import UIKit
import SwiftUI
import Kingfisher

struct ChatLogView: View {
    @ObservedObject var viewModel: AppViewModel
    @Environment(\.presentationMode) var presentationMode
    @State var ChatViewIsActive: Bool = true
    
    let reciever: User?
    @State var messages: Message?
    
    @State private var text: String = ""
    @State private var fromId = ""
    @State private var toId = ""
    @State private var userName = ""
    @State private var profilePictureUrl = ""
    let notSelected = Color(red: 0.68, green: 0.81, blue: 0.92)
    
    static let emptyScrollToString = "Empty"
    //    @State private var timeStamp = ""
    //    @State private var read = false
    
    init(reciever: User?) {
        self.reciever = reciever
        self.viewModel = AppViewModel()
        viewModel.fetchMessages(message: messages, reciever: reciever )
        //        self.message = message
        
    }
    
    
    
    var body: some View {
        
        VStack {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            VStack (alignment: .leading){
                HStack {
                    Image(systemName: "arrowshape.turn.up.backward.fill").padding()
                        .foregroundColor(notSelected)
                    Spacer()
                    HStack (alignment: .top) {

                        Spacer()
                        KFImage(URL(string: reciever?.profilePictureUrl ?? self.profilePictureUrl))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 35, height: 35)
                            .clipShape(Circle())
                            .cornerRadius(20)
                        Text(reciever?.userName.capitalizingFirstLetter() ?? self.userName)
                            .font(.system(size:25)).fontWeight(Font.Weight.medium)
                            .foregroundColor(notSelected)
                        Spacer()
                    }
                    .offset(x: -35)
                        .padding()
                        
                }
            }
        }.background(Color("DarkBlue"))
        
        
        VStack {
            ScrollView{
                ScrollViewReader { proxy in
                    VStack (alignment: .leading, spacing: 12) {
                        ForEach(viewModel.messages, id: \.self)
                        { message in
                            HStack {
                                if  message.fromId == viewModel.userSession?.uid {
                                    Spacer()
                                    Text(message.text)
                                        .padding(12)
                                        .background(Color.blue.opacity(0.6))
                                        .font(.system(size: 16))
                                        .clipShape(ChatBubble(isFromCurrentUser: true))
                                        .foregroundColor(.white)
                                        .padding(.horizontal)
                                        .padding(.leading, 100)
                                                                             
                                } else {
                    
                                        Text(message.text)
                                    .padding(12)
                                        .background(Color(.systemGray6))
                                        .font(.system(size: 16))
                                        .clipShape(ChatBubble(isFromCurrentUser: false))
                                        .foregroundColor(.black)
                                        .padding(.horizontal)

                                }
                            }
                        }
                        
                        HStack { Spacer() }
                        
                            .id(Self.emptyScrollToString)
                         
                    }
                    .onAppear() {
                        self.viewModel.fetchMessages(message: messages, reciever: reciever)
                    }
                    .onReceive(viewModel.$count) { _ in
                        withAnimation (.easeOut(duration: 0.5)) {
                            proxy.scrollTo(Self.emptyScrollToString, anchor: .bottom)
                        }
                    }
                }
            }
//            .background(Color(.init(white: 0.95, alpha: 1)))
//            .background(Color("DarkBlue").opacity(0.7))
            //                .safeAreaInset(edge: .bottom)
            
            VStack {

                Rectangle()

                    .frame(width: UIScreen.main.bounds.width, height: 0.3)
                    .edgesIgnoringSafeArea(.horizontal)

                HStack{
                    
                    CustomTextField(placeholder: Text("Enter your message here"), text: $text)
                    
                        .textFieldStyle(PlainTextFieldStyle())

//                        .font(.body)
                        .frame(height: 10)
                        .disableAutocorrection(true)
                    
                    Button(action: {
                        viewModel.sendMessage(text: text, reciever: reciever)
                        text.removeAll()
                    }) {
                        
                        ZStack {
                            Image(systemName: "paperplane.fill")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(.blue.opacity(0.8))
                                .padding(15)
                                .cornerRadius(50)
                                .frame(height: 30)
                        }
                    }
                }
                .padding(.bottom, 8)
                .padding(.horizontal)
            }
            
            
        }.navigationBarBackButtonHidden(true)
    
        }.offset(y: -25)
        .background(Color("DarkBlue").opacity(0.6))
    }
    
}

//MARK: // NON CLASS STRUCTS

struct CustomTextField: View {
    var placeholder: Text
    @Binding var text: String
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }
    
    var body: some View {
        ZStack(alignment: .leading) {
            // If text is empty, show the placeholder on top of the TextField
            if text.isEmpty {
                placeholder
                    .opacity(0.5)
            }
            TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit)
        }
    }
}


struct MessageViewModel {
    
    @ObservedObject var viewModel: AppViewModel
    let message: Message
    
    var currentUid: String { return viewModel.userSession?.uid ?? "" }
    
    var isFromCurrentUser: Bool { return message.fromId == currentUid }
}


struct ChatBubble: Shape {
    var isFromCurrentUser: Bool

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft, .topRight, isFromCurrentUser ? .bottomLeft: .bottomRight], cornerRadii: CGSize(width: 16, height: 16))

        return Path(path.cgPath)
    }
}


