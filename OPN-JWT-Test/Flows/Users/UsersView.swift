//
//  ContentView.swift
//  OPN-JWT-Test
//
//  Created by Roman Sorochak on 04.08.2020.
//  Copyright © 2020 StarGo. All rights reserved.
//

import SwiftUI

struct UsersView: View {
    
    @ObservedObject private var viewModel: UsersViewModel
    
    init(viewModel: UsersViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            content
                .navigationBarTitle("users_nav_title".localized)
        }
        .onAppear {
            self.viewModel.fetchData()
        }
    }
}

private extension UsersView {
    
    var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            return loading.eraseToAnyView()
        case .dataRetreived:
            return usersList.eraseToAnyView()
        case .error(let description):
            return errorView(description: description).eraseToAnyView()
        }
    }
    
    var loading: some View {
        Spinner(isAnimating: true, style: .large).eraseToAnyView()
    }
    
    var usersList: some View {
        List {
            Section {
                ForEach(
                    viewModel.dataSource,
                    content: UserRow.init(viewModel:)
                )
            }
        }
        .listStyle(GroupedListStyle())
    }
    
    func errorView(description: String) -> some View {
        return Text("\(description)")
            .foregroundColor(.gray)
    }
}

struct UsersView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = UsersViewModel(fetcher: TestFetcher())
        return UsersView(viewModel: viewModel)
    }
}
