//
//  categoryDetailTableViewCell.m
//  Meal Prep
//
//  Created by Naveed Ahmed on 27/06/2016.
//  Copyright © 2016 Naveed Ahmed. All rights reserved.
//

#import "categoryDetailTableViewCell.h"

@implementation categoryDetailTableViewCell

@synthesize catArray,catColView,catSelectionArray, managedObjectModel,managedObjectContext,persistentStoreCoordinator, mealObject, theString;

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
    
    [self setArrayForCat];
}




-(void)setArrayForCat {
    
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
    
    catArray = [[NSMutableArray alloc]initWithArray:fetchedObjects];
    
    //set catselection array
    NSArray *mealCatArray = [NSArray arrayWithArray:[[mealObject valueForKey:@"MealCategory"]allObjects]];
    
    catSelectionArray = [[NSMutableArray alloc]initWithArray:mealCatArray];
}





#pragma mark - Collection View

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
        return catArray.count;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    catCellCollectionViewCell *catCell = [catColView dequeueReusableCellWithReuseIdentifier:@"catCell" forIndexPath:indexPath];

    NSString *name = [[catArray objectAtIndex:indexPath.row]valueForKey:@"catName"];
    catCell.label.text = name;
    
    //show background change depending if item is selected
    if ([catSelectionArray containsObject:[catArray objectAtIndex:indexPath.row]]) {
        UIColor *selectedColour = [UIColor colorWithRed:172.0f/255.0f
                                                  green:90.0f/255.0f
                                                   blue:79.0f/255.0f
                                                  alpha:1.0f];
        catCell.catBg
        .backgroundColor = selectedColour;
    }
    
        return catCell;
}




-(void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //used this method because the cell reuse kept displaying duplicates, so had to reset the cell when it goes off screen
    catCellCollectionViewCell *catCell = [catColView dequeueReusableCellWithReuseIdentifier:@"catCell" forIndexPath:indexPath];
    
    catCell.label.backgroundColor = nil;
}



-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    Meals *meal = (Meals *)mealObject;
    Categories *category = (Categories *)[catArray objectAtIndex:indexPath.row];
        
        
        if ([catSelectionArray containsObject:[catArray objectAtIndex:indexPath.row]]) {
            NSLog(@"duplicate found");
            
            [catSelectionArray removeObjectIdenticalTo:[catArray objectAtIndex:indexPath.row]];
            [meal removeMealCategoryObject:category];
            
            
        } else {
            NSLog(@"cat added");
            [catSelectionArray addObject:[catArray objectAtIndex:indexPath.row]];
            [meal addMealCategoryObject:category];
        }
        
    
    NSError *error = nil;
    if (![managedObjectContext save:&error]) {
        //handle error
    }
    
    
        [catColView reloadItemsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil]];

        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:catSelectionArray];
    
        NSUserDefaults *newMealSave = [NSUserDefaults standardUserDefaults];
        [newMealSave setObject:data forKey:@"catStats"];
        [newMealSave synchronize];
    
        NSLog(@"cat selected array: %@",catSelectionArray);
   }



-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
        return CGSizeMake(125, 35);
    
}



-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {

        return 0;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
