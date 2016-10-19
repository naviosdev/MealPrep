//
//  newAddMealTableViewCell.m
//  Trucks
//
//  Created by Naveed Ahmed on 18/05/2016.
//  Copyright © 2016 Naveed Ahmed. All rights reserved.
//

#import "newAddMealTableViewCell.h"

@implementation newAddMealTableViewCell

@synthesize carbLabel,carbSlider, proLabel,proSlider,fatLabel,fatSlider,albumColView, albumArray, thumbArray, selectedItem, selectedDefaultItem, deleteIndexPath, macroRemainingPercentLabel, catArray, catColView, catSelectionArray, mealSaveData, mealNameTextField, prepTImePicker, managedObjectContext, managedObjectModel, persistentStoreCoordinator,macroPie;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    managedObjectContext = [appDelegate managedObjectContext];

    //retrieving the photo array and setting the col view array
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:@"array"];
    albumArray = [[NSMutableArray alloc]initWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
    
    //retrieve thumbs
    NSData *thumbData = [defaults objectForKey:@"arrayThumbs"];
    thumbArray = [[NSMutableArray alloc]initWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:thumbData]];
    
    
    
    selectedItem = -1;
    

    self.mealNameTextField.delegate = self;
    
    
    self.albumColView.delegate = self;
    self.albumColView.dataSource = self;
    
    
    
    //this carried out the methods for numberofitems and cellforrowatindex
    [albumColView reloadData];
    NSIndexSet * sections = [NSIndexSet indexSetWithIndex:0];
    [self.albumColView reloadSections:sections];
   
    
    
    macroRemainingPercentLabel.text = @"";

    
    //cat stuff
    [self setArrayForCatArray];
    
    self.catColView.delegate = self;
    self.catColView.dataSource = self;
    catSelectionArray = [[NSMutableArray alloc]init];
    
    
    [albumColView reloadData];

    mealSaveData = [NSUserDefaults standardUserDefaults];
}



-(void)setArrayForCatArray {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Categories" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"catName", s];
    //[fetchRequest setPredicate:predicate];
    // Specify how the fetched objects should be sorted
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"catName"
                                                                   ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        
        //error
    }

    catArray = [[NSMutableArray alloc]initWithArray:fetchedObjects];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)updateArray:(NSMutableArray*)array {
    albumArray = [NSMutableArray arrayWithArray:array];
    [self.albumColView reloadData];
}


-(void)reloaddata {
    [albumColView reloadData];
    NSIndexSet * sections = [NSIndexSet indexSetWithIndex:0];
    [self.albumColView reloadSections:sections];
}



#pragma mark - TextField (Meal Name and Prep Time)

//cell 1 - meal name

-(void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField == mealNameTextField) {
        [mealSaveData setObject:mealNameTextField.text forKey:@"mealName"];
        [mealSaveData synchronize];
        
    }
}



-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == mealNameTextField) {
        [mealNameTextField resignFirstResponder];
        return YES;
    } else {
        return YES;
    }
}


-(BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}




- (IBAction)prepTImeValueAction:(id)sender {
    NSLog(@"prepdate: %@",prepTImePicker.date);
    
    //format the date to get a string
    //correct the picker
    NSDate *prepTime = prepTImePicker.date;
    NSCalendar *calendar1 = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar1 components:(NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:prepTime];
    [dateComponents setCalendar:[NSCalendar currentCalendar]];
    prepTime = [[NSCalendar currentCalendar]dateFromComponents:dateComponents];
    
    
    //retrieve just the hour and mins selected
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"HH"];
    NSString *formattedHour = [df stringFromDate:prepTime];
    
    NSDateFormatter *df1 = [[NSDateFormatter alloc]init];
    [df1 setDateFormat:@"mm"];
    NSString *formattedMinute = [df1 stringFromDate:prepTime];

    
    //set the prepTimeLabel string
    NSString *prepTimeString = [[NSString alloc]init];
    if ([formattedHour isEqualToString:@"00"]) {
        prepTimeString = [NSString stringWithFormat:@"%@MN",formattedMinute];
        NSLog(@"formatted prep time:%@",prepTimeString);
    } else {
        prepTimeString = [NSString stringWithFormat:@"%@HR %@MN",formattedHour,formattedMinute];
        NSLog(@"formatted prep time: %@",prepTimeString);
    }
    
    
    
    
    //save to user defaults
    NSUserDefaults *prepDate = [NSUserDefaults standardUserDefaults];
    [prepDate setObject:prepTimeString forKey:@"prepTimePicked"];
    [prepDate synchronize];
}







