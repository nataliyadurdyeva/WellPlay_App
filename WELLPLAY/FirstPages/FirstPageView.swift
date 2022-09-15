//
//  FirstPageView.swift
//  WellPlay
//
//  Created by Nataliya Durdyeva on 8/14/22.
//

import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import Firebase

struct FirstPageView: View {
    
    @EnvironmentObject var viewModel: AppViewModel
    
    var body: some View {
        
        NavigationView {
            
            VStack(alignment:. leading, spacing: 30) {
                Text("FIND FRIENDS \nTO DO ACTIVITIES \nWITH YOU!")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                    .padding()
                Group {
                    HStack {
                        NavigationLink(destination: SignInView(), label: {
                            Text("Sign In")
                                .bold()
                                .frame(maxWidth: 400, maxHeight: 40)
                                .background(Color.black)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        })
                        .padding()
                        
                        NavigationLink(destination: SignUpView(), label: {
                            Text("Sign Up")
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
            .background(Image("friends_fiests_bike")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
            )
        }
    }
    
}



