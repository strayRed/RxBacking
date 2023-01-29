//
//  UICollectionView+ItemSizingSwizzle.m
//  RxBacking
//
//  Created by strayRed on 2021/10/7.
//

#import "UICollectionView+ItemSizingSwizzle.h"
#import "UITableView+ItemSizingSwizzle.h"
#import <objc/runtime.h>

@implementation UICollectionView(CellAutoSizingSwizzle)

static IMP __collectionView_original_reloadData_IMP;

void __collectionView_swizzle_reloadData(id __nonnull self, SEL __nonnull _cmd) {
    assert(_cmd == @selector(reloadData));

    ((void(*)(id,SEL))__collectionView_original_reloadData_IMP)(self, _cmd);
    
    UICollectionView* collectionView = (UICollectionView *)self;
    SEL swizzle_reloadData = NSSelectorFromString([[NSString alloc] initWithFormat:@"%@reloadData", swizzleMethodPrefix]);
    
    if ([collectionView respondsToSelector:swizzle_reloadData]) {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [collectionView performSelector:swizzle_reloadData];
        #pragma clang diagnostic pop
    }
}




+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method method = class_getInstanceMethod([self class], @selector(reloadData));
        __collectionView_original_reloadData_IMP = method_setImplementation(method, (IMP)__collectionView_swizzle_reloadData);
    });
}

@end

