//
//  EditProfile.swift
//  WELLPLAY
//
//  Created by Nataliya Durdyeva on 9/26/22.
//

import Foundation
import UIKit
import SwiftUI
import Kingfisher

struct EditNameView: View {
    
    @ObservedObject var viewModel = AppViewModel()
    
    @State private var userName = ""
    
    @Environment(\.dismiss) private var dismiss
    
    
    var body: some View {
        
        NavigationView {
            ZStack{
                Color("DarkBlue")
                    .ignoresSafeArea(.all)
                
                VStack {
                    
                    Group{
                        Text("Your name:")
                            .font(.system(size:25)).fontWeight(Font.Weight.medium)
                            .foregroundColor(.white)
                        TextField(viewModel.currentUser?.userName ?? "", text: $userName
                        )
                        .disableAutocorrection(true)
                        .font(Font.system(size: 15))
                        .frame(width: 300, height: 15)
                        .padding(20)
                        .background(RoundedRectangle(cornerRadius: 20).fill(.white))
                        .foregroundColor(.black)
                        .padding(8)
                        
                        Button(action: {
                            
                            viewModel.updateName(userName: userName)
                            dismiss()
                        }){
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .frame(width: 250, height: 40)
                                    .foregroundColor(Color("FancyGreen").opacity(0.7))
                                
                                Text("Update")
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                            }
                        }
                        
                        Button(action: {
                            
                            dismiss()
                            
                        }, label: {
                            Text("Cancel")
                                .foregroundColor(.black)
                                .fontWeight(.bold)
                                .frame(width: 250, height: 40)
                                .background(Color("LightPinkRed").opacity(0.4))
                            
                        }).cornerRadius(15)
                        
                    }
                    
                    Spacer()
                    
                }
                .onAppear() {
                    self.viewModel.fetchUsers()
                }
                .navigationBarHidden(false)
                
            }
        }
    }
}


struct EditAgeView: View {
    
    @ObservedObject var viewModel = AppViewModel()
    @State private var age = ""
    @Environment(\.dismiss) private var dismiss
    
    
    var body: some View {
        
        NavigationView {
            ZStack{
                Color("DarkBlue")
                    .ignoresSafeArea(.all)
                
                VStack {
                    
                    Group{
                        Text("Your age:")
                            .font(.system(size:25)).fontWeight(Font.Weight.medium)
                            .foregroundColor(.white)
                        TextField(viewModel.currentUser?.age ?? "", text: $age
                        )
                        .disableAutocorrection(true)
                        .font(Font.system(size: 15))
                        .frame(width: 300, height: 15)
                        .padding(20)
                        .background(RoundedRectangle(cornerRadius: 20).fill(.white))
                        .foregroundColor(.black)
                        .padding(8)
                        
                        Button(action: {
                            
                            viewModel.updateAge(age: age)
                            dismiss()
                        }){
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .frame(width: 250, height: 40)
                                    .foregroundColor(Color("FancyGreen").opacity(0.7))
                                
                                Text("Update")
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                            }
                        }
                        
                        Button(action: {
                            
                            dismiss()
                            
                        }, label: {
                            Text("Cancel")
                                .foregroundColor(.black)
                                .fontWeight(.bold)
                                .frame(width: 250, height: 40)
                                .background(Color("LightPinkRed").opacity(0.4))
                            
                        }).cornerRadius(15)
                    }
                    Spacer()
                }
                .onAppear() {
                    self.viewModel.fetchUsers()
                }
                .navigationBarHidden(false)
                
            }
        }
    }
}


struct EditLocationView: View {
    
