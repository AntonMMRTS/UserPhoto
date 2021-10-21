//
//  NetworkManager.swift
//  Gora
//
//  Created by Антон Усов on 19.10.2021.
//

import UIKit

class PhotoManager {
    
    func getAlbums(userID: Int, completion: @escaping ([Photo]) -> Void) {
        
        let urlString = "https://jsonplaceholder.typicode.com/albums"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard let data = data, error == nil else { return }
            do {
                let allAlbums = try JSONDecoder().decode([Album].self, from: data).filter { $0.userId == userID }
                
                var photos: [Photo] = []
                
                for i in allAlbums {
                    self.getPhotos(albumId: i.id) { (newPhotos) in
                        photos += newPhotos
                        
                        if i == allAlbums.last {
                            DispatchQueue.main.async {
                                completion(photos)
                            }
                        }
                    }
                }
            }
            catch {
                print(error)
            }
        }.resume()
    }
    
    func getPhotos(albumId: Int, completion: @escaping ([Photo]) -> Void) {
        
        let urlString = "https://jsonplaceholder.typicode.com/photos"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard let data = data,
                  error == nil  else { return }
            do {
                let photos = try JSONDecoder().decode([Photo].self, from: data).filter { $0.albumId == albumId }
                
                DispatchQueue.main.async {
                    completion(photos)
                }
            }
            catch {
                print(error)
            }
        }.resume()
    }
    
}
