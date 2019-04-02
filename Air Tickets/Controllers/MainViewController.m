//
//  MainViewController.m
//  Air Tickets
//
//  Created by Artem Kufaev on 28/03/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

#import "MainViewController.h"

#import "DataManager.h"
#import "APIManager.h"
#import "LocationService.h"

#import "PlaceViewController.h"
#import "TicketsTableViewController.h"
#import "PlaceTabBarViewController.h"

@interface MainViewController () <PlaceViewControllerDelegate>
@property (nonatomic, strong) UIView *placeContainerView;
@property (nonatomic, strong) UIButton *departureButton;
@property (nonatomic, strong) UIButton *arrivalButton;
@property (nonatomic) SearchRequest searchRequest;
@property (nonatomic, strong) UIButton *searchButton;
@property (nonatomic, strong) LocationService *locationService;
@property (nonatomic, strong) City *origin;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureController];
    [self configurePlaceContainerView];
    
    [[DataManager sharedInstance] loadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataLoadedSuccessfully) name:kDataManagerLoadDataDidComplete object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCurrentLocation:) name:kLocationServiceDidUpdateCurrentLocation object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDataManagerLoadDataDidComplete object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kLocationServiceDidUpdateCurrentLocation object:nil];
}

#pragma mark - Configures

- (void)configureController {
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setPrefersLargeTitles:YES];
}

- (void)configurePlaceContainerView {
    UIView *placeContainerView = [[UIView alloc] initWithFrame:CGRectMake(20.0, 140.0, [UIScreen mainScreen].bounds.size.width - 40.0, 170.0)];
    [placeContainerView setBackgroundColor:[UIColor whiteColor]];
    [placeContainerView.layer setShadowColor:[[[UIColor blackColor] colorWithAlphaComponent:0.1] CGColor]];
    [placeContainerView.layer setShadowOffset:CGSizeZero];
    [placeContainerView.layer setShadowRadius:20.0];
    [placeContainerView.layer setShadowOpacity:1.0];
    [placeContainerView.layer setCornerRadius:6.0];
    [self setPlaceContainerView:placeContainerView];
    
    [self configureDepartureButton];
    [self configureArrivalButton];
    [self configureSearchButton];
    [self.view addSubview:_placeContainerView];
}

- (void)configureDepartureButton {
    UIButton *departureButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [departureButton setTitle:@"Откуда" forState: UIControlStateNormal];
    [departureButton setFrame:CGRectMake(10.0, 20.0, _placeContainerView.frame.size.width - 20.0, 60.0)];
    [self setDepartureButton:departureButton];
    
    [self configurePlaceButton:departureButton];
    [self.placeContainerView addSubview:departureButton];
}

- (void)configureArrivalButton {
    UIButton *arrivalButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [arrivalButton setTitle:@"Куда" forState: UIControlStateNormal];
    [arrivalButton setFrame:CGRectMake(10.0, CGRectGetMaxY(_departureButton.frame) + 10.0, _placeContainerView.frame.size.width - 20.0, 60.0)];
    [self setArrivalButton:arrivalButton];
    
    [self configurePlaceButton:arrivalButton];
    [self.placeContainerView addSubview:arrivalButton];
}

- (void)configurePlaceButton:(UIButton *)btn {
    [btn setTintColor:[UIColor blackColor]];
    [btn setBackgroundColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.1]];
    [btn.layer setCornerRadius:4.0];
    [btn addTarget:self action:@selector(placeButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)configureSearchButton {
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [searchButton setTitle:@"Найти" forState:UIControlStateNormal];
    [searchButton setTintColor:[UIColor whiteColor]];
    [searchButton setFrame:CGRectMake(30.0, CGRectGetMaxY(_placeContainerView.frame) + 30, [UIScreen mainScreen].bounds.size.width - 60.0, 60.0)];
    [searchButton setBackgroundColor:[UIColor blackColor]];
    [searchButton.layer setCornerRadius:8.0];
    [searchButton.titleLabel setFont:[UIFont systemFontOfSize:20.0 weight:UIFontWeightBold]];
    [searchButton addTarget:self action:@selector(searchButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:searchButton];
    [self setSearchButton:searchButton];
}

#pragma mark - Location

- (void)dataLoadedSuccessfully {
    _locationService = [LocationService new];
}

- (void)updateCurrentLocation:(NSNotification *)notification {
    CLLocation *currentLocation = notification.object;
    City *city = [[DataManager sharedInstance] cityForLocation:currentLocation];
    [self setPlace:city withDataType:DataSourceTypeCity andPlaceType:PlaceTypeDeparture forButton:self->_departureButton];
    
    _locationService = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDataManagerLoadDataDidComplete object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kLocationServiceDidUpdateCurrentLocation object:nil];
}

#pragma mark - Tap reactions

- (void)placeButtonDidTap:(UIButton *)sender {
    PlaceType type = ([sender isEqual:_departureButton]) ? PlaceTypeDeparture : PlaceTypeArrival;
    PlaceViewController *placeViewController = [[PlaceViewController alloc] initWithType:type];
    [placeViewController setDelegate:self];
    if ([sender isEqual:_arrivalButton]) {
        PlaceTabBarViewController *tabBarViewController = [[PlaceTabBarViewController alloc] initWithController:placeViewController origin:_origin];
        [self.navigationController pushViewController: tabBarViewController animated:YES];
    } else {
        [self.navigationController pushViewController: placeViewController animated:YES];
    }
}

- (void)searchButtonDidTap:(UIButton *)sender {
    if (!_searchRequest.destionation || !_searchRequest.origin) {
        NSString *msg = (!_searchRequest.origin) ? @"Выберите адрес отправления" : @"Выберите адрес прибытия";
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Внимание!" message:msg preferredStyle: UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Закрыть" style:(UIAlertActionStyleDefault) handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    [[APIManager sharedInstance] ticketsWithRequest:_searchRequest withCompletion:^(NSArray *tickets) {
        if (tickets.count > 0) {
            TicketsTableViewController *ticketsViewController = [[TicketsTableViewController alloc] initWithTickets:tickets];
            [self.navigationController showViewController:ticketsViewController sender:self];
        } else {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Увы!" message:@"По данному направлению билетов не найдено" preferredStyle: UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Закрыть" style:(UIAlertActionStyleDefault) handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }];
}

#pragma mark - PlaceViewControllerDelegate

- (void)selectPlace:(id)place withType:(PlaceType)placeType andDataType:(DataSourceType)dataType {
    [self setPlace:place withDataType:dataType andPlaceType:placeType forButton: (placeType == PlaceTypeDeparture) ? _departureButton : _arrivalButton ];
}

- (void)setPlace:(id)place withDataType:(DataSourceType)dataType andPlaceType:(PlaceType)placeType forButton:(UIButton *)button {
    NSString *title;
    NSString *iata;
    if (dataType == DataSourceTypeCity) {
        City *city = (City *)place;
        title = city.name;
        iata = city.code;
        _origin = city;
    }
    else if (dataType == DataSourceTypeAirport) {
        Airport *airport = (Airport *)place;
        title = airport.name;
        iata = airport.cityCode;
    }
    if (placeType == PlaceTypeDeparture) {
        _searchRequest.origin = iata;
    } else {
        _searchRequest.destionation = iata;
    }
    [button setTitle: title forState: UIControlStateNormal];
}

@end
