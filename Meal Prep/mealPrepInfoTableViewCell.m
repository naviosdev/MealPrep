//
//  mealPrepInfoTableViewCell.m
//  Meal Prep
//
//  Created by Naveed Ahmed on 05/09/2016.
//  Copyright © 2016 Naveed Ahmed. All rights reserved.
//

#import "mealPrepInfoTableViewCell.h"

@implementation mealPrepInfoTableViewCell

@synthesize recipeTableView, recipeArray, managedObjectModel,managedObjectContext,persistentStoreCoordinator, mealObject;


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    managedObjectContext = [appDelegate managedObjectContext];
    
    
    //getting and setting the meal object
    NSUserDefaults *object = [NSUserDefaults standardUserDefaults];
    NSString *mealNameString = [object valueForKey:@"mealName"];
    
    
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
    
    
    
}



-(void)setRecipeArray {
    
    NSArray *array = [[NSArray alloc]initWithArray:[[mealObject valueForKeyPath:@"mealRecipes.recipeName"]allObjects]];
    recipeArray = [[NSMutableArray alloc]initWithArray:array];

    //[recipeArray insertObject:@"Recipe:" atIndex:0];

    [self.recipeTableView reloadData];
}




-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return recipeArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    recipeTableViewCell *recipeCell = [recipeTableView dequeueReusableCellWithIdentifier:@"recipe"];
    
    
    if (recipeCell == nil) {
        recipeCell = [[recipeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"recipe"];
    }
    
    
    recipeCell.recipeNameLabel.text = [recipeArray objectAtIndex:indexPath.row];
    
    return recipeCell;
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
