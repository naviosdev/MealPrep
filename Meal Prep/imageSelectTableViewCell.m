//
//  imageSelectTableViewCell.m
//  Meal Prep
//
//  Created by Naveed Ahmed on 14/06/2016.
//  Copyright © 2016 Naveed Ahmed. All rights reserved.
//

#import "imageSelectTableViewCell.h"

@implementation imageSelectTableViewCell

@synthesize managedObjectModel, managedObjectContext, persistentStoreCoordinator, mealImageArray, mealThumbnailArray, mealObject, imageSelectColView, selectedItem, deleteIndexPath,mainImageView, deleteButton,makeDefaultButton, imageOptionButton;

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
    

    self.imageSelectColView.delegate = self;
    self.imageSelectColView.dataSource = self;
    
    selectedItem = 0;
    
    [self setMealArray];
    [self setMainImage];

}




-(void)setMealArray {
    
    //this method resets the meal array for when a default is set or any values are changed so the reload can show the new results...
    mealImageArray = nil;
    //mealThumbnailArray = nil;
    
    
    
    //setting the image array of the meal
    NSArray *array = [NSArray arrayWithArray:[[mealObject valueForKeyPath:@"mealImage"]allObjects]];
    //NSArray *thumbnailArray = [NSArray arrayWithArray:[[mealObject valueForKeyPath:@"mealThumbnailImage"]allObjects]];
    
    mealImageArray = [[NSMutableArray alloc]initWithArray:array];
    //mealThumbnailArray = [[NSMutableArray alloc]initWithArray:thumbnailArray];
    
    
    
    
    //keeps order of images in chronological order
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"dateAdded" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc]initWithObjects:sortDescriptor, nil];
    [mealImageArray sortUsingDescriptors:sortDescriptors];
    //[mealThumbnailArray sortUsingDescriptors:sortDescriptors];
    
    //reload the data
    [imageSelectColView reloadData];
    [self setMainImage];
}




-(void)mealObjectLog {

    //getting/setting the imagearray

    if ([[mealObject valueForKeyPath:@"mealImage.mealImage"] isKindOfClass:[NSSet class]]) {
        NSLog(@"le match");
    }
    
    NSArray *array = [[NSArray alloc]initWithArray:[[mealObject valueForKeyPath:@"mealImage.mealImage"]allObjects]];
    
    mealImageArray = [[NSMutableArray alloc]initWithArray:array];
    
    [imageSelectColView reloadData];
    
}






- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



#pragma mark - Collection View

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    if (mealImageArray.count == 0) {
        return 2;
    } else if (mealImageArray.count != 0) {
        return mealImageArray.count+2;
    } else {
        return 0;
    }
}



-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    mealSelectCollectionViewCell *cell = [imageSelectColView dequeueReusableCellWithReuseIdentifier:@"1" forIndexPath:indexPath];
    mealSelectCollectionViewCell *cell2 = [imageSelectColView dequeueReusableCellWithReuseIdentifier:@"2" forIndexPath:indexPath];
    mealSelectCollectionViewCell *cell3 = [imageSelectColView dequeueReusableCellWithReuseIdentifier:@"3" forIndexPath:indexPath];
    

    NSLog(@"selected item: %d",selectedItem);
    
    
    if (mealImageArray.count == 0) {

        switch (indexPath.row) {
            case 0:
                //cell.backgroundColor = [UIColor redColor];
                return cell;
                break;
                
            case 1:
                //cell2.backgroundColor = [UIColor blueColor];
                return cell2;
                break;
                
            default:
                return 0;
                break;
        }
    } else if (mealImageArray.count != 0) {

        if (indexPath.row == mealImageArray.count) {
            return cell;
        } else if (indexPath.row == mealImageArray.count+1) {
            return cell2;
        } else {
    
            if (selectedItem == indexPath.item) {
                
                cell3.mealImageView.image = [[mealImageArray objectAtIndex:indexPath.row]valueForKey:@"mealThumbnailImage"];
                
                cell3.backgroundColor = [UIColor greenColor];
                cell3.selectedImageView.alpha = 1;
                //cell3.deleteButton.alpha=1;

                return cell3;
                
            } else  {
                
                cell3.mealImageView.image = [[mealImageArray objectAtIndex:indexPath.row]valueForKey:@"mealThumbnailImage"];
                //[cell3.mealImageView setClipsToBounds:YES];

                
                //cell3.deleteButton.alpha=0;
                cell3.selectedImageView.alpha=0;
                return cell3;
            }
        }
    } else {
        return 0;
    }
}





