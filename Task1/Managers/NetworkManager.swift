//
//  NetworkManager.swift
//  Task1
//
//  Created by mac on 02/03/2025.
//

import Foundation

class NetworkManager{
    // Create a Singleton Instance
    static let shared = NetworkManager()
    private let urlString = "https://jsonplaceholder.typicode.com/users"
    
    
    func fetchContacts(completion: @escaping(Result<[Contact], Error>) -> Void){
        guard let url = URL(string: urlString) else{
            completion(.failure(NSError(domain: "Invalid URL", code: 400)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error{
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: 404)))
                return
            }
            
            do{
                let contacts = try JSONDecoder().decode([Contact].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(contacts))
                }
                
            }catch{
                completion(.failure(error))
            }
        }.resume()
         
        
    }
}
