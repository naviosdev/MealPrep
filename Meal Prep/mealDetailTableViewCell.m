//
//  mealDetailTableViewCell.m
//  Meal Prep
//
//  Created by Naveed Ahmed on 11/06/2016.
//  Copyright © 2016 Naveed Ahmed. All rights reserved.
//

#import "mealDetailTableViewCell.h"

@implementation mealDetailTableViewCell

@synthesize mealObject, managedObjectModel,managedObjectContext,persistentStoreCoordinator, mainImage, prepTimeTextField, mealNameTextField;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    managedObjectContext = [appDelegate managedObjectContext];
    
    //getting and setting the meal object
    NSUserDefaults *object = [NSUserDefaults standardUserDefaults];
    NSString *mealNameString = [object valueForKey:@"mealName"];
    NSLog(@"log string %@",mealNameString);
    
    //fething the meal object
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
    
    
    [managedObjectContext existingObjectWithID:mealObject.objectID error:&error];
    
    mealNameTextField.text = [mealObject valueForKey:@"mealName"];
    prepTimeTextField.text = [mealObject valueForKey:@"timePrep"];
    
    
    
    
    self.mealNameTextField.delegate = self;
    self.prepTimeTextField.delegate = self;
    

 
}



-(void)mealObjectLog {
    NSLog(@"hakuna matata");
    //sets the meal object - for the rest of the cells
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"defaultImage = %@",[NSNumber numberWithBool:YES]];
    NSLog(@"meal imageee %@",[[mealObject valueForKey:@"mealImage"]filteredSetUsingPredicate:pred]);
    
    NSManagedObject *mealImageMo = [[[mealObject valueForKey:@"mealImage"]filteredSetUsingPredicate:pred]anyObject];
    
    mainImage = [mealImageMo valueForKey:@"mealImage"];

}







#pragma mark - TextField (Meal Name and Prep Time)

//cell 1 - meal name

-(void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField == mealNameTextField) {
        
        
        Meals *meal = (Meals *)mealObject;
        [meal setMealName:mealNameTextField.text];
        NSError *error = nil;
        if (![managedObjectContext save:&error]) {
            //handle error
        }
        

        
    } else if (textField == prepTimeTextField) {
        
   
        Meals *meal = (Meals *)mealObject;
        [meal setTimePrep:prepTimeTextField.text];
        NSError *error = nil;
        if (![managedObjectContext save:&error]) {
            //handle error
        }
        
        
    }
}



-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    
    if (textField == mealNameTextField) {
        
        [mealNameTextField resignFirstResponder];
        return YES;
        
    } else if (textField == prepTimeTextField) {
        
        [prepTimeTextField resignFirstResponder];
        return YES;
        
    } else {
        return YES;
    }
    
    
    
}



-(BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    
    [textField resignFirstResponder];
    return YES;
}






- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}






@end
