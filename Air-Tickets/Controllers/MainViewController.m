//
//  MainViewController.m
//  Air Tickets
//
//  Created by Artem Kufaev on 05/04/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

#import "MainViewController.h"

#import "SearchViewController.h"
#import "TicketsViewController.h"
#import "HistoryTracksViewController.h"

@interface MainViewController ()
@property (nonatomic, strong) SearchViewController *searchVC;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureTabBar];
    [self setViewControllers:[self createViewControllers]];
}

- (void)configureTabBar {
    [self.tabBar setTintColor:[UIColor blackColor]];
}

- (NSArray<UIViewController*> *)createViewControllers {
    NSMutableArray<UIViewController*> *controllers = [NSMutableArray new];
    
    _searchVC = [SearchViewController new];
    _searchVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"main_search_bar", @"") image:[UIImage imageNamed:@"search"] selectedImage:[UIImage imageNamed:@"search_selected"]];
    [controllers addObject:[self createNC:_searchVC]];
    
    TicketsViewController *favoriteVC = [[TicketsViewController alloc] initFavoriteTicketsController];
    favoriteVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"main_favorite_bar", @"") image:[UIImage imageNamed:@"favorite"] selectedImage:[UIImage imageNamed:@"favorite_selected"]];
    [controllers addObject:[self createNC:favoriteVC]];
    
    HistoryTracksViewController *historyTracksTVC = [HistoryTracksViewController new];
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

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSLog(@"");
}

@end
