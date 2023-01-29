//
//  BackingType.swift
//  RxBacking
//
//  Created by strayRed on 2021/10/12.
//

import Foundation

open class Backing<ParentObject: BackingParentObjectType>: _Backing, BackingType {
    open override func forwardObject() -> NSObject! {
        self.forwardObject
    }
}

public protocol BackingType: AnyObject {
    associatedtype ParentObject: BackingParentObjectType
}

private var parentObjectKey: Void?
private var forwardObjectKey: Void?
private var isRetainedKey: Void?


extension BackingType {
    
    @discardableResult
    public func forwordObject(_ forwordObject: NSObject?) -> Self {
        self.forwardObject = forwordObject
        return self
    }
    
    func setParentObject(_ parentObject: ParentObject, shouldRetain: Bool) {
        self.parentObject = parentObject
        if shouldRetain {
            parentObject.retainBacking(self)
        }
    }
    
    var isRetained: Bool {
        set {
            objc_setAssociatedObject(self, &isRetainedKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            (objc_getAssociatedObject(self, &isRetainedKey) as? Bool) ?? false
        }
    }
    
    var parentObject: ParentObject {
        set {
            objc_setAssociatedObject(self, &parentObjectKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
        get {
            if let parentObject = objc_getAssociatedObject(self, &parentObjectKey) as? ParentObject {
                return parentObject
            }
            fatalError("The parentObject MUST be set first.")
            
        }
    }
    
    var forwardObject: NSObject? {
        set {
            objc_setAssociatedObject(self, &forwardObjectKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        get {
            objc_getAssociatedObject(self, &forwardObjectKey) as? NSObject
        }
    }
}


