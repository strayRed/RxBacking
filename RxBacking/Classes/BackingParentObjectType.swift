//
//  BackingParentObjectType.swift
//  RxBacking
//
//  Created by strayRed on 2021/7/23.
//


private var backingArrayKey: Void?

public protocol BackingParentObjectType: NSObject { }

extension NSObject: BackingParentObjectType { }

extension BackingParentObjectType {

    private var backings: [AnyObject] {
        set {
            objc_setAssociatedObject(self, &backingArrayKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            (objc_getAssociatedObject(self, &backingArrayKey) as? [AnyObject]) ?? []
        }
    }
    
    func retainBacking<Backing: BackingType>(_ backing: Backing) where Backing.ParentObject == Self {
        if backing.isRetained { return }
        backings.append(backing)
        backing.isRetained = true
    }
}

