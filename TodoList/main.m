//
//  main.m
//  TodoList
//
//  Created by bwang on 12/13/13.
//  Copyright (c) 2013 bwang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BWAppDelegate.h"

int main(int argc, char * argv[])
{
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([BWAppDelegate class]));

        /*NSString *error;
        NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *plistPath = [rootPath stringByAppendingPathComponent:@"TodoItems.plist"];
        NSLog(@"plist path : %@", plistPath);
        const char * pp = [plistPath UTF8String];
        NSLog(@"utf8 : %s", pp);
        
        NSDictionary *plistDict = [NSDictionary
                                   dictionaryWithObjects:[NSArray arrayWithObjects:@"Do 1", nil]
                                                 forKeys:[NSArray arrayWithObjects:@"item", nil]];
        NSData *plistData = [NSPropertyListSerialization
                             dataFromPropertyList:plistDict
                                           format:NSPropertyListXMLFormat_v1_0
                                 errorDescription:&error];
        [plistData writeToFile:plistPath atomically:YES];*/
        
//        NSArray *data = [NSArray arrayWithContentsOfFile:plistPath];
//        NSLog(@"plist data: %@", data);
    }
}
