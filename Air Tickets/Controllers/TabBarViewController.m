//
//  TabBarViewController.m
//  Air Tickets
//
//  Created by Артем Куфаев on 02/04/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

#import "TabBarViewController.h"
#import "MapViewController.h"

@interface TabBarViewController () <MapViewControllerDelegate>
@property (nonatomic, strong) PlaceViewController *placeViewController;
@property (nonatomic, strong) MapViewController *mapViewController;
@end

@implementation TabBarViewController

- (instancetype)initWithController:(PlaceViewController *)controller origin:(City *)city {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _placeViewController = controller;
        _origin = city;
        
        [self configurePlaceViewController];
        [self configureMapViewController:city];
        [self configureNavigationItem];
        
        self.viewControllers = @[controller, _mapViewController];
        self.tabBar.tintColor = [UIColor blackColor];
        self.selectedIndex = 0;
    }
    return self;
}

- (void)configureNavigationItem {
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationItem.hidesSearchBarWhenScrolling = NO;
    self.title = _placeViewController.title;
    self.navigationItem.titleView = _placeViewController.navigationItem.titleView;
}

- (void)hideNavigationItem {
    [self.navigationController.navigationBar setPrefersLargeTitles:NO];
    self.navigationItem.titleView = nil;
}

- (void)displayNavigationItem {
    [self.navigationController.navigationBar setPrefersLargeTitles:YES];
    self.navigationItem.titleView = _placeViewController.navigationItem.titleView;
}

- (void)configurePlaceViewController {
    _placeViewController.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemSearch tag:0];
}

- (void)configureMapViewController:(City *)origin {
    if (_origin) {
        _mapViewController = [[MapViewController alloc] initWithOrigin:_origin];
    } else {
        _mapViewController = [[MapViewController alloc] init];
    }
    _mapViewController.delegate = self;
    UIImage *mapImage = [UIImage imageNamed:@"MapIcon"];
    UIImage *image = [UIImage imageWithCGImage:[mapImage CGImage]
                                         scale:4.5
                                   orientation:(mapImage.imageOrientation)];
    _mapViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Карта" image:image tag:1];
}

#pragma mark - MapViewDelegate

- (void)selectCity:(City *)city {
    DataSourceType dataType = DataSourceTypeCity;
    [_placeViewController.delegate selectPlace:city withType:PlaceTypeArrival andDataType:dataType];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    if (item.tag == 0) {
        [self displayNavigationItem];
    } else {
        [self hideNavigationItem];
    }
}

@end
