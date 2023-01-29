//
//  UITableView+Backing.m
//  RxBacking
//
//  Created by strayRed on 2021/9/3.
//

#import "UITableView+ItemSizingSwizzle.h"
#import <objc/runtime.h>

const NSString *swizzleMethodPrefix = @"_list_item_sizing_swizzle_";

@implementation UITableView(CellAutoSizingSwizzle)

static IMP __tableView_original_reloadData_IMP;

void __tableView_swizzle_reloadData(id __nonnull self, SEL __nonnull _cmd) {
    assert(_cmd == @selector(reloadData));

    ((void(*)(id,SEL))__tableView_original_reloadData_IMP)(self, _cmd);
    
    UITableView* tableView = (UITableView *)self;
    SEL swizzle_reloadData = NSSelectorFromString([[NSString alloc] initWithFormat:@"%@reloadData", swizzleMethodPrefix]);
    
    if ([tableView respondsToSelector:swizzle_reloadData]) {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [tableView performSelector:swizzle_reloadData];
        #pragma clang diagnostic pop
    }
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method method = class_getInstanceMethod([self class], @selector(reloadData));
        __tableView_original_reloadData_IMP = method_setImplementation(method, (IMP)__tableView_swizzle_reloadData);
    });
}

@end

