//
//  UsersRightsView.swift
//  BibliographicGuide
//
//  Created by Alexander on 20.04.23.
//

import SwiftUI

struct UsersRightsView: View {
    
    @EnvironmentObject var userInformationListViewModel: UserInformationListViewModel
    
    @State private var showUserRightsWindow: Bool = false
    @State var selectedUser = UserInformation(role: "", userName: "", updatingImage: 0, blockingChat: true, blockingAccount: true, reasonBlockingAccount: "", language: "")
    
    @State var isSearching = false
    
    var body: some View {
        VStack{
            ZStack{
                VStack{
                    if(!(isSearching == true && userInformationListViewModel.searchUsersInformation.count == 0)){
                        List{
                            if(isSearching == true){
                                ForEach(userInformationListViewModel.searchUsersInformation) { userInformation in
                                    HStack{
                                        Text("\(userInformation.userInformation.userName)")
                                            .lineLimit(1)
                                        Spacer()
                                        HStack{
                                            Text(stringUserRole(userInformation.userInformation.role))
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        showUserRightsWindow.toggle()
                                        selectedUser = userInformation.userInformation
                                    }
                                    .onChange(of: userInformation.userInformation){ Value in
                                        if(selectedUser.id == userInformation.userInformation.id){
                                            selectedUser = Value
                                        }
                                    }
                                }
                            }
                            else{
                                ForEach(userInformationListViewModel.usersInformationViewModel) { userInformation in
                                    HStack{
                                        Text("\(userInformation.userInformation.userName)")
                                            .lineLimit(1)
                                        Spacer()
                                        HStack{
                                            Text(stringUserRole(userInformation.userInformation.role))
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        showUserRightsWindow.toggle()
                                        selectedUser = userInformation.userInformation
                                    }
                                    .onChange(of: userInformation.userInformation){ Value in
                                        if(selectedUser.id == userInformation.userInformation.id){
                                            selectedUser = Value
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.top, 87)
                    }
                }
                
                VStack{
                    HStack{
                        Text("Пользователи".uppercased())
                            .font(.system(.title, design: .rounded))
                            .fontWeight(.bold)
                            .padding(EdgeInsets(top: 25, leading: 0, bottom: 5, trailing: 0))
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color(red: 0.949, green: 0.949, blue: 0.971))
                    
                    SearchBarUserRightsView(isSearching: $isSearching)
                        .padding(.bottom, 8)
                        .background(Color(red: 0.949, green: 0.949, blue: 0.971))
                        .environmentObject(userInformationListViewModel)
                    
                    Spacer()
                }
            }
        }
        .background(Color(red: 0.949, green: 0.949, blue: 0.971))
        .sheet(isPresented: self.$showUserRightsWindow) {
            UserRightsView(selectedUser: $selectedUser)
                .environmentObject(userInformationListViewModel)
        }
    }
    
    func stringUserRole(_ userRole: String) -> String {
        switch userRole {
        case "reader":
            return "Читатель"
        case "editor":
            return "Редактор"
        case "admin":
            return "Администратор"
        default:
            return "Читатель"
        }
    }
}

//struct UsersRightsView_Previews: PreviewProvider {
//    static var previews: some View {
//        UsersRightsView()
//    }
//}
