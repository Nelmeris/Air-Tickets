//
//  HistoryTracksViewController.m
//  Air Tickets
//
//  Created by Artem Kufaev on 06/04/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

#import "HistoryTracksViewController.h"
#import "CoreDataHelper.h"
#import "SearchRequest.h"
#import "TicketsViewController.h"
#import "APIManager.h"
#import "HistoryTracksTableViewCell.h"

#define CellReuseIdentifier @"ReusableCell"

@interface HistoryTracksViewController ()
@property (nonatomic, strong) NSMutableArray<HistoryTrack *> *historyTracks;
@end

@implementation HistoryTracksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureController];
    [self configureTableView];
}

- (void)configureController {
    [self setTitle:NSLocalizedString(@"history_title", @"")];
}

- (void)configureTableView {
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UILongPressGestureRecognizer* longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPress:)];
    [self.tableView addGestureRecognizer:longPressRecognizer];
    [self.tableView registerClass:[HistoryTracksTableViewCell class] forCellReuseIdentifier:CellReuseIdentifier];
    _historyTracks = [NSMutableArray arrayWithArray:[[CoreDataHelper sharedInstance] historyTracks]];
    [self.tableView reloadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData:) name:kHistoryDidUpdate object:nil];
}

- (void)reloadData:(NSNotification *)notification {
    HistoryTrack *newHistoryTrack = notification.object;
    [self.tableView beginUpdates];
    if ([_historyTracks containsObject:newHistoryTrack]) {
        for (int i = 0; i < _historyTracks.count; i++) {
            if ([_historyTracks[i] isEqual:newHistoryTrack]) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [_historyTracks removeObject:newHistoryTrack];
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
                break;
            }
        }
    } else {
        NSMutableArray *newArray = [NSMutableArray arrayWithArray:_historyTracks];
        [newArray addObject:newHistoryTrack];
        [_historyTracks sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return ((HistoryTrack *)obj1).created < ((HistoryTrack *)obj2).created;
        }];
        bool flag = false;
        for (int i = 0; i < _historyTracks.count; i++) {
            if ([_historyTracks[i] isEqual:newArray[i]]) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [_historyTracks insertObject:newHistoryTrack atIndex:i];
                [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
                break;
            }
        }
        if (!flag) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_historyTracks.count inSection:0];
            [_historyTracks insertObject:newHistoryTrack atIndex:_historyTracks.count];
            [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
        }
    }
    [self.tableView endUpdates];
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
        TicketsViewController *ticketsTVC = [[TicketsViewController alloc] initWithTickets:tickets];
        [self.navigationController pushViewController:ticketsTVC animated:YES];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140.0;
}

-(void)onLongPress:(UILongPressGestureRecognizer*)pGesture
{
    if (pGesture.state == UIGestureRecognizerStateBegan) {
        UITableView* tableView = (UITableView*)self.view;
        CGPoint touchPoint = [pGesture locationInView:self.view];
        NSIndexPath* indexPath = [tableView indexPathForRowAtPoint:touchPoint];
        if (indexPath) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"history_delete_msg", @"") message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *favoriteAction;
            favoriteAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"delete_btn", @"") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [[CoreDataHelper sharedInstance] removeFromHistory:self->_historyTracks[indexPath.row]];
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", @"") style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:favoriteAction];
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
}

@end
