//
//  ContentView.swift
//  TravelAi
//
//  Created by Abdul Alkawasmeh on 2025-02-11.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var isShowingSplash = true
    
    var body: some View {
        Group {
            if isShowingSplash {
                SplashScreen()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                            withAnimation {
                                isShowingSplash = false
                            }
                        }
                    }
            } else {
                MainTabView()
            }
        }
    }
}

#Preview {
    ContentView()
}
