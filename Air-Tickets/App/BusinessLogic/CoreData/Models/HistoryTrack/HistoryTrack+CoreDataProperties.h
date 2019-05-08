//
//  HistoryTrack+CoreDataProperties.h
//  Air Tickets
//
//  Created by Artem Kufaev on 06/04/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//
//

#import "HistoryTrack+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface HistoryTrack (CoreDataProperties)

+ (NSFetchRequest<HistoryTrack *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *created;
@property (nullable, nonatomic, copy) NSString *destinationIATA;
@property (nullable, nonatomic, copy) NSString *originIATA;
@property (nonatomic) int64_t value;

@end

NS_ASSUME_NONNULL_END
