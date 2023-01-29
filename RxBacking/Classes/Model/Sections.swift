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

public protocol MutableSectionModelType: SectionModelType {
    var items: [Item] { get set }
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

public protocol MutatbleAnimatableSectionModelType: AnimatableSectionModelType, MutableSectionModelType where Item: MutableIdentifiableType { }

public protocol MutableIdentifiableType: IdentifiableType where Identity == AnyHashable {
    var identity : Identity { get set }
}

public typealias SectionModelType = RxDataSources.SectionModelType

public typealias AnimatableSectionItem = ModelIdentifiableType & Equatable

public typealias SectionModel<Section, Item> = RxDataSources.SectionModel<Section, Item>

public typealias AnimatableSectionModel<Section: ModelIdentifiableType, Item: AnimatableSectionItem> = RxDataSources.AnimatableSectionModel<Section, Item>

public typealias AnimationConfiguration = RxDataSources.AnimationConfiguration

extension RxDataSources.ViewTransition {
    public static func isRelod(_ isReload: Bool) -> Self {
        return isReload ? .reload : .animated
    }
}

public protocol ModelIdentifiableType: RxDataSources.IdentifiableType {
    associatedtype MetricIdentity: Hashable = Identity
    var metricIdentity: MetricIdentity { get }
}

extension ModelIdentifiableType where MetricIdentity == Identity {
    public var metricIdentity: MetricIdentity { identity }
}

public protocol MutableModelIdentifiableType: ModelIdentifiableType where Identity == AnyHashable, MetricIdentity == AnyHashable {
    var identity: Identity { get set }
    var metricIdentity: MetricIdentity  { get set }
}

public protocol AnimatableSectionModelType: RxDataSources.AnimatableSectionModelType, ModelIdentifiableType where Item: AnimatableSectionItem { }
