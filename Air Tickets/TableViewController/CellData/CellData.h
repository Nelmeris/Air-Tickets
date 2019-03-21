//
//  CellData.h
//  Air Tickets
//
//  Created by Artem Kufaev on 21/03/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CellData : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIViewController *controller;

- (instancetype)initWithTitle: (NSString *)title andController: (UIViewController *)controller;

@end

NS_ASSUME_NONNULL_END
