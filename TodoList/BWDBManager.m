//
//  BWDBManager.m
//  Contact
//
//  Created by bwang on 12/24/13.
//  Copyright (c) 2013 bwang. All rights reserved.
//

#import "BWDBManager.h"
#import "BWItem.h"

static BWDBManager *sharedInstance = nil;
static sqlite3 *connection = nil;
static sqlite3_stmt *statement = nil;

@implementation BWDBManager

+ (BWDBManager *)getSharedInstance
{
    if (!sharedInstance)
    {
        sharedInstance = (BWDBManager *) [[super allocWithZone:NULL] init];
        [sharedInstance createDB];
    }
    return sharedInstance;
}

- (BOOL)createDB
{
    NSString *docDir;
    NSArray *dirPaths;
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docDir = dirPaths[0];
    dbPath = [[NSString alloc] initWithString:[docDir stringByAppendingString:@"todos.db"]];
    BOOL isSuccess = YES;
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    if (![fileMgr fileExistsAtPath:dbPath])
    {
        const char *dp = [dbPath UTF8String];
        if (sqlite3_open(dp, &connection) == SQLITE_OK)
        {
            char *errorMsg;
            const char *sql_stmt = "create table if not exists todos(regno integer primary key, name text)";
            if (sqlite3_exec(connection, sql_stmt, NULL, NULL, &errorMsg) != SQLITE_OK)
            {
                isSuccess = NO;
                NSLog(@"Failed to create table");
            }
            sqlite3_close(connection);
            return isSuccess;
        }
        else
        {
            isSuccess = NO;
            NSLog(@"Failed to open/create table");
        }
    }
    
    return isSuccess;
}

- (int)create:(NSString *)name
{
    const char *dp = [dbPath UTF8String];
    if (sqlite3_open(dp, &connection) == SQLITE_OK)
    {
        NSString *insertSql = [NSString stringWithFormat:@"insert into todos(name) values(\"%@\")",name];
        const char *insert_stmt = [insertSql UTF8String];
        sqlite3_prepare_v2(connection, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE) {
            int id = (int)sqlite3_last_insert_rowid(connection);
            return id;
        }
    }
    
    return 0;
}

- (BOOL)update:(NSString *)name byId:(int)id
{
    const char *dp = [dbPath UTF8String];
    if (sqlite3_open(dp, &connection) == SQLITE_OK)
    {
        NSString *sql = [NSString stringWithFormat:@"update todos set name = \"%@\" where regno = %d",name, id];
        const char *sql_stmt = [sql UTF8String];
        sqlite3_prepare_v2(connection, sql_stmt, -1, &statement, NULL);
        return sqlite3_step(statement) == SQLITE_DONE;
    }

    return NO;
}

- (BOOL)remove:(int)id
{
    const char *dp = [dbPath UTF8String];
    if (sqlite3_open(dp, &connection) == SQLITE_OK)
    {
        NSString *sql = [NSString stringWithFormat:@"delete from todos where regno = %d", id];
        const char *sql_stmt = [sql UTF8String];
        sqlite3_prepare_v2(connection, sql_stmt, -1, &statement, NULL);
        return sqlite3_step(statement) == SQLITE_DONE;
    }

    return NO;
}

- (NSMutableArray *)findAll
{
    const char *dp = [dbPath UTF8String];
    if (sqlite3_open(dp, &connection) == SQLITE_OK)
    {
        NSString *querySql = [NSString stringWithFormat:@"select regno, name from todos"];
        const char *query_stmt = [querySql UTF8String];
        NSMutableArray *resultArray = [[NSMutableArray alloc] init];
        if (sqlite3_prepare_v2(connection, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                int regno = sqlite3_column_int(statement, 0);
                NSString *name = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                BWItem *item = [[BWItem alloc] init];
                [item setItemName:name];
                [item setIndex:regno];
                [resultArray addObject:item];
                NSLog(@"regno : %d, itemName : %@", regno, name);
            }
        }
        return resultArray;
    }

    return nil;
}

@end
