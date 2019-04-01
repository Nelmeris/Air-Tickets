
//
//  PlaceViewController.m
//  Air Tickets
//
//  Created by Artem Kufaev on 28/03/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

#import "PlaceViewController.h"
#import "MapView.h"

#define ReuseIdentifier @"CellIdentifier"

@interface PlaceViewController () <MapViewDelegate>

@end

@interface PlaceViewController ()
@property (nonatomic) PlaceType placeType;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MapView *mapView;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) NSArray *currentArray;
@end

#define ReuseIdentifier @"CellIdentifier"

@interface PlaceViewController () <UISearchResultsUpdating>
@property (nonatomic, strong) NSArray *searchArray;
@property (nonatomic, strong) UISearchController *searchController;
@end

@implementation PlaceViewController

- (instancetype)initWithType:(PlaceType)type {
    self = [super init];
    if (self) {
        _placeType = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationItem.hidesSearchBarWhenScrolling = NO;
    self.title = (_placeType == PlaceTypeDeparture) ? @"Откуда" : @"Куда";
    
    [self configureTableView];
    [self configureMapView];
    [self congigureSegmentedControl];
    [self changeSource];
}

#pragma mark - Configurations

- (void)configureTableView {
    [self configureSearchController];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    if (@available(iOS 11.0, *)) {
        self.navigationItem.searchController = _searchController;
    } else {
        _tableView.tableHeaderView = _searchController.searchBar;
    }
    [self.view addSubview:_tableView];
}

- (void)configureSearchController {
    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _searchController.dimsBackgroundDuringPresentation = NO;
    _searchController.searchResultsUpdater = self;
    [_searchController.searchBar setPlaceholder:@"Поиск..."];
    _searchArray = [NSArray new];
}

- (void)configureMapView {
    _mapView = [[MapView alloc] initWithFrame:self.view.bounds];
    _mapView.delegate = self;
}

- (void)congigureSegmentedControl {
    _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Города", @"Аэропорты", @"Карта"]];
    [_segmentedControl addTarget:self action:@selector(changeSource) forControlEvents:UIControlEventValueChanged];
    _segmentedControl.tintColor = [UIColor blackColor];
    self.navigationItem.titleView = _segmentedControl;
    _segmentedControl.selectedSegmentIndex = 0;
}

- (void)changeSource {
    switch (_segmentedControl.selectedSegmentIndex) {
        case 0:
            if (![self.view.subviews containsObject:_tableView])
                [self.view addSubview:_tableView];
            [_mapView removeFromSuperview];
            _currentArray = [[DataManager sharedInstance] cities];
            self.navigationItem.searchController = _searchController;
            [self.navigationController.navigationBar setPrefersLargeTitles:YES];
            break;
        case 1:
            if (![self.view.subviews containsObject:_tableView])
                [self.view addSubview:_tableView];
            [_mapView removeFromSuperview];
            _currentArray = [[DataManager sharedInstance] airports];
            self.navigationItem.searchController = _searchController;
            [self.navigationController.navigationBar setPrefersLargeTitles:YES];
            break;
        case 2:
            if (![self.view.subviews containsObject:_mapView])
                [self.view addSubview:_mapView];
            if ([self.view.subviews containsObject:_tableView])
                [_tableView removeFromSuperview];
            self.navigationItem.searchController = nil;
            [self.navigationController.navigationBar setPrefersLargeTitles:NO];
            break;
        default:
            break;
    }
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_searchController.isActive && [_searchArray count] > 0) {
        return [_searchArray count];
    }
    return [_currentArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:ReuseIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (_segmentedControl.selectedSegmentIndex == 0) {
        City *city = (_searchController.isActive && [_searchArray count] > 0) ? [_searchArray objectAtIndex:indexPath.row] : [_currentArray objectAtIndex:indexPath.row];
        cell.textLabel.text = city.name;
        cell.detailTextLabel.text = city.code;
    }
    else if (_segmentedControl.selectedSegmentIndex == 1) {
        Airport *airport = (_searchController.isActive && [_searchArray count] > 0) ? [_searchArray objectAtIndex:indexPath.row] : [_currentArray objectAtIndex:indexPath.row];
        cell.textLabel.text = airport.name;
        cell.detailTextLabel.text = airport.code;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DataSourceType dataType = ((int)_segmentedControl.selectedSegmentIndex) + 1;
    if (_searchController.isActive && [_searchArray count] > 0) {
        [self.delegate selectPlace:[_searchArray objectAtIndex:indexPath.row] withType:_placeType andDataType:dataType];
        _searchController.active = NO;
    } else {
        [self.delegate selectPlace:[_currentArray objectAtIndex:indexPath.row] withType:_placeType andDataType:dataType];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - MapViewDelegate

- (void)selectCity:(City *)city {
    DataSourceType dataType = DataSourceTypeCity;
    [self.delegate selectPlace:city withType:_placeType andDataType:dataType];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    if (searchController.searchBar.text) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name CONTAINS[cd] %@", searchController.searchBar.text];
        _searchArray = [_currentArray filteredArrayUsingPredicate: predicate];
        [_tableView reloadData];
    }
}

@end
