//
//  ImageManager.swift
//  Gora
//
//  Created by Антон Усов on 21.10.2021.
//

import Foundation

class Cache: NSCache<NSString, NSData> {

    static let shared = Cache()

    private override init() {}
 }


class ImageManager {
    
    func getImage(url: String, completion: @escaping (NSData?) -> Void) {
        
        if let cacheImage = Cache.shared.object(forKey: url as NSString) {
           
            DispatchQueue.main.async {
                completion(cacheImage)
            }
            
        } else {
            guard let url = URL(string: url) else { return }
            
            let request = URLRequest(url: url,
                                     cachePolicy: .returnCacheDataElseLoad,
                                     timeoutInterval: 10)
            
            URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
                
                guard let data = data as NSData?, error == nil,
                      let `self` = self else { return }
                
                Cache.shared.setObject(data, forKey: url.absoluteString as NSString)
                
                DispatchQueue.main.async {
                    completion(data)
                }
            }.resume()
        }
    }
    
}