#pragma mark - UISlider (Macros)

//cell 3 - macro set
- (IBAction)carbAction:(id)sender {
    
    carbLabel.text = [NSString stringWithFormat:@"%d%%",(int)carbSlider.value];
    int i = 100 - (proSlider.value + carbSlider.value + fatSlider.value);
    macroRemainingPercentLabel.text = [NSString stringWithFormat:@"(%d)",i];
    
    if ((proSlider.value + fatSlider.value + carbSlider.value) >101) {
        
        //compare between pro and fat values
        //highest one moves down
        float fatValue = 100 - (carbSlider.value + proSlider.value);
        float proValue = 100 - (carbSlider.value + fatSlider.value);

        if (proSlider.value < fatSlider.value) {
            [fatSlider setValue:fatValue];
        } else if (proSlider.value > fatSlider.value) {
            [proSlider setValue:proValue];
        }
        
        carbLabel.text = [NSString stringWithFormat:@"%d%%",(int)carbSlider.value];
        proLabel.text = [NSString stringWithFormat:@"%d%%",(int)proSlider.value];
        fatLabel.text = [NSString stringWithFormat:@"%d%%",(int)fatSlider.value];
    }

    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:(int)carbSlider.value],@"carb", [NSNumber numberWithInt:(int)proSlider.value],@"pro", [NSNumber numberWithInt:(int)fatSlider.value],@"fat", nil];
    
    
    
    [mealSaveData setObject:dict forKey:@"macros"];
    [mealSaveData synchronize];
    
    [self setPieChart];
}

- (IBAction)proAction:(id)sender {
    
    proLabel.text = [NSString stringWithFormat:@"%d%%",(int)proSlider.value];
    int i = 100 - (proSlider.value + carbSlider.value + fatSlider.value);
    macroRemainingPercentLabel.text = [NSString stringWithFormat:@"(%d)",i];
    
    if ((proSlider.value + fatSlider.value + carbSlider.value) >101) {
        
        //compare between pro and fat values
        //highest one moves down
        float carbValue = 100 - (proSlider.value + fatSlider.value);
        float fatValue = 100 - (proSlider.value + carbSlider.value);
        
        if (carbSlider.value < fatSlider.value) {
            [fatSlider setValue:fatValue];
        } else if (carbSlider.value > fatSlider.value) {
            [carbSlider setValue:carbValue];
        }
        
        carbLabel.text = [NSString stringWithFormat:@"%d%%",(int)carbSlider.value];
        proLabel.text = [NSString stringWithFormat:@"%d%%",(int)proSlider.value];
        fatLabel.text = [NSString stringWithFormat:@"%d%%",(int)fatSlider.value];
    }
 
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:(int)carbSlider.value],@"carb", [NSNumber numberWithInt:(int)proSlider.value],@"pro", [NSNumber numberWithInt:(int)fatSlider.value],@"fat", nil];
    
    [mealSaveData setObject:dict forKey:@"macros"];
    [mealSaveData synchronize];
    
    [self setPieChart];
}

- (IBAction)fatAction:(id)sender {
    
    fatLabel.text = [NSString stringWithFormat:@"%d%%",(int)fatSlider.value];
    int i = 100 - (proSlider.value + carbSlider.value + fatSlider.value);
    macroRemainingPercentLabel.text = [NSString stringWithFormat:@"(%d)",i];
    
    if ((proSlider.value + fatSlider.value + carbSlider.value) > 100) {
        
        //compare between pro and fat values
        //highest one moves down
        float carbValue = 100 - (fatSlider.value + proSlider.value);
        float proValue = 100 - (fatSlider.value + carbSlider.value);
        
        if (proSlider.value < carbSlider.value) {
            [carbSlider setValue:carbValue];
        } else if (proSlider.value > carbSlider.value) {
            [proSlider setValue:proValue];
        }
        
        carbLabel.text = [NSString stringWithFormat:@"%d%%",(int)carbSlider.value];
        proLabel.text = [NSString stringWithFormat:@"%d%%",(int)proSlider.value];
        fatLabel.text = [NSString stringWithFormat:@"%d%%",(int)fatSlider.value];
    }
 
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:(int)carbSlider.value],@"carb", [NSNumber numberWithInt:(int)proSlider.value],@"pro", [NSNumber numberWithInt:(int)fatSlider.value],@"fat", nil];
    
    [mealSaveData setObject:dict forKey:@"macros"];
    [mealSaveData synchronize];
    
    [self setPieChart];
}



