//
//  TableViewController.h
//  Air Tickets
//
//  Created by Artem Kufaev on 17/03/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TableViewController : UITableViewController {
    UINavigationController *navigationController;
}

- (instancetype)initWithNavController: (UINavigationController *)nc;

@end

NS_ASSUME_NONNULL_END
