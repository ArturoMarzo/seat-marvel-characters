import UIKit

protocol UITableViewCellStaticProtocol {
    static func cellIdentifier() -> String
    static func cellHeight() -> CGFloat
}

extension UITableViewCellStaticProtocol {
    static func cellIdentifier() -> String {
        return String(describing: type(of: self))
    }
}

extension UITableView {
    func registerNib<T: UITableViewCell>(_ classValue: T.Type) where T: UITableViewCellStaticProtocol {
        register(UINib(nibName: String(describing: classValue), bundle: nil), forCellReuseIdentifier: classValue.cellIdentifier())
    }
}
