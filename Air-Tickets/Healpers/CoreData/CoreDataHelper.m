//
//  CoreDataHelper.m
//  Air Tickets
//
//  Created by Artem Kufaev on 05/04/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

#import "CoreDataHelper.h"

@interface CoreDataHelper ()
@property (nonatomic, strong) NSPersistentContainer *persistentContainer;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@end

@implementation CoreDataHelper

+ (instancetype)sharedInstance
{
    static CoreDataHelper *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [CoreDataHelper new];
        [instance setup];
    });
    return instance;
}

- (void)setup {
    self.persistentContainer = [[NSPersistentContainer alloc] initWithName:@"DataBase"];
    [self.persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *desc, NSError *error) {
        if (error) {
            NSLog(@"%@", [error localizedDescription]);
            abort();
        }
        self.managedObjectContext = self.persistentContainer.viewContext;
    }];
}

- (void)save:(NSString *)notificationName object:(id)object  {
    NSError *error;
    [_managedObjectContext save: &error];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:object];
    }
}

#pragma mark - Favorite

- (FavoriteTicket *)favoriteFromTicket:(Ticket *)ticket {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"FavoriteTicket"];
    request.predicate = [NSPredicate predicateWithFormat:@"price == %ld AND airline == %@ AND from == %@ AND to == %@ AND departure == %@ AND expires == %@ AND flightNumber == %ld", (long)ticket.price.integerValue, ticket.airline, ticket.from, ticket.to, ticket.departure, ticket.expires, (long)ticket.flightNumber.integerValue];
    return [[_managedObjectContext executeFetchRequest:request error:nil] firstObject];
}

- (BOOL)isFavorite:(Ticket *)ticket {
    return [self favoriteFromTicket:ticket] != nil;
}

- (void)addToFavorite:(Ticket *)ticket {
    FavoriteTicket *favorite = [NSEntityDescription insertNewObjectForEntityForName:@"FavoriteTicket" inManagedObjectContext:_managedObjectContext];
    favorite.price = ticket.price.intValue;
    favorite.airline = ticket.airline;
    favorite.departure = ticket.departure;
    favorite.expires = ticket.expires;
    favorite.flightNumber = ticket.flightNumber.intValue;
    favorite.returnDate = ticket.returnDate;
    favorite.from = ticket.from;
    favorite.to = ticket.to;
    favorite.created = [NSDate date];
    [self save:kFavoriteDidUpdate object:favorite];
}

- (void)removeFromFavorite:(FavoriteTicket *)favorite {
    if (favorite) {
        [_managedObjectContext deleteObject:favorite];
        [self save:kFavoriteDidUpdate object:favorite];
    }
}

- (void)removeTicketFromFavorite:(Ticket *)ticket {
    FavoriteTicket *favorite = [self favoriteFromTicket:ticket];
    if (favorite) {
        [_managedObjectContext deleteObject:favorite];
        [self save:kFavoriteDidUpdate object:favorite];
    }
}

- (NSArray *)favorites {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"FavoriteTicket"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"created" ascending:NO]];
    return [_managedObjectContext executeFetchRequest:request error:nil];
}

#pragma mark - History Tracks

- (HistoryTrack *)historyTrackFromMapPrice:(MapPrice *)mapPrice {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"HistoryTrack"];
    request.predicate = [NSPredicate predicateWithFormat:@"originIATA == %@ AND destinationIATA == %@", mapPrice.origin.code, mapPrice.destination.code];
    HistoryTrack *var = [[_managedObjectContext executeFetchRequest:request error:nil] firstObject];
    return var;
}

- (BOOL)isHistoryTrack:(NSString *)originIATA destination:(NSString *)destinationIATA value:(NSInteger)value {
    MapPrice *mapPrice = [MapPrice new];
    mapPrice.origin = [City new];
    mapPrice.origin.code = originIATA;
    mapPrice.destination = [City new];
    mapPrice.destination.code = destinationIATA;
    mapPrice.value = value;
    return [self historyTrackFromMapPrice:mapPrice] != nil;
}

- (BOOL)isHistoryTrack:(MapPrice *)mapPrice {
    return [self historyTrackFromMapPrice:mapPrice] != nil;
}

- (void)addToHistory:(MapPrice *)mapPrice {
    HistoryTrack *historyTrack = [NSEntityDescription insertNewObjectForEntityForName:@"HistoryTrack" inManagedObjectContext:_managedObjectContext];
    historyTrack.originIATA = mapPrice.origin.code;
    historyTrack.destinationIATA = mapPrice.destination.code;
    historyTrack.value = mapPrice.value;
    historyTrack.created = [NSDate date];
    [self save:kHistoryDidUpdate object:historyTrack];
}

- (void)addToHistory:(NSString *)originIATA destination:(NSString *)destinationIATA value:(NSInteger)value {
    HistoryTrack *historyTrack = [NSEntityDescription insertNewObjectForEntityForName:@"HistoryTrack" inManagedObjectContext:_managedObjectContext];
    historyTrack.originIATA = originIATA;
    historyTrack.destinationIATA = destinationIATA;
    historyTrack.value = value;
    historyTrack.created = [NSDate date];
    [self save:kHistoryDidUpdate object:historyTrack];
}

- (void)removeFromHistory:(NSString *)originIATA destination:(NSString *)destinationIATA value:(NSInteger)value {
    MapPrice *mapPrice = [MapPrice new];
    mapPrice.origin = [City new];
    mapPrice.origin.code = originIATA;
    mapPrice.destination = [City new];
    mapPrice.destination.code = destinationIATA;
    mapPrice.value = value;
    HistoryTrack *historyTrack = [self historyTrackFromMapPrice:mapPrice];
    if (historyTrack) {
        [_managedObjectContext deleteObject:historyTrack];
        [self save:kHistoryDidUpdate object:historyTrack];
    }
}

- (void)removeFromHistory:(HistoryTrack *)historyTrack {
    if (historyTrack) {
        [_managedObjectContext deleteObject:historyTrack];
        [self save:kHistoryDidUpdate object:historyTrack];
    }
}

- (void)removeMapPriceFromHistory:(MapPrice *)mapPrice {
    HistoryTrack *historyTrack = [self historyTrackFromMapPrice:mapPrice];
    if (historyTrack) {
        [_managedObjectContext deleteObject:historyTrack];
        [self save:kHistoryDidUpdate object:historyTrack];
    }
}

- (NSArray *)historyTracks {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"HistoryTrack"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"created" ascending:NO]];
    return [_managedObjectContext executeFetchRequest:request error:nil];
}

@end
