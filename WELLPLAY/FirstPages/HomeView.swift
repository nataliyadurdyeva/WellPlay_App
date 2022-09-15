//
//  HomeView.swift
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
import Kingfisher
import SwiftUI


struct HomeView: View {
    
    
    
    @State var user: User?
    @State var messages: Message?
    
    @State private var selectedIndex = 0
    @EnvironmentObject var viewModel: AppViewModel
    let rgbColor = Color(red: 0.03, green: 0.22, blue: 0.39)
    let notSelected = Color(red: 0.68, green: 0.81, blue: 0.92)
    
    init() {
        UITabBar.appearance().unselectedItemTintColor = UIColor(notSelected)
    }
    
    
    var body: some View {
        
        TabView(selection: $selectedIndex) {
            
            SearchView()
                .onTapGesture {
                    selectedIndex = 0
                }
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    
                }.tag(0)
            
            ProfileView()
                .onTapGesture {
                    selectedIndex = 1
                }
                .tabItem {
                    Image(systemName: "person")
                }.tag(1)
            
            AllConversationsView()
                .onTapGesture {
                    selectedIndex = 2
                }
                .tabItem {
                    Image(systemName: "message")
                }.tag(2)
        }.accentColor(rgbColor).imageScale(.large)
            .onAppear{
                UITabBar.appearance().barTintColor = .init(named: "DarkBlue")
            }
    }
    
}


