//
//  TicketTableViewCell.m
//  Air Tickets
//
//  Created by Artem Kufaev on 28/03/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

#import "TicketTableViewCell.h"
#import <YYWebImage/YYWebImage.h>
#import "APIManager.h"

@interface TicketTableViewCell ()
@property (nonatomic, strong) UIImageView *airlineLogoView;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *placesLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@end

@implementation TicketTableViewCell

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
        [self airlineLogoViewConfiguration];
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

- (void)airlineLogoViewConfiguration {
    _airlineLogoView = [[UIImageView alloc] initWithFrame:self.bounds];
    _airlineLogoView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_airlineLogoView];
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
    _airlineLogoView.frame = CGRectMake(CGRectGetMaxX(_priceLabel.frame) + 10.0, 10.0, 80.0, 80.0);
    _placesLabel.frame = CGRectMake(10.0, CGRectGetMaxY(_priceLabel.frame) + 16.0, 100.0, 20.0);
    _dateLabel.frame = CGRectMake(10.0, CGRectGetMaxY(_placesLabel.frame) + 8.0, self.contentView.frame.size.width - 20.0, 20.0);
}

- (void)setTicket:(Ticket *)ticket {
    _ticket = ticket;
    
    _priceLabel.text = [NSString stringWithFormat:@"%@ руб.", ticket.price];
    _placesLabel.text = [NSString stringWithFormat:@"%@ - %@", ticket.from, ticket.to];
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"dd MMMM yyyy hh:mm";
    _dateLabel.text = [dateFormatter stringFromDate:ticket.departure];
    
    NSURL *urlLogo = AirlineLogo(ticket.airline);
    [_airlineLogoView yy_setImageWithURL:urlLogo options:YYWebImageOptionSetImageWithFadeAnimation];
}

- (void)setFavoriteTicket:(FavoriteTicket *)favoriteTicket {
    _favoriteTicket = favoriteTicket;
    
    _priceLabel.text = [NSString stringWithFormat:@"%lld руб.", favoriteTicket.price];
    _placesLabel.text = [NSString stringWithFormat:@"%@ - %@", favoriteTicket.from, favoriteTicket.to];
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"dd MMMM yyyy hh:mm";
    _dateLabel.text = [dateFormatter stringFromDate:favoriteTicket.departure];
    NSURL *urlLogo = AirlineLogo(favoriteTicket.airline);
    [_airlineLogoView yy_setImageWithURL:urlLogo options:YYWebImageOptionSetImageWithFadeAnimation];
}

@end
