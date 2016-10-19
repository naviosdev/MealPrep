//
//  DemoMeals.m
//  Meal Prep
//
//  Created by Naveed Ahmed on 30/06/2016.
//  Copyright © 2016 Naveed Ahmed. All rights reserved.
//

#import "DemoMeals.h"

@implementation DemoMeals

@synthesize managedObjectModel,managedObjectContext,persistentStoreCoordinator;

-(void)createDefaultCatergories {
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    managedObjectContext = [appDelegate managedObjectContext];
    
    //this code is to set the default meal catergories the first time the app is run
    NSUserDefaults *firstAppRunDefault = [NSUserDefaults standardUserDefaults];
    
    if ([firstAppRunDefault objectForKey:@"catsSet"]) {
    } else {
        NSArray *array = [NSArray arrayWithObjects:@"Breakfast", @"Lunch", @"Dinner", @"Snack", @"Supplement", nil];
        int n;
        for (n=0; n<array.count; n++) {
            Categories *cat = [NSEntityDescription insertNewObjectForEntityForName:@"Categories" inManagedObjectContext:managedObjectContext];
            [cat setCatName:[array objectAtIndex:n]];
            
            NSError *error = nil;
            if (![managedObjectContext save:&error]) {
            }
        }
        [firstAppRunDefault setObject:@"done" forKey:@"catsSet"];
    }

    
}




//creates data for when the app is first opened by user for sample purposes
-(void)createDummyData {
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    managedObjectContext = [appDelegate managedObjectContext];
    
    NSUserDefaults * dummyMeals = [NSUserDefaults standardUserDefaults];
    
    if ([dummyMeals objectForKey:@"meals"]) {
        //meal already exists
    } else {
        
        //create new meal
        Meals *meal = [NSEntityDescription insertNewObjectForEntityForName:@"Meals" inManagedObjectContext:managedObjectContext];
        [meal setMealName:@"Chicken and Sweet Potato Traybake"];
        [meal setTimePrep:@"50mn"];
        [meal setArchived:@"no"];
        [meal setFridgeStorageDays:[NSNumber numberWithInt:5]];
        [meal setFreezerStorageDays:[NSNumber numberWithInt:12]];
        

        //setting up meal image
        MealImages *image = [NSEntityDescription insertNewObjectForEntityForName:@"MealImages" inManagedObjectContext:managedObjectContext];
        UIImage *image1 = [UIImage imageNamed:@"chickensweetpotato.png"];
        
        
        //needs finishing
        UIImage *tempImage = nil;
        CGSize targetSize = CGSizeMake(375, 267);
        UIGraphicsBeginImageContext(targetSize);
        
        CGRect thumnbnailRect = CGRectMake(0, 0, 0, 0);
        thumnbnailRect.origin= CGPointMake(0.0, 0.0);
        thumnbnailRect.size.height = targetSize.height;
        thumnbnailRect.size.width = targetSize.width;
        [image1 drawInRect:thumnbnailRect];
        
        tempImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        
        //thumbnail
        UIImage *thumbImage = [self squareImageWithImage:[UIImage imageNamed:@"chickensweetpotato.png"] scaledToSize:CGSizeMake(100, 92)];
        
        
        
        [image setDateAdded:[NSDate date]];
        [image setMealImage:tempImage];
        [image setMealThumbnailImage:thumbImage];
        [image setDefaultImage:[NSNumber numberWithBool:YES]];
        [meal addMealImageObject:image];
        
        
        
        //macros
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@60,@"carb", @30,@"pro", @10,@"fat", nil];
        NSData *macroData = [NSKeyedArchiver archivedDataWithRootObject:dict];
        [meal setMacroStats:macroData];
        
        
        
        //steps
        NSArray *stepsArray = [[NSArray alloc]initWithObjects:@"Cut each chicken thigh fillet in two and sear over high heat in a non-stick frying pan in a little of the oil until lightly golden;",
                               
            @"Peel the sweet potatoes and cut into 1.5cm thick slices; peel and quarter the onions and add the vegetables to a roasting pan ",
                               
            @"Roast at 200°C for 15 minutes.",
                               
            @"Remove the roasting pan from the oven, use a spatula to turn over the vegetable pieces, and tuck the chicken thighs in amongst them. ",
                               
            @"Squeeze over the juice from one lemon and add a little more seasoning and the smoked paprika. Roast at 180°C for 15 minutes",
                               
            @"Add the chicken stock to the pan and continue cooking for another 20 minutes",
                               
            @"When everything is tender, the chicken is cooked through with no pink showing and there is a little gravy in the bottom of the pan, serve, with a little more lemon juice squeezed over.", nil];
        
        int i;
        for (i=0; i<stepsArray.count; i++) {
            
            Steps *step = [NSEntityDescription insertNewObjectForEntityForName:@"Steps" inManagedObjectContext:managedObjectContext];
            NSNumber *p = [NSNumber numberWithInt:i+1];
            
            
            [step setStep:[stepsArray objectAtIndex:i]];
            [step setDateAdded:[NSDate date]];
            [step setPosition:p];
            [meal addMealStepsObject:step];
            
            NSError *error = nil;
            if (![managedObjectContext save:&error]) {
                //handle error
            }
        }
        
 
        
        //recipes
        NSArray *recipeArray = [[NSArray alloc]initWithObjects:@"6 skinless chicken thigh fillets", @"500g (16oz) sweet potatoes", @"2 medium red onions", @"8 cloves garlic, skin on", @"2 lemons", @"150ml chicken stock", nil];
        
        int r;
        for (r=0; r<recipeArray.count; r++) {
            
            Recipes *recipe = [NSEntityDescription insertNewObjectForEntityForName:@"Recipes" inManagedObjectContext:managedObjectContext];
            
            [recipe setRecipeName:[recipeArray objectAtIndex:r]];
            [meal addMealRecipesObject:recipe];
            
            NSError *error = nil;
            if (![managedObjectContext save:&error]) {
                //handle error
            }
        }


        
        //categories
        //fetch cats
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Categories" inManagedObjectContext:managedObjectContext];
        [fetchRequest setEntity:entity];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"catName"
                                                                       ascending:YES];
        [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
        
        NSError *error = nil;
        NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
        if (fetchedObjects == nil) {
            //error
        }
        
        NSMutableArray* catArray = [[NSMutableArray alloc]initWithArray:fetchedObjects];
        Categories *category = (Categories *)[catArray objectAtIndex:1];
        [meal addMealCategoryObject:category];

        NSError *e = nil;
        if (![managedObjectContext save:&e]) {
            //handle error
        }
        
        //set the NSUserDefault
        [dummyMeals setObject:@"done" forKey:@"meals"];
    }



}



