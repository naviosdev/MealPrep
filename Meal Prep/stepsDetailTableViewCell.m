//
//  stepsDetailTableViewCell.m
//  Meal Prep
//
//  Created by Naveed Ahmed on 26/06/2016.
//  Copyright © 2016 Naveed Ahmed. All rights reserved.
//

#import "stepsDetailTableViewCell.h"

@implementation stepsDetailTableViewCell

@synthesize stepsArray, stepsTableView, managedObjectContext, managedObjectModel, persistentStoreCoordinator, mealObject, addCellTapped;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    managedObjectContext = [appDelegate managedObjectContext];
    
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
    
    
    [self setArrayForSteps];
    
    
    addCellTapped = 0;
    

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(stepSaved:)
                                                 name:@"stepIsSaved"
                                               object:nil];
    
}


-(void)setArrayForSteps {
    
    NSArray *array = [[NSArray alloc]initWithArray:[[mealObject valueForKey:@"mealSteps"]allObjects]];
    
    stepsArray = [[NSMutableArray alloc]initWithArray:array];
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"position" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc]initWithObjects:sortDescriptor, nil];
    [stepsArray sortUsingDescriptors:sortDescriptors];
    

    
    [stepsArray insertObject:@"" atIndex:0];
    
    NSLog(@"steps array: %@",stepsArray);
    
    [self.stepsTableView reloadData];
    
    
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}





#pragma mark - TableView


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return stepsArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    StepsListTableViewCell *cell = [stepsTableView dequeueReusableCellWithIdentifier:@"addCell"];
    StepsListTableViewCell *cellex = [stepsTableView dequeueReusableCellWithIdentifier:@"exAddCell"];
    StepsListTableViewCell *cell2 = [stepsTableView dequeueReusableCellWithIdentifier:@"stepCell"];
    
    
    
    
    Steps *steps = (Steps *)[stepsArray objectAtIndex:indexPath.row];

    if (indexPath.row == 0) {
        
        
        switch (addCellTapped) {
            case 0:
                return cell;
                break;
            case 1:
                return cellex;
                break;
            default:
                return 0;
                break;
        }

        
        
        
    } else {
        
        cell2.stepPositionLabel.text = [NSString stringWithFormat:@"%@.",[steps position]];
        cell2.stepLabel.text = [steps step];
        return cell2;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    
    if (indexPath.row == 0) {
        
        if (addCellTapped == 0) {
            addCellTapped = 1;
            [self increaseCellSize:indexPath ifAddCellTapped:addCellTapped];
        } else {
            addCellTapped = 0;
        }
    
        
    } else {
    }
    
}


-(void)increaseCellSize:(NSIndexPath *)indexPath ifAddCellTapped:(int)cellTapped{
    
    NSIndexPath *indexa = [NSIndexPath indexPathForRow:0 inSection:0];

     [UIView animateKeyframesWithDuration:1.3 delay:0.0 options:0 animations:^{
        
        [self.stepsTableView beginUpdates];
        [self.stepsTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexa] withRowAnimation:UITableViewRowAnimationAutomatic];
         
    
    } completion:^(BOOL finished) {
        NSLog(@"called");
        [self.stepsTableView endUpdates];

    }];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        switch (addCellTapped) {
            case 0:
                return 60;
                break;
            case 1:
                return 135;
                break;
            default:
                return 0;
                break;
        }
        
    } else {
        return 65;
    }
    
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDate *ddate = [NSDate date];
    ddate = [[stepsArray objectAtIndex:indexPath.row]valueForKey:@"dateAdded"];
    
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        
        //fetch the recipe object
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Steps" inManagedObjectContext:managedObjectContext];
        [fetchRequest setEntity:entity];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"dateAdded = %@", ddate];
        [fetchRequest setPredicate:predicate];
        NSError *e = nil;
        NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&e];
        if (fetchedObjects == nil) {
            //error
        }
        
        //recipe and meal retrieveed
        Steps *step = (Steps *)[fetchedObjects firstObject];
        
        //Meals *meal = (Meals *)mealObject;
        //[meal removeMealStepsObject:step];
        
        [managedObjectContext deleteObject:step];
    
        //update table
        [stepsArray removeObjectAtIndex:indexPath.row];
        [stepsTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        //save
        NSError *error = nil;
        if (![managedObjectContext save:&error]) {
            //handle the error
        }
    
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}






- (IBAction)cancelAddAction:(id)sender {
    
    addCellTapped = 0;

    NSIndexPath *indexa = [NSIndexPath indexPathForRow:0 inSection:0];
    
    [UIView animateKeyframesWithDuration:0.5 delay:0.0 options:0 animations:^{
        
        [self.stepsTableView beginUpdates];
        [self.stepsTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexa] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        
    } completion:^(BOOL finished) {
        NSLog(@"called");
        [self.stepsTableView endUpdates];
        
    }];
}




- (void)stepSaved:(NSNotification *)notif {
    
    addCellTapped = 0;

    NSIndexPath *indexa = [NSIndexPath indexPathForRow:0 inSection:0];
    
    [UIView animateKeyframesWithDuration:0.5 delay:0.0 options:0 animations:^{
        
        [self.stepsTableView beginUpdates];
        [self.stepsTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexa] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        
    } completion:^(BOOL finished) {
        NSLog(@"called");
        [self.stepsTableView endUpdates];
        [self setArrayForSteps];
    }];
    
    [stepsTableView reloadData];
}






@end
