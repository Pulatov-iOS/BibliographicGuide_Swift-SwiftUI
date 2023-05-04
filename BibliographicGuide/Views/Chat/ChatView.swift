//
//  ChatView.swift
//  BibliographicGuide
//
//  Created by Alexander on 4.04.23.
//

import SwiftUI

struct ChatView: View {
    var body: some View {
        NavigationView{
            VStack{
                MessageListView(messageListViewModel: MessageListViewModel())
            }
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
