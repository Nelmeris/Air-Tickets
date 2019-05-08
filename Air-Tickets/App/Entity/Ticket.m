//
//  Ticket.m
//  Air Tickets
//
//  Created by Artem Kufaev on 28/03/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

#import "Ticket.h"

@implementation Ticket

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        _airline = [dictionary valueForKey:@"airline"];
        _expires = dateFromString([dictionary valueForKey:@"expires_at"]);
        _departure = dateFromString([dictionary valueForKey:@"departure_at"]);
        _flightNumber = [dictionary valueForKey:@"flight_number"];
        _price = [dictionary valueForKey:@"price"];
        _returnDate = dateFromString([dictionary valueForKey:@"return_at"]);
    }
    return self;
}

NSDate *dateFromString(NSString *dateString) {
    if (!dateString) return nil;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSString *correctStringDate = [dateString stringByReplacingOccurrencesOfString:@"Z" withString:@""];
    correctStringDate = [NSString stringWithFormat:@"%@+0000", correctStringDate];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZ";
    NSDate *date = [dateFormatter dateFromString:correctStringDate];
    return date;
}

@end
