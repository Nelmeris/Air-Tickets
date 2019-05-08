//
//  FavoriteTicket+CoreDataProperties.m
//  Air Tickets
//
//  Created by Artem Kufaev on 06/04/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//
//

#import "FavoriteTicket+CoreDataProperties.h"

@implementation FavoriteTicket (CoreDataProperties)

+ (NSFetchRequest<FavoriteTicket *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"FavoriteTicket"];
}

@dynamic created;
@dynamic departure;
@dynamic expires;
@dynamic returnDate;
@dynamic airline;
@dynamic from;
@dynamic to;
@dynamic price;
@dynamic flightNumber;

@end
