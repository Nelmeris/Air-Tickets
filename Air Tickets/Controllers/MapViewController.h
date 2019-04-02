//
//  MapViewController.h
//  Air Tickets
//
//  Created by Артем Куфаев on 01/04/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "DataManager.h"

@protocol MapViewControllerDelegate <NSObject>
- (void)selectCity:(City *)city;
@end

@interface MapViewController : UIViewController

@property (nonatomic, strong) id<MapViewControllerDelegate>delegate;
@property (nonatomic, strong) City *origin;

- (instancetype)init;
- (instancetype)initWithOrigin:(City *)city;

@end
