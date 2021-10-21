//
//  UserManager.swift
//  Gora
//
//  Created by Антон Усов on 21.10.2021.
//

import Foundation

class UserManager {
    
    func getUsers(completion: @escaping ([User]) -> Void) {
        
        let urlString = "https://jsonplaceholder.typicode.com/users"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard let data = data, error == nil else { return }
            do {
                let users = try JSONDecoder().decode([User].self, from: data)
                DispatchQueue.main.async {
                    completion(users)
                }
            }
            catch {
                print(error)
            }
        }.resume()
    }
    
}
