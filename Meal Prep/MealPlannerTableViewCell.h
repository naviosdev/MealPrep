//
//  MealPlannerTableViewCell.h
//  Meal Prep
//
//  Created by Naveed Ahmed on 24/07/2016.
//  Copyright © 2016 Naveed Ahmed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Meals.h"
#import "MealImages.h"
#import "mealCollectionViewCell.h"

@interface MealPlannerTableViewCell : UITableViewCell <UICollectionViewDelegate, UICollectionViewDataSource>


@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


@property (strong, nonatomic) NSMutableArray *mealsArray;


@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic) IBOutlet UIButton *addMealButton;




//selectcell
@property (strong, nonatomic) IBOutlet UILabel *selectInfoLabel;
@property (strong, nonatomic) IBOutlet UILabel *selectedMealNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *selectedPrepTimeLabel;
@property (strong, nonatomic) IBOutlet UIImageView *selectedMealImageView;
@property (strong, nonatomic) IBOutlet UIButton *deletePrepButton;



//preppedcell
@property (strong, nonatomic) IBOutlet UILabel *mealNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *prepTimeLabel;
@property (strong, nonatomic) IBOutlet UIImageView *mealImageView;


@property (strong, nonatomic) IBOutlet UICollectionView *mealSelectColView;



@end
