//
//  MealImages+CoreDataProperties.h
//  MealPrep
//
//  Created by Naveed Ahmed on 03/10/2016.
//  Copyright © 2016 Naveed Ahmed. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "MealImages.h"

NS_ASSUME_NONNULL_BEGIN

@interface MealImages (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *dateAdded;
@property (nullable, nonatomic, retain) NSNumber *defaultImage;
@property (nullable, nonatomic, retain) NSString *mealCaption;
@property (nullable, nonatomic, retain) id mealImage;
@property (nullable, nonatomic, retain) id mealThumbnailImage;
@property (nullable, nonatomic, retain) Meals *meal;

@end

NS_ASSUME_NONNULL_END
