//
//  RxTableViewCellHeightProvider.swift
//  RxBacking
//
//  Created by strayRed on 2021/9/6.
//

class RxTableViewCellHeightProvider: ListIndePathSizedItemStorage {
    
    private weak var tableView: UITableView?
    
    private weak var dataSource: ListItemSizingDataSource?
    
    private var heightStroages: [ListItemKind: ListItemStorage.KeyIdentified<AnyHashable, CGFloat>] = [:]
    
    init(tableView: UITableView?, dataSource: ListItemSizingDataSource?) {
        self.tableView = tableView
        self.dataSource = dataSource
    }
    
    private func height(inKind kind: ListItemKind, forKey key: AnyHashable) -> CGFloat? {
        guard let stroage = heightStroages[kind] else {
            heightStroages[kind] = .init(); return nil
        }
        return stroage.item(forKey: key)
    }
    
    func storeHeight(_ height: CGFloat, inKind kind: ListItemKind, forKey key: AnyHashable) {
        heightStroages[kind]?.store(height, forKey: key)
    }
    
    func makeHeight(kind: ListItemKind, indexPath: IndexPath) -> CGFloat? {
        guard let tableView = self.tableView, let dataSource = dataSource else { return nil }
        let key = dataSource.metricIdentifier(kind: kind, indexPath: indexPath)
        if let height = height(inKind: kind, forKey: key) {
            return height
        }
        let newHeight = tableView.caculateItemHeight(kind: kind, indexPath: indexPath, dataSource: dataSource)
        if let newHeight = newHeight {
            storeHeight(newHeight, inKind: kind, forKey: key)
        }
        return newHeight
    }
    
    func removeAllItems() {
        heightStroages.removeAll(keepingCapacity: true)
    }
}