- (UIImage *)squareImageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    double ratio;
    double delta;
    CGPoint offset;
    
    //make a new square size, that is the resized imaged width
    CGSize sz = CGSizeMake(newSize.width, newSize.width);
    
    //figure out if the picture is landscape or portrait, then
    //calculate scale factor and offset
    if (image.size.width > image.size.height) {
        ratio = newSize.width / image.size.width;
        delta = (ratio*image.size.width - ratio*image.size.height);
        offset = CGPointMake(delta/2, 0);
    } else {
        ratio = newSize.width / image.size.height;
        delta = (ratio*image.size.height - ratio*image.size.width);
        offset = CGPointMake(0, delta/2);
    }
    
    //make the final clipping rect based on the calculated values
    CGRect clipRect = CGRectMake(-offset.x, -offset.y,
                                 (ratio * image.size.width) + delta,
                                 (ratio * image.size.height) + delta);
    
    
    //start a new context, with scale factor 0.0 so retina displays get
    //high quality image
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(sz, YES, 0.0);
    } else {
        UIGraphicsBeginImageContext(sz);
    }
    UIRectClip(clipRect);
    [image drawInRect:clipRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}





-(void)setSamplePreps {
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    managedObjectContext = [appDelegate managedObjectContext];
    
    
    NSUserDefaults * dummyMeals = [NSUserDefaults standardUserDefaults];
    
    if ([dummyMeals objectForKey:@"mealPrep"]) {
        //meal already exists
    } else {
    
    
        //retrieving and preparing data to be saved to core data...
        MealPrep *mealPrep = [NSEntityDescription insertNewObjectForEntityForName:@"MealPrep" inManagedObjectContext:managedObjectContext];
    

        NSDate *mealDate = [NSDate date];
        //set the time to selected hour
        NSCalendar *calendar1 = [NSCalendar currentCalendar];
        NSDateComponents *dateComponents = [calendar1 components:(NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:mealDate];
        [dateComponents setHour:15];
        [dateComponents setMinute:00];
        [dateComponents setSecond:00];
        [dateComponents setDay:dateComponents.day+1];
        [dateComponents setCalendar:[NSCalendar currentCalendar]];
        mealDate = [[NSCalendar currentCalendar]dateFromComponents:dateComponents];
    

    
    //set date of meal
    [mealPrep setDateToBeEaten:mealDate];
    

    //set meal
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Meals" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        //
    }
    Meals *meal = (Meals *)[fetchedObjects firstObject];
    [mealPrep setMeal:meal];
    [mealPrep setMealName:[meal mealName]];
    
    //set new field, for just the date
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd MMM YYYY"];
    NSString *formattedDateString = [dateFormatter stringFromDate:mealDate];
    [mealPrep setDateToBeEatenDate:formattedDateString];
    
    //set new field just for the hour
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"HH"];
    NSString *formattedHour = [df stringFromDate:mealDate];
    [mealPrep setDateToBeEatenHour:formattedHour];
    
    

    
    //set date prepped = now
    
    //format date for datePreppedDate value
    NSDateFormatter *dateFormatterDatePrepped = [[NSDateFormatter alloc] init];
    [dateFormatterDatePrepped setDateFormat:@"dd/MM/YYYY"];
    NSString *formattedDatePreppedString = [dateFormatterDatePrepped stringFromDate:[NSDate date]];
    [mealPrep setDatePrepped:[NSDate date]];
    [mealPrep setDatePreppedDate:formattedDatePreppedString];
    
    
    
    //save data and reload data/table
    NSError *error1 = nil;
    if (![managedObjectContext save:&error1]) {
        //handle error
    }
        
        //set the NSUserDefault
        [dummyMeals setObject:@"done" forKey:@"mealPrep"];
    
    }
    
    
}





