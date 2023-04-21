//
//  UsersRightsView.swift
//  BibliographicGuide
//
//  Created by Alexander on 20.04.23.
//

import SwiftUI

struct UsersRightsView: View {
    
    @State var userInformationListViewModel: UserInformationListViewModel
    @State private var showUserRightsWindow: Bool = false
    @State var userInformationViewModel = UserInformationViewModel(userInformation: UserInformation(role: "", userName: "", blockingChat: true, dateUnblockingChat: Date(), blockingAccount: true))
    
    var body: some View {
        NavigationView{
            VStack{
                Text("Пользователи".uppercased())
                    .font(.system(.title, design: .rounded))
                    .fontWeight(.bold)
                    .frame(minWidth: 200)
                    .padding(.top, 26)
                   
                
                SearchBarView(textSearch: "", isEditing: false)
                
                VStack{
                    ForEach(userInformationListViewModel.usersInformationViewModel) { users in
                        HStack{
                           // Text(users.objectWillChange.values)
                            Text(users.userInformation.userName)
                            Spacer()
                            Text(users.userInformation.role)
                        }
                        .padding([.top, .bottom], 5)
                        .padding(.leading, 15)
                        .padding(.trailing, 50)
                        .background(Color(red: 0.8745098039215686, green: 0.807843137254902, blue: 0.7058823529411765))
                        .onTapGesture {
                            userInformationViewModel = users
                            showUserRightsWindow = true
                        }
                    }
                }
                .padding([.leading, .trailing], 10)
                Spacer()
            }
            .sheet(isPresented: self.$showUserRightsWindow) {
                UserRightsView(userInformationListViewModel: userInformationListViewModel, userInformationViewModel: $userInformationViewModel)
            }
        }
    }
}

//struct UsersRightsView_Previews: PreviewProvider {
//    static var previews: some View {
//        UsersRightsView()
//    }
//}
