//
//  UserDetailsViewModelTests.swift
//  OPN-JWT-TestTests
//
//  Created by Roman Sorochak on 05.08.2020.
//  Copyright © 2020 StarGo. All rights reserved.
//

import Foundation
import XCTest
@testable import OPN_JWT_Test

class UserDetailsViewModelSuccessFlowTests: XCTestCase {
    
    var mockUserDetails: UserDetails!
    var userDetailsViewModel: UserDetailsViewModel!

    override func setUpWithError() throws {
        mockUserDetails = SuccessMockFetcher().userDetails
        userDetailsViewModel = UserDetailsViewModel(userDetails: mockUserDetails)
        
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        mockUserDetails = nil
        userDetailsViewModel = nil
        
        try super.tearDownWithError()
    }
    
    func testAllFieldsContainCorrectData() throws {
        XCTAssert(userDetailsViewModel.firstName == "Roman", "first name should be Roman")
        XCTAssert(userDetailsViewModel.lastName == "Sorochak", "last name should be Sorochak")
        XCTAssert(userDetailsViewModel.fullName == "Roman Sorochak", "full name should be Roman Sorochak")
        XCTAssert(userDetailsViewModel.age == "26", "age should be 26")
        XCTAssert(userDetailsViewModel.gender == "Male", "gender name should be Male")
        XCTAssert(userDetailsViewModel.country == "Ukraine", "country name should be Ukraine")
    }
}
