//
//  MapViewController.m
//  Air Tickets
//
//  Created by Артем Куфаев on 01/04/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

#import "MapViewController.h"
#import "LocationService.h"
#import "APIManager.h"
#import "MapPrice.h"

@interface MapViewController () <MKMapViewDelegate>
@property (strong, nonatomic) MKMapView *mapView;
@property (nonatomic, strong) LocationService *locationService;
@property (nonatomic, strong) City *destination;
@property (nonatomic, strong) NSArray *prices;
@end

@implementation MapViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        [self configureMapView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataLoadedSuccessfully) name:kDataManagerLoadDataDidComplete object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCurrentLocation:) name:kLocationServiceDidUpdateCurrentLocation object:nil];
    }
    return self;
}

- (instancetype)initWithOrigin:(City *)city {
    self = [super init];
    if (self) {
        [self setOrigin:city];
        
        [self configureMapView];
        
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(_origin.coordinate, 1000000, 1000000);
        [_mapView setRegion:region animated:YES];
        
        [[APIManager sharedInstance] mapPricesFor:_origin withCompletion:^(NSArray *prices) {
            [self setPrices:prices];
        }];
    }
    return self;
}

- (void)configureMapView {
    _mapView = [[MKMapView alloc] initWithFrame:self.view.frame];
    [_mapView setShowsUserLocation:YES];
    [_mapView setDelegate:self];
    [self.view addSubview:_mapView];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dataLoadedSuccessfully {
    _locationService = [LocationService new];
}

- (void)updateCurrentLocation:(NSNotification *)notification {
    CLLocation *currentLocation = notification.object;
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(currentLocation.coordinate, 1000000, 1000000);
    [_mapView setRegion:region animated:YES];
    
    if (!currentLocation) return;
    _origin = [[DataManager sharedInstance] cityForLocation:currentLocation];
    if (!_origin) return;
    [[APIManager sharedInstance] mapPricesFor:_origin withCompletion:^(NSArray *prices) {
        [self setPrices:prices];
    }];
}

- (void)setPrices:(NSArray *)prices {
    _prices = prices;
    [_mapView removeAnnotations: _mapView.annotations];
    
    for (MapPrice *price in prices) {
        dispatch_async(dispatch_get_main_queue(), ^{
            MKPointAnnotation *annotation = [MKPointAnnotation new];
            annotation.title = [NSString stringWithFormat:@"%@ (%@)", price.destination.name, price.destination.code];
            annotation.subtitle = [NSString stringWithFormat:@"%ld руб.", (long)price.value];
            annotation.coordinate = price.destination.coordinate;
            [self->_mapView addAnnotation: annotation];
        });
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    static NSString *identifier = @"MarkerIdentifier";
    MKMarkerAnnotationView *annotationView = (MKMarkerAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    
    if ([annotationView.annotation.title isEqual: @"My Location"]) {
        [annotationView setAnnotation:nil];
        return nil;
    }
    
    if (!annotationView) {
        annotationView = [[MKMarkerAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        [annotationView setCanShowCallout:YES];
        [annotationView setCalloutOffset:CGPointMake(0, 5.0)];
        
        UIButton* annotationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [annotationButton setFrame:CGRectMake(0, 0, 30, 30)];
        [annotationButton setImage:[UIImage imageNamed:@"SelectIcon"] forState:UIControlStateNormal];
        [annotationButton addTarget:self action:@selector(selectAirport) forControlEvents:UIControlEventTouchUpInside];
        [annotationView setRightCalloutAccessoryView:annotationButton];
    }
    
    [annotationView setAnnotation:annotation];
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    for (MapPrice *price in _prices) {
        if (price.destination.coordinate.latitude == view.annotation.coordinate.latitude && price.destination.coordinate.longitude == view.annotation.coordinate.longitude)
            [self setDestination:price.destination];
    }
}

- (void)selectAirport {
    [self.delegate selectCity:_destination];
}

@end
