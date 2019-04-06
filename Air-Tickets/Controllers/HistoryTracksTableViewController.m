//
//  HistoryTracksTableViewController.m
//  Air Tickets
//
//  Created by Artem Kufaev on 06/04/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

#import "HistoryTracksTableViewController.h"
#import "CoreDataHelper.h"
#import "SearchRequest.h"
#import "TicketsTableViewController.h"
#import "APIManager.h"
#import "HistoryTracksTableViewCell.h"

#define CellReuseIdentifier @"ReusableCell"

@interface HistoryTracksTableViewController ()
@property (nonatomic, strong) NSMutableArray<HistoryTrack *> *historyTracks;
@end

@implementation HistoryTracksTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureController];
    [self configureTableView];
}

- (void)configureController {
    [self setTitle:@"История поиска"];
}

- (void)configureTableView {
    [self.tableView registerClass:[HistoryTracksTableViewCell class] forCellReuseIdentifier:CellReuseIdentifier];
    [self reloadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:kHistoryDidUpdate object:nil];
}

- (void)reloadData {
    _historyTracks = [NSMutableArray arrayWithArray:[[CoreDataHelper sharedInstance] historyTracks]];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _historyTracks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HistoryTracksTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellReuseIdentifier forIndexPath:indexPath];
    
    cell.historyTrack = _historyTracks[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchRequest searchRequest;
    searchRequest.origin = _historyTracks[indexPath.row].originIATA;
    searchRequest.destionation = _historyTracks[indexPath.row].destinationIATA;
    searchRequest.departDate = searchRequest.returnDate = nil;
    [[APIManager sharedInstance] ticketsWithRequest:searchRequest withCompletion:^(NSArray *tickets) {
        TicketsTableViewController *ticketsTVC = [[TicketsTableViewController alloc] initWithTickets:tickets];
        [self.navigationController pushViewController:ticketsTVC animated:YES];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140.0;
}

@end
