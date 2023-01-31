//
//  ViewModelIdentifiableType+Extensions.swift
//  RxBacking
//
//  Created by strayRed on 2023/1/30.
//

import Foundation
import RxDataSources

public protocol ViewModelIdentifiableType: RxDataSources.IdentifiableType {
    associatedtype MetricIdentity: Hashable = Identity
    var metricIdentity: MetricIdentity { get }
}

extension ViewModelIdentifiableType where MetricIdentity == Identity {
    public var metricIdentity: MetricIdentity { identity }
}
