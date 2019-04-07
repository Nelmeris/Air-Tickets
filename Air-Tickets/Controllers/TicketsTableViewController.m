//
//  TicketsTableViewController.m
//  Air Tickets
//
//  Created by Artem Kufaev on 28/03/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

#import "TicketsTableViewController.h"
#import "TicketTableViewCell.h"
#import "CoreDataHelper.h"

#define TicketCellReuseIdentifier @"TicketCellIdentifier"

@interface TicketsTableViewController ()
@property (nonatomic, strong) NSMutableArray *tickets;
@end

@implementation TicketsTableViewController {
    BOOL isFavorites;
}

- (instancetype)initFavoriteTicketsController {
    self = [super init];
    if (self) {
        isFavorites = YES;
        self.tickets = [NSMutableArray new];
        self.title = @"Избранное";
        [self configureTableView];
    }
    return self;
}

- (instancetype)initWithTickets:(NSArray *)tickets {
    self = [super init];
    if (self)
    {
        _tickets = [NSMutableArray arrayWithArray:tickets];
        self.title = @"Билеты";
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
    [self.tableView beginUpdates];
    if ([_tickets containsObject:newFavorit]) {
        for (int i = 0; i < _tickets.count; i++) {
            if ([_tickets[i] isEqual:newFavorit]) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [_tickets removeObject:newFavorit];
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
                break;
            }
        }
    } else {
        NSMutableArray *newArray = [NSMutableArray arrayWithArray:_tickets];
        [newArray addObject:newFavorit];
        [_tickets sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return ((FavoriteTicket *)obj1).created < ((FavoriteTicket *)obj2).created;
        }];
        for (int i = 0; i < _tickets.count; i++) {
            if ([_tickets[i] isEqual:newArray[i]]) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [_tickets insertObject:newFavorit atIndex:i];
                [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
                break;
            }
        }
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
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Действия с билетом" message:@"Удалить из избранного?" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *favoriteAction;
        favoriteAction = [UIAlertAction actionWithTitle:@"Да" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [[CoreDataHelper sharedInstance] removeFromFavorite:[self->_tickets objectAtIndex:indexPath.row]];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Закрыть" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:favoriteAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Действия с билетом" message:@"Что необходимо сделать с выбранным билетом?" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *favoriteAction;
    if ([[CoreDataHelper sharedInstance] isFavorite: [_tickets objectAtIndex:indexPath.row]]) {
        favoriteAction = [UIAlertAction actionWithTitle:@"Удалить из избранного" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [[CoreDataHelper sharedInstance] removeTicketFromFavorite:[self->_tickets objectAtIndex:indexPath.row]];
        }];
    } else {
        favoriteAction = [UIAlertAction actionWithTitle:@"Добавить в избранное" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[CoreDataHelper sharedInstance] addToFavorite:[self->_tickets objectAtIndex:indexPath.row]];
        }];
    }
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Закрыть" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:favoriteAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
