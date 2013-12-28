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
    self.filteredItems = [[NSMutableArray alloc] init];
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
    if ( tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.filteredItems count];
    } else {
        return [self.items count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MyCellIdentifier";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyCellIdentifier"];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    // Configure the cell...
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        cell.textLabel.text = [[self.filteredItems objectAtIndex:indexPath.row] itemName];
    } else {
        cell.textLabel.text = [[self.items objectAtIndex:indexPath.row ] itemName];
    }
    
    return cell;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:
      [self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    return YES;
}

- (void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope
{
    [self.filteredItems removeAllObjects];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.itemName contains[c] %@", searchText];
    self.filteredItems = [NSMutableArray arrayWithArray:[self.items filteredArrayUsingPredicate:predicate]];
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
        BWItem *itemToRemove = self.items[indexPath.row];
        [[[BWDBManager alloc] init] remove:itemToRemove.index];
        [self.items removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}

@end
