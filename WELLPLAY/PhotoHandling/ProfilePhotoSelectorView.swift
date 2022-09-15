//
//  ProfilePhotoSelectorView.swift
//  WellPlay
//
//  Created by Nataliya Durdyeva on 8/14/22.
//

import SwiftUI
import Foundation

struct ProfilePhotoSelectorView: View {
    
    @State private var isShowingPhotoPicker = false
    @State private var selectedPicture: UIImage?
    @State private var profilePicture: Image?
    
    @EnvironmentObject var viewModel: AppViewModel
    
    
    var body: some View {
        NavigationView {
            VStack{
                
                Text("Let's upload your profile picture!")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(Color("DarkBlue"))
                    .padding()
                
                Spacer()
                
                Button(action: { isShowingPhotoPicker.toggle() }, label: {
                    ZStack {
                        if let profilePicture = profilePicture {
                            profilePicture
                                .resizable()
                                .modifier(ProfilePhotoModifier())
                        } else {
                            Image(systemName: "plus")
                                .foregroundColor(Color("DarkBlue"))
                                .modifier(ProfilePhotoModifier())
                        }
                    }
                })
                .sheet(isPresented: $isShowingPhotoPicker, onDismiss: loadPhoto, content: { PhotoPicker(selectedPicture: $selectedPicture)
                    
                })
                .padding(30)
                
             Spacer()
                
                Text(profilePicture == nil ? "Select a profile photo" : "Great! Tap below to continue")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color("DarkBlue"))
                
                if let selectedPicture = selectedPicture {
                    Button(action: {
                        viewModel.uploadProfilePhoto(selectedPicture) }, label: {
                            Text("Continue")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(width: 340, height: 50)
                                .background(Color("DarkBlue"))
                                .clipShape(Capsule())
                                .padding()
                        }) .padding(.top, 24)
                                        .shadow(color: .gray.opacity(0.5), radius: 10, x: 0, y: 0)
                }
                Spacer()
            }.navigationBarHidden(true)
               
            
        }
        
    }
}

private struct ProfilePhotoModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(Color(.systemBlue))
            .scaledToFill()
            .frame(width: 100, height: 90)
    }
}

extension ProfilePhotoSelectorView {
    func loadPhoto() {
        
        guard let selectedPicture = selectedPicture else {return}
        profilePicture = Image(uiImage: selectedPicture)
    }
}

struct ProfilePhotoSelectorView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePhotoSelectorView()
    }
}



