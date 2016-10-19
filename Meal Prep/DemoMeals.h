//
//  DemoMeals.h
//  Meal Prep
//
//  Created by Naveed Ahmed on 30/06/2016.
//  Copyright © 2016 Naveed Ahmed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "Meals.h"
#import "MealPrep.h"
#import "Categories.h"
#import "MealImages.h"
#import "Recipes.h"
#import "Steps.h"

@interface DemoMeals : NSObject

//core data properties
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


//creates data for when the app is first opened by user for sample purposes
-(void)createDefaultCatergories;
-(void)createDummyData;
-(void)setSamplePreps;
-(void)setSampleUnprepped;



@end
