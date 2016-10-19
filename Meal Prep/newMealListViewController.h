//
//  newMealListViewController.h
//  Trucks
//
//  Created by Naveed Ahmed on 04/05/2016.
//  Copyright © 2016 Naveed Ahmed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Meals.h"
#import "Categories.h"
#import "mealCell.h"
#import "mealDetailViewController.h"
#import "imageSelectTableViewCell.h"
#import "VBPieChart.h"
#import "DemoMeals.h"
#import "newAddMealViewController.h"
#import "categoryDetailTableViewCell.h"




@interface newMealListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>


@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic , strong) NSMutableArray *trucksArray;
@property (strong, nonatomic) IBOutlet UITableView *mealListTable;


@property (nonatomic) NSDictionary *tmpdict;
@property (nonatomic) NSString *sendstring;
@property (nonatomic) NSManagedObject *sendObj;



@property (strong, nonatomic) IBOutlet UILabel *memLabel;



@end
