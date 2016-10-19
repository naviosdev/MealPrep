//
//  mealDetailTableViewCell.h
//  Meal Prep
//
//  Created by Naveed Ahmed on 11/06/2016.
//  Copyright © 2016 Naveed Ahmed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Meals.h"
#import "MealImages.h"
#import "MealPrep.h"
#import "Recipes.h"
#import "mealDetailViewController.h"
#import "newMealListCollectionViewCell.h"
#import "imageSelectTableViewCell.h"


@interface mealDetailTableViewCell : UITableViewCell <UITextFieldDelegate>

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;



@property (strong, nonatomic) NSManagedObject *mealObject;


//cell 1 - meal name
@property (strong, nonatomic) IBOutlet UITextField *mealNameTextField;


//cell 2 - image view
@property (strong, nonatomic) UIImage *mainImage;


//cell 5 - prep time
@property (strong, nonatomic) IBOutlet UITextField *prepTimeTextField;





-(void)mealObjectLog;

@end
