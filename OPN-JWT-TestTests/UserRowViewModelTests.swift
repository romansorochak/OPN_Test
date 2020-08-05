//
//  UserRowViewModel.swift
//  OPN-JWT-TestTests
//
//  Created by Roman Sorochak on 05.08.2020.
//  Copyright © 2020 StarGo. All rights reserved.
//

import XCTest
import Combine
@testable import OPN_JWT_Test

class UserRowViewModelSuccessFlowTests: XCTestCase {
    
    var disposables: Set<AnyCancellable>!
    var mockFetcher: Fetchable!
    var userRowViewModel: UserRowViewModel!

    override func setUpWithError() throws {
        disposables = Set<AnyCancellable>()
        mockFetcher = SuccessMockFetcher()
        userRowViewModel = UserRowViewModel(userID: "1", fetcher: mockFetcher)
        
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        disposables = nil
        mockFetcher = nil
        userRowViewModel = nil
        
        try super.tearDownWithError()
    }
    
    func testUsersViewModelStateChangesToDataRetreivedFlow() throws {
        XCTAssert(userRowViewModel.state == .idle)
        
        let promise = expectation(description: "ViewState should change: idle -> loading -> dataRetreived")
        
        userRowViewModel.fetchData()
        XCTAssert(userRowViewModel.state == .loading)
        
        userRowViewModel.$state.sink { viewState in
            switch viewState {
            case .dataRetreived, .error, .idle:
                promise.fulfill()
            case .loading:
                break
            }
        }.store(in: &disposables)
        
        wait(for: [promise], timeout: 5)
        
        XCTAssert(userRowViewModel.state == .dataRetreived)
        
        XCTAssert(userRowViewModel.firstName == "Roman", "userRowViewModel.firstName should be Roman")
    }
}

class UserRowViewModelFailureFlowTests: XCTestCase {
    
    var disposables: Set<AnyCancellable>!
    var mockFetcher: Fetchable!
    var userRowViewModel: UserRowViewModel!

    override func setUpWithError() throws {
        disposables = Set<AnyCancellable>()
        mockFetcher = FailureMockFetcher()
        userRowViewModel = UserRowViewModel(userID: "2", fetcher: mockFetcher)
        
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        disposables = nil
        mockFetcher = nil
        userRowViewModel = nil
        
        try super.tearDownWithError()
    }
    
    func testUsersViewModelStateChangesToErrorFlow() throws {
        XCTAssert(userRowViewModel.state == .idle)
        
        let promise = expectation(description: "ViewState should change: idle -> loading -> error")
        
        userRowViewModel.fetchData()
        XCTAssert(userRowViewModel.state == .loading)
        
        userRowViewModel.$state.sink { viewState in
            print("viewState: \(viewState)")
            switch viewState {
            case .dataRetreived, .error, .idle:
                promise.fulfill()
            case .loading:
                break
            }
        }.store(in: &disposables)
        
        wait(for: [promise], timeout: 5)
        
        switch userRowViewModel.state {
        case .error:
            XCTAssert(true)
        default:
            XCTAssert(false, "usersViewModel.state should be .error")
        }
        
        XCTAssert(userRowViewModel.firstName.isEmpty == true, "userRowViewModel.firstName should be empty")
    }
}

