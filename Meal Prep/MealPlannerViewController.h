//
//  MealPlannerViewController.h
//  Meal Prep
//
//  Created by Naveed Ahmed on 23/07/2016.
//  Copyright © 2016 Naveed Ahmed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSCalendar.h"
#import "MealPlannerTableViewCell.h"
#import "AppDelegate.h"
#import "MealPrep.h"

@interface MealPlannerViewController : UIViewController <FSCalendarDataSource, FSCalendarDelegate, UITableViewDelegate,UITableViewDataSource> {
    
    UITableView *tableView1;
}


@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


@property (strong , nonatomic) FSCalendar *calendar;
@property (nonatomic) float floatHeight;
@property (nonatomic) float floatWidth;


@property (strong, nonatomic) IBOutlet UITableView *tableView1;
@property (strong ,nonatomic) NSMutableArray *prepsArray;
@property (strong, nonatomic) NSMutableArray *dayArray;


@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;


@property (strong,nonatomic) NSIndexPath *addButtonIndexPath;
@property (strong,nonatomic) NSIndexPath *addMealCellIndexPath;

@property (strong,nonatomic) NSIndexPath *previousCellIndexPath;


//meal info
@property (strong,nonatomic) NSDate *mealDate;


@end
