//
//  AuthorizationView.swift
//  BibliographicGuide
//
//  Created by Alexander on 3.04.23.
//

import SwiftUI

struct AuthorizationView: View {
    
    @ObservedObject var authorizationViewModel: AuthorizationViewModel
    
    @State var email = ""
    @State var password = ""
    
    @State var titleAlert = ""
    @State var messageAlert = ""
    @State var showAlert = false
    
    @State var showRegistrationWindow = false
    @State var screenWidth = CGFloat(393)
    
    var body : some View{
            VStack {
                Text("Вход")
                    .fontWeight(.heavy)
                    .font(.largeTitle)
                    .padding(.top, 20)
                    .padding(.bottom, 30)
                VStack{
                    VStack(alignment: .leading){
                        VStack(alignment: .leading){
                            Text("Email:").font(.headline).fontWeight(.light).foregroundColor(Color.init(.label).opacity(0.75))
                            HStack{
                                TextField("Введите ваш Email", text: $email)
                            }
                            Divider()
                        }
                        
                        VStack{
                            if(authorizationViewModel.statusCheckEmail == true){
                                Text(authorizationViewModel.textAuthorizationError)
                                    .font(.headline)
                                    .fontWeight(.light)
                                    .foregroundColor(Color(UIColor(hex: "c42316") ?? .red))
                                    .opacity(0.75)
                            }
                        }
                        .padding(.bottom, 10)
                        
                        VStack(alignment: .leading){
                            Text("Пароль:").font(.headline).fontWeight(.light).foregroundColor(Color.init(.label).opacity(0.75))
                            SecureField("Введите ваш пароль", text: $password)
                            Divider()
                        }
                        
                        if(authorizationViewModel.statusCheckEmailPassword == true){
                            VStack(alignment: .leading){
                                Text(authorizationViewModel.textAuthorizationError)
                                    .font(.headline)
                                    .fontWeight(.light)
                                    .foregroundColor(Color(UIColor(hex: "c42316") ?? .red))
                                    .opacity(0.75)
                            }
                            .padding(.bottom, 15)
                        }
                        else{
                            VStack{
                                Text("Введите Email и пароль")
                                    .foregroundColor(Color.white)
                            }
                        }
                    }.padding(.horizontal, 6)
                }.padding([.leading, .trailing], 30)
                
                VStack{
                    Button(action: {
                        authorizationViewModel.authorizationWithEmail(email: self.email, password: self.password){ (verified, status) in
                            if !verified {
                                titleAlert = status[0]
                                messageAlert = status[1]
                                showAlert.toggle()
                            }
                            else{
                                UserDefaults.standard.set(true, forKey: "status")
                                // Ключ статус который определяет находимся мы на домашней странице или на странице входа
                                NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
                            }
                        }
                    }) {
                        Text("Войти")
                            .foregroundColor(.black)
                            .frame(width: 180)
                            .padding()
                    }
                    .background(Color(red: 0.8745098039215686, green: 0.807843137254902, blue: 0.7058823529411765))
                    .clipShape(Capsule())
                }
                .alert(isPresented: $showAlert){ // Ошибка входа
                    Alert(title: Text(self.titleAlert), message: Text(self.messageAlert), dismissButton: .default(Text("Ок")))
                }
                VStack{
                    Text("(или)").foregroundColor(Color.gray.opacity(0.5)).padding(.top, 30)
                    HStack(spacing: 8){
                        Text("Нет учетной записи?").foregroundColor(Color.gray.opacity(0.5))
                        Button(action: {
                            self.showRegistrationWindow.toggle()
                        }) {
                          Text("Регистрация")
                        }.foregroundColor(Color(red: 0.8745098039215686, green: 0.807843137254902, blue: 0.7058823529411765))
                    }
                    .padding(.top, 5)
                }
                .sheet(isPresented: $showRegistrationWindow){
                    RegistrationView(registrationViewModel: RegistrationViewModel(), showRegistrationWindow: self.$showRegistrationWindow, screenWidth: $screenWidth)
                }
            }
            .frame(maxWidth: screenWidth)
            .onChange(of: email){ value in
                authorizationViewModel.statusCheckEmail = false
                authorizationViewModel.statusCheckEmailPassword = false
            }
            .onChange(of: password){ value in
                authorizationViewModel.statusCheckEmailPassword = false
            }
            .onAppear(){
                screenWidth = UIScreen.screenWidth
                if(screenWidth >= 393){
                    screenWidth = 393
                }
            }
        }
    }
    
//struct AuthorizationView_Previews: PreviewProvider {
//    static var previews: some View {
//        AuthorizationView(authorizationViewModel: AuthorizationViewModel())
//    }
//}
