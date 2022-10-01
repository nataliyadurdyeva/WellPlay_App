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
    @State private var signInErrorMessage = ""
    
    var body: some View {
        
        VStack {
            
            Text("Let's sign you in!")
                .font(.system(size: 35, weight: .semibold))
            
                .foregroundColor(.white)
                .padding()
            
            VStack{
                Text(viewModel.signInErrorMessage ?? "")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color("CarrotColor"))
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(nil)
            }.padding(.top)
            
            VStack {
                Group {
                    TextField("Email Address", text: $email)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(20)
                        .shadow(color: .gray, radius: 1, x: 0, y: 2)
                    
                    SecureField("Password", text: $password)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(20)
                        .shadow(color: .gray, radius: 1, x: 0, y: 2)
                    
                    HStack {
                        Spacer()
                        NavigationLink("Forgot Your Password?", destination: ResetPasswordView())
                            .padding()
                            .foregroundColor(.blue)
                            .font(.system(size: 15, weight: .semibold))
                    }.offset(y:-10)
                    
                    Button(action: {
                        
                        guard !email.isEmpty, !password.isEmpty else {
                            return
                        }
                        viewModel.signIn(email:email, password: password)
                        print("SIGN IN")
                    }, label: {
                        Text("Sign In")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                        
                            .frame(width: 350, height: 40)
                            .background(Color("FancyGreen").opacity(0.6))
                        
                    })  .cornerRadius(40)
                        .shadow(color: .black, radius: 2, x: 0, y: 2)
                }
                HStack {
                    Spacer()
                    NavigationLink("Don't have an account yet?", destination: SignUpView())
                        .padding()
                        .foregroundColor(Color("NoAccountYet"))
                        .font(.system(size: 15, weight: .semibold))
                    
                }.offset(y: -10)
            }.padding()
            
            Spacer()
            
        }.navigationBarBackButtonHidden(true)
            .background(Color("DarkBlue"))
    }
}
struct ResetPasswordView: View {
    
    @ObservedObject var viewModel = AppViewModel()
    @Environment(\.presentationMode) var presentationMode
    @State private var errorMessage: String?
    @State private var shouldShowPasswordReset = false
    @State var email = ""
    
    var body: some View {
        
        VStack{
            TextField("Enter your email address", text: $email)
                .autocapitalization(.none)
            Button(action: {
                viewModel.resetPassword(email: email)
                { (result) in
                    switch result {
                    case .failure(let error):
                        self.errorMessage = error.localizedDescription
                    case .success( _):
                        break
                    }
                    self.shouldShowPasswordReset = true
                }
                
            }) {
                Text("Reset Password")
            }
        }.padding(.top)
        
            .navigationBarBackButtonHidden(true)
        
            .frame(width:300)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .navigationBarTitle("Request a password reset", displayMode: .inline)
            .navigationBarItems(trailing: Button("Dismiss") {
                self.presentationMode.wrappedValue.dismiss()
            })
            .alert(isPresented: $shouldShowPasswordReset) {
                Alert(title: Text("Reset password"),
                      message: Text(self.errorMessage ?? "Success! A resent link has been sent to your email. Check your spam folder."),
                      dismissButton: .default(Text("OK")) {
                    self.presentationMode.wrappedValue.dismiss()
                })
            }       
    }
}
