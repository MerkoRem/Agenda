//
//  AddEventView.swift
//  AgendaSwiftUI
//
//  Created by Iker Rero Martínez on 19/1/23.
//

import SwiftUI

struct AddEventView: View {
    @Binding var showAddEvent : Bool
    @State var dateSelected: Date = Date()
    @State var name: String = ""
    @State var date: Int = 0
    @Binding public var selection: String
    
    let dictionaryLanguage: [String: String] = [
        "English": "en",
        "Español": "es",
        "Français": "fr",
        "português": "pt"
    ]
    
    var completion: ()->() = {}
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        ZStack{
            VStack{
                Text("Add Event")
                    .foregroundColor(.yellow)
                    .font(.system(size:50, weight: .bold))
                    .padding(.top, 40)
                
                
                DatePicker("", selection: $dateSelected, displayedComponents: .date)
                    .datePickerStyle(.graphical)
                    .tint(Color.yellow)
                    .background(.white)
                    .cornerRadius(10)
                    .padding(10)
                    .environment(\.locale, Locale.init(identifier: dictionaryLanguage[selection] ?? "en"))
                
                
                TextField("Event name" , text: $name)
                    .frame(height: 60)
                    .padding(.horizontal, 10)
                    .background(Color.white)
                    .cornerRadius(15)
                    .padding(10)
                
                Spacer()
                Button {
                    addEvent(name: name, date: Int(dateSelected.timeIntervalSince1970))
                    
                } label: {
                    Text("Add Event")
                        .foregroundColor(.black)
                        .frame(height: 80)
                        .frame(maxWidth: .infinity)
                        .background(Color.yellow)
                        .cornerRadius(25)
                        .padding(.horizontal, 10)
                        .padding(.bottom, 100)
                }.padding(20)
                
            }
            
        }
        .background(.purple)
    }
    
    
    func onSucces(){
        
        completion()
        showAddEvent = false
        
    }
    func onError(error: String){
        
    }
    
    func addEvent(name: String, date: Int){
        let dictionary: [String: Any] = [
            "name" : name,
            "date" : date
        ]
                
        NetworkHelper.shared.requestProvider(url: "https://superapi.netlify.app/api/db/eventos", params: dictionary) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                
            }else if let data = data, let response = response as? HTTPURLResponse{
                print(response.statusCode)
                print(String(bytes:data, encoding: .utf8))
                if response.statusCode == 200{
                    onSucces()
                }else{
                    onError(error: error?.localizedDescription ?? "Request error")
                }
            }
        }
    }
    
    struct AddEventView_Previews: PreviewProvider {
        static var previews: some View {
            AddEventView(showAddEvent: .constant(true), selection: .constant("en"))
        }
    }
}
