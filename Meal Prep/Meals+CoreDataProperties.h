//
//  Meals+CoreDataProperties.h
//  MealPrep
//
//  Created by Naveed Ahmed on 03/10/2016.
//  Copyright © 2016 Naveed Ahmed. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Meals.h"

NS_ASSUME_NONNULL_BEGIN

@interface Meals (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *archived;
@property (nullable, nonatomic, retain) id category;
@property (nullable, nonatomic, retain) id imageArray;
@property (nullable, nonatomic, retain) NSString *macro;
@property (nullable, nonatomic, retain) id macroStats;
@property (nullable, nonatomic, retain) NSString *mealDescription;
@property (nullable, nonatomic, retain) NSString *mealName;
@property (nullable, nonatomic, retain) NSString *recipeAmount;
@property (nullable, nonatomic, retain) NSString *timePrep;
@property (nullable, nonatomic, retain) NSData *truckPhoto;
@property (nullable, nonatomic, retain) NSNumber *fridgeStorageDays;
@property (nullable, nonatomic, retain) NSNumber *freezerStorageDays;
@property (nullable, nonatomic, retain) NSSet<Categories *> *mealCategory;
@property (nullable, nonatomic, retain) NSSet<MealImages *> *mealImage;
@property (nullable, nonatomic, retain) NSSet<MealPrep *> *mealPrepped;
@property (nullable, nonatomic, retain) NSSet<Recipes *> *mealRecipes;
@property (nullable, nonatomic, retain) NSSet<Steps *> *mealSteps;

@end

@interface Meals (CoreDataGeneratedAccessors)

- (void)addMealCategoryObject:(Categories *)value;
- (void)removeMealCategoryObject:(Categories *)value;
- (void)addMealCategory:(NSSet<Categories *> *)values;
- (void)removeMealCategory:(NSSet<Categories *> *)values;

- (void)addMealImageObject:(MealImages *)value;
- (void)removeMealImageObject:(MealImages *)value;
- (void)addMealImage:(NSSet<MealImages *> *)values;
- (void)removeMealImage:(NSSet<MealImages *> *)values;

- (void)addMealPreppedObject:(MealPrep *)value;
- (void)removeMealPreppedObject:(MealPrep *)value;
- (void)addMealPrepped:(NSSet<MealPrep *> *)values;
- (void)removeMealPrepped:(NSSet<MealPrep *> *)values;

- (void)addMealRecipesObject:(Recipes *)value;
- (void)removeMealRecipesObject:(Recipes *)value;
- (void)addMealRecipes:(NSSet<Recipes *> *)values;
- (void)removeMealRecipes:(NSSet<Recipes *> *)values;

- (void)addMealStepsObject:(Steps *)value;
- (void)removeMealStepsObject:(Steps *)value;
- (void)addMealSteps:(NSSet<Steps *> *)values;
- (void)removeMealSteps:(NSSet<Steps *> *)values;

@end

NS_ASSUME_NONNULL_END
