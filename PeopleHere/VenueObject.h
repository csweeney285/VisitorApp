//
//  VenueObject.h
//  ios-interview
//
//  Created by Conor Sweeney on 4/18/18.
//  Copyright © 2018 Foursquare. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VisitorObject.h"

@interface VenueObject : NSObject

-(id)initWithDictionary:(NSDictionary *)dict;

@property (nonatomic) float openTime;
@property (nonatomic) float closeTime;
@property (nonatomic, strong) NSString *uniqueId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSMutableArray *visitors;

@end
