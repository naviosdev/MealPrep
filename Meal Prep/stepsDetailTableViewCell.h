//
//  stepsDetailTableViewCell.h
//  Meal Prep
//
//  Created by Naveed Ahmed on 26/06/2016.
//  Copyright © 2016 Naveed Ahmed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Meals.h"
#import "MealImages.h"
#import "MealPrep.h"
#import "Recipes.h"
#import "Steps.h"
#import "StepsListTableViewCell.h"


@interface stepsDetailTableViewCell : UITableViewCell <UITableViewDelegate, UITableViewDataSource>{
    UITableView *stepsTableView;
}


@property (readonly, weak, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, weak, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, weak, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


@property (weak, nonatomic) NSManagedObject *mealObject;
@property (strong, nonatomic) IBOutlet UITableView *stepsTableView;
@property (strong, nonatomic) NSMutableArray *stepsArray;
@property (nonatomic) int addCellTapped;


@end
