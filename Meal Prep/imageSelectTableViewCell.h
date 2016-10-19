//
//  imageSelectTableViewCell.h
//  Meal Prep
//
//  Created by Naveed Ahmed on 14/06/2016.
//  Copyright © 2016 Naveed Ahmed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Meals.h"
#import "MealImages.h"
#import "MealPrep.h"
#import "mealDetailViewController.h"
#import "mealSelectCollectionViewCell.h"
#import "newMealListViewController.h"
#import "mealDetailTableViewCell.h"
#import "UIImageViewModeScaleAspect.h"

@interface imageSelectTableViewCell : UITableViewCell <UICollectionViewDelegate, UICollectionViewDataSource>



@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) NSManagedObject *mealObject;


//main image
@property (strong, nonatomic) IBOutlet UIImageView *mainImageView;
@property (strong, nonatomic) IBOutlet UIButton *deleteButton;
@property (strong, nonatomic) IBOutlet UIButton *makeDefaultButton;
@property (strong, nonatomic) IBOutlet UIButton *imageOptionButton;




//image select collection view
@property (strong, nonatomic) IBOutlet UICollectionView *imageSelectColView;
@property (strong, nonatomic) NSMutableArray *mealImageArray;
@property (strong, nonatomic) NSMutableArray *mealThumbnailArray;

@property (nonatomic) int selectedItem;
@property (strong,nonatomic) NSIndexPath *deleteIndexPath;


-(void)mealObjectLog;

@end
