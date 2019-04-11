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
#import "HistoryTrack+CoreDataClass.h"

#define kFavoriteDidUpdate @"FavoriteDidUpdate"
#define kHistoryDidUpdate @"HistoryDidUpdate"

@interface CoreDataHelper : NSObject

+ (instancetype)sharedInstance;

- (BOOL)isFavorite:(Ticket *)ticket;
- (NSArray *)favorites;
- (void)addToFavorite:(Ticket *)ticket;
- (void)removeFromFavorite:(FavoriteTicket *)favorite;
- (void)removeTicketFromFavorite:(Ticket *)ticket;

- (BOOL)isHistoryTrack:(NSString *)originIATA destination:(NSString *)destinationIATA value:(NSInteger)value;
- (BOOL)isHistoryTrack:(MapPrice *)mapPrice;
- (NSArray *)historyTracks;
- (void)addToHistory:(MapPrice *)mapPrice;
- (void)addToHistory:(NSString *)originIATA destination:(NSString *)destinationIATA value:(NSInteger)value;
- (void)removeFromHistory:(NSString *)originIATA destination:(NSString *)destinationIATA value:(NSInteger)value;
- (void)removeFromHistory:(HistoryTrack *)historyTrack;
- (void)removeMapPriceFromHistory:(MapPrice *)mapPrice;

@end
