//
//  Sections.swift
//  RxBacking
//
//  Created by strayRed on 2023/1/25.
//

import Foundation
import RxDataSources

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

public protocol MutableSectionModelType: SectionModelType {
    var items: [Item] { get set }
}

public protocol MutatbleAnimatableSectionModelType: AnimatableSectionModelType, MutableSectionModelType { }

public typealias SectionModelType = RxDataSources.SectionModelType

public typealias SectionModel<Section, Item> = RxDataSources.SectionModel<Section, Item>

public typealias AnimatableSectionModel<Section: ViewModelIdentifiableType, Item: AnimatableSectionItemType> = RxDataSources.AnimatableSectionModel<Section, Item>

public typealias AnimationConfiguration = RxDataSources.AnimationConfiguration

public protocol AnimatableSectionItemType: ViewModelIdentifiableType, Equatable { }xw

public protocol AnimatableSectionModelType: RxDataSources.AnimatableSectionModelType, ViewModelIdentifiableType where Item: AnimatableSectionItemType { }

extension RxDataSources.ViewTransition {
    public static func isRelod(_ isReload: Bool) -> Self {
        return isReload ? .reload : .animated
    }
}


