//
//  BWActivity.m
//  joinme
//
//  Created by bwang on 12/13/13.
//  Copyright (c) 2013 bwang. All rights reserved.
//

#import "BWActivity.h"

@interface BWActivity ()

@property NSDate *completeDate;

@end

@implementation BWActivity

- (void)markAsCompleted: (BOOL)isCompleted
{
    self.completed = isCompleted;
    [self setCompleteDate];
}

- (void)setCompleteDate
{
    if (self.completed)
    {
        self.completeDate = [NSDate date];
    }
    else
    {
        self.completeDate = nil;
    }
}

@end
