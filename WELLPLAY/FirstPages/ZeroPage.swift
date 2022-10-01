//
//  ZeroPage.swift
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

struct ZeroPageView: View {
    
    @EnvironmentObject var viewModel: AppViewModel
    
    var body: some View {
        
        if viewModel.userSession != nil  {
            HomeView()
        }
        else {
            FirstPageView()
        }
        
    }
}

struct ZeroPageView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ZeroPageView()
                .preferredColorScheme(.dark)
        }
    }
}

