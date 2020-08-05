//
//  UsersViewModel.swift
//  OPN-JWT-Test
//
//  Created by Roman Sorochak on 04.08.2020.
//  Copyright © 2020 StarGo. All rights reserved.
//

import SwiftUI
import Combine

class UsersViewModel: ObservableObject {
    
    private let fetcher: Fetchable
    
    private var disposables = Set<AnyCancellable>()
    
    @Published var state: ViewState = .idle
    @Published var dataSource: [UserRowViewModel] = []
    
    
    init(fetcher: Fetchable) {
        self.fetcher = fetcher
    }
    
    
    func fetchData() {
        state = .loading
        fetcher.users()
            .map { response in
                response.data.map { item in
                    return UserRowViewModel(
                        userID: item,
                        fetcher: self.fetcher
                    )
                }
        }
        .receive(on: DispatchQueue.main)
        .sink(
            receiveCompletion: { [weak self] value in
                guard let self = self else { return }
                switch value {
                case .failure(let error):
                    self.state = .error(description: error.localizedDescription)
                    self.dataSource = []
                case .finished:
                    self.state = .dataRetreived
                }
            },
            receiveValue: { [weak self] dataSource in
                guard let self = self else { return }
                
                self.dataSource = dataSource
        })
            .store(in: &disposables)
    }
}
