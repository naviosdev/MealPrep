//
//  macroDetailTableViewCell.h
//  Meal Prep
//
//  Created by Naveed Ahmed on 27/06/2016.
//  Copyright © 2016 Naveed Ahmed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Meals.h"
#import "VBPieChart.h"

@interface macroDetailTableViewCell : UITableViewCell


@property (readonly, weak, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, weak, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, weak, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


@property (weak, nonatomic) NSManagedObject *mealObject;


@property (weak, nonatomic) IBOutlet UISlider *carbSlider;
@property (weak, nonatomic) IBOutlet UISlider *proSlider;
@property (weak, nonatomic) IBOutlet UISlider *fatSlider;

@property (weak, nonatomic) IBOutlet UILabel *carbLabel;
@property (weak, nonatomic) IBOutlet UILabel *proLabel;
@property (weak, nonatomic) IBOutlet UILabel *fatLabel;

@property (weak, nonatomic) IBOutlet UIView *macroPie;


@property (weak, nonatomic) NSUserDefaults *mealSaveData;


@end
