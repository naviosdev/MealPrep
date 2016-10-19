//
//  newPrepViewController.h
//  Meal Prep
//
//  Created by Naveed Ahmed on 05/09/2016.
//  Copyright © 2016 Naveed Ahmed. All rights reserved.
//

#import <UIKit/UIKit.h>
//core data
#import "AppDelegate.h"
#import "Meals.h"
#import "MealPrep.h"
//import cells
#import "mealPrepInfoTableViewCell.h"
#import "mealPrepBasicTableViewCell.h"
#import "cookNowTableViewCell.h"
#import "prepDateTableViewCell.h"
#import "cookedDateTableViewCell.h"
#import "changeDateTableViewCell.h"
#import "stepsTableViewCell.h"
#import "surplusPrepTableViewCell.h"
#import "surplusPlanDateTableViewCell.h"

@interface newPrepViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource>


@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


@property (nonatomic) NSManagedObject *sentObj;
@property (strong, nonatomic) MealPrep *mealPrep;


@property (strong, nonatomic) IBOutlet UITableView *prepTableView;
//size values
@property (nonatomic) double prepTableY;
@property (nonatomic) double prepTableWidth;
@property (nonatomic) double prepTableHeight;


@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;

//date cell
@property (strong, nonatomic) NSMutableArray *prepDatesArray;
@property (strong, nonatomic) NSMutableArray *prepDatesArrayPreFormat;
@property (strong, nonatomic) NSIndexPath *selectedDate;
@property (strong,nonatomic) MealPrep *mealPrepToBeUpdated;


//surplus prep cell
@property (strong, nonatomic) NSMutableArray *surplusMealPreps;
@property (strong, nonatomic) NSMutableArray *surplusMealPrepsPreFormat;
@property (strong,nonatomic) MealPrep *SurplusPrepToBePlanned;



//cook now cell
@property (nonatomic) int allPrepped;

//steps
@property (nonatomic) int showSteps;
@property (strong, nonatomic) NSMutableArray *stepsArray;
@property (nonatomic) long stepsCount; //count needed to numberofrowsinsection
//completeCookingView


@property (strong, nonatomic) IBOutlet UIView *completeCookingView;
@property (strong, nonatomic) IBOutlet UIButton *completePreppingButton;
@property (strong,nonatomic) NSArray *pickerViewArray;
@property (strong,nonatomic) UIPickerView *pickerView;
@property (nonatomic) int pickerValue;
@property (nonatomic) long cookedQuantity;
//ui
@property (strong, nonatomic) UILabel *headerLabel;



//layout variables
//header label
@property (nonatomic) double headerLabelx;
@property (nonatomic) double headerLabely;
@property (nonatomic) double headerLabelWidth;
@property (nonatomic) double headerLabelHeight;
//picker view
@property (nonatomic) double pickerViewx;
@property (nonatomic) double pickerViewy;
@property (nonatomic) double pickerViewWidth;
@property (nonatomic) double pickerViewHeight;
//confirm button
@property (nonatomic) double confirmButtonx;
@property (nonatomic) double confirmButtony;
@property (nonatomic) double confirmButtonWidth;
@property (nonatomic) double confirmButtonHeight;





@end
