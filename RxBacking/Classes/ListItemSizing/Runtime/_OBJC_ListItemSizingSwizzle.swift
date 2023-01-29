//
//  _OBJC_ListItemSizingSwizzle.swift
//  RxBacking
//
//  Created by strayRed on 2021/8/10.
//

import Foundation
import UIKit

extension UIScrollView {
    private var isRXProxyDelegate: Bool {
        guard let delegateProxyClass = NSClassFromString("_RXDelegateProxy") else {
            return false
        }
        return delegate?.isKind(of: delegateProxyClass) ?? false
    }
    
    @objc func _list_item_sizing_swizzle_reloadData() {
        
        if let container = delegate as? ListIndePathSizedItemStorageContainer {
            container.cellIndePathSizedItemStorage.removeAllItems()
        }
    
        else if isRXProxyDelegate, let container = rx.delegate.forwardToDelegate() as? ListIndePathSizedItemStorageContainer {
            container.cellIndePathSizedItemStorage.removeAllItems()
        }
    }
}
