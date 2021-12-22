//
//  ShortysApp.swift
//  Shortys
//
//  Created by user on 22.12.2021.
//

import SwiftUI

@main
struct ShortysApp: App {
    let network = NetworkManager()
    var body: some Scene {
        WindowGroup {
            ContentView()
            Button("Tap me") {
                self.network.getShorterLinks { (response, error) in
                    
                }
            }
        }
    }
}
