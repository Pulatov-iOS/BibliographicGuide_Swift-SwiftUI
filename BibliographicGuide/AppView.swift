//
//  AppView.swift
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
struct AppView: App {
    
    // Регистрация делегата приложения для настройки Firebase
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
    @State var userId = UserDefaults.standard.value(forKey: "userId") as? String ?? ""

    var body: some Scene {
        WindowGroup {
            VStack{
                if status{
                    TabView {
                        HomeView()
                            .tabItem {
                                Image(systemName: "house")
                                Text("Home")
                            }
                        ChatView()
                            .tabItem {
                                Image(systemName: "message.badge")
                                Text("Chat")
                            }
                        SettingsView()
                            .tabItem {
                                Image(systemName: "square.and.pencil")
                                Text("Add Record")
                            }
                        SettingsView()
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
                else{
                    AuthorizationView(authorizationViewModel: AuthorizationViewModel())
                }
            }.animation(.spring())
                .onAppear{
                    // Создание наблюдателя, name - имя события, за которым необходимо наблюдать
                    NotificationCenter.default.addObserver(forName: NSNotification.Name("statusChange"), object: nil, queue: .main){
                        (_) in
                        let status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
                        self.status = status
                    }
                }
        }
    }
}
