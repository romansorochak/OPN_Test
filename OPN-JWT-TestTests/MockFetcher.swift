//
//  MockFetcher.swift
//  OPN-JWT-TestTests
//
//  Created by Roman Sorochak on 05.08.2020.
//  Copyright © 2020 StarGo. All rights reserved.
//

import Foundation
import Combine
@testable import OPN_JWT_Test

struct SuccessMockFetcher: Fetchable {
    
    let usersList = Users(data: ["1", "2", "3", "4", "5"])
    let userDetails = UserDetails(
        data: UserDetails.Data(
            id: "1",
            firstName: "Roman",
            lastName: "Sorochak",
            age: 26,
            gender: "Male",
            country: "Ukraine"
        )
    )
    
    func users() -> AnyPublisher<Users, OPNError> {
        return Future<Users, OPNError> { promise in
            promise(.success(self.usersList))
        }.eraseToAnyPublisher()
    }
    
    func userDetail(forID id: String) -> AnyPublisher<UserDetails, OPNError> {
        return Future<UserDetails, OPNError> { promise in
            promise(.success(self.userDetails))
        }.eraseToAnyPublisher()
    }
}

struct FailureMockFetcher: Fetchable {
    
    func users() -> AnyPublisher<Users, OPNError> {
        return Future<Users, OPNError> { promise in
            promise(.failure(OPNError.network(description: "Something went wrong")))
        }.eraseToAnyPublisher()
    }
    
    func userDetail(forID id: String) -> AnyPublisher<UserDetails, OPNError> {
        return Future<UserDetails, OPNError> { promise in
            promise(.failure(OPNError.network(description: "Something went wrong")))
        }.eraseToAnyPublisher()
    }
}
