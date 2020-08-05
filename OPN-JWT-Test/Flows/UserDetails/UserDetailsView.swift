//
//  UserDetailsView.swift
//  OPN-JWT-Test
//
//  Created by Roman Sorochak on 04.08.2020.
//  Copyright © 2020 StarGo. All rights reserved.
//

import SwiftUI


struct UserDetailsView: View {
    
    private var viewModel: UserDetailsViewModel
    
    
    init(viewModel: UserDetailsViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        List {
            Section {
                row(left: "first_name".localized, right: viewModel.firstName)
                row(left: "last_name".localized, right: viewModel.lastName)
                row(left: "age".localized, right: viewModel.age)
                row(left: "gender".localized, right: viewModel.gender)
                row(left: "country".localized, right: viewModel.country)
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle(viewModel.fullName)
    }
}

private extension UserDetailsView {
    
    func row(left: String, right: String) -> some View {
        return HStack {
            Text(left)
                .font(.body)
            Spacer()
            Text(right)
                .foregroundColor(.gray)
        }
    }
}


struct UserDetailsView_Previews: PreviewProvider {
    
    static var previews: some View {
        let userDetails = UserDetails(
            data: UserDetails.Data(
                id: "asdfaf",
                firstName: "Roman",
                lastName: "Sorochak",
                age: 26,
                gender: "Male",
                country: "Ukraine"
            )
        )
        return NavigationView {
            UserDetailsView(
                viewModel: UserDetailsViewModel(userDetails: userDetails)
            )
        }
    }
}
