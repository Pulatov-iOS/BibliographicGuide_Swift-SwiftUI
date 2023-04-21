//
//  UserRightsView.swift
//  BibliographicGuide
//
//  Created by Alexander on 20.04.23.
//

import SwiftUI

struct UserRightsView: View {
    
    @State var userInformationListViewModel: UserInformationListViewModel
    @Binding var userInformationViewModel: UserInformationViewModel
    
    @State private var isBlockingChat = false
    @State private var blockingAccount = false
    @State private var currentDate = Date()
    @State var newUserName = ""
    
    var body: some View {
        NavigationView{
            VStack{
                Text(userInformationViewModel.userInformation.userName.uppercased())
                    .font(.system(.title, design: .rounded))
                    .fontWeight(.bold)
                    .frame(minWidth: 200)
                    .padding(.top, 26)
                    .padding(.bottom, 15)
                
                VStack{
                    HStack{
                        Text("Роль:")
                        Spacer()
                        Text(userInformationViewModel.userInformation.role)
                    }
                    HStack{
                        Text("Блокировка чата:")
                        Toggle("", isOn: $isBlockingChat).onTapGesture {
                            isBlockingChat.toggle()
                            if(isBlockingChat == false){
                                
                            }
                            else{
                                
                            }
                        }
                    }
                    HStack{
                        VStack{
                            HStack{
                                Text("Дата разблокирования чата:")
                                Spacer()
                            }
                            DatePicker("", selection: $currentDate, displayedComponents: [.date, .hourAndMinute])
                                .labelsHidden()
                        }
                    }
                    HStack{
                        Text("Блокировка учетной записи:")
                        Toggle("", isOn: $blockingAccount).onTapGesture {
                            blockingAccount.toggle()
                            if(blockingAccount == false){
                                
                            }
                            else{
                                
                            }
                        }
                    }
                    HStack{
                        Text("Новое имя польз.:")
                        TextField(userInformationViewModel.userInformation.userName, text: $newUserName)
                        Spacer()
                        Button{
                           
                        } label: {
                            Image(systemName: "doc.text")
                                .resizable()
                                .frame(width: 20, height: 28)
                                .foregroundColor(Color.black)
                        }
                        .padding(8)
                    }
                }.padding(20)
                Spacer()
            }
        }
    }
}

//struct UserRightsView_Previews: PreviewProvider {
//    static var previews: some View {
//        UserRightsView()
//    }
//}
