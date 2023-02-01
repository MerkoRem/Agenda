//
//  ScheduleView.swift
//  AgendaSwiftUI
//
//  Created by Iker Rero Martínez on 19/1/23.
//

import SwiftUI

struct AgendaView: View {
    // MARK: Variable initalization
    //Here we initialize the variable that we will use to create a user
    @State var dateSelected: Date = Date()
    @State var events: [EventPresentationModel] = []
    @State private var showAddEvent = false
    @State public var selection = "English"
    let languages = ["English", "Español", "Français", "português"]
    let dictionaryLanguage: [String: String] = [
        "English": "en",
        "Español": "es",
        "Français": "fr",
        "português": "pt"
    ]
    
    //MARK: - Body
    var body: some View {
        ZStack{
            VStack(spacing:10){
                Text("Schedule")
                    .foregroundColor(.yellow)
                    .font(.system(size:50, weight: .bold))
                    .padding(.top, 20)
                
                
                //                Language picker for the Calendar
                Picker("Select a language", selection: $selection) {
                    ForEach(languages, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.menu)
                .tint(Color.purple)
                .background(.yellow)
                .cornerRadius(10)
                .padding(5)
                
                
                //                Datepicker
                DatePicker("", selection: $dateSelected, displayedComponents: .date)
                    .datePickerStyle(.graphical)
                    .tint(Color.yellow)
                    .background(.white)
                    .cornerRadius(10)
                    .padding(10)
                    .environment(\.locale, Locale.init(identifier: dictionaryLanguage[selection] ?? "en")) //Set language to the selected one
                
                
                //                Show events in a Table via LazyVStack
                ScrollView{
                    LazyVStack(spacing: 2) {
                        ForEach(events) { event in
                            HStack{
                                Text(event.name)
                                    .fixedSize()
                                    .foregroundColor(Color.purple)
                                Spacer()
                                Text("\(getDate(event: event))")
                                    .fixedSize()
                                    .foregroundColor(.purple)
                            }
                            .frame(height:44)
                            .padding(10)
                            .background(.white)
                            .cornerRadius(8)
                        }
                    }
                    
                }
                
            }
            .padding()
            .background(.purple)
        }
        .sheet(isPresented: $showAddEvent, content:{
            AddEventView(showAddEvent: $showAddEvent, selection: $selection) {
                getEvents()
            }
        })
        
        .toolbar{
            Button{
                showAddEvent = true
            }label: {
                Image(systemName: "plus")
                    .font(.system(size: 20))
                    .tint(Color.yellow)
                
            }
        }
        
        .onAppear {
            getEvents()
        }.onChange(of: dateSelected){newValue in
            //     let newDate = Int(dateSelected.timeIntervalSince1970)
            
        }
    }
    //   MARK: - Functions
    func getEvents(){
        
        NetworkHelper.shared.requestProvider(url: "https://superapi.netlify.app/api/db/eventos", type: .GET) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                
            }else if let data = data, let response = response as? HTTPURLResponse{
                print(response.statusCode)
                print(String(bytes:data, encoding: .utf8))
                if response.statusCode == 200{
                    onSucces(data: data)
                    
                }else{
                    onError(error: error?.localizedDescription ?? "Request error")
                    
                }
            }
        }
    }
    
    func onSucces(data: Data){
        do{
            let eventsNotFiltered = try JSONDecoder().decode([EventResponseModel?].self, from: data)
            events = eventsNotFiltered.compactMap({ eventNotFiltered in
                guard let date = eventNotFiltered?.date else { return nil }
                return EventPresentationModel(name: eventNotFiltered?.name ?? "", date: date)
            })
        }catch{
            self.onError(error: error.localizedDescription)
        }
    }
    func onError(error: String){
        
    }
    
    //    func getLanguage() -> String{
    //        language = ""
    //        if let language = dictionaryLanguage[selection]{
    //            return language
    //        }
    //    }
}

func getDate(event: EventPresentationModel) -> String{
    let date = NSDate(timeIntervalSince1970: TimeInterval(event.date))
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "es_ES")
    dateFormatter.dateFormat = "dd-MM-YYYY"
    let converted = dateFormatter.string(from: date as Date)
    
    return converted
}

// MARK: - Preview


struct AgendaView_Previews: PreviewProvider {
    static var previews: some View {
        AgendaView()
    }
}
