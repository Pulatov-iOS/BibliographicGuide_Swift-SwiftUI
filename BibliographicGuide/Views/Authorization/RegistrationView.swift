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
                        }.padding(.bottom, 15)
                        VStack(alignment: .leading){
                            Text("Пароль:").font(.headline).fontWeight(.light).foregroundColor(Color.init(.label).opacity(0.75))
                            SecureField("Введите ваш пароль", text: $password)
                            Divider()
                        }
                    }.padding(.horizontal, 6)
                    
                    Button(action: {
                        registrationViewModel.registrationWithEmail(email: self.email, password: self.password){ (verified, status) in
                            if !verified {
                                self.messageAlert = status
                                self.showAlert.toggle()
                            }
                            else{
                                UserDefaults.standard.set(true, forKey: "status")
                                // Ключ статус который определяет находимся мы на домашней странице или на странице входа
                                self.showAlert.toggle()
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
                            Alert(title: Text("Ошибка"), message: Text(self.messageAlert), dismissButton: .default(Text("Ок")))
                        }
            }
        }
    }


//struct RegistrationView_Previews: PreviewProvider {
//    static var previews: some View {
//        RegistrationView(authorizationViewModel: AuthorizationViewModel(), show: )
//    }
//}
