//
//  AirlineModel.h
//  FlyWhizz
//
//  Created by Amy Baldwin on 11/2/14.
//  Copyright (c) 2014 ASU CSE 494. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AirlineModel : NSObject

@property NSString *name;
@property NSString *acronym;
@property NSString *phoneNumber;

-(id) initWithJSONDictionary:(NSDictionary *)dict;

@end
