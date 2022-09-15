//
//  SignInView.swift
//  WellPlay
//
//  Created by Nataliya Durdyeva on 8/14/22.
//

import SwiftUI
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import Foundation
import Firebase


struct SignInView: View {
    
    @EnvironmentObject var viewModel: AppViewModel
    @State var email = ""
    @State var password = ""
    
    var body: some View {
        
        VStack {
            Text("Let's sign you in!")
                .font(.largeTitle)
                .bold()
                .foregroundColor(.white)
                .padding()
            
            VStack {
                TextField("Email Address", text: $email)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(20)
                
                SecureField("Password", text: $password)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(20)
                
                Button(action: {
                    
                    guard !email.isEmpty, !password.isEmpty else {
                        return
                    }
                    viewModel.signIn(email:email, password: password)
                    print("SIGN IN")
                }, label: {
                    Text("Sign In")
                        .foregroundColor(.black)
                        .fontWeight(.bold)
                        .frame(width: 350, height: 40)
                        .background(Color("sendAnInvite_button_light_brown"))
                    
                })  .cornerRadius(40)
                NavigationLink("Don't have an account yet?", destination: SignUpView())
                    .padding()
                    .foregroundColor(Color("NoAccountYet"))
                    
            }.padding()
            Spacer()
        }
        .background(Color("search_bg_dirty_tealBlue"))
 
    }
}

