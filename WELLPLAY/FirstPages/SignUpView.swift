//
//  SignUpView.swift
//  WellPlay
//
//  Created by Nataliya Durdyeva on 8/14/22.
//

import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import Foundation
import Firebase


struct SignUpView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @Environment(\.presentationMode) var mode
    
    @State var email = ""
    @State var password = ""
    @State private var userName = ""
    @State private var age = ""
    @State private var location = ""
    @State private var sports = ""
    @State private var bio = ""
    @State private var selectedPicture: UIImage?
    @State private var picture: Image?
    
    @State private var isShowingPhotoPicker = false
    
    
    var body: some View {
        
        VStack {
            NavigationLink(destination: ProfilePhotoSelectorView(),
                           isActive: $viewModel.didRegister,
                           label: {} )
            
            VStack {
                
                Spacer()
                Text("Let's create your profile!")
                    .font(.title)
                    .bold()
                    .foregroundColor(.white)
                
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
                    
                    TextField("Name", text: $userName)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(20)
                    
                    TextField("Age", text: $age)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(20)
                    
                    TextField("City", text: $location)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(20)
                    
                    TextField("Bio", text: $bio)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(20)
                    
                    TextField("Sport", text: $sports)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(20)
                }.padding()
                
                Button(action: {
                    
                    guard !email.isEmpty, !password.isEmpty else {
                        return
                    }
                    
                    viewModel.signUp(email: email, password: password, userName: userName, age: age, location: location, sports: sports, bio: bio)
                    
                }, label: {
                    Text("Create Account")
                        .foregroundColor(.black)
                        .fontWeight(.bold)
                        .frame(width: 320, height: 40)
                        .background(Color("sendAnInvite_button_light_brown"))
                }).cornerRadius(40)
                NavigationLink("Have an account already?", destination: SignInView())
                    .padding()
                    .foregroundColor(Color("NoAccountYet"))
                
                
            }.padding()
                .background(Color("DarkBlue"))
            Spacer()
                .sheet(isPresented: $isShowingPhotoPicker, content: {
                    ProfilePhotoSelectorView()
                })
                .padding(10)
            
            
        }.navigationBarHidden(true)
            .offset(y: 30)
            .background(Color("DarkBlue"))
        .onAppear(perform: {
            viewModel.didRegister = false
        })
        
    }
}


extension SignUpView {
    func loadPhoto() {
        
        guard let selectedPicture = selectedPicture else {return}
        picture = Image(uiImage: selectedPicture)
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}

