//
//  TicketTableViewCell.h
//  Air Tickets
//
//  Created by Artem Kufaev on 28/03/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
#import "APIManager.h"
#import "Ticket.h"

@interface TicketTableViewCell : UITableViewCell

@property (nonatomic, strong) Ticket *ticket;

@end
