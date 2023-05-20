//
//  AppView.swift
//  BibliographicGuide
//
//  Created by Alexander on 28.03.23.
//

import SwiftUI
import FirebaseAnalytics
import FirebaseCore
import FirebaseFirestore

// Подключение БД
class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    FirebaseConfiguration.shared.setLoggerLevel(.error)
    Analytics.setAnalyticsCollectionEnabled(true)
    let settings = Firestore.firestore().settings
    settings.cacheSizeBytes = FirestoreCacheSizeUnlimited
    settings.isPersistenceEnabled = true
    Firestore.firestore().settings = settings
    return true
  }
}

@main
struct AppView: App {
    
    // Регистрация делегата приложения для настройки Firebase
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
    @State var userId = UserDefaults.standard.value(forKey: "userId") as? String ?? ""
    
    @StateObject var appViewModel: AppViewModel = AppViewModel()
    @StateObject var recordListViewModel: RecordListViewModel = RecordListViewModel()
    @StateObject var createRecordViewModel: CreateRecordViewModel = CreateRecordViewModel()
    @StateObject var reportViewModel: ReportViewModel = ReportViewModel()
    @StateObject var userInformationListViewModel: UserInformationListViewModel = UserInformationListViewModel()
    
    @State private var selectedMessage: Message?
    @State private var selectedImage = 0
    @State private var editingWindowShow = false
    @State private var openFullSizeImage = false
    @State private var newRecordId = ""
    @State private var newMessageId = ""

    var body: some Scene {
        WindowGroup {
            ZStack{
                VStack{
                    if(status && !(appViewModel.currentUserInformation?.blockingAccount ?? false)){
                        TabView {
                            RecordListView(newRecordId: $newRecordId)
                                .tabItem {
                                    Image(systemName: "house")
                                    Text("Домашняя")
                                }
                                .environmentObject(recordListViewModel)
                            MessageListView(messageListViewModel: MessageListViewModel(), editingWindowShow: $editingWindowShow, selectedMessage: $selectedMessage, newMessageId: $newMessageId, openFullSizeImage: $openFullSizeImage, selectedImage: $selectedImage)
                                .tabItem {
                                    Image(systemName: "message.badge")
                                    Text("Общ. чат")
                                }
                            CreateRecordView(newRecordId: $newRecordId)
                                .tabItem {
                                    Image(systemName: "square.and.pencil")
                                    Text("Доб. запись")
                                }
                                .environmentObject(createRecordViewModel)
                            ReportView()
                                .tabItem {
                                    Image(systemName: "list.bullet.clipboard")
                                    Text("Отчеты")
                                }
                                .environmentObject(reportViewModel)
                            SettingsView()
                                .tabItem {
                                    Image(systemName: "gear")
                                    Text("Настройки")
                                }
                                .environmentObject(userInformationListViewModel)
                        }
                    }
                    if(!status){
                        AuthorizationView(authorizationViewModel: AuthorizationViewModel())
                    }
                    if(status && (appViewModel.currentUserInformation?.blockingAccount ?? false)){
                        Text("Заблокирован")
                            .fontWeight(.heavy)
                            .font(.largeTitle)
                            .padding(.top, 20)
                            .padding(.bottom, 30)
                        Text("Ваша учетная запись была \nзаблокирована администратором.")
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 5)
                        Text("Причина: \(appViewModel.currentUserInformation?.reasonBlockingAccount ?? "")")
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 40)
                        Button( action: {
                            UserDefaults.standard.set(false, forKey: "status")
                            UserDefaults.standard.set("", forKey: "userId")
                            NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
                        }) {
                            Text("Выйти")
                                .foregroundColor(.black)
                                .frame(width: 180)
                                .padding()
                        }
                        .background(Color(red: 0.8745098039215686, green: 0.807843137254902, blue: 0.7058823529411765))
                        .clipShape(Capsule())
                    }
                }.animation(.spring())
                    .onAppear{
                        // Создание наблюдателя, name - имя события, за которым необходимо наблюдать
                        NotificationCenter.default.addObserver(forName: NSNotification.Name("statusChange"), object: nil, queue: .main){
                            (_) in
                            let status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
                            let userId = UserDefaults.standard.value(forKey: "userId") as? String ?? ""
                            self.status = status
                            self.userId = userId
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
