import Foundation

protocol PermissionGateway {
    func requestAccess() async -> Bool
}
