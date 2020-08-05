//
//  ViewState.swift
//  OPN-JWT-Test
//
//  Created by Roman Sorochak on 04.08.2020.
//  Copyright © 2020 StarGo. All rights reserved.
//

import Foundation

enum ViewState: Equatable {
    case idle
    case loading
    case dataRetreived
    case error(description: String)
}
