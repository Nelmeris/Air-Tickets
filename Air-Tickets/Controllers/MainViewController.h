//
//  MainViewController.h
//  Air Tickets
//
//  Created by Artem Kufaev on 05/04/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SearchViewController.h"

@interface MainViewController : UITabBarController

@property (nonatomic, strong) SearchViewController *searchVC;

@end
