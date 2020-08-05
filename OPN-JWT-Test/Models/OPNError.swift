//
//  OPNError.swift
//  OPN-JWT-Test
//
//  Created by Roman Sorochak on 04.08.2020.
//  Copyright © 2020 StarGo. All rights reserved.
//

import Foundation

enum OPNError: Error {
    case invalidResponse
    case serverBusy
    case parsing(description: String)
    case network(description: String)
}
