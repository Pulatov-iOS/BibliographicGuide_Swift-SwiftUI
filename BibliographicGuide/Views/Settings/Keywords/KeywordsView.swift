//
//  KeywordsView.swift
//  BibliographicGuide
//
//  Created by Alexander on 20.04.23.
//

import SwiftUI

struct KeywordsView: View {
    
    @State var key = ["ядерный", "журнал", "социальный", "научный"]
    @State var idSelectedKeyword = ""
    @State var addKeyword = false
    @State var newKeywordName = ""

    var body: some View {
        NavigationView{
            VStack{
                ZStack{
                    VStack{
                        Text("Ключевые слова".uppercased())
                            .font(.system(.title, design: .rounded))
                            .fontWeight(.bold)
                            .frame(minWidth: 200)
                            .padding(.top, 26)
                            .padding(.bottom, 15)
                    }
                    HStack{
                        Spacer()
                        Button{
                           addKeyword = true
                        } label: {
                            Image(systemName: "plus")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(Color.green)
                        }
                        .padding(20)
                    }
                }
                
                SearchBarView(textSearch: "", isEditing: false)
                
                if(addKeyword == true){
                    HStack{
                        TextField("Кл. слово", text: $newKeywordName)
                        Spacer()
                        Button("Cancel"){
                            addKeyword = false
                        }
                        Button("Add"){
                            addKeyword = false
                        }
                    }
                    .padding(10)
                }
                
                ForEach((0...3), id: \.self) {i in
                    HStack{
                        VStack{
                            VStack{
                                HStack{
                                    Text(" \(i+1). ")
                                    Text(key[i])
                                    Spacer()
                                }
                                
                                .padding(5)
                            }
                            .background(Color(red: 0.8745098039215686, green: 0.807843137254902, blue: 0.7058823529411765))
                            .onTapGesture {
                                if(idSelectedKeyword == ""){
                                    idSelectedKeyword = String(i)
                                }
                                else{
                                    idSelectedKeyword = ""
                                }
                            }
                            if(String(i) == idSelectedKeyword){
                                HStack{
                                    TextField("Кл. слово", text: $newKeywordName)
                                        .background(Color.white)
                                        .border(Color(red: 0.8745098039215686, green: 0.807843137254902, blue: 0.7058823529411765))
                                    Spacer()
                                    Button("Delete"){
                                        
                                    }
                                    Button("Save"){
                                        
                                    }
                                }
                            }
                        }
                        
                    }
                    .background(Color(red: 0.8745098039215686, green: 0.807843137254902, blue: 0.7058823529411765)
                    )
                
                    .padding([.leading, .trailing], 10)
                }
                

                Spacer()
            }
        }
    }
}

struct KeywordsView_Previews: PreviewProvider {
    static var previews: some View {
        KeywordsView()
    }
}
