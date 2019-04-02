//
//  SearchCollectionViewCell.m
//  Air Tickets
//
//  Created by Артем Куфаев on 01/04/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

#import "SearchCollectionViewCell.h"

@implementation SearchCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.1]];
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [_label setTextColor:[UIColor blackColor]];
        [_label setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:_label];
    }
    return self;
}

@end
