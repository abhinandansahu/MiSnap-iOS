//
//  MiSnapSampleAppSwiftUIApp.swift
//  MiSnapSampleAppSwiftUI
//
//  
//

import SwiftUI
import MiSnapCore

@main
struct MiSnapSampleSwiftUIApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @State private var showLaunchScreen = true
    
    init() {
        // If you prefer to set the MiSnap license globally (instead of in each ViewModel),
        // you can do it here. See feature ViewModels (e.g., DocumentsViewModel) for license setting code.
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                RootTabView()
                
                if showLaunchScreen {
                    LaunchScreenView()
                        .transition(.scale.combined(with: .opacity))
                        .zIndex(1)
                }
            }
            .onAppear {
                // Dismiss launch screen after 1.5 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation(.easeOut(duration: 0.4)) {
                        showLaunchScreen = false
                    }
                }
            }
        }
    }
}
