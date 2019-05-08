//
//  DataUpdater.m
//  Air Tickets
//
//  Created by Artem Kufaev on 11/04/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

#import "DataUpdater.h"
#import "CoreDataHelper.h"

@implementation DataUpdater

+ (DataUpdateInfo)getInfo:(NSArray *)datas newObject:(NSObject *)newObject comparison:(NSComparisonResult(^)(id _Nonnull obj1, id _Nonnull obj2))compasion {
    DataUpdateInfo info;
    if ([datas containsObject:newObject]) { // Deleting
        info.type = deleted;
        for (int i = 0; i < datas.count; i++) {
            if ([datas[i] isEqual:newObject]) {
                info.index = i;
                break;
            }
        }
    } else { // Adding
        info.type = added;
        NSMutableArray *newArray = [NSMutableArray arrayWithArray:datas];
        [newArray addObject:newObject];
        [newArray sortUsingComparator:compasion];
        for (int i = 0; i < newArray.count; i++) {
            if ([newArray[i] isEqual:newObject]) {
                info.index = i;
                break;
            }
        }
    }
    return info;
}

@end
