//
//  RxDataSourcesExpansion.swift
//  RxBacking
//
//  Created by strayRed on 2023/1/31.
//

import Foundation
import RxDataSources

//MARK: - Typealias
public typealias SectionModelType = RxDataSources.SectionModelType

public typealias SectionModel<Section, Item> = RxDataSources.SectionModel<Section, Item>

public typealias AnimatableSectionModel<Section: ViewModelIdentifiableType, Item: AnimatableSectionItemType> = RxDataSources.AnimatableSectionModel<Section, Item>

public typealias AnimationConfiguration = RxDataSources.AnimationConfiguration

//MARK: -Extensions

extension RxDataSources.ViewTransition {
    public static func isRelod(_ isReload: Bool) -> Self {
        return isReload ? .reload : .animated
    }
}

extension AnimatableSectionModel: ViewModelIdentifiableType { }

extension AnimatableSectionModel: AnimatableSectionModelType { }
