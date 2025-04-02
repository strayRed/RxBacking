//
//  RxTableViewBacking.swift
//  RxBacking
//
//  Created by strayRed on 2021/8/5.
//

import Foundation
import RxSwift
import RxDataSources
import RxCocoa
import UIKit

open class RxTableViewBacking<SectionModel: SectionModelType, DataSource: TableViewSectionedDataSource<SectionModel> & RxTableViewDataSourceType>: Backing<UITableView>, _RxSectionedViewBackingType, UITableViewDelegate where DataSource.Element == [SectionModel] {

    public typealias ParentObject = UITableView
    
    public typealias Model = [SectionModel]
    
    public typealias CellConfiguration = (_ cell: UITableViewCell, _ sectionItem: Model.Element.Item, _ indexPath: IndexPath) -> ()
    
    public typealias HeaderFooterConfiguration = (_ view: UITableViewHeaderFooterView, _ sectionModel: Model.Element, _ section: Int) -> ()
    
    public typealias CellHeight = (_ sectionItem: Model.Element.Item, _ indexPath: IndexPath) -> (CGFloat)
    
    public typealias HeaderFooterHeight = (_ sectionModel: Model.Element, _ section: Int) -> (CGFloat)
    
    open var parentDelegate: ParentObject.Delegate {
        return self
    }
    
    open var reusableCell: SectionedViewTypealias.ReusableCell<Model.Element.Item>?
    
    open var reusableSectionHeaderView: SectionedViewTypealias.ReusableView<Model.Element>?
    
    open var reusableSectionFooterView: SectionedViewTypealias.ReusableView<Model.Element>?
    
    open var cellHeight: CellHeight?
    
    open var headerHeight: HeaderFooterHeight?
    
    open var footerHeight: HeaderFooterHeight?
    
    open var cellConfigurationBeforeSynchronized: CellConfiguration?
    
    open var cellConfigurationAfterSynchronized: CellConfiguration?
    
    open var headerConfigurationBeforeSynchronized: HeaderFooterConfiguration?
    
    open var headerConfigurationAfterSynchronized: HeaderFooterConfiguration?
    
    open var footerConfigurationBeforeSynchronized: HeaderFooterConfiguration?
    
    open var footerConfigurationAfterSynchronized: HeaderFooterConfiguration?

    open func reusableCell(_ reusableCell: @escaping SectionedViewTypealias.ReusableCell<Model.Element.Item>) -> Self {
        self.reusableCell = reusableCell
        return self
    }
    
    open func reusableSectionHeaderView(_ reusableSectionHeaderView: @escaping SectionedViewTypealias.ReusableView<Model.Element>) -> Self {
        self.reusableSectionHeaderView = reusableSectionHeaderView
        return self
    }
    
    open func reusableSectionFooterView(_ reusableSectionFooterView: @escaping SectionedViewTypealias.ReusableView<Model.Element>) -> Self {
        self.reusableSectionFooterView = reusableSectionFooterView
        return self
    }
    
    open func cellHeight(_ cellHeight: @escaping CellHeight) -> Self {
        self.cellHeight = cellHeight
        return self
    }
    
    open func headerHeight(_ headerHeight: @escaping HeaderFooterHeight) -> Self {
        self.headerHeight = headerHeight
        return self
    }
    
    open func footerHeight(_ footerHeight: @escaping HeaderFooterHeight) -> Self {
        self.footerHeight = footerHeight
        return self
    }
    
    open func cellConfigurationAfterSynchronized(_ cellConfigurationAfterSynchronized: @escaping CellConfiguration) -> Self {
        self.cellConfigurationAfterSynchronized = cellConfigurationAfterSynchronized
        return self
    }
    
    open func cellConfigurationBeforeSynchronized(_ cellConfigurationBeforeSynchronized: @escaping CellConfiguration) -> Self {
        self.cellConfigurationBeforeSynchronized = cellConfigurationBeforeSynchronized
        return self
    }
    
    open func headerConfigurationBeforeSynchronized(_ headerConfigurationBeforeSynchronized: @escaping HeaderFooterConfiguration) -> Self {
        self.headerConfigurationBeforeSynchronized = headerConfigurationBeforeSynchronized
        return self
    }
    
    open func headerConfigurationAfterSynchronized(_ headerConfigurationAfterSynchronized: @escaping HeaderFooterConfiguration) -> Self {
        self.headerConfigurationAfterSynchronized = headerConfigurationAfterSynchronized
        return self
    }
    
    open func footerConfigurationBeforeSynchronized(_ footerConfigurationBeforeSynchronized: @escaping HeaderFooterConfiguration) -> Self {
        self.footerConfigurationBeforeSynchronized = footerConfigurationBeforeSynchronized
        return self
    }
    
    open func footerConfigurationAfterSynchronized(_ footerConfigurationAfterSynchronized: @escaping HeaderFooterConfiguration) -> Self {
        self.footerConfigurationAfterSynchronized = footerConfigurationAfterSynchronized
        return self
    }
    
