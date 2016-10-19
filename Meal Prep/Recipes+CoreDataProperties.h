//
//  Recipes+CoreDataProperties.h
//  MealPrep
//
//  Created by Naveed Ahmed on 03/10/2016.
//  Copyright © 2016 Naveed Ahmed. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Recipes.h"

NS_ASSUME_NONNULL_BEGIN

@interface Recipes (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *availablity;
@property (nullable, nonatomic, retain) NSString *recipeName;
@property (nullable, nonatomic, retain) NSSet<Meals *> *forMeal;

@end

@interface Recipes (CoreDataGeneratedAccessors)

- (void)addForMealObject:(Meals *)value;
- (void)removeForMealObject:(Meals *)value;
- (void)addForMeal:(NSSet<Meals *> *)values;
- (void)removeForMeal:(NSSet<Meals *> *)values;

@end

NS_ASSUME_NONNULL_END
