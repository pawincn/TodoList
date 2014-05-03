//
//  BWListViewController.h
//  TodoList
//
//  Created by bwang on 12/13/13.
//  Copyright (c) 2013 bwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BWItem.h"

@interface BWListViewController : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate>

@property NSMutableArray *items;
@property NSMutableArray *filteredItems;
@property BWItem *itemToSave;

@end
