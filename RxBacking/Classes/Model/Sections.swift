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

public typealias AnimatableSectionItemType = ViewModelIdentifiableType & Equatable

public typealias SectionModel<Section, Item> = RxDataSources.SectionModel<Section, Item>

public typealias AnimatableSectionModel<Section: ViewModelIdentifiableType, Item: AnimatableSectionItemType> = RxDataSources.AnimatableSectionModel<Section, Item>

public typealias AnimationConfiguration = RxDataSources.AnimationConfiguration

extension RxDataSources.ViewTransition {
    public static func isRelod(_ isReload: Bool) -> Self {
        return isReload ? .reload : .animated
    }
}

public protocol ViewModelIdentifiableType: RxDataSources.IdentifiableType {
    associatedtype MetricIdentity: Hashable = Identity
    var metricIdentity: MetricIdentity { get }
}

extension ViewModelIdentifiableType where MetricIdentity == Identity {
    public var metricIdentity: MetricIdentity { identity }
}

public protocol MutableViewModelIdentifiableType: ViewModelIdentifiableType where Identity == AnyHashable, MetricIdentity == AnyHashable {
    var identity: Identity { get set }
    var metricIdentity: MetricIdentity  { get set }
}

public protocol AnimatableSectionModelType: RxDataSources.AnimatableSectionModelType, ViewModelIdentifiableType where Item: AnimatableSectionItemType { }

public struct AnimatableSectionModelWrapper<Base: AnimatableSectionModelType, Value>: AnimatableSectionModelType {
    
    public typealias Item = Base.Item
    
    public typealias Identity = Base.Identity
    
    public typealias MetricIdentity = Base.MetricIdentity

    public var base: Base
    
    public var value: Value
    
    public var identity: Base.Identity {
        base.identity
    }
    
    public var metricIdentity: Base.MetricIdentity {
        base.metricIdentity
    }
    
    public var items: [Base.Item] { base.items }
    
    public init(original: AnimatableSectionModelWrapper<Base, Value>, items: [Base.Item]) {
        self = original
    }
    
    public init(base: Base, value: Value) {
        self.base = base
        self.value = value
    }
}

public struct AnimatableSectionItemWrapper<Base: AnimatableSectionItemType, Value>: AnimatableSectionItemType {
    
    public typealias Identity = Base.Identity
    
    public typealias MetricIdentity = Base.MetricIdentity

    public var base: Base
    
    public var value: Value
    
    public var identity: Base.Identity {
        base.identity
    }
    
    public var metricIdentity: Base.MetricIdentity {
        base.metricIdentity
    }
    
    public init(base: Base, value: Value) {
        self.base = base
        self.value = value
    }
    
    public static func == (lhs: AnimatableSectionItemWrapper<Base, Value>, rhs: AnimatableSectionItemWrapper<Base, Value>) -> Bool {
        lhs.base == rhs.base
    }
}
