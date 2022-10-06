//
//  WellPlayApp.swift
//  WellPlay
//
//  Created by Nataliya Durdyeva on 8/14/22.
//

import SwiftUI
import Firebase
import SwiftUI


@main
struct WellPlay: App {
    
    
        @StateObject var viewModel = AppViewModel()
        
        init() {
            FirebaseApp.configure()
        }
        
        var body: some Scene {
            WindowGroup {
                NavigationView {
                    ZeroPageView()
                }
                .environmentObject(viewModel)
            }
        }
    }



