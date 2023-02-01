//
//  LoginView.swift
//  AgendaSwiftUI
//
//  Created by Alejandro Garcia on 9/1/23.
//

import SwiftUI

struct LoginView: View {
    // MARK: Variable initalization
    //Here we initialize the variable that we will use to enter with a user
    @State var email: String = ""
    @State var pass: String = ""
    @State var showAgenda: Bool = false
    @State private var alert = false
    @State private var alertMessage = ""
    
    // MARK: - Body
    var body: some View {
        NavigationView{
            VStack(spacing: 10) {
                Text("Login")
                    .foregroundColor(.yellow)
                    .font(.system(size: 30, weight: .bold))
                    .padding(.top, 20)
                
                TextField("Email", text: $email)
                    .frame(height: 44)
                    .padding(.horizontal, 10)
                    .background(Color.white)
                    .cornerRadius(5)
                    .padding(10)
                
                SecureInputView("Password", text: $pass)
                    .frame(height: 44)
                    .padding(.horizontal, 10)
                    .background(Color.white)
                    .cornerRadius(5)
                    .padding(10)
                
                
                Spacer()
                
                loginImage
                    .padding(15)
                
                //                Navigate to AgendaView
                Button {
                    checkFields() //We use the checkFields function to check if the email and password are acceptable
                } label: {
                    Text("Login")
                        .foregroundColor(.black)
                        .frame(height: 60)
                        .frame(maxWidth: .infinity)
                        .background(Color.yellow)
                        .cornerRadius(5)
                        .padding(.all, 10)
                    
                }.alert("Error", isPresented: $alert) {
                    Button {
                        
                    } label: {
                        Text("OK")
                    }
                    
                } message: {
                    Text(alertMessage)
                }
                .background(NavigationLink(destination: AgendaView(),
                                           isActive: $showAgenda) {
                    EmptyView()
                })
                
                HStack{
                    Text("Not regiretered yet?")
                        .foregroundColor(.black)
                        .font(.system(size: 18, weight: .bold))
                    
                    //Navigate to Sign In
                    NavigationLink{
                        RegisterView()
                    }label: {
                        Text("Sign In!")
                            .foregroundColor(.yellow)
                            .font(.system(size: 18, weight: .bold))
                            .underline()
                    }
                    
                    
                    
                }
            }
            .background(Color.purple)
            .ignoresSafeArea(.keyboard)
            
            
        }.accentColor(.yellow)
    }
    
    
    // MARK: - Accessory View
    
    var loginImage: some View {
        Image("Login")
            .resizable()
    }
    
    // MARK: Used Funcs
    func checkFields(){
        if email.isEmpty || pass.isEmpty{
            alertMessage = "All fields must be filled."
            self.alert = true
        } else {
            login(email: email, password: pass)
        }
    }
    
    func onSucces(){
        showAgenda = true
        
    }
    func onError(error: String){
        alertMessage = "User or password is not correct or doesn´t exist."
        self.alert = true
    }
    //MARK: - Petitions
    func login(email: String, password: String){
        
        let dictionary: [String: Any] = [
            "user" : email,
            "pass" : password
        ]
        
        
        
        NetworkHelper.shared.requestProvider(url: "https://superapi.netlify.app/api/login", params: dictionary) { data, response, error in
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
}

struct LoginView_Previews: PreviewProvider {
    // MARK: - Preview
    static var previews: some View {
        LoginView()
    }
}

