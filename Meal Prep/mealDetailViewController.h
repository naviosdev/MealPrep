//
//  mealDetailViewController.h
//  Meal Prep
//
//  Created by Naveed Ahmed on 09/06/2016.
//  Copyright © 2016 Naveed Ahmed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "mealDetailTableViewCell.h"
#import "Meals.h"
#import "MealPrep.h"
#import "newMealListViewController.h"
#import "imageSelectTableViewCell.h"
#import "categoryDetailTableViewCell.h"
#import "storageDetailTableViewCell.h"

@interface mealDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UIImagePickerController *ipc;
    UIPopoverController *popever;
}

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;

@property (strong, nonatomic) IBOutlet UITableView *detailTableView;

@property (nonatomic) NSManagedObject *sentObj;
@property (nonatomic) NSString *sentString;


@property (strong,nonatomic) UIImage *mainImage;


@property (strong, nonatomic) NSUserDefaults *mealDetailsSave;



-(void)reloadImageMainCell:(UIImage *)image;
-(void)reloadAlbumRow;
-(void)reloadRecipeRow;



//storyboard settings
@property (strong, nonatomic) NSArray *cellHeightArray;


@end