-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    if (mealImageArray.count == 0) {
        
        switch (indexPath.row) {
            case 0:
                break;
                
            case 1:
                break;
                
            default:
                break;
        }
    } else if (mealImageArray.count != 0) {

        
        if (indexPath.row == mealImageArray.count) {
            //cell (camera cell)
        } else if (indexPath.row == mealImageArray.count+1) {
            //cell2 (album cell)
        } else {
            
            //cell 3 (image cell)
            if (selectedItem == [[NSNumber numberWithLong:indexPath.item]intValue]) {
                selectedItem = -1;
                [imageSelectColView reloadData];
            } else {
                
                selectedItem = [[NSNumber numberWithLong:indexPath.item]intValue];
                deleteIndexPath = indexPath;
                [imageSelectColView reloadData];
                
                
                mealDetailViewController *mdvc = [[mealDetailViewController alloc]init];
                [mdvc reloadImageMainCell:[[mealImageArray objectAtIndex:indexPath.row]valueForKey:@"mealImage"]];
                
                
                if ([[[mealImageArray objectAtIndex:indexPath.row]valueForKey:@"mealImage"] isKindOfClass:[UIImage class]]) {
                    NSLog(@"le match");
                }
                [self setMainImage];

                NSLog(@"selected item: %d",selectedItem);
            }
        }
    } else {
        
    }
}



#pragma mark - Actions



