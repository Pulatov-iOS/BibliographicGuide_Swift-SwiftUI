//
//  RegistrationView.swift
//  BibliographicGuide
//
//  Created by Alexander on 3.04.23.
//

import SwiftUI

struct RegistrationView: View {
    
    var authorizationViewModel: AuthorizationViewModel
    
    @State var user = ""
    @State var pass = ""
    @State var message = ""
    @State var alert = false
    @Binding var show: Bool
    
    var body: some View{
     
            VStack {
                Text("Регистрация").fontWeight(.heavy).font(.largeTitle).padding([.top,.bottom], 20)
                VStack{
                    
                    VStack(alignment: .leading){
                        
                        VStack(alignment: .leading){
                            
                            Text("Email").font(.headline).fontWeight(.light).foregroundColor(Color.init(.label).opacity(0.75))
                            
                            HStack{
                                
                                TextField("Введите ваш Email", text: $user)
                                
                                if user != ""{
                                    
                                    Image("check").foregroundColor(Color.init(.label))
                                }
                                
                            }
                            
                            Divider()
                            
                        }.padding(.bottom, 15)
                        
                        VStack(alignment: .leading){
                            
                            Text("Пароль").font(.headline).fontWeight(.light).foregroundColor(Color.init(.label).opacity(0.75))
                            
                            SecureField("Введите ваш пароль", text: $pass)
                            
                            Divider()
                        }
                        
                    }.padding(.horizontal, 6)
                    
                    
                    Button(action: {
                        
                        authorizationViewModel.registrationWithEmail(email: self.user, password: self.pass){ (verified, status) in
                            
                            if !verified {
                                self.message=status
                                self.alert.toggle()
                            }
                            else{
                                UserDefaults.standard.set(true, forKey: "status")
                                // Ключ статус который определяет находимся мы на домашней странице или на странице входа
                                self.show.toggle()
                                NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
                            }
                        }
                    }) {
                        
                        Text("Зарегистрироваться").foregroundColor(.black).frame(width: UIScreen.main.bounds.width - 120).padding()
                        
                        
                    }.background(Color(red: 0.8745098039215686, green: 0.807843137254902, blue: 0.7058823529411765))
                        .clipShape(Capsule())
                        .padding(.top, 45)
                    
                }.padding()
                
                        .alert(isPresented: $alert){ // Ошибка входа
                            Alert(title: Text("Error"), message: Text(self.message), dismissButton: .default(Text("Ok")))
                        }
            }
        }
    }


//struct RegistrationView_Previews: PreviewProvider {
//    static var previews: some View {
//        RegistrationView(authorizationViewModel: AuthorizationViewModel(), show: )
//    }
//}
