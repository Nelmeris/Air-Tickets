//
//  CellData.m
//  Air Tickets
//
//  Created by Artem Kufaev on 21/03/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

#import "CellData.h"

@implementation CellData

- (instancetype)initWithTitle: (NSString *)title andController: (UIViewController *)controller {
    self = [super init];
    if (self) {
        _title = title;
        _controller = controller;
    }
    return self;
}

@end
