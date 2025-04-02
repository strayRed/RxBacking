//
//  RxSectionedViewBackingType.swift
//  RxBacking
//
//  Created by strayRed on 2021/9/7.
//

import Foundation
import RxDataSources


public enum SectionedViewTypealias {
    public typealias ReusableCell<SectionItem> = (_ sectionItem: SectionItem, _ indexPath: IndexPath) -> AnyReusableCell
    public typealias ReusableView<SectionModel> = (_ sectionModel: SectionModel, _ section: Int) -> AnyReusableView?
}

public protocol RxSectionedViewBackingType: RxDelegateAndDataSourceBackingType where Model: Collection, Model.Element: SectionModelType, Model.Index == Int {
    
    var reusableCell: SectionedViewTypealias.ReusableCell<Model.Element.Item>? { get }
    
    func reusableCell(_ reusableCell: @escaping SectionedViewTypealias.ReusableCell<Model.Element.Item>) -> Self
    
    var reusableSectionHeaderView: SectionedViewTypealias.ReusableView<Model.Element>? { get }
    
    func reusableSectionHeaderView(_ reusableSectionHeaderView: @escaping SectionedViewTypealias.ReusableView<Model.Element>) -> Self
    
    var reusableSectionFooterView: SectionedViewTypealias.ReusableView<Model.Element>? { get }
    
    func reusableSectionFooterView(_ reusableSectionFooterView: @escaping SectionedViewTypealias.ReusableView<Model.Element>) -> Self
}

protocol _RxSectionedViewBackingType: RxSectionedViewBackingType, ListItemSizingDataSource { }

extension _RxSectionedViewBackingType {
    
    var strongModel: Model { model! }
    
    func reusableCell(at indexPath: IndexPath) -> AnyReusableCell? {
        reusableCell?(strongModel[indexPath], indexPath)
    }
    
    func reusableSectionHeaderView(at section: Int) -> AnyReusableView? {
        reusableSectionHeaderView?(strongModel[section], section)
    }
    
    func reusableSectionFooterView(at section: Int) -> AnyReusableView? {
        reusableSectionFooterView?(strongModel[section], section)
    }
    
    func sectionModelItem(at indexPath: IndexPath) -> Any { strongModel[indexPath]
    }
    
    func sectionModel(at section: Int) -> Any { strongModel[section]
    }
}

