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
    
    @StateObject var recordListViewModel: RecordListViewModel = RecordListViewModel()
    @StateObject var userInformationListViewModel: UserInformationListViewModel = UserInformationListViewModel()
    
    @State private var selectedMessage: Message?
    @State private var selectedImage = 0
    @State private var editingWindowShow = false
    @State private var openFullSizeImage = false
    @State private var newMessageId = ""

    var body: some Scene {
        WindowGroup {
            ZStack{
                VStack{
                    if status{
                        TabView {
                            RecordListView()
                                .tabItem {
                                    Image(systemName: "house")
                                    Text("Home")
                                }
                                .environmentObject(recordListViewModel)
                            MessageListView(messageListViewModel: MessageListViewModel(), editingWindowShow: $editingWindowShow, selectedMessage: $selectedMessage, newMessageId: $newMessageId, openFullSizeImage: $openFullSizeImage, selectedImage: $selectedImage)
                                .tabItem {
                                    Image(systemName: "message.badge")
                                    Text("Chat")
                                }
                            CreateRecordView(createViewModel: CreateViewModel())
                                .tabItem {
                                    Image(systemName: "square.and.pencil")
                                    Text("Add Record")
                                }
                            ReportView(reportViewModel: ReportViewModel())
                                .tabItem {
                                    Image(systemName: "list.bullet.clipboard")
                                    Text("Report")
                                }
                            SettingsView()
                                .tabItem {
                                    Image(systemName: "gear")
                                    Text("Settings")
                                }
                                .environmentObject(userInformationListViewModel)
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
              
                if(openFullSizeImage == true){
                    VStack{}
                        .frame(
                            minWidth: 0,
                            maxWidth: .infinity,
                            minHeight: 0,
                            maxHeight: .infinity,
                            alignment: .topLeading
                        )
                        .background(Color.black)
                        .gesture(DragGesture(minimumDistance: 3.0, coordinateSpace: .local)
                            .onEnded { value in
                                switch(value.translation.width, value.translation.height) {
                                    case (-100...100, ...0):  do {
                                        editingWindowShow = false
                                        openFullSizeImage = false
                                    }
                                    case (-100...100, 0...):  do {
                                        editingWindowShow = false
                                        openFullSizeImage = false
                                    }
                                    default:  print("")
                                }
                            }
                        )

                    VStack{
                        MessageFullSizeImageView(selectedMessage: selectedMessage ?? Message(idUser: "", typeMessage: "", text: "", countImages: 0, replyIdMessage: "", editing: false), selectedImage: $selectedImage, newMessageId: $newMessageId, openFullSizeImage: $openFullSizeImage)
                            .gesture(DragGesture(minimumDistance: 3.0, coordinateSpace: .local)
                                .onEnded { value in
                                    switch(value.translation.width, value.translation.height) {
                                        case (0..., -30...30):  do {
                                            if(selectedImage > 0){
                                                selectedImage -= 1
                                            }
                                        }
                                        case (...0, -30...30):  do {
                                            if(selectedImage < ((selectedMessage?.countImages ?? 0) - 1)){
                                                selectedImage += 1
                                            }
                                        }
                                        case (-100...100, ...0):  do {
                                            editingWindowShow = false
                                            openFullSizeImage = false
                                        }
                                        case (-100...100, 0...):  do {
                                            editingWindowShow = false
                                            openFullSizeImage = false
                                        }
                                        default:  print("")
                                    }
                                }
                            )
                    }
                }
            }
        }
    }
}
