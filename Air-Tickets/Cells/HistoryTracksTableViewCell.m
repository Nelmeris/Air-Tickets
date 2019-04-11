//
//  HistoryTracksTableViewCell.m
//  Air Tickets
//
//  Created by Artem Kufaev on 06/04/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

#import "HistoryTracksTableViewCell.h"
#import "APIManager.h"

@interface HistoryTracksTableViewCell ()
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *placesLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@end

@implementation HistoryTracksTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.layer.shadowColor = [[[UIColor blackColor] colorWithAlphaComponent:0.2] CGColor];
        self.contentView.layer.shadowOffset = CGSizeMake(1.0, 1.0);
        self.contentView.layer.shadowRadius = 10.0;
        self.contentView.layer.shadowOpacity = 1.0;
        self.contentView.layer.cornerRadius = 6.0;
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        [self priceLabelConfiguration];
        [self placesLabelConfiguration];
        [self dateLabelConfiguration];
    }
    return self;
}

- (void)priceLabelConfiguration {
    _priceLabel = [[UILabel alloc] initWithFrame:self.bounds];
    _priceLabel.font = [UIFont systemFontOfSize:24.0 weight:UIFontWeightBold];
    [self.contentView addSubview:_priceLabel];
}

- (void)placesLabelConfiguration {
    _placesLabel = [[UILabel alloc] initWithFrame:self.bounds];
    _placesLabel.font = [UIFont systemFontOfSize:15.0 weight:UIFontWeightLight];
    _placesLabel.textColor = [UIColor darkGrayColor];
    [self.contentView addSubview:_placesLabel];
}

- (void)dateLabelConfiguration {
    _dateLabel = [[UILabel alloc] initWithFrame:self.bounds];
    _dateLabel.font = [UIFont systemFontOfSize:15.0 weight:UIFontWeightRegular];
    [self.contentView addSubview:_dateLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.contentView.frame = CGRectMake(10.0, 10.0, [UIScreen mainScreen].bounds.size.width - 20.0, self.frame.size.height - 20.0);
    _priceLabel.frame = CGRectMake(10.0, 10.0, self.contentView.frame.size.width - 110.0, 40.0);
    _placesLabel.frame = CGRectMake(10.0, CGRectGetMaxY(_priceLabel.frame) + 16.0, 100.0, 20.0);
    _dateLabel.frame = CGRectMake(10.0, CGRectGetMaxY(_placesLabel.frame) + 8.0, self.contentView.frame.size.width - 20.0, 20.0);
}

- (void)setHistoryTrack:(HistoryTrack *)historyTrack {
    _historyTrack = historyTrack;
    
    self->_placesLabel.text = [NSString stringWithFormat:@"%@ - %@", historyTrack.originIATA, historyTrack.destinationIATA];
    
    _priceLabel.text = [NSString stringWithFormat:@"%lld %@", historyTrack.value, NSLocalizedString(@"rubles", @"")];
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"dd MMMM yyyy hh:mm";
    _dateLabel.text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"saved", @""), [dateFormatter stringFromDate:historyTrack.created]];
}

@end
