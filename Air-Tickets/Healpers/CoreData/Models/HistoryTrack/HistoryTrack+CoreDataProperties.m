//
//  HistoryTrack+CoreDataProperties.m
//  Air Tickets
//
//  Created by Artem Kufaev on 06/04/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//
//

#import "HistoryTrack+CoreDataProperties.h"

@implementation HistoryTrack (CoreDataProperties)

+ (NSFetchRequest<HistoryTrack *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"HistoryTrack"];
}

@dynamic created;
@dynamic destinationIATA;
@dynamic originIATA;
@dynamic value;

@end
