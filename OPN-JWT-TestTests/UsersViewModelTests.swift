//
//  OPN_JWT_TestTests.swift
//  OPN-JWT-TestTests
//
//  Created by Roman Sorochak on 04.08.2020.
//  Copyright © 2020 StarGo. All rights reserved.
//

import XCTest
import Combine
@testable import OPN_JWT_Test

class UsersViewModelSuccessFlowTests: XCTestCase {
    
    var disposables: Set<AnyCancellable>!
    var mockFetcher: Fetchable!
    var usersViewModel: UsersViewModel!

    override func setUpWithError() throws {
        disposables = Set<AnyCancellable>()
        mockFetcher = SuccessMockFetcher()
        usersViewModel = UsersViewModel(fetcher: mockFetcher)
        
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        disposables = nil
        mockFetcher = nil
        usersViewModel = nil
        
        try super.tearDownWithError()
    }
    
    func testUsersViewModelStateChangesToDataRetreivedFlow() throws {
        XCTAssert(usersViewModel.state == .idle)
        
        let promise = expectation(description: "ViewState should change: idle -> loading -> dataRetreived")
        
        usersViewModel.fetchData()
        XCTAssert(usersViewModel.state == .loading)
        
        usersViewModel.$state.sink { viewState in
            switch viewState {
            case .dataRetreived, .error, .idle:
                promise.fulfill()
            case .loading:
                break
            }
        }.store(in: &disposables)
        
        wait(for: [promise], timeout: 5)
        
        XCTAssert(usersViewModel.state == .dataRetreived)
        
        XCTAssert(usersViewModel.dataSource.isEmpty == false, "usersViewModel.dataSource should not be empty")
    }
}

class UsersViewModelFailureFlowTests: XCTestCase {
    
    var disposables: Set<AnyCancellable>!
    var mockFetcher: Fetchable!
    var usersViewModel: UsersViewModel!

    override func setUpWithError() throws {
        disposables = Set<AnyCancellable>()
        mockFetcher = FailureMockFetcher()
        usersViewModel = UsersViewModel(fetcher: mockFetcher)
        
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        disposables = nil
        mockFetcher = nil
        usersViewModel = nil
        
        try super.tearDownWithError()
    }
    
    func testUsersViewModelStateChangesToErrorFlow() throws {
        XCTAssert(usersViewModel.state == .idle)
        
        let promise = expectation(description: "ViewState should change: idle -> loading -> error")
        
        usersViewModel.fetchData()
        XCTAssert(usersViewModel.state == .loading)
        
        usersViewModel.$state.sink { viewState in
            switch viewState {
            case .dataRetreived, .error, .idle:
                promise.fulfill()
            case .loading:
                break
            }
        }.store(in: &disposables)
        
        wait(for: [promise], timeout: 5)
        
        switch usersViewModel.state {
        case .error:
            XCTAssert(true)
        default:
            XCTAssert(false, "usersViewModel.state should be .error")
        }
        
        XCTAssert(usersViewModel.dataSource.isEmpty == true, "usersViewModel.dataSource should be empty")
    }
}
