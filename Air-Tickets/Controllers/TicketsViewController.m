//
//  TicketsViewController.m
//  Air Tickets
//
//  Created by Artem Kufaev on 28/03/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

#import "TicketsViewController.h"
#import "TicketTableViewCell.h"
#import "CoreDataHelper.h"
#import "DataUpdater.h"

#define TicketCellReuseIdentifier @"TicketCellIdentifier"

@interface TicketsViewController ()
@property (nonatomic, strong) NSMutableArray *tickets;
@end

@implementation TicketsViewController {
    BOOL isFavorites;
}

- (instancetype)initFavoriteTicketsController {
    self = [super init];
    if (self) {
        isFavorites = YES;
        self.tickets = [NSMutableArray new];
        [self setTitle:NSLocalizedString(@"favorite_title", @"")];
        [self configureTableView];
    }
    return self;
}

- (instancetype)initWithTickets:(NSArray *)tickets {
    self = [super init];
    if (self)
    {
        _tickets = [NSMutableArray arrayWithArray:tickets];
        [self setTitle:NSLocalizedString(@"tickets_title", @"")];
        [self configureTableView];
    }
    return self;
}

- (void)configureTableView {
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[TicketTableViewCell class] forCellReuseIdentifier:TicketCellReuseIdentifier];
    if (isFavorites) {
        _tickets = [NSMutableArray arrayWithArray:[[CoreDataHelper sharedInstance] favorites]];
        [self.tableView reloadData];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData:) name:kFavoriteDidUpdate object:nil];
    }
}

- (void)reloadData:(NSNotification *)notification {
    FavoriteTicket *newFavorit = notification.object;
    DataUpdateInfo info = [DataUpdater getInfo:_tickets newObject:newFavorit comparison:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return ((FavoriteTicket *)obj1).created.timeIntervalSinceNow < ((FavoriteTicket *)obj2).created.timeIntervalSinceNow;
    }];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:info.index inSection:0];
    [self.tableView beginUpdates];
    if (info.type == added) {
        [_tickets insertObject:newFavorit atIndex:info.index];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    } else {
        [_tickets removeObjectAtIndex:info.index];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    }
    [self.tableView endUpdates];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tickets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TicketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TicketCellReuseIdentifier forIndexPath:indexPath];
    if (isFavorites) {
        cell.favoriteTicket = [_tickets objectAtIndex:indexPath.row];
    } else {
        cell.ticket = [_tickets objectAtIndex:indexPath.row];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (isFavorites) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"favorite_alert_title", @"") message:NSLocalizedString(@"favorite_alert_msg", @"") preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *favoriteAction;
        favoriteAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"favorite_alert_yes_btn", @"") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [[CoreDataHelper sharedInstance] removeFromFavorite:[self->_tickets objectAtIndex:indexPath.row]];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel_btn", @"") style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:favoriteAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"tickets_alert_title", @"") message:NSLocalizedString(@"tickets_alert_msg", @"") preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *favoriteAction;
    if ([[CoreDataHelper sharedInstance] isFavorite: [_tickets objectAtIndex:indexPath.row]]) {
        favoriteAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"tickets_alert_delete_btn", @"") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [[CoreDataHelper sharedInstance] removeTicketFromFavorite:[self->_tickets objectAtIndex:indexPath.row]];
        }];
    } else {
        favoriteAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"tickets_alert_add_btn", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[CoreDataHelper sharedInstance] addToFavorite:[self->_tickets objectAtIndex:indexPath.row]];
        }];
    }
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel_btn", @"") style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:favoriteAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
