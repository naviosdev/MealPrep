//
//  StepsListTableViewCell.h
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
#import "stepsDetailTableViewCell.h"

@interface StepsListTableViewCell : UITableViewCell <UITextViewDelegate>


@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


@property (strong, nonatomic) NSManagedObject *mealObject;

@property (strong, nonatomic) IBOutlet UILabel *stepLabel;
@property (strong, nonatomic) IBOutlet UILabel *stepPositionLabel;



//exAddCell
@property (strong, nonatomic) IBOutlet UITextView *stepTextEntryField;
@property (strong, nonatomic) IBOutlet UILabel *textViewCountLabel;
@property (strong, nonatomic) NSString *string;





@end
