//
//  Steps+CoreDataProperties.h
//  MealPrep
//
//  Created by Naveed Ahmed on 03/10/2016.
//  Copyright © 2016 Naveed Ahmed. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Steps.h"

NS_ASSUME_NONNULL_BEGIN

@interface Steps (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *dateAdded;
@property (nullable, nonatomic, retain) NSNumber *position;
@property (nullable, nonatomic, retain) NSString *step;
@property (nullable, nonatomic, retain) id stepImage;
@property (nullable, nonatomic, retain) Meals *stepsForMeal;

@end

NS_ASSUME_NONNULL_END
