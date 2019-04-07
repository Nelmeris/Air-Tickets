//
//  MapView.m
//  Air Tickets
//
//  Created by Артем Куфаев on 01/04/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

#import "MapView.h"
#import "LocationService.h"
#import "APIManager.h"
#import "MapPrice.h"
#import "CoreDataHelper.h"

@interface MapView () <MKMapViewDelegate>
@property (strong, nonatomic) MKMapView *mapView;
@property (nonatomic, strong) LocationService *locationService;
@property (nonatomic, strong) MapPrice *selectedPrice;
@property (nonatomic, strong) NSArray *prices;
@end

@implementation MapView

- (instancetype)initWithFrame:(CGRect)frame origin:(City *)origin
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configureMapView];
        
        if (origin) {
            _origin = origin;
            [self setRegion:origin.coordinate];
            [self loadPrices];
        } else {
            [[DataManager sharedInstance] loadData];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataLoadedSuccessfully) name:kDataManagerLoadDataDidComplete object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCurrentLocation:) name:kLocationServiceDidUpdateCurrentLocation object:nil];
        }
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateOrigin:) name:kLocationServiceDidUpdateOrigin object:nil];
    }
    return self;
}

- (void)configureMapView {
    _mapView = [[MKMapView alloc] initWithFrame:self.bounds];
    _mapView.showsUserLocation = YES;
    _mapView.delegate = self;
    [self addSubview:_mapView];
}

- (void)updateOrigin:(NSNotification *)notification {
    City *city = notification.object;
    _origin = city;
    [self setRegion:_origin.coordinate];
    [self loadPrices];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dataLoadedSuccessfully {
    _locationService = [LocationService new];
}

- (void)loadPrices {
    UIView *loadingView = [self createLoadingView];
    [self addSubview:loadingView];
    [[APIManager sharedInstance] mapPricesFor:_origin withCompletion:^(NSArray *prices) {
        if ([self.subviews containsObject:loadingView])
            [loadingView removeFromSuperview];
        self.prices = prices;
    }];
}

- (UIView *)createLoadingView {
    UIView *loadingView = [[UIView alloc] initWithFrame:self.bounds];
    [loadingView setBackgroundColor:[UIColor clearColor]];
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = self.bounds;
    blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [loadingView addSubview:blurEffectView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:loadingView.frame];
    [label setText:@"Поиск..."];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont fontWithName:@"HelveticaNeue" size:40]];
    [label setTextColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
    [loadingView addSubview:label];
    
    return loadingView;
}

- (void)setRegion:(CLLocationCoordinate2D)coordinate {
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 1000000, 1000000);
    [_mapView setRegion: region animated: YES];
}

- (void)updateCurrentLocation:(NSNotification *)notification {
    CLLocation *currentLocation = notification.object;
    
    [self setRegion:currentLocation.coordinate];
    
    if (!currentLocation) return;
    _origin = [[DataManager sharedInstance] cityForLocation:currentLocation];
    if (!_origin) return;
    [self loadPrices];
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
    if ([annotation isKindOfClass:[MKUserLocation class]]) return nil;
    if (!annotationView) {
        annotationView = [[MKMarkerAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        annotationView.canShowCallout = YES;
        annotationView.calloutOffset = CGPointMake(0, 5.0);
        UIButton* annotationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [annotationButton setFrame:CGRectMake(0, 0, 30, 30)];
        [annotationButton setImage:[UIImage imageNamed:@"SelectIcon"] forState:UIControlStateNormal];
        annotationView.rightCalloutAccessoryView = annotationButton;
        [annotationButton addTarget:self action:@selector(selectAirport) forControlEvents:UIControlEventTouchUpInside];
    }
    annotationView.annotation = annotation;
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    for (MapPrice *price in _prices) {
        if (price.destination.coordinate.latitude == view.annotation.coordinate.latitude && price.destination.coordinate.longitude == view.annotation.coordinate.longitude)
            _selectedPrice = price;
    }
}

- (void)selectAirport {
    [[CoreDataHelper sharedInstance] addToHistory:_selectedPrice];
    [self.delegate selectCity:_selectedPrice.destination];
}

@end
