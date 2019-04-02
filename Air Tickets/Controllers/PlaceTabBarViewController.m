//
//  PlaceTabBarViewController.m
//  Air Tickets
//
//  Created by Артем Куфаев on 02/04/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

#import "PlaceTabBarViewController.h"
#import "MapViewController.h"

@interface PlaceTabBarViewController () <MapViewControllerDelegate>
@property (nonatomic, strong) PlaceViewController *placeViewController;
@property (nonatomic, strong) MapViewController *mapViewController;
@end

@implementation PlaceTabBarViewController

- (instancetype)initWithController:(PlaceViewController *)controller origin:(City *)city {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        [self setPlaceViewController:controller];
        [self setOrigin:city];
        
        [self configurePlaceViewController];
        [self configureMapViewController:city];
        [self configureNavigationItem];
        
        [self configureTabBar];
    }
    return self;
}

#pragma mark - Configures

- (void)configureNavigationItem {
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [self.navigationItem setHidesSearchBarWhenScrolling:NO];
    [self setTitle:_placeViewController.title];
    [self.navigationItem setTitleView:_placeViewController.navigationItem.titleView];
}

- (void)configurePlaceViewController {
    UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemSearch tag:0];
    [_placeViewController setTabBarItem:tabBarItem];
}

- (void)configureMapViewController:(City *)origin {
    if (_origin)
        _mapViewController = [[MapViewController alloc] initWithOrigin:_origin];
    else
        _mapViewController = [MapViewController new];
    [_mapViewController setDelegate:self];
    UIImage *mapImage = [UIImage imageNamed:@"MapIcon"];
    UIImage *scaleMapImage = [UIImage imageWithCGImage:[mapImage CGImage]
                                                 scale:4.5
                                           orientation:(mapImage.imageOrientation)];
    UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Карта" image:scaleMapImage tag:1];
    [_mapViewController setTabBarItem:tabBarItem];
}

- (void)configureTabBar {
    [self setViewControllers:@[_placeViewController, _mapViewController]];
    [self.tabBar setTintColor:[UIColor blackColor]];
    [self setSelectedIndex:0];
}

#pragma mark - Settings

- (void)hideNavigationItem {
    [self.navigationController.navigationBar setPrefersLargeTitles:NO];
    [self.navigationItem setTitleView:nil];
}

- (void)displayNavigationItem {
    [self.navigationController.navigationBar setPrefersLargeTitles:YES];
    [self.navigationItem setTitleView:_placeViewController.navigationItem.titleView];
}

#pragma mark - TabBarViewDelegate

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    if (item.tag == 0)
        [self displayNavigationItem];
    else
        [self hideNavigationItem];
}

#pragma mark - MapViewDelegate

- (void)selectCity:(City *)city {
    [_placeViewController.delegate selectPlace:city withType:PlaceTypeArrival andDataType:DataSourceTypeCity];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
