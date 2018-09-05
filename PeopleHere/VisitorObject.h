//
//  VisitorObject.h
//  ios-interview
//
//  Created by Conor Sweeney on 4/18/18.
//  Copyright © 2018 Foursquare. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VisitorObject : NSObject

@property (nonatomic) BOOL visitor;

-(id)initWithDictionary:(NSDictionary *)dict;

@property (nonatomic) float arriveTime;
@property (nonatomic) float leaveTime;
@property (nonatomic, strong) NSString *uniqueId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *timeStr;

- (void) formatTimeStr;

@end