-(void)setSampleUnprepped {
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    managedObjectContext = [appDelegate managedObjectContext];
    
    
    NSUserDefaults * dummyMeals = [NSUserDefaults standardUserDefaults];
    
    if ([dummyMeals objectForKey:@"mealUnpreped"]) {
        //meal already exists
    } else {
        
        
        //retrieving and preparing data to be saved to core data...
        MealPrep *mealPrep = [NSEntityDescription insertNewObjectForEntityForName:@"MealPrep" inManagedObjectContext:managedObjectContext];
        
        
        NSDate *mealDate = [NSDate date];
        //set the time to selected hour
        NSCalendar *calendar1 = [NSCalendar currentCalendar];
        NSDateComponents *dateComponents = [calendar1 components:(NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:mealDate];
        [dateComponents setHour:17];
        [dateComponents setMinute:00];
        [dateComponents setSecond:00];
        [dateComponents setDay:dateComponents.day+2];
        [dateComponents setCalendar:[NSCalendar currentCalendar]];
        mealDate = [[NSCalendar currentCalendar]dateFromComponents:dateComponents];
        
        
        //set date of meal
        [mealPrep setDateToBeEaten:mealDate];
        
        //set meal
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Meals" inManagedObjectContext:managedObjectContext];
        [fetchRequest setEntity:entity];
        
        NSError *error = nil;
        NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
        if (fetchedObjects == nil) {
            //
        }
        Meals *meal = (Meals *)[fetchedObjects firstObject];
        [mealPrep setMeal:meal];
        [mealPrep setMealName:[meal mealName]];
        
        //set new field, for just the date
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd MMM YYYY"];
        NSString *formattedDateString = [dateFormatter stringFromDate:mealDate];
        [mealPrep setDateToBeEatenDate:formattedDateString];
        
        //set new field just for the hour
        NSDateFormatter *df = [[NSDateFormatter alloc]init];
        [df setDateFormat:@"HH"];
        NSString *formattedHour = [df stringFromDate:mealDate];
        [mealPrep setDateToBeEatenHour:formattedHour];
        
        
        
        //save data and reload data/table
        NSError *error1 = nil;
        if (![managedObjectContext save:&error1]) {
            //handle error
        }
        
        //set the NSUserDefault
        [dummyMeals setObject:@"done" forKey:@"mealUnpreped"];
    }
}


@end
