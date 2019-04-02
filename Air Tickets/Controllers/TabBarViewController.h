//
//  TabBarViewController.h
//  Air Tickets
//
//  Created by Артем Куфаев on 02/04/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
#import "PlaceViewController.h"

@interface TabBarViewController : UITabBarController

- (instancetype)initWithController:(PlaceViewController *)controller origin:(City *)city;

@property (nonatomic, strong) City *origin;

@end