    @ObservedObject var viewModel = AppViewModel()
    @State private var location = ""
    @Environment(\.dismiss) private var dismiss
    
    
    var body: some View {
        
        NavigationView {
            ZStack{
                Color("DarkBlue")
                    .ignoresSafeArea(.all)
                
                VStack {
                    Group{
                        Text("Your city")
                            .font(.system(size:25)).fontWeight(Font.Weight.medium)
                            .foregroundColor(.white)
                        TextField(viewModel.currentUser?.location ?? "", text: $location
                        )
                        .disableAutocorrection(true)
                        .font(Font.system(size: 15))
                        .frame(width: 300, height: 15)
                        .padding(20)
                        .background(RoundedRectangle(cornerRadius: 20).fill(.white))
                        .foregroundColor(.black)
                        .padding(8)
                        
                        Button(action: {
                            
                            viewModel.updateLocation(location: location)
                            dismiss()
                        }){
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .frame(width: 250, height: 40)
                                    .foregroundColor(Color("FancyGreen").opacity(0.7))
                                
                                Text("Update")
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                            }
                        }
                        
                        Button(action: {
                            
                            dismiss()
                            
                        }, label: {
                            Text("Cancel")
                                .foregroundColor(.black)
                                .fontWeight(.bold)
                                .frame(width: 250, height: 40)
                                .background(Color("LightPinkRed").opacity(0.4))
                            
                        }).cornerRadius(15)
                        
                    }
                    Spacer()
                }
                .onAppear() {
                    self.viewModel.fetchUsers()
                }
                .navigationBarHidden(false)
            }
        }
    }
}

struct EditSportsView: View {
    
    @ObservedObject var viewModel = AppViewModel()
    @State private var sports = ""
    @Environment(\.dismiss) private var dismiss
    
    
    var body: some View {
        
        NavigationView {
            ZStack{
                Color("DarkBlue")
                    .ignoresSafeArea(.all)
                
                VStack {
                    
                    Group{
                        Text("Your Sports:")
                            .font(.system(size:25)).fontWeight(Font.Weight.medium)
                            .foregroundColor(.white)
                        TextField(viewModel.currentUser?.sports ?? "", text: $sports
                        )
                        .disableAutocorrection(true)
                        .font(Font.system(size: 15))
                        .frame(width: 300, height: 15)
                        .padding(20)
                        .background(RoundedRectangle(cornerRadius: 20).fill(.white))
                        .foregroundColor(.black)
                        .padding(8)
                        
                        Button(action: {
                            
                            viewModel.updateSports(sports: sports)
                            dismiss()
                        }){
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .frame(width: 250, height: 40)
                                    .foregroundColor(Color("FancyGreen").opacity(0.7))
                                
                                Text("Update")
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                            }
                        }
                        
                        Button(action: {
                            
                            dismiss()
                            
                        }, label: {
                            Text("Cancel")
                                .foregroundColor(.black)
                                .fontWeight(.bold)
                                .frame(width: 250, height: 40)
                                .background(Color("LightPinkRed").opacity(0.4))
                            
                        }).cornerRadius(15)
                    }
                    
                    Spacer()
                }
                .onAppear() {
                    self.viewModel.fetchUsers()
                }
                .navigationBarHidden(false)
                
            }
        }
    }
}

struct EditBioView: View {
    
    @ObservedObject var viewModel = AppViewModel()
    @State private var bio = ""
    @Environment(\.dismiss) private var dismiss
    
    
    var body: some View {
        
        NavigationView {
            ZStack{
                Color("DarkBlue")
                    .ignoresSafeArea(.all)
                VStack {
                    Group{
                        Text("Your bio:")
                            .font(.system(size:25)).fontWeight(Font.Weight.medium)
                            .foregroundColor(.white)
                        
                        if #available(iOS 16.0, *) {
                            TextField(viewModel.currentUser?.bio ?? "", text: $bio, axis: .vertical)
                                .multilineTextAlignment(.leading)
                                .disableAutocorrection(true)
                                .font(Font.system(size: 15))
                                .frame(width: 300, height: 15)
                                .padding(20)
                                .background(RoundedRectangle(cornerRadius: 20).fill(.white))
                                .foregroundColor(.black)
                                .padding(8)
                        } else {
                            // Fallback on earlier versions
                        }
                        
                        Button(action: {
                            
                            viewModel.updateBio(bio: bio)
                            dismiss()
                        }){
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .frame(width: 250, height: 40)
                                    .foregroundColor(Color("FancyGreen").opacity(0.7))
                                
                                Text("Update")
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                            }
                        }
                        
                        Button(action: {
                            
                            dismiss()
                            
                        }, label: {
                            Text("Cancel")
                                .foregroundColor(.black)
                                .fontWeight(.bold)
                                .frame(width: 250, height: 40)
                                .background(Color("LightPinkRed").opacity(0.4))
                            
                        }).cornerRadius(15)
                    }
                    Spacer()
                }
                .onAppear() {
                    self.viewModel.fetchUsers()
                }
                .navigationBarHidden(false)
            }
        }
    }
}
