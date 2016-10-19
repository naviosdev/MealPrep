//
//  MealPlannerTableViewCell.m
//  Meal Prep
//
//  Created by Naveed Ahmed on 24/07/2016.
//  Copyright © 2016 Naveed Ahmed. All rights reserved.
//

#import "MealPlannerTableViewCell.h"

@implementation MealPlannerTableViewCell

@synthesize timeLabel,addMealButton, mealSelectColView, managedObjectModel,managedObjectContext,persistentStoreCoordinator, mealsArray, selectedMealImageView,selectedMealNameLabel,selectedPrepTimeLabel, selectInfoLabel, deletePrepButton;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    
    managedObjectContext = [appDelegate managedObjectContext];
    
    
    
    
    //fetch the list of meals, and set the array..
    
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *trucks = [NSEntityDescription entityForName:@"Meals" inManagedObjectContext:managedObjectContext];
    [request setEntity:trucks];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"mealName" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc]initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    
    NSError *error = nil;
    NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error]mutableCopy];
    if (mutableFetchResults == nil) {
        //handle error
    }
    
    [self setMealsArray:mutableFetchResults];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return mealsArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    mealCollectionViewCell *cell = [mealSelectColView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];

    Meals *meal = (Meals *)[mealsArray objectAtIndex:indexPath.row];
    cell.mealNameLabel.text = [meal mealName];

    //displays default image for the meal
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"defaultImage = %@",[NSNumber numberWithBool:YES]];
    NSManagedObject *mealImageMo = [[[meal mealImage]filteredSetUsingPredicate:pred]anyObject];
    
    UIImage *theDefaultImage = [mealImageMo valueForKey:@"mealImage"];
    
    if (theDefaultImage != nil) {
        cell.mealImageView.clipsToBounds = YES;
        cell.mealImageView.image = theDefaultImage;
    } else {
        cell.mealImageView.clipsToBounds = YES;
        cell.mealImageView.image = [UIImage imageNamed:@"noImage.png"];
    }
    
    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    Meals *meal = (Meals *)[mealsArray objectAtIndex:indexPath.row];
    selectInfoLabel.text = @"Meal Selected:";
    selectedMealNameLabel.text = [meal mealName];
    selectedPrepTimeLabel.text = [NSString stringWithFormat:@"Prep Time: %@",[meal timePrep]];
    
    //displays default image for the meal
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"defaultImage = %@",[NSNumber numberWithBool:YES]];
    NSManagedObject *mealImageMo = [[[meal mealImage]filteredSetUsingPredicate:pred]anyObject];
    UIImage *theDefaultImage = [mealImageMo valueForKey:@"mealImage"];
    if (theDefaultImage != nil) {
        selectedMealImageView.image = theDefaultImage;
    } else {
        selectedMealImageView.image = [UIImage imageNamed:@"noImage.png"];
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[meal mealName] forKey:@"meal"];
    [defaults setObject:[NSNumber numberWithLong:indexPath.row] forKey:@"time"];
    [defaults synchronize];
}


@end
