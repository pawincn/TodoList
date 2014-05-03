//
//  BWItem.h
//  joinme
//
//  Created by bwang on 12/13/13.
//  Copyright (c) 2013 bwang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BWItem : NSObject

@property NSString *itemName;
@property BOOL completed;
@property BOOL isToUpdate;
@property int index;

- (void)markAsCompleted: (BOOL)isCompleted;

@end
