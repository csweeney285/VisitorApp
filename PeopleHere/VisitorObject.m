//
//  VisitorObject.m
//  ios-interview
//
//  Created by Conor Sweeney on 4/18/18.
//  Copyright © 2018 Foursquare. All rights reserved.
//

#import "VisitorObject.h"

@implementation VisitorObject

-(id)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.arriveTime = [dict objectForKey:@"arriveTime"] ? [[dict objectForKey:@"arriveTime"] floatValue] : 0.0;
        self.leaveTime = [dict objectForKey:@"leaveTime"] ? [[dict objectForKey:@"leaveTime"] floatValue] : 0.0;
        self.name = [dict objectForKey:@"name"] ? [NSString stringWithFormat:@"%@", [dict objectForKey:@"name"] ] : @"";
        self.uniqueId = [dict objectForKey:@"id"] ? [NSString stringWithFormat:@"%@", [dict objectForKey:@"id"] ] : @"";
        [self formatTimeStr];
    }
    return self;
}

- (void) formatTimeStr{
      self.timeStr = [NSString stringWithFormat:@"%@ - %@",[self floatToString:self.arriveTime],[self floatToString:self.leaveTime]];
}

- (NSString *)floatToString: (float) timeFloat{
    //get an NSDate starting at midnight
    NSDate *const date = NSDate.date;
    NSCalendar *const calendar = NSCalendar.currentCalendar;
    NSCalendarUnit const preservedComponents = (NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay);
    NSDateComponents *const components = [calendar components:preservedComponents fromDate:date];
    NSDate *const normalizedDate = [calendar dateFromComponents:components];
    //add the seconds since midnight
    NSDate *newDate = [normalizedDate dateByAddingTimeInterval:timeFloat];
    //format into a readable time
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"H:mm"];
    return [dateFormatter stringFromDate:newDate];
}

@end
