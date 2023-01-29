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
    /// Only work for View.
    var isNeedStateSynchronized: Bool { get }
    
    func tableViewItemHeight(state: Any, reusableItem: ReusableItem, contentWidth: CGFloat) -> CGFloat
}

extension TableViewItemHeightProvidable {
    public var isNeedStateSynchronized: Bool { false }
}


public protocol CollectionViewItemSizeProvidable {
    /// Only work for View.
    var isNeedStateSynchronized: Bool { get }
    
    func collectionViewItemSize(state: Any, reusableItem: ReusableItem, collectionViewWidth: CGFloat) -> CGSize
}

extension CollectionViewItemSizeProvidable {
    public var isNeedStateSynchronized: Bool { false }
}
