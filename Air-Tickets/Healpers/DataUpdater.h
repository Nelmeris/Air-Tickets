//
//  DataUpdater.h
//  Air Tickets
//
//  Created by Artem Kufaev on 11/04/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum DataUpdateType {
    deleted, added
} DataUpdateType;

typedef struct DataUpdateInfo {
    DataUpdateType type;
    NSInteger index;
} DataUpdateInfo;

@interface DataUpdater : NSObject

+ (DataUpdateInfo)getInfo:(NSArray *)datas newObject:(NSObject *)newObject comparison:(NSComparisonResult(^)(id _Nonnull obj1, id _Nonnull obj2))compasion;

@end
