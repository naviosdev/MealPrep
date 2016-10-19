//
//  storageDetailTableViewCell.m
//  MealPrep
//
//  Created by Naveed Ahmed on 03/10/2016.
//  Copyright © 2016 Naveed Ahmed. All rights reserved.
//

#import "storageDetailTableViewCell.h"

@implementation storageDetailTableViewCell

@synthesize managedObjectModel, managedObjectContext, persistentStoreCoordinator, mealObject, fridgeStepper,freezerStepper, fridgeValue,freezerValue, fridgeDaysLabel, freezerDaysLabel;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    managedObjectContext = [appDelegate managedObjectContext];
    
    //getting and setting the meal object
    NSUserDefaults *object = [NSUserDefaults standardUserDefaults];
    NSString *mealNameString = [object valueForKey:@"mealName"];
    NSLog(@"long string %@",mealNameString);
    
    //fething and setting the meal object
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Meals" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"mealName = %@", mealNameString];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        //error
    }
    [self setMealObject:fetchedObjects.firstObject];
    
    Meals *meal = (Meals *)mealObject;
    
    
    //get and set the values for stepper and labels
    fridgeStepper.value = [[meal fridgeStorageDays]doubleValue];
    freezerStepper.value = [[meal freezerStorageDays]doubleValue];
    
    fridgeDaysLabel.text = [NSString stringWithFormat:@"%d days",(int)fridgeStepper.value];
    freezerDaysLabel.text = [NSString stringWithFormat:@"%d days",(int)freezerStepper.value];
    

}


- (IBAction)fridgeStepperAction:(id)sender {
    
    //set label
    fridgeValue = fridgeStepper.value;
    fridgeDaysLabel.text = [NSString stringWithFormat:@"%d days",fridgeValue];
    
    //update data
    Meals *meal = (Meals *)mealObject;
    [meal setFridgeStorageDays:[NSNumber numberWithInt:fridgeValue]];
    
    //save data
    NSError *error = nil;
    if (![managedObjectContext save:&error]) {
        //handle error
    }
}

- (IBAction)freezerStepperAction:(id)sender {
    
    //update label
    freezerValue = freezerStepper.value;
    freezerDaysLabel.text = [NSString stringWithFormat:@"%d days",freezerValue];
    
    //update meal data
    Meals *meal = (Meals *)mealObject;
    [meal setFreezerStorageDays:[NSNumber numberWithInt:freezerValue]];
    
    //save data
    NSError *error = nil;
    if (![managedObjectContext save:&error]) {
        //handle error
    }
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
