//
//  Reusable.swift
//  RxBacking_Example
//
//  Created by strayRed on 2023/1/25.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import RxBacking

enum Reusable {
    static let tableViewCell = AnyReusableCell(type: TableViewCell.self)
    static let collectionViewCell = AnyReusableCell(type: CollectionViewCell.self)
    static let talbeViewHeader = AnyReusableView(type: TableViewHeaderView.self)
    static let collectionViewHeaderFooter = AnyReusableView(type: CollectionReusableView.self)
}
