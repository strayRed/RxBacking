//
//  SectionWrapper.swift
//  RxBacking
//
//  Created by strayRed on 2023/1/30.
//

import Foundation
import Differentiator

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
