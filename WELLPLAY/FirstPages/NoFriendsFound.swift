//
//  NoFriendsFound.swift
//  WellPlay
//
//  Created by Nataliya Durdyeva on 8/15/22.
//


import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import Firebase

struct NoFriendsFound: View {
    
    @EnvironmentObject var viewModel: AppViewModel
    
    var body: some View {
        
        NavigationView {
            
            VStack(alignment:. leading, spacing: 30) {
                HStack {
                Text("SORRY! \nNOBODY \nIN YOUR CITY \nYET!")
                    .font(.title)
                    .bold()
                    .foregroundColor(Color("DarkBlue").opacity(0.8))
                    .padding(20)
                }
                .offset(y: -170)
         
                Group {
                    HStack {
                        NavigationLink(destination: SignInView(), label: {
                            Text("Change City")
                                .bold()
                                .frame(maxWidth: 400, maxHeight: 40)
                                .background(Color.black)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        })
                        .padding()
                        
                        NavigationLink(destination: SignUpView(), label: {
                            Text("Sign Out")
                                .bold()
                                .frame(maxWidth: 400, maxHeight: 40)
                                .background(Color.white)
                                .foregroundColor(.black)
                                .cornerRadius(10)
                        })
                        .padding()
                    }
                } .frame(maxHeight: .infinity, alignment: .bottom)
   
            }
            .background(Image("sadBlackDog")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
            )
        }
    }
}
