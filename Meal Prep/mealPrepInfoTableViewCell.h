//
//  mealPrepInfoTableViewCell.h
//  Meal Prep
//
//  Created by Naveed Ahmed on 05/09/2016.
//  Copyright © 2016 Naveed Ahmed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Meals.h"
#import "MealPrep.h"
#import "recipeTableViewCell.h"


@interface mealPrepInfoTableViewCell : UITableViewCell <UITableViewDelegate, UITableViewDataSource>


@property (readonly, weak, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, weak, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, weak, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (weak, nonatomic) NSManagedObject *mealObject;

//begin

@property (strong, nonatomic) IBOutlet UILabel *mealNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *mealImageView;

@property (strong, nonatomic) IBOutlet UITableView *recipeTableView;
@property (strong, nonatomic) NSMutableArray *recipeArray;













@end
