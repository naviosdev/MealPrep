//
//  recipeDetailTableViewCell.m
//  Meal Prep
//
//  Created by Naveed Ahmed on 23/06/2016.
//  Copyright © 2016 Naveed Ahmed. All rights reserved.
//

#import "recipeDetailTableViewCell.h"
#import "AppDelegate.h"
#import "Meals.h"
#import "MealPrep.h"
#import "Recipes.h"

@implementation recipeDetailTableViewCell

@synthesize recipeListArray,recipeListTableView, managedObjectModel,managedObjectContext,persistentStoreCoordinator, mealObject;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    managedObjectContext = [appDelegate managedObjectContext];
    
    //managedObjectContext1 = [appDelegate managedObjectContext];
    
    
    
    
    //getting and setting the meal object
    NSUserDefaults *object = [NSUserDefaults standardUserDefaults];
    NSString *mealNameString = [object valueForKey:@"mealName"];
    NSLog(@"log string %@",mealNameString);
    
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
    
    [mealObject valueForKey:@"mealRecipes"];
    
    //set recipe array for the meal
    [self setRecipeArray];
  
    //reload table 
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadTableView:)
                                                 name:@"reloadTable"
                                               object:nil];
    
    
}



- (void)reloadTableView:(NSNotification *)notif {
    
    
    NSIndexPath *indexa = [NSIndexPath indexPathForRow:0 inSection:0];
    
    [recipeListArray removeObjectAtIndex:0];
    [self.recipeListTableView beginUpdates];
    [self.recipeListTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexa] withRowAnimation:UITableViewRowAnimationLeft];
    [self.recipeListTableView endUpdates];
    [self setRecipeArray];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"reloadTable"       object:nil];
}



-(void)setRecipeArray {
    
    
    NSArray *array = [[NSArray alloc]initWithArray:[[mealObject valueForKeyPath:@"mealRecipes.recipeName"]allObjects]];
    
    recipeListArray = [[NSMutableArray alloc]initWithArray:array];
    
    NSLog(@"recipe array: %@",recipeListArray);
    
    [self.recipeListTableView reloadData];
}





- (IBAction)addRecipeAction:(id)sender {
    
    
    if (recipeListArray.count >0) {
        
        
        if ([[recipeListArray objectAtIndex:0]isEqualToString:@""]) {
            
            //cell is already up, do nothing
        } else {
            
            //the array/table is empty OR first cell is not the add cell - add cell and reload
            [recipeListArray insertObject:@"" atIndex:0];
            
            
            NSIndexPath *indexa = [NSIndexPath indexPathForRow:0 inSection:0];
            
            
            [self.recipeListTableView beginUpdates];
            [self.recipeListTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexa] withRowAnimation:UITableViewRowAnimationRight];
            [self.recipeListTableView endUpdates];

            [self.recipeListTableView scrollToRowAtIndexPath:indexa atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
        
    } else {
        //array is empty add the first object
        [recipeListArray insertObject:@"" atIndex:0];
        [recipeListTableView reloadData];
    }
}


-(void)finishedAddRecipe {
    
    NSIndexPath *indexa = [NSIndexPath indexPathForRow:0 inSection:0];
    
    [recipeListArray removeObjectAtIndex:0];
    [self.recipeListTableView beginUpdates];
    [self.recipeListTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexa] withRowAnimation:UITableViewRowAnimationFade];
    [self.recipeListTableView endUpdates];
    [recipeListTableView reloadData];
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}




#pragma mark - Table View


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return recipeListArray.count;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    recipeListTableViewCell *cell = [recipeListTableView dequeueReusableCellWithIdentifier:@"addRecipeCell"];
    recipeListTableViewCell *cell2 = [recipeListTableView dequeueReusableCellWithIdentifier:@"recipeCell"];
    
    if ([[recipeListArray objectAtIndex:indexPath.row] isEqualToString:@""]) {
    
        return cell;
        } else {
        
        cell2.recipeNameLabel.text = [recipeListArray objectAtIndex:indexPath.row];
        
        return cell2;
    }
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        /*Note: deletion of the recipe is not happening, instead the recipe will be removed from the relationhip of the meal, so it can still be used with other meals
        if a recipe needs to be permantely deleted it needs to do so on the grocery list view controller (or you can create an alert to ask to delete from all other meals also)*/
        
        //fetch the recipe object
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Recipes" inManagedObjectContext:managedObjectContext];
        [fetchRequest setEntity:entity];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"recipeName = %@", [recipeListArray objectAtIndex:indexPath.row]];
        [fetchRequest setPredicate:predicate];
        NSError *e = nil;
        NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&e];
        if (fetchedObjects == nil) {
            //error
        }

        //recipe and meal retrieveed
        Recipes *recipe1 = (Recipes *)[fetchedObjects firstObject];
        Meals *meal = (Meals *)mealObject;
        //remove recipe from meal (not delete)
        [meal removeMealRecipesObject:recipe1];
        
        
        //update table
        [recipeListArray removeObjectAtIndex:indexPath.row];
        [recipeListTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        //save
        NSError *error = nil;
        if (![managedObjectContext save:&error]) {
            //handle the error
        }
        
        
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}







-(void)reloadTable {
    
    
    NSIndexPath *ind = [NSIndexPath indexPathForRow:0 inSection:0];
    [recipeListTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:ind] withRowAnimation:UITableViewRowAnimationFade];

}



@end
