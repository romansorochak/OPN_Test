//
//  UserRowViewModel.swift
//  OPN-JWT-Test
//
//  Created by Roman Sorochak on 04.08.2020.
//  Copyright © 2020 StarGo. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

class UserRowViewModel: ObservableObject, Identifiable {
    
    private let fetcher: Fetchable
    
    private var disposables = Set<AnyCancellable>()
    
    private var userDetails: UserDetails?
    private let userID: String
    
    var id: String {
        return userID
    }
    
    var firstName: String {
        return userDetails?.data.firstName ?? ""
    }
    @Published private (set) var state: ViewState = .idle
    
    
    init(userID: String, fetcher: Fetchable) {
        self.userID = userID
        self.fetcher = fetcher
    }
    
    func fetchData() {
        state = .loading
        fetcher.userDetail(forID: userID)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] value in
                    guard let self = self else { return }
                    switch value {
                    case .failure(let error):
                        self.state = .error(description: error.localizedDescription)
                    case .finished:
                        self.state = .dataRetreived
                    }
                },
                receiveValue: { [weak self] userDetail in
                    guard let self = self else { return }
                    
                    self.userDetails = userDetail
            })
            .store(in: &disposables)
    }
}


extension UserRowViewModel {
    
    var userDetailsView: some View {
        guard let details = userDetails else {
            return Text("No user found").eraseToAnyView()
        }
        let viewModel = UserDetailsViewModel(userDetails: details)
        return UserDetailsView(viewModel: viewModel).eraseToAnyView()
    }
}
