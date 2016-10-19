//
//  MealPrep+CoreDataProperties.h
//  MealPrep
//
//  Created by Naveed Ahmed on 03/10/2016.
//  Copyright © 2016 Naveed Ahmed. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "MealPrep.h"

NS_ASSUME_NONNULL_BEGIN

@interface MealPrep (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *cookedQuantity;
@property (nullable, nonatomic, retain) NSDate *datePrepped;
@property (nullable, nonatomic, retain) NSString *datePreppedDate;
@property (nullable, nonatomic, retain) NSDate *dateToBeEaten;
@property (nullable, nonatomic, retain) NSString *dateToBeEatenDate;
@property (nullable, nonatomic, retain) NSString *dateToBeEatenHour;
@property (nullable, nonatomic, retain) NSNumber *daysGoodInFridge;
@property (nullable, nonatomic, retain) NSNumber *daysToBeEaten;
@property (nullable, nonatomic, retain) NSString *eaten;
@property (nullable, nonatomic, retain) NSString *mealName;
@property (nullable, nonatomic, retain) NSNumber *neededQuantity;
@property (nullable, nonatomic, retain) NSNumber *numberInFreezer;
@property (nullable, nonatomic, retain) NSNumber *numberInFridge;
@property (nullable, nonatomic, retain) NSString *storeStatus;
@property (nullable, nonatomic, retain) NSString *thrown;
@property (nullable, nonatomic, retain) Meals *meal;

@end

NS_ASSUME_NONNULL_END
