//
//  MapView.h
//  Air Tickets
//
//  Created by Артем Куфаев on 01/04/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "DataManager.h"

@protocol MapViewDelegate <NSObject>
- (void)selectCity:(City *)city;
@end

@interface MapView : UIView

@property (nonatomic, strong) City *origin;
@property (nonatomic, strong) id<MapViewDelegate>delegate;
- (instancetype)initWithFrame:(CGRect)frame origin:(City *)origin;

@end
