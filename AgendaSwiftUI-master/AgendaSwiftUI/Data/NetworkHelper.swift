//
//  NetworkHelper.swift
//  AgendaSwiftUI
//
//  Created by Iker Rero Martínez on 16/1/23.
//

import Foundation

class NetworkHelper {
    
     enum RequestType: String {
        case POST
        case GET
    }
    
//    Singleton
    static let shared = NetworkHelper()
    
    //    se comunica con la API
   private func requestAPI(request: URLRequest, completion: @escaping (_ data: Data?, _ reponse: URLResponse?, _ error: Error?) -> Void){
        let task = URLSession.shared.dataTask(with: request) { data, response, error in completion(data, response, error)
        }
        task.resume()
        
    }
    
    //    se comunica con la funcion requestAPI, capa repositoy
    func requestProvider(url: String, type: RequestType = .POST, params: [String: Any]? = nil, completion: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) -> Void{
        let url = URL(string: url)
        
        guard let urlNotNil = url else { return }
        var request = URLRequest(url: urlNotNil)
        
        request.httpMethod = type.rawValue
        
        if let dictionary = params {
            let data = try! JSONSerialization.data(withJSONObject: dictionary, options: [])
            request.httpBody = data
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        requestAPI(request: request) { data, reponse, error in
            DispatchQueue.main.async {
                completion(data, reponse, error)
            }
        }
        
//        if let urlNotNil = url{
//            var request = URLRequest(url: urlNotNil)
//        } else{
//            return
//        }
    }
//
//    func devuelveString(nombre: String?) -> String {
//        guard let nombre = nombre else { return "" }
//        return nombre
//    }
}
