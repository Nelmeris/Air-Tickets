//
//  LocationService.m
//  Air Tickets
//
//  Created by Артем Куфаев on 01/04/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

#import "LocationService.h"

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationService () <CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;
@end

@implementation LocationService

- (instancetype)init {
    self = [super init];
    if (self) {
        _locationManager = [CLLocationManager new];
        _locationManager.delegate = self;
        [_locationManager requestAlwaysAuthorization];
    }
    return self;
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [_locationManager startUpdatingLocation];
    } else if (status != kCLAuthorizationStatusNotDetermined) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"loc_serv_alert_title", @"") message:NSLocalizedString(@"loc_serv_alert_msg", @"") preferredStyle: UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"close_btn", @"") style:(UIAlertActionStyleDefault) handler:nil]];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    if (_currentLocation) return;
    
    _currentLocation = [locations firstObject];
    [_locationManager stopUpdatingLocation];
    [[NSNotificationCenter defaultCenter] postNotificationName:kLocationServiceDidUpdateCurrentLocation object:_currentLocation];
}

@end
