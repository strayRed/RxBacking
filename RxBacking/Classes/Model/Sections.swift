//
//  Sections.swift
//  RxBacking
//
//  Created by strayRed on 2023/1/25.
//

import Foundation
import RxDataSources


public protocol MutableSectionModelType: SectionModelType {
    var items: [Item] { get set }
}

public protocol MutatbleAnimatableSectionModelType: AnimatableSectionModelType, MutableSectionModelType { }

public protocol AnimatableSectionItemType: ViewModelIdentifiableType, Equatable { }

public protocol AnimatableSectionModelType: RxDataSources.AnimatableSectionModelType, ViewModelIdentifiableType where Item: AnimatableSectionItemType { }





extension Collection where Element: SectionModelType, Index == Int {
    public subscript(_ indexPath: IndexPath) -> Element.Item {
        self[indexPath.section].items[Swift.max(indexPath.row, indexPath.item)]
    }
}

extension MutableCollection where Element: MutableSectionModelType, Index == Int {
    public subscript(_ indexPath: IndexPath) -> Element.Item {
        set {
            self[indexPath.section].items[Swift.max(indexPath.row, indexPath.item)] = newValue
        }

        get {
            self[indexPath.section].items[Swift.max(indexPath.row, indexPath.item)]
        }
    }
}

extension Int : AnimatableSectionItemType {}

extension Int8 : AnimatableSectionItemType {}

extension Int16 : AnimatableSectionItemType {}

extension Int32 : AnimatableSectionItemType {}

extension Int64 : AnimatableSectionItemType {}

extension UInt : AnimatableSectionItemType {}

extension UInt8 : AnimatableSectionItemType {}

extension UInt16 : AnimatableSectionItemType {}

extension UInt32 : AnimatableSectionItemType {}

extension UInt64 : AnimatableSectionItemType {}

extension Float : AnimatableSectionItemType {}

extension Double : AnimatableSectionItemType {}

extension String : AnimatableSectionItemType {}
