//
//  StateSynchronization.swift
//  RxBacking
//  Created by strayRed on 2019/7/26.
//

import Foundation
import UIKit


@objc public protocol ListItemStateSynchronizable {
    func synchronizeWithState(_ state: Any?, at indexPath: IndexPath)
}

extension UITableViewCell: ListItemStateSynchronizable {
    open func synchronizeWithState(_ state: Any?, at indexPath: IndexPath) { }
}

extension UICollectionReusableView: ListItemStateSynchronizable {
    open func synchronizeWithState(_ state: Any?, at indexPath: IndexPath) { }
}

extension UITableViewHeaderFooterView: ListItemStateSynchronizable {
    open func synchronizeWithState(_ state: Any?, at indexPath: IndexPath) { }
}
