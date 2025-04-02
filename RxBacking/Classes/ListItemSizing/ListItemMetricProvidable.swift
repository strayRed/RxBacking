//
//  ListItemMetricProvidable.swift
//  RxBacking
//
//  Created by strayRed on 2021/9/17.
//

import Foundation
import ViewSizeCalculation
import UIKit

public protocol TableViewItemHeightProvidable {
    /// Should sync the state with item before returning the height.
    ///
    /// Default is false
    var isNeedStateSynchronized: Bool { get }
    
    func tableViewItemHeight(state: Any, token: ReusableViewToken, contentWidth: CGFloat) -> CGFloat
}

extension TableViewItemHeightProvidable {
    public var isNeedStateSynchronized: Bool { false }
}


public protocol CollectionViewItemSizeProvidable {
    /// Should sync the state with item before returning the size.
    ///
    /// Default is false
    var isNeedStateSynchronized: Bool { get }
    
    func collectionViewItemSize(state: Any, token: ReusableViewToken, collectionViewWidth: CGFloat) -> CGSize
}

extension CollectionViewItemSizeProvidable {
    public var isNeedStateSynchronized: Bool { false }
}
