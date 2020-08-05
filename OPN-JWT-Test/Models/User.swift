//
//  User.swift
//  OPN-JWT-Test
//
//  Created by Roman Sorochak on 04.08.2020.
//  Copyright © 2020 StarGo. All rights reserved.
//

import Foundation

struct Users: Codable {
    let data: [String]
}

struct UserDetails: Codable {
    let data: Data
    
    struct Data: Codable {
        let id: String
        let firstName: String
        let lastName: String
        let age: Int
        let gender: String
        let country: String
    }
}
