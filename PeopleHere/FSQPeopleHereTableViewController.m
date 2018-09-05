//
//  FSQPeopleHereTableViewController.m
//  ios-interview
//
//  Created by Samuel Grossberg on 3/17/16.
//  Copyright © 2016 Foursquare. All rights reserved.
//

#import "FSQPeopleHereTableViewController.h"

@interface FSQPeopleHereTableViewController ()

@end

@implementation FSQPeopleHereTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self downloadParseJSON];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)downloadParseJSON{
    //do this on a background thread to pretend it is a real url request
    dispatch_queue_t myprocess_queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_async(myprocess_queue, ^{
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"people-here" ofType:@"json"];
        NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
        if([dict objectForKey:@"venue"]){
            NSDictionary *venueDict = [dict objectForKey:@"venue"];
            self.venue = [[VenueObject alloc] initWithDictionary:venueDict];
            //push to main thread to reload tableview
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.venue.visitors.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    VisitorObject *visitor = [self.venue.visitors objectAtIndex:indexPath.row];
    if (!visitor.visitor) {
        cell.textLabel.textColor = [UIColor lightGrayColor];
    }
    else{
        cell.textLabel.textColor = [UIColor blackColor];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@: %@",visitor.name, visitor.timeStr];    
    return cell;
}

@end
