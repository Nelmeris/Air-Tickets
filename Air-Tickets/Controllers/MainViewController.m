//
//  MainViewController.m
//  Air Tickets
//
//  Created by Artem Kufaev on 05/04/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

#import "MainViewController.h"

#import "SearchViewController.h"
#import "TicketsTableViewController.h"
#import "HistoryTracksTableViewController.h"

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setViewControllers:[self createViewControllers]];
}

- (NSArray<UIViewController*> *)createViewControllers {
    NSMutableArray<UIViewController*> *controllers = [NSMutableArray new];
    
    SearchViewController *searchVC = [SearchViewController new];
    searchVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Поиск" image:[UIImage imageNamed:@"search"] selectedImage:[UIImage imageNamed:@"search_selected"]];
    [controllers addObject:[self createNC:searchVC]];
    
    TicketsTableViewController *favoriteVC = [[TicketsTableViewController alloc] initFavoriteTicketsController];
    favoriteVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Избранное" image:[UIImage imageNamed:@"favorite"] selectedImage:[UIImage imageNamed:@"favorite_selected"]];
    [controllers addObject:[self createNC:favoriteVC]];
    
    HistoryTracksTableViewController *historyTracksTVC = [HistoryTracksTableViewController new];
    historyTracksTVC.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemHistory tag:2];
    [controllers addObject:[self createNC:historyTracksTVC]];
    
    return controllers;
}

- (UINavigationController *)createNC:(UIViewController*)rootVC {
    UINavigationController *NC = [[UINavigationController alloc] initWithRootViewController:rootVC];
    [NC.navigationBar setPrefersLargeTitles:YES];
    [NC.navigationBar setTintColor:[UIColor blackColor]];
    return NC;
}


@end
