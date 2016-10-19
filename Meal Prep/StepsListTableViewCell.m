//
//  StepsListTableViewCell.m
//  Meal Prep
//
//  Created by Naveed Ahmed on 26/06/2016.
//  Copyright © 2016 Naveed Ahmed. All rights reserved.
//

#import "StepsListTableViewCell.h"

@implementation StepsListTableViewCell

@synthesize managedObjectModel,managedObjectContext,persistentStoreCoordinator,stepLabel,stepPositionLabel,stepTextEntryField, mealObject, textViewCountLabel, string;

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
    
    
    textViewCountLabel.text = @"0/120 left";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}




-(void)textViewDidEndEditing:(UITextView *)textView {
    
    [textView resignFirstResponder];
}


-(void)textViewDidChange:(UITextView *)textView {
    
    textViewCountLabel.text = [NSString stringWithFormat:@"%lu/120 left",(unsigned long)[stepTextEntryField.text length]];
    
    
    //sets maximum character limit
    if ([stepTextEntryField.text length] == 120) {
        string = stepTextEntryField.text;
        }
    
    
    if ([stepTextEntryField.text length] >120) {
        [stepTextEntryField setText:string];
    }
    
    
}




- (IBAction)saveAction:(id)sender {
    
    
    Meals *meal = (Meals *)mealObject;
    Steps *step = [NSEntityDescription insertNewObjectForEntityForName:@"Steps" inManagedObjectContext:managedObjectContext];
    
    [step setStep:stepTextEntryField.text];
    [step setDateAdded:[NSDate date]];
    [meal addMealStepsObject:step];
    
    
    int i = (int)[[meal mealSteps]count];
    [step setPosition:[NSNumber numberWithInt:i]];
    
    
    NSError *error = nil;
    if (![managedObjectContext save:&error]) {
        //handle error
    }
    
    
    [stepTextEntryField resignFirstResponder];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"stepIsSaved"
                                                        object:nil];
}


@end
