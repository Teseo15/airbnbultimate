//
//  Places.swift
//  semana7-b
//
//  Created by Linder Hassinger on 6/10/21.
//

import Foundation

class Place: Codable {
    
    let name: String
    let address: String
    let rating: Float
    let userRatingsTotal: Int
    let photo: String
    let latitude: String
    let longitude: String
    let id: String
}
