//
//  PlaceViewController.m
//  Air Tickets
//
//  Created by Artem Kufaev on 28/03/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

#import "PlaceViewController.h"
#import "MapView.h"
#import "SearchCollectionViewCell.h"
#import "LocationService.h"

#define ReuseIdentifier @"CellIdentifier"

@interface PlaceViewController ()
@property (nonatomic) PlaceType placeType;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@end

@interface PlaceViewController () <MapViewDelegate>
@property (nonatomic, strong) MapView *mapView;
@end

#define TABLE_CELL_IDENTIFIER @"CellIdentifier"
@interface PlaceViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *currentArray;
@end

#define SEARCH_COLLECTION_CELL_IDENTIFIER @"SearchCell"
@interface PlaceViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UISearchResultsUpdating>
@property (nonatomic, strong) UICollectionView *searchCollectionView;
@property (nonatomic, strong) NSArray *searchArray;
@property (nonatomic, strong) UISearchController *searchController;
@end

@implementation PlaceViewController

- (instancetype)initWithType:(PlaceType)type origin:(City *)origin {
    self = [super init];
    if (self) {
        _placeType = type;
        _origin = origin;
        
        [self configureController];
        [self configureNavigationController];
        [self configureTableView];
        [self configureMapView];
        [self congigureSegmentedControl];
        [self changeSource];
    }
    return self;
}

#pragma mark - Configures

- (void)configureController {
    [self setTitle:(_placeType == PlaceTypeDeparture) ? @"Откуда" : @"Куда"];
}

- (void)configureNavigationController {
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [self.navigationItem setHidesSearchBarWhenScrolling:NO];
}

- (void)configureTableView {
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    if (@available(iOS 11.0, *)) {
        self.navigationItem.searchController = _searchController;
    } else {
        _tableView.tableHeaderView = _searchController.searchBar;
    }
    
    [self.view addSubview:_tableView];
    
    [self configureSearchController];
}

- (void)configureSearchController {
    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _searchController.dimsBackgroundDuringPresentation = NO;
    _searchController.searchResultsUpdater = self;
    [_searchController.searchBar setPlaceholder:@"Поиск..."];
    _searchArray = [NSArray new];
    
    [self configureSearchCollectionView];
}

- (void)configureSearchCollectionView {
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.minimumLineSpacing = 10.0;
    layout.minimumInteritemSpacing = 10.0;
    layout.itemSize = CGSizeMake(100.0, 100.0);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _searchCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _searchCollectionView.backgroundColor = [UIColor whiteColor];
    _searchCollectionView.delegate = self;
    _searchCollectionView.dataSource = self;
    [_searchCollectionView registerClass:[SearchCollectionViewCell class] forCellWithReuseIdentifier:SEARCH_COLLECTION_CELL_IDENTIFIER];
    
    [_searchCollectionView setCenter:CGPointMake(self.view.bounds.size.width / 2, -self.view.bounds.size.height / 2)];
    [self.view addSubview:_searchCollectionView];
}

- (void)configureMapView {
    _mapView = [[MapView alloc] initWithFrame:self.view.bounds origin:_origin];
    _mapView.delegate = self;
}

- (void)congigureSegmentedControl {
    NSMutableArray<NSString *> *items = [NSMutableArray arrayWithArray:@[@"Города", @"Аэропорты"]];
    if (_placeType == PlaceTypeArrival)
        [items addObject:@"Карта"];
    _segmentedControl = [[UISegmentedControl alloc] initWithItems:items];
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
            
            if (@available(iOS 11.0, *)) {
                self.navigationItem.searchController = _searchController;
            } else {
                _tableView.tableHeaderView = _searchController.searchBar;
            }
            break;
        case 1:
            if (![self.view.subviews containsObject:_tableView])
                [self.view addSubview:_tableView];
            [_mapView removeFromSuperview];
            _currentArray = [[DataManager sharedInstance] airports];
            if (@available(iOS 11.0, *)) {
                self.navigationItem.searchController = _searchController;
            } else {
                _tableView.tableHeaderView = _searchController.searchBar;
            }
            break;
        case 2:
            if (![self.view.subviews containsObject:_mapView])
                [self.view addSubview:_mapView];
            if ([self.view.subviews containsObject:_tableView])
                [_tableView removeFromSuperview];
            if (@available(iOS 11.0, *)) {
                self.navigationItem.searchController = nil;
            } else {
                _tableView.tableHeaderView = nil;
            }
            break;
        default:
            break;
    }
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_currentArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:ReuseIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (_segmentedControl.selectedSegmentIndex == 0) {
        City *city = [_currentArray objectAtIndex:indexPath.row];
        cell.textLabel.text = city.name;
        cell.detailTextLabel.text = city.code;
    }
    else if (_segmentedControl.selectedSegmentIndex == 1) {
        Airport *airport = [_currentArray objectAtIndex:indexPath.row];
        cell.textLabel.text = airport.name;
        cell.detailTextLabel.text = airport.code;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DataSourceType dataType = ((int)_segmentedControl.selectedSegmentIndex) + 1;
    [self.delegate selectPlace:[_currentArray objectAtIndex:indexPath.row] withType:_placeType andDataType:dataType];
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
    if (![searchController.searchBar.text isEqual: @""]) {
        [UIView animateWithDuration:0.5 animations:^{
            [self->_searchCollectionView setCenter:CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height / 2)];
        }];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name CONTAINS[cd] %@", searchController.searchBar.text];
        _searchArray = [_currentArray filteredArrayUsingPredicate: predicate];
        [_searchCollectionView reloadData];
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            [self->_searchCollectionView setCenter:CGPointMake(self.view.bounds.size.width / 2, -self.view.bounds.size.height / 2)];
        }];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _searchArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SearchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: SEARCH_COLLECTION_CELL_IDENTIFIER forIndexPath:indexPath];
    if (_segmentedControl.selectedSegmentIndex == 0) {
        City *city = (_searchController.isActive && [_searchArray count] > 0) ? [_searchArray objectAtIndex:indexPath.row] : [_currentArray objectAtIndex:indexPath.row];
        [cell.label setText:city.name];
    }
    else if (_segmentedControl.selectedSegmentIndex == 1) {
        Airport *airport = (_searchController.isActive && [_searchArray count] > 0) ? [_searchArray objectAtIndex:indexPath.row] : [_currentArray objectAtIndex:indexPath.row];
        [cell.label setText:airport.name];
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    DataSourceType dataType = ((int)_segmentedControl.selectedSegmentIndex) + 1;
    if (_searchController.isActive && [_searchArray count] > 0) {
        [self.delegate selectPlace:[_searchArray objectAtIndex:indexPath.row] withType:_placeType andDataType:dataType];
        _searchController.active = NO;
    } else {
        [self.delegate selectPlace:[_currentArray objectAtIndex:indexPath.row] withType:_placeType andDataType:dataType];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
