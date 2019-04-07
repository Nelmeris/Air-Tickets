//
//  HistoryTracksTableViewCell.h
//  Air Tickets
//
//  Created by Artem Kufaev on 06/04/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataHelper.h"

@interface HistoryTracksTableViewCell : UITableViewCell

@property (nonatomic, strong) HistoryTrack *historyTrack;
@property (nonatomic, strong) NSArray<Ticket *> *tickets;

@end
