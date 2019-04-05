//
//  MainViewController.m
//  Air Tickets
//
//  Created by Artem Kufaev on 05/04/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

#import "MainViewController.h"

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _searchVC = [SearchViewController new];
    
    UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemSearch tag:0];
    [_searchVC setTabBarItem:tabBarItem];
    [self setViewControllers:@[
                               [[UINavigationController alloc] initWithRootViewController:_searchVC]
                               ]];
    // Do any additional setup after loading the view.
}

@end
