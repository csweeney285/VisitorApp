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
    //no idea why I need to add 1800 but it makes the times match the screenshot
    NSNumber *time = [NSNumber numberWithFloat:(timeFloat + 18000)];
    NSTimeInterval interval = [time doubleValue];
    NSDate *online = [NSDate date];
    online = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    return [dateFormatter stringFromDate:online];
}

@end
