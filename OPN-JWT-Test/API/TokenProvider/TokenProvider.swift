//
//  TokenProvider.swift
//  OPN-JWT-Test
//
//  Created by Roman Sorochak on 04.08.2020.
//  Copyright © 2020 StarGo. All rights reserved.
//

import Foundation
import SwiftJWT
import Combine

protocol TokenProvider {
    func getToken() -> String
}

struct OPNClaims: Claims {
    let uid: String
    let identity: String
}

struct JWTTokenProvider: TokenProvider {
    
    
    func getToken() -> String {
        let claims = OPNClaims(uid: "123", identity: "1234")
        
        let header = Header()
        
        var myJWT = JWT(header: header, claims: claims)
        
        let base64Encoded = Data("$SECRET$".utf8).base64EncodedData()
        
        let jwtSigner = JWTSigner.hs256(key: base64Encoded)
        
        do {
            let signedJWT = try myJWT.sign(using: jwtSigner)
            return signedJWT
        } catch {
            print(error)
            return ""
        }
    }
}
