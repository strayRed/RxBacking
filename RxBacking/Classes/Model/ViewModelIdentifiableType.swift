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

extension Int : ViewModelIdentifiableType {}

extension Int8 : ViewModelIdentifiableType {}

extension Int16 : ViewModelIdentifiableType {}

extension Int32 : ViewModelIdentifiableType {}

extension Int64 : ViewModelIdentifiableType {}

extension UInt : ViewModelIdentifiableType {}

extension UInt8 : ViewModelIdentifiableType {}

extension UInt16 : ViewModelIdentifiableType {}

extension UInt32 : ViewModelIdentifiableType {}

extension UInt64 : ViewModelIdentifiableType {}

extension Float : ViewModelIdentifiableType {}

extension Double : ViewModelIdentifiableType {}

extension String : ViewModelIdentifiableType {}
