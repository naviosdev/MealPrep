//
//  recipeListTableViewCell.h
//  Meal Prep
//
//  Created by Naveed Ahmed on 23/06/2016.
//  Copyright © 2016 Naveed Ahmed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Meals.h"
#import "Recipes.h"
#import "mealDetailViewController.h"
#import "mealSelectCollectionViewCell.h"
#import "newMealListViewController.h"
#import "mealDetailTableViewCell.h"
#import "recipeListTableViewCell.h"
#import "recipeDetailTableViewCell.h"

@protocol CustomTableCellDelegate <NSObject>
@required
- (void)reloadMyTable;
@end

@interface recipeListTableViewCell : UITableViewCell <UITextFieldDelegate> {
    //id<CustomTableCellDelegate> delegate;
}

@property (assign) id<CustomTableCellDelegate> delegate;

@property (readonly, weak, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, weak, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, weak, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (weak, nonatomic) NSManagedObject *mealObject;

@property (weak, nonatomic) IBOutlet UILabel *recipeNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *recipeAddTextField;

@property (weak, nonatomic) NSUserDefaults *recipeDefaults;

@end
