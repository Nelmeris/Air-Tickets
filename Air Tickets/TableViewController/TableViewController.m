//
//  TableViewController.m
//  Air Tickets
//
//  Created by Artem Kufaev on 17/03/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

#import "TableViewController.h"
#import "GreenViewController.h"
#import "CellData/CellData.h"

@interface TableViewController () {
    NSMutableArray<CellData *> *data;
}

@end

@implementation TableViewController

- (instancetype)initWithNavController: (UINavigationController *)nc {
    self = [super init];
    if (self) {
        navigationController = nc;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Table";
    
    data = [NSMutableArray new];
    
    [data addObject: [[CellData alloc] initWithTitle:@"Timer" andController:[GreenViewController new]]];
    
    for (int i = 0; i < 100; i++) {
        UIViewController *controller = [UIViewController new];
        UIColor *color = [UIColor colorWithRed:rand() % 255 / 255.0 green:rand() % 255 / 255.0 blue:rand() % 255 / 255.0 alpha:1];
        [controller.view setBackgroundColor:color];
        [data addObject:[[CellData alloc] initWithTitle:[NSString stringWithFormat:@"%d", i] andController:controller]];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [UITableViewCell new];
    
    [cell.textLabel setText:data[indexPath.row].title];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *vc = data[indexPath.row].controller;
    [vc setTitle:data[indexPath.row].title];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Main VC" style:UIBarButtonItemStylePlain target:nil action:nil];
    [navigationController pushViewController:vc animated:YES];
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
