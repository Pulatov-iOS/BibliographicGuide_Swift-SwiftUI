//
//  BibliographicGuideApp.swift
//  BibliographicGuide
//
//  Created by Alexander on 28.03.23.
//

import SwiftUI
import FirebaseCore

// Подключение БД
class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct BibliographicGuideApp: App {
    
    // Регистрация делегата приложения для настройки Firebase
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            VStack{
                TabView {
                    HomeView(recordListViewModel: RecordListViewModel())
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
                    SettingsView()
                        .tabItem {
                            Image(systemName: "gear")
                            Text("Settings")
                    }
                }
            }
        }
    }
}