    open var dataSourceItems: DataSourceItems<Model> {
        parentObject.rx.items(dataSource: dataSource)
    }

    open var configureCell: TableViewSectionedDataSource<Model.Element>.ConfigureCell {
        return { [weak self] (dataSource, tableView, indexPath, sectionItem) in
            guard let self = self else { return .init() }
            let reusableCell = self.reusableCell(at: indexPath)
            guard let reusableCell = reusableCell else { return .init() }
            let cell = tableView.dequeue(reusableCell)
            self.synchronizeItem(cell, withState: sectionItem, atIndexPath: indexPath, kind: .cell)
            return cell
        }
    }
    
    
    open var dataSource: DataSource { abstractMethod() }

    
    open var titleForHeaderInSection: TableViewSectionedDataSource<SectionModel>.TitleForHeaderInSection = {_,_ in nil }
    
    open var titleForFooterInSection: TableViewSectionedDataSource<SectionModel>.TitleForFooterInSection = {_,_ in nil }
    
    open var canEditRowAtIndexPath: TableViewSectionedDataSource<SectionModel>.CanEditRowAtIndexPath = {_,_ in false }
    
    open var canMoveRowAtIndexPath: TableViewSectionedDataSource<SectionModel>.CanMoveRowAtIndexPath = {_,_ in false }
    
    open var sectionIndexTitles: TableViewSectionedDataSource<SectionModel>.SectionIndexTitles = {_ in nil }
    
    open var sectionForSectionIndexTitle: TableViewSectionedDataSource<SectionModel>.SectionForSectionIndexTitle = { _, _, index in index }
    
    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionModel = strongModel[section]
        guard let reusableView = self.reusableSectionHeaderView?(sectionModel, section)
        else { return nil }
        let view = tableView.dequeue(reusableView)
        synchronizeItem(view, withState: sectionModel, atIndexPath: .init(row: 0, section: section), kind: .header)
        return view
    }
    
    open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let sectionModel = strongModel[section]
        guard let reusableView = self.reusableSectionFooterView?(sectionModel, section)
        else { return nil }
        let view = tableView.dequeue(reusableView)
        synchronizeItem(view, withState: sectionModel, atIndexPath: .init(row: 0, section: section), kind: .footer)
        return view
    }

    open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let headerHeight = heightProvider.makeHeight(kind: .header, indexPath: .init(row: 0, section: section)) {
            return headerHeight
        }

        if let headerHeight = headerHeight {
            return headerHeight(strongModel[section], section)
        }

        return .leastNormalMagnitude
    }

    open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if let footerHeight = heightProvider.makeHeight(kind: .footer, indexPath: .init(row: 0, section: section)) {
            return footerHeight
        }

        if let footerHeight = footerHeight {
            return footerHeight(strongModel[section], section)
        }

        return .leastNormalMagnitude
    }

    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let cellHeight = heightProvider.makeHeight(kind: .cell, indexPath: indexPath) {
            return cellHeight
        }

        if let cellHeight = cellHeight {
            return cellHeight(self.strongModel[indexPath], indexPath)
        }
        
        return parentObject.estimatedRowHeight == 0 ? parentObject.rowHeight : parentObject.estimatedRowHeight
    }
    
    open func modelDidUpdate(model: inout [SectionModel]) {
        
    }
    
    open func setupParentObject(_ parentObject: UITableView) {
        if #available(iOS 15.0, *) {
            if parentObject.style == .plain {
                parentObject.sectionHeaderTopPadding = 0
            }
        }
    }
    //MARK: - Internal
    
    lazy var heightProvider: RxTableViewCellHeightProvider = .init(tableView: parentObject, dataSource: self)
    
    func synchronizeItem(_ item: ListItemStateSynchronizable, withState state: Any, atIndexPath indexPath: IndexPath, kind: ListItemKind) {
        switch kind {
        case .cell:
            if let cell = item as? UITableViewCell, let sectionItem = state as? SectionModel.Item {
                cellConfigurationBeforeSynchronized?(cell, sectionItem, indexPath)
                cell.synchronizeWithState(sectionItem, at: indexPath)
                cellConfigurationAfterSynchronized?(cell, sectionItem, indexPath)
            }
        case .header:
            if let view = item as? UITableViewHeaderFooterView, let section = state as? SectionModel {
                headerConfigurationBeforeSynchronized?(view, section, indexPath.section)
                view.synchronizeWithState(section, at: indexPath)
                headerConfigurationAfterSynchronized?(view, section, indexPath.section)
            }
        case .footer:
            if let view = item as? UITableViewHeaderFooterView, let section = state as? SectionModel {
                footerConfigurationBeforeSynchronized?(view, section, indexPath.section)
                view.synchronizeWithState(section, at: indexPath)
                footerConfigurationAfterSynchronized?(view, section, indexPath.section)
            }
        }
    }
    
    func metricIdentifier(kind: ListItemKind, indexPath: IndexPath) -> AnyHashable {
        abstractMethod()
    }
}
