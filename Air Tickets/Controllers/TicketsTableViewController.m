//
//  TicketsTableViewController.m
//  Air Tickets
//
//  Created by Artem Kufaev on 28/03/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

#import "TicketsTableViewController.h"
#import "TicketTableViewCell.h"

#define TicketCellReuseIdentifier @"TicketCellIdentifier"

@interface TicketsTableViewController ()
@property (nonatomic, strong) NSArray *tickets;
@end

@implementation TicketsTableViewController

- (instancetype)initWithTickets:(NSArray *)tickets {
    self = [super init];
    if (self) {
        [self setTickets:tickets];
        
        [self configureController];
        [self configureTableView];
    }
    return self;
}

#pragma mark - Configures

- (void)configureController {
    [self setTitle:@"Билеты"];
}

- (void)configureTableView {
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView registerClass:[TicketTableViewCell class] forCellReuseIdentifier:TicketCellReuseIdentifier];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tickets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TicketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TicketCellReuseIdentifier forIndexPath:indexPath];
    [cell setTicket:[_tickets objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140.0;
}

@end
