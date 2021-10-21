//
//  PhotoModel.swift
//  Gora
//
//  Created by Антон Усов on 19.10.2021.
//

import UIKit

class Photo: Decodable {
    var albumId: Int
    var title: String
    var url: String
    var image: Data?
}


