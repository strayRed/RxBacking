//
//  ListIndePathSizedItemStorage.swift
//  RxBacking
//
//  Created by strayRed on 2023/1/26.
//

import Foundation

protocol ListIndePathSizedItemStorage {
    func removeAllItems()
    //func insertSections(_ sections: Set<Int>)
    //func deleteSections(_ sections: Set<Int>)
    ///...
}

//extension ListIndePathSizedItemStorage {
//    func insertSections(_ sections: Set<Int>) { }
//    func deleteSections(_ sections: Set<Int>) { }
//}

protocol ListIndePathSizedItemStorageContainer {
    var  cellIndePathSizedItemStorage: ListIndePathSizedItemStorage { get }
}
