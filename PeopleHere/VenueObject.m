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

-(NSMutableArray *)parseVisitors:(NSArray *)visitorArr{
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
    //Sorting will run in O(NLogN)
    NSArray *sortedKeys = [containerDict.allKeys sortedArrayUsingSelector:@selector(compare:)];
    //Container Array outside loop to add visitors
    NSMutableArray *containerVisitorArr = [NSMutableArray new];
    //Loop through sorted keys again to format Array
    //Both loops are ordered
    //This will be used to calculate no visitor times
    float startTime = self.openTime;
    for (NSString *key in sortedKeys) {
        float keyTime = [key floatValue];
        if (keyTime > startTime) {
            //add a no visitor block
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
            startTime = visitor.leaveTime;
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
