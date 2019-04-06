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

- (void)save:(NSString *)notificationName {
    NSError *error;
    [_managedObjectContext save: &error];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil];
    }
}

#pragma mark - Favorite

- (FavoriteTicket *)favoriteFromTicket:(Ticket *)ticket {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"FavoriteTicket"];
    request.predicate = [NSPredicate predicateWithFormat:@"price == %ld AND airline == %@ AND from == %@ AND to == %@ AND departure == %@ AND expires == %@ AND flightNumber == %ld", (long)ticket.price.integerValue, ticket.airline, ticket.from, ticket.to, ticket.departure, ticket.expires, (long)ticket.flightNumber.integerValue];
    return [[_managedObjectContext executeFetchRequest:request error:nil] firstObject];
}

- (Ticket *)ticketFromFavorite:(FavoriteTicket *)favorite {
    Ticket *ticket = [[Ticket alloc] init];
    ticket.price = [NSNumber numberWithLongLong:favorite.price];
    ticket.airline = favorite.airline;
    ticket.departure = favorite.departure;
    ticket.expires = favorite.expires;
    ticket.flightNumber = [NSNumber numberWithLongLong:favorite.flightNumber];
    ticket.returnDate = favorite.returnDate;
    ticket.from = favorite.from;
    ticket.to = favorite.to;
    return ticket;
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
    [self save:kFavoriteDidUpdate];
}

- (void)removeFromFavorite:(Ticket *)ticket {
    FavoriteTicket *favorite = [self favoriteFromTicket:ticket];
    if (favorite) {
        [_managedObjectContext deleteObject:favorite];
        [self save:kFavoriteDidUpdate];
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
    return [[_managedObjectContext executeFetchRequest:request error:nil] firstObject];
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
    [self save:kHistoryDidUpdate];
}

- (void)removeFromHistory:(MapPrice *)mapPrice {
    HistoryTrack *historyTrack = [self historyTrackFromMapPrice:mapPrice];
    if (historyTrack) {
        [_managedObjectContext deleteObject:historyTrack];
        [self save:kHistoryDidUpdate];
    }
}

- (NSArray *)historyTracks {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"HistoryTrack"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"created" ascending:NO]];
    return [_managedObjectContext executeFetchRequest:request error:nil];
}

@end
