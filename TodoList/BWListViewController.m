//
//  BWListViewController.m
//  TodoList
//
//  Created by bwang on 12/13/13.
//  Copyright (c) 2013 bwang. All rights reserved.
//

#import "BWListViewController.h"
#import "BWAddViewController.h"
#import "BWDBManager.h"

@interface BWListViewController ()

@property BWItem *tappedItem;

@end

@implementation BWListViewController

- (IBAction)backToList:(UIStoryboardSegue *)segue
{
//    BWAddViewController *source = [segue sourceViewController];
//    BWItem *item = source.item;
    BWItem *item = self.itemToSave;
    if (item == nil) return;
    if (!item.isToUpdate)
    {
        [self.items addObject:item];
    }
    [self.tableView reloadData];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    if (self.items == nil) self.items = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MyCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    BWItem *item = [self.items objectAtIndex:indexPath.row];
    cell.textLabel.text = item.itemName;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self updateItem:indexPath];
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

// update item
- (void)updateItem:(NSIndexPath *)indexPath
{
    // needn't to init this instance firstly?
    self.tappedItem = [self.items objectAtIndex:indexPath.row];
    self.tappedItem.isToUpdate = YES;
    [self.tappedItem markAsCompleted:!self.tappedItem.completed];
    [self performSegueWithIdentifier:@"itemSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    BWAddViewController *destination = (BWAddViewController*)segue.destinationViewController;
    destination.item = self.tappedItem;
    self.tappedItem = nil; // this clearing is necessary, otherwise the Add button won't work.
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        BWItem *itemToRemove = self.items[indexPath.row];
        [[[BWDBManager alloc] init] remove:itemToRemove.index];
        [self.items removeObjectAtIndex:indexPath.row];
    }
}

@end
