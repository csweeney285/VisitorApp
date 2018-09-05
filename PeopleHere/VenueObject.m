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

//overall this method runs in NLogN sorting > iterating
-(NSMutableArray *)parseVisitors:(NSArray *)visitorArr{
    
    //1. Sort the visitors in ascending order(NLogN)
    //Since I can assume the JSON is well formed, I'm ignoring any unnecessary checks
    NSSortDescriptor *sortByName = [NSSortDescriptor sortDescriptorWithKey:@"arriveTime"
                                                                 ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortByName];
    NSArray *sortedArray = [visitorArr sortedArrayUsingDescriptors:sortDescriptors];
    
    //2. Iterate throught the visitor dictionaries Runs in O(N)
    
    //this container will be used to store the strings that will appear in the tableview
    NSMutableArray *containerArr = [NSMutableArray new];
    //this variable will be used to track empty space
    float startTime = self.openTime;
    for (int i = 0; i < [sortedArray count]; i++) {
        NSDictionary *visitorDict = [sortedArray objectAtIndex:i];
        VisitorObject *visitor = [[VisitorObject alloc] initWithDictionary:visitorDict];
        
        //2a. check for empty time slot
        if (visitor.arriveTime > startTime) {
            //add an empty time slot to the array
            VisitorObject *empty = [VisitorObject new];
            empty.name = @"No Visitors";
            empty.arriveTime = startTime;
            empty.leaveTime = visitor.arriveTime;
            empty.visitor = NO;
            [empty formatTimeStr];
            [containerArr addObject:empty]; //add to array
        }
        
        //2b. add visitor
        [containerArr addObject:visitor];
        
        //2c. reset empty time slot start time
        if (visitor.leaveTime > startTime) {
            startTime = visitor.leaveTime;
        }
        
        //2d. final visitor check
        if (i == [sortedArray count]-1) {
            if (visitor.leaveTime < self.closeTime) {
                VisitorObject *empty = [VisitorObject new];
                empty.arriveTime = visitor.leaveTime;
                empty.leaveTime = self.closeTime;
                empty.name = @"No Visitors";
                empty.visitor = NO;
                [empty formatTimeStr];
                [containerArr addObject:empty]; //add to array
            }
        }
    }
    
    //3. return the container
    return containerArr;
}

@end
