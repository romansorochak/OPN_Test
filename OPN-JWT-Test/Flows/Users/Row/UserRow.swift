//
//  UserRow.swift
//  OPN-JWT-Test
//
//  Created by Roman Sorochak on 04.08.2020.
//  Copyright © 2020 StarGo. All rights reserved.
//

import SwiftUI

struct UserRow: View {
    @ObservedObject private var viewModel: UserRowViewModel
    
    init(viewModel: UserRowViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        switch viewModel.state {
        case .idle, .loading:
            return loading.onAppear {
                if self.viewModel.state == .idle {
                    self.viewModel.fetchData()
                }
            }.eraseToAnyView()
        case .dataRetreived:
            return nameView.eraseToAnyView()
        case .error(let description):
            return errorView(description: description)
        }
    }
}

private extension UserRow {
    
    var loading: AnyView {
        Text("Loading ...")
            .foregroundColor(.gray)
            .eraseToAnyView()
    }
    
    var nameView: AnyView {
        NavigationLink(destination: viewModel.userDetailsView) {
            Text("\(viewModel.firstName)")
                .font(.body)
        }.eraseToAnyView()
    }
    
    func errorView(description: String) -> AnyView {
        return Text("\(description)")
            .foregroundColor(.gray)
            .eraseToAnyView()
    }
}
