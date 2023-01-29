//
//  RxSectionedViewBackingType.swift
//  RxBacking
//
//  Created by strayRed on 2021/7/23.
//

import Foundation
import RxCocoa
import RxSwift

public typealias DataSourceItems<Element> = (_ source: Observable<Element>)
    -> Disposable

public protocol RxDelegateAndDataSourceBackingType: NSObject, BackingType where ParentObject: HasDelegate & HasDataSource {
    
    associatedtype Model
    
    var dataSourceItems: DataSourceItems<Model> { get }
    
    var parentDelegate: ParentObject.Delegate { get }
    
    func dataSourceBinded(to observable: Observable<Model>) -> Disposable
    
    func modelDidUpdate(model: inout Model)
    
    func setupParentObject(_ parentObject: ParentObject)
}

extension RxDelegateAndDataSourceBackingType {
    
    fileprivate func setModel(_ model: Model) {
        _model = model
        modelDidUpdate(model: &_model!)
    }
    
    public init(parentObject: ParentObject, shouldRetain: Bool) {
        self.init()
        self.setupParentObject(parentObject)
        self.setParentObject(parentObject, shouldRetain: shouldRetain)
        parentObject.delegate = parentDelegate
    }
    
    public func setupParentObject(_ parentObject: ParentObject) { }
    
    public func dataSourceBinded(to observable: Observable<Model>) -> Disposable {
        observable
            .do(onNext: {[weak self] in self?.setModel($0) })
            .bind(to: dataSourceItems)
    }
}

private var modelKey: Void?

extension RxDelegateAndDataSourceBackingType {
    
    public var model: Model? { _model }
    
    fileprivate var _model: Model? {
        set {
            objc_setAssociatedObject(self, &modelKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            objc_getAssociatedObject(self, &modelKey) as? Model
        }
    }
}

extension ObservableType {
    public func bind<Backing: RxDelegateAndDataSourceBackingType>(to backing: Backing) -> Disposable where Self.Element == Backing.Model {
        self.do(onNext: {[weak backing] in backing?.setModel($0) }).bind(to: backing.dataSourceItems)
    }
}
