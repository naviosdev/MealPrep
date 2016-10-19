//
//  HomeViewController.h
//  Meal Prep
//
//  Created by Naveed Ahmed on 23/07/2016.
//  Copyright © 2016 Naveed Ahmed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Meals.h"
#import "MealPrep.h"
#import "HomeTableViewCell.h"
#import "homeViewSurplusPrepsTableViewCell.h"
#import "noSurplusMealsTableViewCell.h"
#import "newPrepViewController.h"
#import "M13ProgressViewBar.h"
#import "M13ProgressView.h"
#import "M13ProgressViewSegmentedRing.h"
#import "M13ProgressViewPie.h"


@interface HomeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    
    UITableView *mainTable;
}


@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


//homeview
@property (retain, nonatomic) IBOutlet UIScrollView *homeScrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *homeViewPageControl;
@property (strong, nonatomic) IBOutlet UIView *homeView;
@property (nonatomic) int numberOfMealsPlanned;
@property (nonatomic) int numberOfPreppedMeals;

//seg progress view
@property (retain, nonatomic) M13ProgressViewSegmentedRing *progressViewseg;
@property (nonatomic) CGFloat progressPercentage;
@property (strong, nonatomic) IBOutlet UIImageView *noPrepsImageView;


//labels
@property (strong, nonatomic) IBOutlet UILabel *numberToPrepLabel;
@property (strong, nonatomic) IBOutlet UILabel *numberOfSurplusMealsLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalMealsLabel;
@property (strong, nonatomic) IBOutlet UILabel *tapToPrepLabel;

//home view surplus table
@property (strong, nonatomic) IBOutlet UITableView *homeViewSurplusTable;
@property (strong, nonatomic) NSMutableArray *surplusPrepArray;


//main view table
@property (strong, nonatomic) IBOutlet UITableView *mainTable;
@property (nonatomic) NSMutableArray *prepArray;
@property (nonatomic) NSMutableArray *sectionHeaders;
@property (nonatomic) NSMutableDictionary *dict1;


@property (nonatomic) NSManagedObject *sendObj;


-(NSMutableArray *)getTableAndSectionData;

@end
