//
//  ListItemStorage.swift
//  RxBacking
//
//  Created by strayRed on 2021/8/5.
//

import Foundation


enum ListItemStorage {
    
final private class Item<T> {
    
    private var isPortrait: Bool {
        
        return UIDevice.current.orientation.isPortrait
    }
    
    private var portrait: T?
    private var landscape: T?
    
    var value: T? {
        set {
            if isPortrait { portrait = newValue }
            else { landscape = newValue }
        }
        get {
            isPortrait ? portrait : landscape
        }
    }
    
    init(_ value: T? = nil) {
        self.value = value
    }
}
    
    final class IndexPathIdentified<Item> {
        
        private typealias Items<Value> = [[ListItemStorage.Item<Value>]]
        
        private var items: Items<Item> = .init()
        
        private func allocIndexPathMemoryIfNeed(indexPath: IndexPath) {
            allocSectionMemoryIfNeed(section: indexPath.section)
            allocItemMemoryIfNeed(item: max(indexPath.row, indexPath.item), inSection: indexPath.section)
        }
        
        private func _allocObjectsMemoryIfNeed<C: MutableCollection>(objects: inout C, index: Int, defalutElement: C.Element) where C.Index == Int {
            let newCount = index + 1
            if objects.count >= newCount { return }
            (objects.count..<newCount).forEach() { objects[$0] = defalutElement }
        }
        
        private func allocSectionMemoryIfNeed(section: Int) {
            self._allocObjectsMemoryIfNeed(objects: &items, index: section, defalutElement: .init())
        }
        
        private func allocItemMemoryIfNeed(item: Int, inSection section: Int) {
            self._allocObjectsMemoryIfNeed(objects: &items[section], index: item, defalutElement: .init())
        }
        
        func store(_ item: Item,  atIndexPath indexPath: IndexPath) {
            allocIndexPathMemoryIfNeed(indexPath: indexPath)
            items[indexPath.section][max(indexPath.item, indexPath.row)] = .init(item)
        }
        
        func item(atIndexPath indexPath: IndexPath) -> Item? {
            allocIndexPathMemoryIfNeed(indexPath: indexPath)
            return items[indexPath.section][max(indexPath.item, indexPath.row)].value
        }
        
        func removeAll() {
            items.removeAll()
        }
        
    }
    
    final class KeyIdentified<Key: Hashable, Item> {
        private var items: [Key: Item] = [:]
        func store(_ item: Item, forKey key: Key) {
            items[key] = item
        }
        func item(forKey key: Key) -> Item? {
            items[key]
        }
        
        func removeAll() {
            items.removeAll()
        }
    }
    
}
