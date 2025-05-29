//
//  RoutingCoordinator.swift
//  GithubClient
//
//  Created by Aung Htoo Myat Khaing on 22/05/2025.
//

import SwiftUI

enum Route: Hashable, Equatable {
    case userList
    case userDetail(userName: String?)
    case repoDetail(title: String?, url: String?)
}

enum Modal: Identifiable {
    case filerOptions(sort: Binding<SortBy>)
    
    var id: String {
        switch self {
        case .filerOptions:
            return "filterOptions"
        }
    }
}

struct AlertMessage: Identifiable {
    let id: UUID = UUID()
    let title: String? = nil
    let message: String?
}

protocol AppCoordinatorProtocol: ObservableObject {
    var path: NavigationPath { get set }
    var presentedModal: Modal? { get set }
    var presentedAlert: AlertMessage? { get set }
    
    func routeToUserList()
    func routeToUserDetail(userName: String?)
    func routeToRepoDetail(title: String?, url: String?)
    func routeToFileOptions(sort: Binding<SortBy>)
    func showAlert(message: AlertMessage)
    func routeToBack()
    func reset()
}

class AppCoordinator: AppCoordinatorProtocol {
    @Published internal var path = NavigationPath()
    @Published internal var presentedModal: Modal?
    @Published internal var presentedAlert: AlertMessage?
    
    func routeToUserList() {
        path.append(Route.userList)
    }
    
    func routeToUserDetail(userName: String?) {
        path.append(Route.userDetail(userName: userName))
    }
    
    func routeToRepoDetail(title: String? = nil, url: String?) {
        path.append(Route.repoDetail(title: title, url: url))
    }
    
    func routeToFileOptions(sort: Binding<SortBy>) {
        presentedModal = .filerOptions(sort: sort)
    }
    
    func showAlert(message: AlertMessage) {
        presentedAlert = message
    }
    
    func routeToBack() {
        path.removeLast()
        presentedModal = nil
    }
    
    func reset() {
        path.removeLast(path.count)
        presentedModal = nil
    }
    
    // Mock data for preview
    static let preview: AppCoordinator = {
        let coordinator = AppCoordinator()
        return coordinator
    }()
}
