//
//  MenuViewController.m
//  RevealControllerStoryboardExample
//
//  Created by Nick Hodapp on 1/9/13.
//  Copyright (c) 2013 CoDeveloper. All rights reserved.
//
#import "SWRevealViewController.h"
#import "MenuViewController.h"
#import "coldcall-Swift.h"

@implementation SWUITableViewCell3
@end

@implementation MenuViewController3

- (void) prepareForSegueB: (UIStoryboardSegue *) segue sender: (id) sender
{
    // configure the destination view controller:
    if ( [segue.destinationViewController isKindOfClass: [ColorViewController class]] &&
        [sender isKindOfClass:[UITableViewCell class]] )
    {
        UILabel* c = [(SWUITableViewCell3 *)sender label];
        ColorViewController* cvc = segue.destinationViewController;
        
        cvc.color = c.textColor;
        cvc.text = c.text;
    }

    // configure the segue.
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] )
    {
        SWRevealViewControllerSegue* rvcs = (SWRevealViewControllerSegue*) segue;
        
        SWRevealViewController* rvc = self.revealViewController;
        NSAssert( rvc != nil, @"oops! must have a revealViewController" );
        
        NSAssert( [rvc.frontViewController isKindOfClass: [UINavigationController class]], @"oops!  for this segue we want a permanent navigation controller in the front!" );

        rvcs.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc)
        {
            UINavigationController* nc = [[UINavigationController alloc] initWithRootViewController:dvc];
            [rvc pushFrontViewController:nc animated:YES];
        };
    }
}


- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    // configure the destination view controller:
    if ( [sender isKindOfClass:[UITableViewCell class]] )
    {
        UILabel* c = [(SWUITableViewCell3 *)sender label];
        UINavigationController *navController = segue.destinationViewController;
        ColorViewController* cvc = [navController childViewControllers].firstObject;
        if ( [cvc isKindOfClass:[ColorViewController class]] )
        {
            cvc.color = c.textColor;
            cvc.text = c.text;
        }
        if ( [cvc isKindOfClass:[NewCCTableViewController class]] )
        {
           // insert seque information for NewViewController Class
        }
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";

    switch ( indexPath.row )
    {
        case 0:
            CellIdentifier = @"coldcalls";
            break;
            
        case 1:
            CellIdentifier = @"contacts";
            break;

        case 2:
            CellIdentifier = @"competition";
            break;
        case 3:
            CellIdentifier = @"settings";
    }

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier forIndexPath: indexPath];
 
    return cell;
}

@end
