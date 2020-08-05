//
//  UserDetailsViewModel.swift
//  OPN-JWT-Test
//
//  Created by Roman Sorochak on 04.08.2020.
//  Copyright © 2020 StarGo. All rights reserved.
//

import Foundation


class UserDetailsViewModel: ObservableObject {
    
    private let userDetails: UserDetails
    
    init(userDetails: UserDetails) {
        self.userDetails = userDetails
    }
    
    var firstName: String {
        return userDetails.data.firstName
    }
    
    var lastName: String {
        return userDetails.data.lastName
    }
    
    var fullName: String {
        return firstName + " " + lastName
    }
    
    var age: String {
        return userDetails.data.age.string
    }
    
    var gender: String {
        return userDetails.data.gender
    }
    
    var country: String {
        return userDetails.data.country
    }
}
