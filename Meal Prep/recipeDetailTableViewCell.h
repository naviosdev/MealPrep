//
//  recipeDetailTableViewCell.h
//  Meal Prep
//
//  Created by Naveed Ahmed on 23/06/2016.
//  Copyright © 2016 Naveed Ahmed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Meals.h"
#import "MealImages.h"
#import "MealPrep.h"
#import "Recipes.h"
#import "mealDetailViewController.h"
#import "mealSelectCollectionViewCell.h"
#import "newMealListViewController.h"
#import "mealDetailTableViewCell.h"
#import "recipeListTableViewCell.h"


@interface recipeDetailTableViewCell : UITableViewCell <UITableViewDelegate,UITableViewDataSource> {
    UITableView *recipeListTableView;
}

@property (readonly, weak, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, weak, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, weak, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;



@property (weak, nonatomic) NSManagedObject *mealObject;

@property (strong, nonatomic) IBOutlet UITableView *recipeListTableView;
@property (strong,nonatomic) NSMutableArray *recipeListArray;


-(void)finishedAddRecipe;


@end
