//
//  BWAddViewController.m
//  TodoList
//
//  Created by bwang on 12/13/13.
//  Copyright (c) 2013 bwang. All rights reserved.
//

#import "BWAddViewController.h"
#import "BWListViewController.h"
#import "BWDBManager.h"

@interface BWAddViewController ()

@property (weak, nonatomic) IBOutlet UITextField *text;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;

@end

@implementation BWAddViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if (self.item != nil)
    {
        self.text.text = self.item.itemName;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (sender != self.doneButton || self.text.text == nil || self.text.text.length <= 0)
    {
        return;
    }
    if (self.item == nil)
    {
        BWItem *item = [[BWItem alloc] init];
        item.itemName = self.text.text;
        int id = [[BWDBManager getSharedInstance] create:item.itemName];
        item.index = id;
        [segue.destinationViewController setItemToSave:item];
    }
    else
    {
        self.item.itemName = self.text.text;
        BWListViewController *destination =  segue.destinationViewController;
        destination.itemToSave = self.item;
        [[BWDBManager getSharedInstance] update:self.item.itemName byId:self.item.index];
    }   
}

@end
