//
//  recipeListTableViewCell.m
//  Meal Prep
//
//  Created by Naveed Ahmed on 23/06/2016.
//  Copyright © 2016 Naveed Ahmed. All rights reserved.
//

#import "recipeListTableViewCell.h"



@implementation recipeListTableViewCell

@synthesize recipeDefaults, recipeAddTextField, managedObjectModel,managedObjectContext,persistentStoreCoordinator,mealObject, delegate;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
    self.recipeAddTextField.delegate = self;
    
    
    
    
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
    // Specify criteria for filtering which objects to fetch
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"mealName = %@", mealNameString];
    [fetchRequest setPredicate:predicate];
    // Specify how the fetched objects should be sorted
    
    NSError *error = nil;
    NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        
        //error
    }
    [self setMealObject:fetchedObjects.firstObject];
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}





#pragma mark - TextField



-(void)textFieldDidEndEditing:(UITextField *)textField {

    [recipeDefaults setObject:recipeAddTextField.text forKey:@"recipeName"];
    [recipeDefaults synchronize];

}



-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    Recipes *recipe = [NSEntityDescription insertNewObjectForEntityForName:@"Recipes" inManagedObjectContext:managedObjectContext];
    Meals *meal = (Meals *)mealObject;
    
    [recipe setRecipeName:recipeAddTextField.text];
    [meal addMealRecipesObject:recipe];
    
    //save to db
    NSError *error = nil;
    if (![managedObjectContext save:&error]) {
        //handle error
    }
    
    recipeAddTextField.text = nil;
    
    recipeDetailTableViewCell *rdtvc = [[recipeDetailTableViewCell alloc]init];
    [rdtvc finishedAddRecipe];
    [rdtvc.recipeListTableView reloadData];

    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadTable"
                                                        object:nil];
    
    mealDetailViewController *mdvc = [[mealDetailViewController alloc]init];
    [mdvc reloadRecipeRow];
    
    [mdvc.detailTableView reloadData];

    [recipeAddTextField resignFirstResponder];
    return YES;
}





-(BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    
    [textField resignFirstResponder];
    return YES;
}




@end
