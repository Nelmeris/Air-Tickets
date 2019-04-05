//
//  CoreDataHelper.h
//  Air Tickets
//
//  Created by Artem Kufaev on 05/04/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "DataManager.h"
#import "FavoriteTicket+CoreDataClass.h"

@interface CoreDataHelper : NSObject

+ (instancetype)sharedInstance;

- (BOOL)isFavorite:(Ticket *)ticket;
- (NSArray *)favorites;
- (void)addToFavorite:(Ticket *)ticket;
- (void)removeFromFavorite:(Ticket *)ticket;
- (Ticket *)ticketFromFavorite:(FavoriteTicket *)favorite;

@end
