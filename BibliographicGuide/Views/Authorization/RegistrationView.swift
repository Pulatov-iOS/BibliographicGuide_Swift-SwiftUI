//
//  RegistrationView.swift
//  BibliographicGuide
//
//  Created by Alexander on 3.04.23.
//

import SwiftUI

struct RegistrationView: View {
    
    @ObservedObject var registrationViewModel: RegistrationViewModel
    
    @State var email = ""
    @State var password = ""
    
    @State var titleAlert = ""
    @State var messageAlert = ""
    @State var showAlert = false
    
    @Binding var showRegistrationWindow: Bool
    
    var body: some View{
            VStack {
                Text("Регистрация").fontWeight(.heavy).font(.largeTitle).padding([.top,.bottom], 20)
                VStack{
                    VStack(alignment: .leading){
                        VStack(alignment: .leading){
                            Text("Email:").font(.headline).fontWeight(.light).foregroundColor(Color.init(.label).opacity(0.75))
                            HStack{
                                TextField("Введите ваш Email", text: $email)
                            }
                            Divider()
                        }
                        .padding(.bottom, 0)
                        .onChange(of: email){ newValue in
                            registrationViewModel.statusCheckEmail = true
                        }
                        
                        VStack{
                            if(registrationViewModel.statusCheckEmail == false){
                                Text("Некорректный email")
                                    .font(.headline)
                                    .fontWeight(.light)
                                    .foregroundColor(Color(UIColor(hex: "c42316") ?? .red))
                                    .opacity(0.75)
                            }
                        }.padding(.bottom, 10)
                        
                        VStack(alignment: .leading){
                            Text("Пароль:").font(.headline).fontWeight(.light).foregroundColor(Color.init(.label).opacity(0.75))
                            SecureField("Введите ваш пароль", text: $password)
                            Divider()
                        }
                        .onChange(of: password){ newValue in
                            registrationViewModel.checkPassword(password: self.password)
                        }
                        
                        VStack(alignment: .leading){
                            Text("Требования к паролю:")
                                .font(.headline)
                                .fontWeight(.light)
                                .foregroundColor(Color.black)
                                .opacity(0.75)
                            if(registrationViewModel.statusCheckPassword[0] == false){
                                Text("- 6 и более символов")
                                    .font(.headline)
                                    .fontWeight(.light)
                                    .foregroundColor(Color(UIColor(hex: "c42316") ?? .red))
                                    .opacity(0.75)
                            }
                            else{
                                Text("- 6 и более символов")
                                    .font(.headline)
                                    .fontWeight(.light)
                                    .foregroundColor(Color.green)
                                    .opacity(0.75)
                            }
                            if(registrationViewModel.statusCheckPassword[1] == false){
                                Text("- строчные латинские буквы")
                                    .font(.headline)
                                    .fontWeight(.light)
                                    .foregroundColor(Color(UIColor(hex: "c42316") ?? .red))
                                    .opacity(0.75)
                            }
                            else{
                                Text("- строчные латинские буквы")
                                    .font(.headline)
                                    .fontWeight(.light)
                                    .foregroundColor(Color.green)
                                    .opacity(0.75)
                            }
                            if(registrationViewModel.statusCheckPassword[2] == false){
                                Text("- прописные латинские буквы")
                                    .font(.headline)
                                    .fontWeight(.light)
                                    .foregroundColor(Color(UIColor(hex: "c42316") ?? .red))
                                    .opacity(0.75)
                            }
                            else{
                                Text("- прописные латинские буквы")
                                    .font(.headline)
                                    .fontWeight(.light)
                                    .foregroundColor(Color.green)
                                    .opacity(0.75)
                            }
                        }.padding(.top, 20)
                    }.padding(.horizontal, 6)
                    
                    Button(action: {
                        registrationViewModel.registrationWithEmail(email: self.email, password: self.password){ (verified, status) in
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
                        Text("Регистрация").foregroundColor(.black).frame(width: UIScreen.main.bounds.width - 200).padding()
                    }
                    .background(Color(red: 0.8745098039215686, green: 0.807843137254902, blue: 0.7058823529411765))
                    .clipShape(Capsule())
                    .padding(.top, 45)
                }
                .padding()
                        .alert(isPresented: $showAlert){ // Ошибка входа
                            Alert(title: Text(titleAlert), message: Text(messageAlert), dismissButton: .default(Text("Ок")))
                        }
            }
        }
    }


//struct RegistrationView_Previews: PreviewProvider {
//    static var previews: some View {
//        RegistrationView(authorizationViewModel: AuthorizationViewModel(), show: )
//    }
//}
