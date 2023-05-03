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
    
    @State var showAuthorizationError = false
    @State var textAuthorizationError = ""
    
    var body : some View{
            VStack {
                Text("Вход").fontWeight(.heavy).font(.largeTitle).padding([.top,.bottom], 20)
                VStack{
                    VStack(alignment: .leading){
                        VStack(alignment: .leading){
                            Text("Email:").font(.headline).fontWeight(.light).foregroundColor(Color.init(.label).opacity(0.75))
                            HStack{
                                TextField("Введите ваш Email", text: $email)
                            }
                            Divider()
                        }.padding(.bottom, 15)
                        VStack(alignment: .leading){
                            Text("Пароль:").font(.headline).fontWeight(.light).foregroundColor(Color.init(.label).opacity(0.75))
                            SecureField("Введите ваш пароль", text: $password)
                            Divider()
                        }
                    }.padding(.horizontal, 6)
                }.padding()
                
                if(showAuthorizationError == true){
                    VStack(alignment: .leading){
                        Text(textAuthorizationError)
                            .font(.headline)
                            .fontWeight(.light)
                            .foregroundColor(Color(UIColor(hex: "c42316") ?? .black))
                            .opacity(0.75)
                    }
                    .padding()
                }
                else{
                    VStack{
                        Text("Введите Email и пароль")
                            .foregroundColor(Color.white)
                    }
                    .padding()
                }
                
                VStack{
                    Button(action: {
                        authorizationViewModel.authorizationWithEmail(email: self.email, password: self.password){ (verified, status) in
                            if !verified {
                                titleAlert = status[0]
                                messageAlert = status[1]
                                if(status[2] != ""){
                                    textAuthorizationError = status[2]
                                    showAuthorizationError = true
                                }
                                showAlert.toggle()
                            }
                            else{
                                UserDefaults.standard.set(true, forKey: "status")
                                // Ключ статус который определяет находимся мы на домашней странице или на странице входа
                                NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
                            }
                        }
                    }) {
                        Text("Войти").foregroundColor(.black).frame(width: UIScreen.main.bounds.width - 200).padding()
                    }
                    .background(Color(red: 0.8745098039215686, green: 0.807843137254902, blue: 0.7058823529411765))
                        .clipShape(Capsule())
                        .padding(.top, 45)
                }
                .padding()
                        .alert(isPresented: $showAlert){ // Ошибка входа
                            Alert(title: Text(self.titleAlert), message: Text(self.messageAlert), dismissButton: .default(Text("Ок")))
                        }
                VStack{
                    Text("(или)").foregroundColor(Color.gray.opacity(0.5)).padding(.top,30)
                    HStack(spacing: 8){
                        Text("Нет учетной записи?").foregroundColor(Color.gray.opacity(0.5))
                        Button(action: {
                            self.showRegistrationWindow.toggle()
                        }) {
                          Text("Регистрация")
                        }.foregroundColor(Color(red: 0.8745098039215686, green: 0.807843137254902, blue: 0.7058823529411765))
                    }
                    .padding(.top, 25)
                }
                .sheet(isPresented: $showRegistrationWindow){
                    RegistrationView(registrationViewModel: RegistrationViewModel(), showRegistrationWindow: self.$showRegistrationWindow)
                }
            }
            .onChange(of: email){ value in
                showAuthorizationError = false
            }
            .onChange(of: password){ value in
                showAuthorizationError = false
            }
        }
    }
    
struct AuthorizationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthorizationView(authorizationViewModel: AuthorizationViewModel())
    }
}
