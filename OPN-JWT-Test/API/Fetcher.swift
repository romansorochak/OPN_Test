//
//  Fetcher.swift
//  OPN-JWT-Test
//
//  Created by Roman Sorochak on 04.08.2020.
//  Copyright © 2020 StarGo. All rights reserved.
//

import Foundation
import Combine

protocol Fetchable {
    func users() -> AnyPublisher<Users, OPNError>
    
    func userDetail(forID id: String) -> AnyPublisher<UserDetails, OPNError>
}

class Fetcher {
    private let session: URLSession
    private let tokenProvider: TokenProvider
    
    init(session: URLSession = .shared,
         tokenProvider: TokenProvider) {
        self.session = session
        self.tokenProvider = tokenProvider
    }
}

// MARK: - OPN API
private extension Fetcher {
    struct OPNAPI {
        static let scheme = "https"
        static let host = "opn-interview-service.nn.r.appspot.com"
    }
    
    func makeUsersComponents() -> URLComponents {
        var components = URLComponents()
        components.scheme = OPNAPI.scheme
        components.host = OPNAPI.host
        components.path = "/list"
        
        return components
    }
    
    func makeUserDetailComponents(withID id: String) -> URLComponents {
        var components = URLComponents()
        components.scheme = OPNAPI.scheme
        components.host = OPNAPI.host
        components.path = "/get/\(id)"
        
        return components
    }
}


// MARK: - WeatherFetchable
extension Fetcher: Fetchable {
    
    func users() -> AnyPublisher<Users, OPNError> {
        return request(withComponents: makeUsersComponents())
    }
    
    func userDetail(forID id: String) -> AnyPublisher<UserDetails, OPNError> {
        return request(withComponents: makeUserDetailComponents(withID: id))
    }
    
    
    private func request<T>(
        withComponents components: URLComponents
    ) -> AnyPublisher<T, OPNError> where T: Decodable {
        
        guard let url = components.url else {
            let error = OPNError.network(description: "Couldn't create URL")
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        var urlRequest = URLRequest(url: url)
        let token = tokenProvider.getToken()
        urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return session.dataTaskPublisher(for: urlRequest)
            .mapError { error in
                .network(description: error.localizedDescription)
        }
        .flatMap(maxPublishers: .max(1)) { pair in
            decode(pair.data)
        }
        .retry(3)
        .eraseToAnyPublisher()
    }
}


struct TestFetcher: Fetchable {
    
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
