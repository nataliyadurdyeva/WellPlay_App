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

    @State  var userName = ""
    
    @Environment(\.dismiss) private var dismiss
    
    
    var body: some View {
        
        NavigationView {
            ZStack{
                Color("DarkBlue")
                    .ignoresSafeArea(.all)
                
                VStack {

                       Group{
                      Text("Your name:")
                                .font(.system(size:15)).fontWeight(Font.Weight.medium)
                                .foregroundColor(.white)
                           TextField(viewModel.currentUser?.userName ?? "", text: $userName
                                     )
                           .disableAutocorrection(true)
                        .font(Font.system(size: 15))
                                    .padding()
                                    .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                                    .foregroundColor(.black)
                                    .padding(2)
                           
                           Button(action: {
                               
                               viewModel.updateName(userName: userName)
                               dismiss()
                           }) {
                               
                               ZStack {
                                   RoundedRectangle(cornerRadius: 15)
                                       .frame(width: 280, height: 45)
                                       .foregroundColor(Color(.lightGray))
                                   
                                   Text("Update")
                                       .font((.system(size: 15, weight: .semibold, design: .default))
                                       )
                               }
                           }
                           .padding(30)

                        
                    }

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
                                .font(.system(size:15)).fontWeight(Font.Weight.medium)
                                .foregroundColor(.white)
                           TextField(viewModel.currentUser?.age ?? "",
                                     text: $age)
                           .keyboardType(.numberPad)
                        .font(Font.system(size: 12))
                                    .padding()
                                    .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                                    .foregroundColor(.black)
                                    .padding(2)
                           
                           Button(action: {
                               
                               viewModel.updateAge(age:age)
                               dismiss()
                           }) {
                               
                               ZStack {
                                   RoundedRectangle(cornerRadius: 15)
                                       .frame(width: 280, height: 45)
                                       .foregroundColor(Color(.lightGray))
                                   
                                   Text("Update")
                                       .font((.system(size: 15, weight: .semibold, design: .default))
                                       )
                               }
                           }
                           .padding(30)


                        
                    }

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
                      Text("Your location:")
                                .font(.system(size:15)).fontWeight(Font.Weight.medium)
                                .foregroundColor(.white)
                           TextField(viewModel.currentUser?.location ?? "", text: $location
                                     )
                           .disableAutocorrection(true)
                        .font(Font.system(size: 15))
                                    .padding()
                                    .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                                    .foregroundColor(.black)
                                    .padding(2)
                           
                           Button(action: {
                               
                               viewModel.updateLocation(location:location)
                               dismiss()
                           }) {
                               
                               ZStack {
                                   RoundedRectangle(cornerRadius: 15)
                                       .frame(width: 280, height: 45)
                                       .foregroundColor(Color(.lightGray))
                                   
                                   Text("Update")
                                       .font((.system(size: 15, weight: .semibold, design: .default))
                                       )
                               }
                           }
                           .padding(30)


                        
                    }

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
                      Text("Your sports:")
                                .font(.system(size:15)).fontWeight(Font.Weight.medium)
                                .foregroundColor(.white)
                           TextField(viewModel.currentUser?.sports ?? "", text: $sports
                                     )
                           .disableAutocorrection(true)
                           .autocapitalization(.none)
                        .font(Font.system(size: 15))
                                    .padding()
                                    .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                                    .foregroundColor(.black)
                                    .padding(2)
                           
                           Button(action: {
                               
                               viewModel.updateSports(sports:sports)
                               dismiss()
                           }) {
                               
                               ZStack {
                                   RoundedRectangle(cornerRadius: 15)
                                       .frame(width: 280, height: 45)
                                       .foregroundColor(Color(.lightGray))
                                   
                                   Text("Update")
                                       .font((.system(size: 15, weight: .semibold, design: .default))
                                       )
                               }
                           }
                           .padding(30)


                        
                    }

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
                                .font(.system(size:15)).fontWeight(Font.Weight.medium)
                                .foregroundColor(.white)
                           if #available(iOS 16.0, *) {
                               TextField(viewModel.currentUser?.bio ?? "", text: $bio, axis: .vertical)
                                   .multilineTextAlignment(.leading)
                               
                               
                                   .font(Font.system(size: 15))
                                   .padding()
                                   .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                                   .foregroundColor(.black)
                                   .padding(2)
                           } else {
                               // Fallback on earlier versions
                           }
                           
                           Button(action: {
                               
                               viewModel.updateBio(bio:bio)
                               dismiss()
                           }) {
                               
                               ZStack {
                                   RoundedRectangle(cornerRadius: 15)
                                       .frame(width: 280, height: 45)
                                       .foregroundColor(Color(.lightGray))
                                   
                                   Text("Update")
                                       .font((.system(size: 15, weight: .semibold, design: .default))
                                       )
                               }
                           }
                           .padding(30)


                        
                    }

            }
                .onAppear() {
                    self.viewModel.fetchUsers()
                }
                .navigationBarHidden(false)
                
            }
        }
    }
}
