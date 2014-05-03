//
// Created by bwang on 12/24/13.
// Copyright (c) 2013 bwang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface BWDBManager : NSObject
{
    NSString *dbPath;
}

+ (BWDBManager *)getSharedInstance;
- (BOOL)createDB;
- (int)create:(NSString *)name;
- (BOOL)update:(NSString *)name byId:(int)id;
- (NSMutableArray *)findAll;
- (BOOL)remove:(int)id;

@end
