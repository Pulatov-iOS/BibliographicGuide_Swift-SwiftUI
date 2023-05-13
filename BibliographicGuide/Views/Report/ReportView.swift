//
//  ReportView.swift
//  BibliographicGuide
//
//  Created by Alexander on 20.04.23.
//

import SwiftUI

struct ReportView: View {
    
    @State private var showCreateReportWindow = false
    
    var body: some View {
        ZStack{
            VStack{
                ZStack{
                    List{
                        ForEach(0...1, id: \.self) { (item) in
                            Text("названание")
                                   }.onDelete(perform: self.deleteItem)
                        Text("ФИО")
                        Text("Дата созд")
                        Text("Колво статей")
                    }
                    .padding(.top, 45)
                    VStack{
                        HStack{
                            Text("Отчеты".uppercased())
                                .font(.system(.title, design: .rounded))
                                .fontWeight(.bold)
                                .padding(EdgeInsets(top: 25, leading: 0, bottom: 10, trailing: 0))
                                .frame(width: UIScreen.screenWidth)
                        }
                        .background(Color(red: 0.949, green: 0.949, blue: 0.971))
                        Spacer()
                    }
                }
            }
            VStack{
                Spacer()
                HStack{
                    Spacer()
                    VStack{
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(Color.white)
                    }
                    .onTapGesture {
                        showCreateReportWindow = true
                    }
                    .frame(width: 50, height: 50)
                    .background(Color(red: 0.8745098039215686, green: 0.807843137254902, blue: 0.7058823529411765))
                    .cornerRadius(50)
                    .padding(30)
                }
            }

        }
        .sheet(isPresented: self.$showCreateReportWindow) {
            CreateReportView(reportViewModel: ReportViewModel())
        }
        .background(Color(red: 0.949, green: 0.949, blue: 0.971))
    }
    
    private func deleteItem(at indexSet: IndexSet) {
     //      self.listItems.remove(atOffsets: indexSet)
    }
}

//struct ReportView_Previews: PreviewProvider {
//    static var previews: some View {
//        ReportView()
//    }
//}
