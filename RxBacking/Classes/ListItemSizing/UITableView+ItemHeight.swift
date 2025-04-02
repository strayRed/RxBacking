//
//  UITableView+ItemHeight.swift
//  RxBacking
//
//  Created by strayRed on 2021/9/17.
//

import UIKit

extension UITableViewCell {
    fileprivate static let systemAccessoryWidths: [UITableViewCell.AccessoryType: CGFloat] = [.none: 0, .disclosureIndicator: 34, .detailDisclosureButton: 68, .checkmark: 40, .detailButton: 48]
}

extension UITableViewCell {
    
    fileprivate func makeSystemContentViewWidth(tableViewWidth: CGFloat) -> CGFloat {
        var contentViewWidth = tableViewWidth
        // the system view width
        var rightSystemViewsWidth: CGFloat = 0
        
        if let indexClass = NSClassFromString("UIKit.UITableViewIndex") {
            for view in subviews {
                if view.isKind(of: indexClass) {
                    rightSystemViewsWidth = view.frame.width; break
                }
            }
        }
        
        if let accessoryView = accessoryView {
            rightSystemViewsWidth += 16 + accessoryView.frame.width
        }
        else {
            rightSystemViewsWidth += UITableViewCell.systemAccessoryWidths[accessoryType]!
        }
        
        if UIScreen.main.scale >= 3.0 && UIScreen.main.bounds.width >= 414 {
            rightSystemViewsWidth += 4
        }
        
        contentViewWidth -= rightSystemViewsWidth
        
        return contentViewWidth
    }
    
}

private var cellReferencesKey: Void?
private var headerFooterViewReferencesKey: Void?

extension UITableView {
    
    private var cellReferences: [AnyHashable: UITableViewCell] {
        set {
            objc_setAssociatedObject(self, &cellReferencesKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            (objc_getAssociatedObject(self, &cellReferencesKey) as? [AnyHashable: UITableViewCell]) ?? [:]
        }
    }
    
    private var headerFooterViewReferences: [AnyHashable: UITableViewHeaderFooterView] {
        set {
            objc_setAssociatedObject(self, &headerFooterViewReferencesKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            (objc_getAssociatedObject(self, &headerFooterViewReferencesKey) as? [AnyHashable: UITableViewHeaderFooterView]) ?? [:]
        }
    }
    
    private func makeTableViewCell(token: AnyReusableCell) -> UITableViewCell {
        if let cell = cellReferences[token.reuseIdentifier] {
            cell.prepareForReuse()
            return cell
        }
        let cell: UITableViewCell = token.makeView()

        //Using `reuseIdentifier` as the key to avoid unnecessary memory consumption.
        cellReferences[token.reuseIdentifier] = cell
        return cell
    }
    
    private func makeHeaderFooterView(token: AnyReusableView) -> UITableViewHeaderFooterView {
        if let view = headerFooterViewReferences[token.reuseIdentifier] {
            view.prepareForReuse()
            return view
        }
        let view: UITableViewHeaderFooterView = token.makeView()
        headerFooterViewReferences[token.reuseIdentifier] = view
        return view
    }

    
    func caculateItemHeight(kind: ListItemKind, indexPath: IndexPath, dataSource: ListItemSizingDataSource) -> CGFloat? {
        let model: Any
        let item: ListItemStateSynchronizable & UIView
        let itemToken: ReusableViewToken
        let contentWidth: CGFloat
        switch kind {
        case .cell:
            guard let reusableCell = dataSource.reusableCell(at: indexPath) else { return nil }
            model = dataSource.sectionModelItem(at: indexPath)
            let cell = makeTableViewCell(token: reusableCell)
            item = cell
            itemToken = reusableCell
            contentWidth = cell.makeSystemContentViewWidth(tableViewWidth: bounds.width)
        case .header, .footer:
            let section = indexPath.section
            guard let resuableView = kind == .header ? dataSource.reusableSectionHeaderView(at: section) : dataSource.reusableSectionFooterView(at: section) else { return nil }
            model = dataSource.sectionModel(at: section)
            item = makeHeaderFooterView(token: resuableView)
            itemToken = resuableView
            contentWidth = bounds.width
        }
        
        // If cell or model has provided the height, just use it.
        if let heightProvider = model as? TableViewItemHeightProvidable {
            return heightProvider.tableViewItemHeight(state: model, token: itemToken, contentWidth: contentWidth) }
        if let heightProvider = item as? TableViewItemHeightProvidable {
            if heightProvider.isNeedStateSynchronized {
                dataSource.synchronizeItem(item, withState: model, atIndexPath: indexPath, kind: kind)
            }
            return heightProvider.tableViewItemHeight(state: model, token: itemToken, contentWidth: contentWidth)
        }
        
        dataSource.synchronizeItem(item, withState: model, atIndexPath: indexPath, kind: kind)
        
        return item.caculateAutoLayoutSize(sizeConstraint: .width(contentWidth), style: .compressed).height
    }
}
