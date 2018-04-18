//
//  VenueObject.m
//  ios-interview
//
//  Created by Conor Sweeney on 4/18/18.
//  Copyright © 2018 Foursquare. All rights reserved.
//

#import "VenueObject.h"

@implementation VenueObject

-(id)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.openTime = [dict objectForKey:@"openTime"] ? [[dict objectForKey:@"openTime"] floatValue] : 0.0;
        self.closeTime = [dict objectForKey:@"closeTime"] ? [[dict objectForKey:@"closeTime"] floatValue] : 0.0;
        self.name = [dict objectForKey:@"name"] ? [NSString stringWithFormat:@"%@", [dict objectForKey:@"name"]]: @"";
        self.uniqueId = [dict objectForKey:@"id"] ? [NSString stringWithFormat:@"%@", [dict objectForKey:@"id"]] : @"";
        if ([dict objectForKey:@"visitors"]) self.visitors = [self parseVisitors:[dict objectForKey:@"visitors"]];
    }
    return self;
}

//Method Big O is N + NLogN + (N * (MLogM + M)) with N representing parent nodes and M representing their children
//This algorithm will order the visitors first by arrival time in ascending order
//If visitors arrive at the same time they will then be ordered by leaving time
//This algorithm also calculates time where there are no visitors
//Iterating over the visitor nodes multiple times is not ideal but necessary in order to properly sort and store the data
-(NSMutableArray *)parseVisitors:(NSArray *)visitorArr{
    
    //This container dictionary will be used to store visitors based on arrival time
    NSMutableDictionary *containerDict = [NSMutableDictionary new];
    //This loop will run in O(N)
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"leaveTime" ascending:YES];
    for (NSDictionary *visitorDict in visitorArr) {
        VisitorObject *visitor = [[VisitorObject alloc] initWithDictionary:visitorDict];
        NSString *key = [NSString stringWithFormat:@"%f",visitor.arriveTime];
        NSMutableArray *arriveArr;
        if ([containerDict objectForKey:key]) {
            arriveArr = [containerDict objectForKey:key];
        }
        else{
            arriveArr = [NSMutableArray new];
        }
        [arriveArr addObject:visitor];
        [containerDict setObject:arriveArr forKey:key];
    }
    
    //I am now sorting the objects in the dictionary
    //This is less expensive than doing my own insertion sort when building the dictionary
    //Sorting will run in O(NLogN)
    NSArray *sortedKeys = [containerDict.allKeys sortedArrayUsingSelector:@selector(compare:)];
    //Container Array outside loop to add visitors
    NSMutableArray *containerVisitorArr = [NSMutableArray new];
    //Loop through sorted keys again to format Array
    //Both loops are ordered
    //This will be used to calculate no visitor times
    //It is important to realize that this can never run in quadratic time since each node will only be visited exactly once in the tree even though there is a nested loop
    //this start time will be used to check if there is a no visitor time block
    float startTime = self.openTime;
    for (NSString *key in sortedKeys) {
        float keyTime = [key floatValue];
        //no visitor check
        if (keyTime > startTime) {
            //add a no visitor object
            VisitorObject *noVisitor = [[VisitorObject alloc] init];
            noVisitor.name = @"No Visitors";
            noVisitor.arriveTime = startTime;
            noVisitor.leaveTime = keyTime;
            [noVisitor formatTimeStr];
            [containerVisitorArr addObject: noVisitor];
        }
        
        NSArray *visitorArr = [containerDict objectForKey:key];
        //This will run in O(MLogM) with M representing child nodes of N
        NSArray *sortedArray = [visitorArr sortedArrayUsingDescriptors:@[sortDescriptor]];
        //Runs in O(M)
        for (VisitorObject *visitor in sortedArray) {
            if (visitor.leaveTime > startTime) {
                startTime = visitor.leaveTime;
            }
            [containerVisitorArr addObject:visitor];
            //last object check for final no visitors
            if ([key isEqualToString:[sortedKeys lastObject]]) {
                if (visitor.leaveTime < self.closeTime) {
                    VisitorObject *lastNoVisitor = [[VisitorObject alloc] init];
                    lastNoVisitor.name = @"No Visitors";
                    lastNoVisitor.arriveTime = visitor.leaveTime;
                    lastNoVisitor.leaveTime = self.closeTime;
                    [lastNoVisitor formatTimeStr];
                    [containerVisitorArr addObject: lastNoVisitor];
                }
            }
        }
    }
    
    return containerVisitorArr;
}

@end
