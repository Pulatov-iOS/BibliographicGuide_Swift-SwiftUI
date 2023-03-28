//
//  BibliographicGuideApp.swift
//  BibliographicGuide
//
//  Created by Alexander on 28.03.23.
//

import SwiftUI

@main
struct BibliographicGuideApp: App {
    var body: some Scene {
        WindowGroup {
            VStack{
                TabView {
                    ContentView()
                        .tabItem {
                            Image(systemName: "house")
                            Text("Home")
                    }
                    ContentView()
                        .tabItem {
                            Image(systemName: "message.badge")
                            Text("Chat")
                    }
                    ContentView()
                        .tabItem {
                            Image(systemName: "square.and.pencil")
                            Text("Add Record")
                    }
                    ContentView()
                        .tabItem {
                            Image(systemName: "list.bullet.clipboard")
                            Text("Report")
                    }
                    ContentView()
                        .tabItem {
                            Image(systemName: "gear")
                            Text("Settings")
                    }
                }
            }
        }
    }
}
