//
//  ContentView.swift
//  QuickRuns
//
//  Created by Joey Zielinski on 6/29/20.
//  Copyright © 2020 Joey Zielinski. All rights reserved.
//

import SwiftUI

let apiUri: String = "https://quickruns-api.herokuapp.com"

struct ContentView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var buttonText: String = "Login"
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Quick Runs")
                .font(.largeTitle)
            
            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("\(buttonText)") {
                self.buttonText = "Loading..."
                self.authenticate(username: self.username, password: self.password)
            }
            .padding()
            .foregroundColor(Color.white)
            .background(Color.blue)
            .cornerRadius(10)
        }
    }
    
    func authenticate(username: String, password: String) {
        let url = URL(string: apiUri + "/api/login")!
        let json = [
            "username": username,
            "password": password
        ]
        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: [])
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            let finalData = try! JSONDecoder().decode(LoginResponse.self, from: data)
            print(finalData)
        }.resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct User: Decodable {
    let id: Int
    let first_name: String
    let last_name: String
    let email: String
    let username: String
    let created_at: String
}

struct LoginResponse: Decodable {
    let access_token: String
    let user: User
}
