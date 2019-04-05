//
//  MainViewController.m
//  Air Tickets
//
//  Created by Artem Kufaev on 05/04/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

#import "MainViewController.h"
#import "TicketsTableViewController.h"

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setViewControllers:[self createViewControllers]];
}

- (NSArray<UIViewController*> *)createViewControllers {
    NSMutableArray<UIViewController*> *controllers = [NSMutableArray new];
    
    SearchViewController *searchVC = [SearchViewController new];
    searchVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Поиск" image:[UIImage imageNamed:@"search"] selectedImage:[UIImage imageNamed:@"search_selected"]];
    UINavigationController *searchNC = [[UINavigationController alloc] initWithRootViewController:searchVC];
    [controllers addObject:searchNC];
    
    TicketsTableViewController *favoriteVC = [[TicketsTableViewController alloc] initFavoriteTicketsController];
    favoriteVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Избранное" image:[UIImage imageNamed:@"favorite"] selectedImage:[UIImage imageNamed:@"favorite_selected"]];
    UINavigationController *favoriteNC = [[UINavigationController alloc] initWithRootViewController:favoriteVC];
    [controllers addObject:favoriteNC];
    
    return controllers;
}


@end
