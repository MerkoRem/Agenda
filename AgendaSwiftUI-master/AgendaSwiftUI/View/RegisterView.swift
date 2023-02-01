//
//  RegisterView.swift
//  AgendaSwiftUI
//
//  Created by Iker Rero Martínez on 12/1/23.
//

import SwiftUI

struct RegisterView: View {
    // MARK: Variable initalization
    //Here we initialize the variable that we will use to create a user
    @State var email: String=""
    @State var pass: String=""
    @State var passConfirm: String=""
    @State private var alert = false
    @State private var alertMessage = ""
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Register")
                .foregroundColor(.yellow)
                .font(.system(size: 30, weight: .bold))
                .padding(.top, 20)
            
            TextField("Email", text: $email)
                .frame(height: 44)
                .padding(.horizontal, 10)
                .background(Color.white)
                .cornerRadius(5)
                .padding(10)
                .padding(.vertical, 5)
            
            SecureInputView("Password", text: $pass) //Here we use the SecureInputView to switch between TextField and SecureField
                .frame(height: 44)
                .padding(.horizontal, 10)
                .background(Color.white)
                .cornerRadius(5)
                .padding(.horizontal, 10)
            
            
            SecureInputView("Confirm Password", text: $passConfirm)
                .frame(height: 44)
                .padding(.horizontal, 10)
                .background(Color.white)
                .cornerRadius(5)
                .padding(.horizontal, 10)
            
            Spacer()
            
            registerImage
                .padding(15)
            
            Button {
                checkFields() //We use the checkFields function to check if the email and password are acceptable
            } label: {
                Text("Register")
                    .foregroundColor(.black)
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
                    .background(Color.yellow)
                    .cornerRadius(5)
                    .padding(.all, 10)
                
            }
            //                We show the error in case user didnt input correct paramenters
            .alert("Error", isPresented: $alert) {
                Button {
                    
                } label: {
                    Text("OK")
                }
                
            } message: {
                Text(alertMessage)
            }
        }
        .background(Color.purple)
        .ignoresSafeArea(.keyboard) //We make Keyboard go over the image instead of deforming it.
        
        
    }
    //MARK: - Petitions
    func register(email: String, pass: String){
        
        let url = "https://superapi.netlify.app/api/register"
        let dictionary: [String: Any] = [
            "user" : email,
            "pass" : pass
        ]
        
        NetworkHelper.shared.requestProvider(url: url, params: dictionary) { data, response, error in
            if let error = error{
                onError(error: error.localizedDescription)
            } else if let data = data, let response = response as? HTTPURLResponse {
                print(response.statusCode)
                print(String(bytes: data, encoding: .utf8))
                
                if response.statusCode == 200 { //ok
                    self.onSuccess()
                } else { //error
                    onError(error: error?.localizedDescription ?? "Request Error")
                }
            }
        }
    }
    
    // MARK: - Accessory Views
    
    var registerImage: some View {
        Image("Register")
            .resizable()
    }
    
    // MARK: Used Funcs
    
    func onSuccess(){
        mode.wrappedValue.dismiss()
        
    }
    
    func checkFields(){
        if email.isEmpty || pass.isEmpty || passConfirm.isEmpty {
            alertMessage = "All fields must be filled."
            self.alert = true
        } else if pass != passConfirm {
            alertMessage = "Passwords don´t match."
            self.alert = true
        } else if pass.count < 8{
            alertMessage = "Passwords must be at least 8 characters."
            self.alert = true
        } else {
            register(email: email, pass: pass)
        }
    }
    
    func onError(error: String){
        //        print something
    }
    
    
}

// MARK: - Accessory Views

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}


struct SecureInputView: View {
    
    @Binding private var text: String //We use this to keep what the user wrote when we cahnge from textField to secureField
    @State private var isSecured: Bool = true //Check if password is being showed or not
    private var title: String
    
//    preserve the text
    init(_ title: String, text: Binding<String>) {
        self.title = title
        self._text = text
    }
    
    var body: some View {
        ZStack(alignment: .trailing) {
            Group {
                //Set Secure and text field
                if isSecured {
                    SecureField(title, text: $text)
                } else {
                    TextField(title, text: $text)
                }
            }.padding(.trailing, 32)
            
            Button(action: {
                isSecured.toggle() //change between Secure and text field
            }) {
                Image(systemName: self.isSecured ? "eye.slash" : "eye")
                    .accentColor(.gray)
                    .tint(Color.yellow)
            }
        }
    }
}
