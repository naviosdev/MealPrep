//
//  Categories+CoreDataProperties.h
//  MealPrep
//
//  Created by Naveed Ahmed on 03/10/2016.
//  Copyright © 2016 Naveed Ahmed. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Categories.h"

NS_ASSUME_NONNULL_BEGIN

@interface Categories (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *catName;
@property (nullable, nonatomic, retain) NSSet<Meals *> *meal;

@end

@interface Categories (CoreDataGeneratedAccessors)

- (void)addMealObject:(Meals *)value;
- (void)removeMealObject:(Meals *)value;
- (void)addMeal:(NSSet<Meals *> *)values;
- (void)removeMeal:(NSSet<Meals *> *)values;

@end

NS_ASSUME_NONNULL_END