-(void)setPieChart{
    
    
    
    //get variables
    NSNumber *carbn = [NSNumber numberWithInt:(int)carbSlider.value];
    NSNumber *pron = [NSNumber numberWithInt:(int)proSlider.value];
    NSNumber *fatn = [NSNumber numberWithInt:(int)fatSlider.value];
    
    
    //setcolors
    UIColor *carbColour = [UIColor colorWithRed:228.0f/255.0f
                                          green:159.0f/255.0f
                                           blue:61.0f/255.0f
                                          alpha:1.0f];
    UIColor *proColour = [UIColor colorWithRed:142.0f/255.0f
                                         green:195.0f/255.0f
                                          blue:228.0f/255.0f
                                         alpha:1.0f];
    UIColor *fatColour = [UIColor colorWithRed:184.0f/255.0f
                                         green:228.0f/255.0f
                                          blue:139.0f/255.0f
                                         alpha:1.0f];
    
    
    
    //pie
    VBPieChart *chart = [[VBPieChart alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
    //[self.view addSubview:chart];
    
    // Setup some options:
    //[chart setEnableStrokeColor:YES];
    [chart setHoleRadiusPrecent:0.0]; /* hole inside of chart */
    //[chart setLabelBloc;
    //[chart setLabelsPosition:1];
    
    
    // Prepare your data
    NSArray *chartValues = @[
                             @{@"name":@"Carb", @"value":carbn, @"color":carbColour},
                             @{@"name":@"Pro", @"value":pron, @"color":proColour},
                             @{@"name":@"Fat", @"value":fatn, @"color":fatColour}
                             ];
    
    // Present pie chart with animation
    if (([carbn  isEqual: @0]) || ([pron  isEqual: @0]) || ([fatn  isEqual: @0])) {
        
    } else {
        [chart setChartValues:chartValues animation:YES duration:0.9 options:VBPieChartAnimationFan];
        
        [self.macroPie addSubview:chart];
    }
    
    
}




//cell 4 - photo select + category

#pragma mark - Collection View (Photo Album and Categories)

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section


{
    if (collectionView == albumColView) {
        
        
        NSLog(@"numberofitems called");
        if (albumArray.count == 0) {
            return 2;
        } else if (albumArray.count != 0) {
            NSLog(@"numberofitems called");
            return albumArray.count+2;
        } else {
            return 0;
        }
        
        
    } else if (collectionView == catColView) {
        return catArray.count;

    } else {
        return 0;
    }
}




-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    if (collectionView == albumColView) {
        
        newMealListCollectionViewCell *cell = [albumColView dequeueReusableCellWithReuseIdentifier:@"1" forIndexPath:indexPath];
        newMealListCollectionViewCell *cell2 = [albumColView dequeueReusableCellWithReuseIdentifier:@"2" forIndexPath:indexPath];
        newMealListCollectionViewCell *cell3 = [albumColView dequeueReusableCellWithReuseIdentifier:@"3" forIndexPath:indexPath];
        
        
        
        NSLog(@"table sees this array count: %lu",(unsigned long)albumArray.count);
        
        
        if (albumArray.count == 0) {
            
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
        } else if (albumArray.count != 0) {
            
            //cell3.backgroundColor = [UIColor greenColor];
            //return cell3;
            
            
            if (indexPath.row == albumArray.count) {
                return cell;
            } else if (indexPath.row == albumArray.count+1) {
                return cell2;
            } else {
                
                
                if (selectedItem == indexPath.item) {
                    
                    cell3.imageView.image = [albumArray objectAtIndex:indexPath.row];
                    
                    cell3.backgroundColor = [UIColor greenColor];
                    
                    cell3.deleteButton.alpha=1;
                    return cell3;
                    
                } else  {
                    
                    cell3.imageView.image = [albumArray objectAtIndex:indexPath.row];
                    cell3.deleteButton.alpha=0;
                    
                    return cell3;
                }
                
                
            }
        } else {
            return 0;
        }
        
        
        //cat view cells..
    } else if (collectionView == catColView) {
        
        
        newMealListCollectionViewCell *catCell = [catColView dequeueReusableCellWithReuseIdentifier:@"catCell" forIndexPath:indexPath];
        
        
        
        NSString *catNameString = [[catArray objectAtIndex:indexPath.row]valueForKey:@"catName"];
    
        catCell.label.text = catNameString;
        
        
        if (catSelectionArray.count != 0) {

            
        int u = 0;
        int n;
        for (n=0; n<catSelectionArray.count; n++) {
         
            if ([[catSelectionArray objectAtIndex:n] isEqual:catNameString]) {
                
                u=1;
                
            } else {
            }
        }
            
            
            if (u==1) {
                UIColor *selectedColour = [UIColor colorWithRed:172.0f/255.0f
                                                      green:90.0f/255.0f
                                                       blue:79.0f/255.0f
                                                      alpha:1.0f];
                catCell.catBg.backgroundColor = selectedColour;
                
            } else {
                
            }

        }
        return catCell;

    } else {
        return 0;
    }
}




-(void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //had to use this method because the cell reuse kept displaying duplicates, so have to reset the cell when it goes off screen
    newMealListCollectionViewCell *catCell = [catColView dequeueReusableCellWithReuseIdentifier:@"catCell" forIndexPath:indexPath];
    
    catCell.label.backgroundColor = nil;
    
}



-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    if (collectionView == catColView) {
        
        //if object already in array
        if ([catSelectionArray containsObject:[[catArray objectAtIndex:indexPath.row]valueForKey:@"catName"]]) {
            NSLog(@"duplicate found");
            
            NSString *catNameString = [[catArray objectAtIndex:indexPath.row]valueForKey:@"catName"];
            [catSelectionArray removeObjectIdenticalTo:catNameString];
            
          //else add object
        } else {
            NSLog(@"cat added");
            NSString *catNameString = [[catArray objectAtIndex:indexPath.row]valueForKey:@"catName"];
            
            [catSelectionArray addObject:catNameString];
            
        }
        
        [catColView reloadItemsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil]];

        NSUserDefaults *newMealSave = [NSUserDefaults standardUserDefaults];
        [newMealSave setObject:catSelectionArray forKey:@"cats"];
        [newMealSave synchronize];
       
        NSLog(@"cat selected array: %@",catSelectionArray);
        NSLog(@"cell tappedd");
        

    } else {

        if (albumArray.count == 0) {
            
            switch (indexPath.row) {
                case 0:
                    //cell.backgroundColor = [UIColor redColor];
                    //cell
                    break;
                    
                case 1:
                    //cell2.backgroundColor = [UIColor blueColor];
                    //cell2
                    break;
                    
                default:
                    break;
            }
        } else if (albumArray.count != 0) {
            

            if (indexPath.row == albumArray.count) {
                //cell (camera cell)
            } else if (indexPath.row == albumArray.count+1) {
                //cell2 (album cell)
            } else {
                
                //cell 3 (image cell)
                
                if (selectedItem == [[NSNumber numberWithLong:indexPath.item]intValue]) {
                    selectedItem = -1;
                    [albumColView reloadData];
                } else {
                    
                    selectedItem = [[NSNumber numberWithLong:indexPath.item]intValue];
                    deleteIndexPath = indexPath;
                    [albumColView reloadData];
                    //[cell3.deleteButton setAlpha:1];
                    
                    NSLog(@"image tapped");
                }
                
            }
        } else {
        }
    }
}



-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (collectionView == catColView) {
        return CGSizeMake(125, 35);
    } else {
        return CGSizeMake(100, 100);
    }
}




-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    
    if (collectionView == catColView) {
        return 0;
    } else {
        return 10;
    }
}



- (IBAction)deletePicAction:(id)sender {

    
    [albumArray removeObjectAtIndex:selectedItem];
    [thumbArray removeObjectAtIndex:selectedItem];

    [albumColView reloadData];

    //update data
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:albumArray];    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:data forKey:@"array"];
    
    NSData *thumbData = [NSKeyedArchiver archivedDataWithRootObject:thumbArray];
    [defaults setObject:thumbData forKey:@"arrayThumbs"];
    
    
    [defaults synchronize];

}





@end