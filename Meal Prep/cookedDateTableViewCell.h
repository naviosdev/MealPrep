//
//  cookedDateTableViewCell.h
//  MealPrep
//
//  Created by Naveed Ahmed on 13/09/2016.
//  Copyright © 2016 Naveed Ahmed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Meals.h"
#import "MealPrep.h"

@interface cookedDateTableViewCell : UITableViewCell

@property (readonly, weak, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, weak, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, weak, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (weak, nonatomic) NSManagedObject *mealObject;


@property (strong, nonatomic) IBOutlet UILabel *prepDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *prepTimeLabel;

@property (strong, nonatomic) IBOutlet UILabel *cookedDateLabel;





@end