- (IBAction)deleteAction:(id)sender {
    
    
    MealImages *mealImage = (MealImages *)[mealImageArray objectAtIndex:selectedItem];
    
    
    //handle errors for if you are deleting the first image, or if you are deleting the default image... if statements, - get to be deleted item, if default change another to default
    
    if ((selectedItem == 0) && (mealImageArray.count==1)) {
        NSLog(@"1");
        //delete only image
        //set blank image
        //no default method needed
        
        
        
        //deletes only image - regardless if default or not
        
        NSDate *imageDate = [[mealImageArray objectAtIndex:selectedItem]valueForKey:@"dateAdded"];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"MealImages" inManagedObjectContext:managedObjectContext];
        [fetchRequest setEntity:entity];
        // Specify criteria for filtering which objects to fetch
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"dateAdded = %@",imageDate];
        [fetchRequest setPredicate:predicate];
        //UIImage *image = [[mealImageArray objectAtIndex:selectedItem]valueForKey:@"mealImage"];
        //may need to add the above as a predicate and create a compound predicate if there comes any problems with just using the date - run tests
        
        NSError *error = nil;
        NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
        if (fetchedObjects == nil) {
            
            //error
        }
        
        
        MealImages *mealImage = [fetchedObjects firstObject];
        NSLog(@"image to be deleted %@",mealImage);
        //deletes image
        [managedObjectContext deleteObject:mealImage];
        
        error = nil;
        if (![managedObjectContext save:&error]) {
            //handle error
        }
        
        
        //remove from array
        [mealImageArray removeObjectAtIndex:selectedItem];
        [imageSelectColView reloadData];
        [self setMainImage];

        
        
        
        
        
        
        
    } else if (([[mealImage valueForKey:@"defaultImage"]isEqual:[NSNumber numberWithBool:YES]]) && (mealImageArray.count>1)){
        NSLog(@"2");
        //set selectedItem 1 as default, else dont do anything (no images in array)show blank image
        
        
        //prepares to set the next default image by seeing the next possible image
        int imageToSet;
        if (selectedItem == 0) {
            imageToSet=1;
        } else if (selectedItem>0){
            imageToSet= selectedItem-1;
        }
        
        //sets next image as default, original is ready to be deleted now
        MealImages *mealImage1 = (MealImages *)[mealImageArray objectAtIndex:imageToSet];
        [mealImage1 setDefaultImage:[NSNumber numberWithBool:YES]];

        
        //deleting the original default image
        NSDate *imageDate = [[mealImageArray objectAtIndex:selectedItem]valueForKey:@"dateAdded"];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"MealImages" inManagedObjectContext:managedObjectContext];
        [fetchRequest setEntity:entity];
        // Specify criteria for filtering which objects to fetch
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"dateAdded = %@",imageDate];
        [fetchRequest setPredicate:predicate];
        //UIImage *image = [[mealImageArray objectAtIndex:selectedItem]valueForKey:@"mealImage"];
        //may need to add the above as a predicate and create a compound predicate if there comes any problems with just using the date - run tests
        
        NSError *error = nil;
        NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
        if (fetchedObjects == nil) {
            //error
        }
        
        MealImages *mealImage = [fetchedObjects firstObject];
        NSLog(@"image to be deleted %@",mealImage);
        //deletes image
        [managedObjectContext deleteObject:mealImage];
        
        error = nil;
        if (![managedObjectContext save:&error]) {
            //handle error
        }
        
        //remove from array
        [mealImageArray removeObjectAtIndex:selectedItem];

        
        //new default image has been set and original deleted, array is ready to be reloaded
        [self setMealArray];
        [imageSelectColView reloadData];
        [self setMainImage];
        

        
    } else {
        NSLog(@"3");
        
        //any image after 1 in the array delete - for non default images only
        NSDate *imageDate = [[mealImageArray objectAtIndex:selectedItem]valueForKey:@"dateAdded"];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"MealImages" inManagedObjectContext:managedObjectContext];
        [fetchRequest setEntity:entity];
        // Specify criteria for filtering which objects to fetch
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"dateAdded = %@",imageDate];
        [fetchRequest setPredicate:predicate];

        NSError *error = nil;
        NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
        if (fetchedObjects == nil) {
            
            //error
        }
        
        MealImages *mealImage = [fetchedObjects firstObject];
        NSLog(@"image to be deleted %@",mealImage);
        //deletes image
        [managedObjectContext deleteObject:mealImage];
        
        error = nil;
        if (![managedObjectContext save:&error]) {
            //handle error
        }
        
        //remove from array
        [mealImageArray removeObjectAtIndex:selectedItem];
        
        //sets main image to previous image in the array (unless its already the first image in the array)
        if (selectedItem != 0) {
            selectedItem  = selectedItem-1;
        } else {
            selectedItem = 0;
        }
        
        
        //reset the main image
        if ([[mealImageArray objectAtIndex:selectedItem]valueForKey:@"mealImage"] != nil) {
            [self setMainImage];
        } else {
            mainImageView.image = [UIImage imageNamed:@"noImage.png"];
        }
        
        //default image method
        [self setFirstImageAsDefault];
    }
}




-(void)setFirstImageAsDefault{
    
    if (mealImageArray.count != 0) {
        
        MealImages *mealImage = (MealImages *)[mealImageArray objectAtIndex:0];
        [mealImage setDefaultImage:[NSNumber numberWithBool:YES]];
        [self setMealArray];
        [self setMainImage];
        
    } else {
        
        NSLog(@"default meal cannot be set - array is empty");
    }
    
}




- (IBAction)makeDefaultAction:(id)sender {
    
    
    
    //fetch original default image first, set to default to zero..
    NSFetchRequest *fetchRequestD = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityD = [NSEntityDescription entityForName:@"MealImages" inManagedObjectContext:managedObjectContext];
    [fetchRequestD setEntity:entityD];
    // Specify criteria for filtering which objects to fetch
    NSPredicate *predicateD = [NSPredicate predicateWithFormat:@"defaultImage = %@",[NSNumber numberWithBool:YES]];
    NSPredicate *mealPred = [NSPredicate predicateWithFormat:@"meal = %@",mealObject];
    
    NSCompoundPredicate *preds = [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects:predicateD,mealPred, nil]];
    //need another predicate for meals that belong to mealObject..
    [fetchRequestD setPredicate:preds];
    
    NSError *errorD = nil;
    NSArray *fetchedObjectsD = [managedObjectContext executeFetchRequest:fetchRequestD error:&errorD];
    if (fetchedObjectsD == nil) {
        
        //error
    }
    
    
    //set back to no
    MealImages *defaultMeal = [fetchedObjectsD firstObject];
    [defaultMeal setDefaultImage:[NSNumber numberWithBool:NO]];
    NSLog(@"original default meal: %@",defaultMeal);
    
    

    //get current meal selected, and set that to default
    NSDate *imageDate = [[mealImageArray objectAtIndex:selectedItem]valueForKey:@"dateAdded"];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MealImages" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"dateAdded = %@",imageDate];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        
        //error
    }
    
    MealImages *mealImage = [fetchedObjects firstObject];
    [mealImage setDefaultImage:[NSNumber numberWithBool:YES]];
     NSLog(@"new default meal: %@",mealImage);
    
    NSError *e = nil;
    if (![managedObjectContext save:&e]) {
        //handle error
    }

    [self setMainImage];

}


-(void)setMainImage {
    
    if (mealImageArray.count == 0) {
        mainImageView.image = [UIImage imageNamed:@"noImage.png"];
        [mainImageView setImage:[UIImage imageNamed:@"noImage"]];
        deleteButton.alpha= 0;
        makeDefaultButton.alpha=0;
        imageOptionButton.alpha=0;
    } else if (mealImageArray.count > 0){
    
        imageOptionButton.alpha=1;
        //mainImageView.alpha = 1.0f;
    [UIView animateKeyframesWithDuration:0.08 delay:0.0 options:0 animations:^{
        mainImageView.alpha = 0.0f;
        deleteButton.alpha = 0.0f;
        makeDefaultButton.alpha = 0.0f;
      
    } completion:^(BOOL finished) {
        //sets main image to selecteditem
        mainImageView.image = [[mealImageArray objectAtIndex:selectedItem]valueForKey:@"mealImage"];
        
        //checks if image is default image then hides 'set default' button
        if ([[[mealImageArray objectAtIndex:selectedItem]valueForKey:@"defaultImage"] isEqual:[NSNumber numberWithBool:YES]]) {
            [makeDefaultButton setHidden:YES];
        } else {
            [makeDefaultButton setHidden:NO];
        }

        [UIView animateKeyframesWithDuration:0.3 delay:0.0 options:0 animations:^{
            mainImageView.alpha = 1.0f;
            //deleteButton.alpha = 1.0f;
            //makeDefaultButton.alpha = 1.0f;
        } completion:^(BOOL finished) {
        }];
    }];
    }
}






- (IBAction)mainImageOptionsAction:(id)sender {
    
    //first checks if buttons are showing, if yes, remove them, if not show them...
    
    if (deleteButton.alpha == 1) {
        
        
        [UIView animateKeyframesWithDuration:0.3 delay:0.0 options:0 animations:^{
            deleteButton.alpha =0;
            makeDefaultButton.alpha=0;
        } completion:^(BOOL finished) {
        }];

    } else {
  
    //determines whether image is default or not to bring up the correct actions
    if ([[[mealImageArray objectAtIndex:selectedItem]valueForKey:@"defaultImage"] isEqual:[NSNumber numberWithBool:NO]]) {
        
        //both
        [UIView animateKeyframesWithDuration:0.5 delay:0.0 options:0 animations:^{
            //mainImageView.alpha = 1.0f;
            deleteButton.alpha = 1.0f;
            makeDefaultButton.alpha = 1.0f;
        } completion:^(BOOL finished) {
        }];

    } else {
        
        //delete only
        [UIView animateKeyframesWithDuration:0.3 delay:0.0 options:0 animations:^{
            //mainImageView.alpha = 1.0f;
            deleteButton.alpha = 1.0f;
            //makeDefaultButton.alpha = 1.0f;
        } completion:^(BOOL finished) {
        }];
    }
    }
}


@end
