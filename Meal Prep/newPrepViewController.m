//
//  newPrepViewController.m
//  Meal Prep
//
//  Created by Naveed Ahmed on 05/09/2016.
//  Copyright © 2016 Naveed Ahmed. All rights reserved.
//

#import "newPrepViewController.h"

@interface newPrepViewController ()

@end

@implementation newPrepViewController

@synthesize managedObjectModel,managedObjectContext,persistentStoreCoordinator, prepTableView,completeCookingView,completePreppingButton, sentObj, showSteps,stepsArray,stepsCount, mealPrep, prepDatesArray,prepDatesArrayPreFormat, selectedDate, mealPrepToBeUpdated,pickerViewArray,pickerView, pickerValue, cookedQuantity, headerLabel, surplusMealPreps, surplusMealPrepsPreFormat, SurplusPrepToBePlanned, allPrepped, navBar,

    prepTableY,prepTableHeight,prepTableWidth, headerLabelx,headerLabely,headerLabelWidth,headerLabelHeight,pickerViewx,pickerViewy,pickerViewWidth,pickerViewHeight,confirmButtonx,confirmButtony,confirmButtonWidth,confirmButtonHeight;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    managedObjectContext = [appDelegate managedObjectContext];
    
    mealPrep = (MealPrep *)sentObj;
    
    completeCookingView.alpha = 0;

    
    [navBar setBackgroundImage:[UIImage imageNamed:@"navbar_bg"]
                forBarPosition:UIBarPositionAny
                    barMetrics:UIBarMetricsDefault];
    
    [navBar setShadowImage:[UIImage new]];
    
    

    [self setThePrepDatesArray];
    [self setTheSurplusMealsArray];
    [self setTheStepsArray];
    
    //picker view data
    pickerViewArray = [NSArray arrayWithObjects:@"None", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8",@"9", @"10", nil];
    
    
    
    

}



-(void)viewWillAppear:(BOOL)animated {
    
    NSString *mealNameString = [NSString stringWithFormat:@"%@",[mealPrep mealName]];
    NSUserDefaults *object = [NSUserDefaults standardUserDefaults];
    [object setObject:mealNameString forKey:@"mealName"];
    [object synchronize];
    
    
    CGRectMake(0, 44, 320, 463);
    
    CGRectMake(195, 305, 130, 35);
    
    //set layout variables for device screensize
    int screenHeight = [UIScreen mainScreen].bounds.size.height;
    double scrollViewWidth;
    //set the correct storyboard for the app
    switch (screenHeight) {
            
            //iphone 4s
        case 480:
            prepTableWidth = 320;
            prepTableHeight = 355;
            prepTableY = 64;
            
            headerLabelx = 10;
            headerLabely = 10;
            headerLabelWidth = 300;
            headerLabelHeight = 40;
            
            pickerViewx = 80;
            pickerViewy = 70;
            pickerViewWidth = 165;
            pickerViewHeight = 200;
            
            confirmButtonx = 185;
            confirmButtony = 305;
            confirmButtonWidth = 130;
            confirmButtonHeight = 35;
            break;
            //iphone 5s
        case 568:
            prepTableWidth = 320;
            prepTableHeight = 445;
            prepTableY = 64;
            
            headerLabelx = 10;
            headerLabely = 10;
            headerLabelWidth = 300;
            headerLabelHeight = 40;
            
            pickerViewx = 80;
            pickerViewy = 70;
            pickerViewWidth = 165;
            pickerViewHeight = 200;
            
            confirmButtonx = 195;
            confirmButtony = 305;
            confirmButtonWidth = 130;
            confirmButtonHeight = 35;
            
            break;
            //iphone 6s
        case 667:
            prepTableWidth = 375;
            prepTableHeight = 545;
            prepTableY = 64;
            
            headerLabelx = 10;
            headerLabely = 10;
            headerLabelWidth = 355;
            headerLabelHeight = 40;
            
            pickerViewx = 100;
            pickerViewy = 70;
            pickerViewWidth = 165;
            pickerViewHeight = 200;
            
            confirmButtonx = 220;
            confirmButtony = 305;
            confirmButtonWidth = 130;
            confirmButtonHeight = 35;
            break;
            //iphone 6s Plus
        case 736:
            prepTableWidth = 414;
            prepTableHeight = 613;
            prepTableY = 64;
            
            headerLabelx = 10;
            headerLabely = 10;
            headerLabelWidth = 400;
            headerLabelHeight = 40;
            
            pickerViewx = 125;
            pickerViewy = 70;
            pickerViewWidth = 165;
            pickerViewHeight = 200;
            
            confirmButtonx = 265;
            confirmButtony = 305;
            confirmButtonWidth = 130;
            confirmButtonHeight = 35;
            break;
        default:
            scrollViewWidth = 640;
            break;
    }
    
    
}




-(void)setThePrepDatesArray {
    
    //fetch the current preps that need to be made (from current date)
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MealPrep" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"mealName == %@", [sentObj valueForKey:@"mealName"]];
    NSDate *setdate = [[NSDate alloc]init];
    NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"dateToBeEaten > %@", setdate];
    NSCompoundPredicate *compPred = [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects:predicate,predicate2, nil]];
    
    [fetchRequest setPredicate:compPred];
    // Specify how the fetched objects should be sorted
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateToBeEaten" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        //
    }
    
    
    prepDatesArray = [[NSMutableArray alloc]init];
    prepDatesArrayPreFormat = [[NSMutableArray alloc]initWithArray:fetchedObjects];
    
    
    //formatting the date that will be displayed
    int n;
    for (n=0; n<fetchedObjects.count; n++) {
        
        //date
        NSDateFormatter *formatDate = [[NSDateFormatter alloc]init];
        [formatDate setDateFormat:@"dd/MM/YY"];
        NSString *formattedDate = [formatDate stringFromDate:[[fetchedObjects objectAtIndex:n]valueForKey:@"dateToBeEaten"]];
        
        //hour
        NSDateFormatter *formatHour = [[NSDateFormatter alloc]init];
        [formatHour setDateFormat:@"HH:mm"];
        
        
        NSString *prepDate = [NSString stringWithFormat:@"%@",formattedDate];
        //add formatted date to the array
        [prepDatesArray addObject:prepDate];
    }
    
    
    //set cook now info
    allPrepped = 0;
    int i;
    for (i=0; i<prepDatesArrayPreFormat.count; i++) {
        
        if ([[prepDatesArrayPreFormat objectAtIndex:i]valueForKey:@"datePrepped"]) {
            allPrepped ++; //determines if there are any prepped still to be  cooked
        }
    }
}



-(void)setTheSurplusMealsArray {
    
    
    //fetch the current preps that need to be made (from current date)
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MealPrep" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"mealName == %@", [sentObj valueForKey:@"mealName"]];
    
    
    
    //PREDICATES
    //we need to get meals that were cooked a certain number of days ago, for now 7,
    //so any meal cooked 3 days earlier without a planned date..
    NSDate *setdate = [[NSDate alloc]init];
    
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = -3;
    
    NSCalendar *theCalendar = [NSCalendar autoupdatingCurrentCalendar];
    setdate = [theCalendar dateByAddingComponents:dayComponent toDate:setdate options:0];
    
    
    NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"dateToBeEaten == %@", nil];
    NSPredicate *predicate3 = [NSPredicate predicateWithFormat:@"datePrepped > %@",setdate];
    NSCompoundPredicate *compPred = [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects:predicate,predicate2, predicate3, nil]];
    
    [fetchRequest setPredicate:compPred];
    // Specify how the fetched objects should be sorted
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"datePrepped" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        //
    }
    
    surplusMealPreps = [[NSMutableArray alloc]init];
    surplusMealPrepsPreFormat = [[NSMutableArray alloc]initWithArray:fetchedObjects];
    
    
    //formatting the date that will be displayed
    int n;
    for (n=0; n<fetchedObjects.count; n++) {
        
        //date
        NSDateFormatter *formatDate = [[NSDateFormatter alloc]init];
        [formatDate setDateFormat:@"dd/MM/YY"];
        NSString *formattedDate = [formatDate stringFromDate:[[fetchedObjects objectAtIndex:n]valueForKey:@"datePrepped"]];
        

        
        NSString *prepDate = [NSString stringWithFormat:@"%@",formattedDate];
        //add formatted date to the array
        [surplusMealPreps addObject:prepDate];
    
    }
}




-(void)setTheStepsArray {
    
    mealPrep = (MealPrep *)sentObj;
    
    NSArray *array = [[NSArray alloc]initWithArray:[[mealPrep valueForKeyPath:@"meal.mealSteps"]allObjects]];
    stepsArray = [[NSMutableArray alloc]initWithArray:array];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"position" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc]initWithObjects:sortDescriptor, nil];
    [stepsArray sortUsingDescriptors:sortDescriptors];
    
    stepsCount = stepsArray.count;
  
}








#pragma mark - Table View

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 5;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            //meal info
            if (showSteps) {
                return 1;
            } else {
                return 1;
            }
            
            break;
            
        case 1:
            //dates cell
            if (showSteps) {
                return 0;
            } else {
                return prepDatesArray.count;
            }
            
            break;
            
        case 2:
            //surplus meals
            if (showSteps) {
                return 0;
            } else {
                if (surplusMealPreps) {
                    return surplusMealPreps.count;
                } else {
                    return 0;
                }
            }
            break;

        case 3:
            //cook now cell
            if (showSteps) { //change to if datesArray
                return 0;
            } else {
                return 1;
            }
            break;

        case 4:
            //steps cell
            if (showSteps) {
                return stepsArray.count;
            } else {
                return 0;
            }
            break;

        default:
            return 0;
            break;
    }
}







-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //section 1 - meal info
    mealPrepInfoTableViewCell *mealInfoCell = [prepTableView dequeueReusableCellWithIdentifier:@"mealInfo"];
    mealPrepBasicTableViewCell *mealBasicCell = [prepTableView dequeueReusableCellWithIdentifier:@"mealBasic"];
    //section 2 - date cells
    prepDateTableViewCell *prepDateCell = [prepTableView dequeueReusableCellWithIdentifier:@"prepDate"];
    cookedDateTableViewCell *cookedDateCell = [prepTableView dequeueReusableCellWithIdentifier:@"cookedDate"];
    changeDateTableViewCell *changeDateCell = [prepTableView dequeueReusableCellWithIdentifier:@"changeDate"];
    //section 3 - surplus meals
    surplusPrepTableViewCell *surplusPrepCell = [prepTableView dequeueReusableCellWithIdentifier:@"surplusPrep"];
    surplusPlanDateTableViewCell *surplusPlanDateCell = [prepTableView dequeueReusableCellWithIdentifier:@"surplusPlanDate"];
    //section 4 - cook now cell
    cookNowTableViewCell *cookNowCell = [prepTableView dequeueReusableCellWithIdentifier:@"cookNow"];
    //section 5 - steps cell
    stepsTableViewCell *stepsCell = [prepTableView dequeueReusableCellWithIdentifier:@"stepsCell"];
    

    //displays default image for the meal
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"defaultImage = %@",[NSNumber numberWithBool:YES]];
    
    NSManagedObject *mealImageMo = [[[mealPrep valueForKeyPath:@"meal.mealImage"]filteredSetUsingPredicate:pred]anyObject];
    
    UIImage *theDefaultImage = [mealImageMo valueForKey:@"mealImage"];
    
    
    switch (indexPath.section) {
        case 0:
            
            if (showSteps) {
                if (mealBasicCell == nil) {
                    mealBasicCell = [[mealPrepBasicTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mealBasic"];
                }
                
                mealBasicCell.prepMealName.text = [mealPrep mealName];
                mealBasicCell.servingsNeededLabel.text = @"2 Servings Needed";
                return mealBasicCell;
            } else {
                if (mealInfoCell == nil) {
                    mealInfoCell = [[mealPrepInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mealInfo"];
                }
                
                mealInfoCell.mealNameLabel.text = [mealPrep mealName];
                mealInfoCell.mealImageView.image = theDefaultImage;
                return mealInfoCell;
            }
            break;
            
            
        case 1:
            //dates cells
            if (showSteps) {
                return 0;
            } else {
                //this will show the dates, also need to determine which dates cell will display depending if dateprepped and then if dateprepped and tapped
                
                if ([[prepDatesArrayPreFormat objectAtIndex:indexPath.row]valueForKey:@"datePrepped"]) {
                    
                    if (indexPath == selectedDate) {
                        
                        
                        if (changeDateCell == nil) {
                            changeDateCell = [[changeDateTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"changeDate"];
                        }
                        
                        changeDateCell.prepDateLabel.text = [prepDatesArray objectAtIndex:indexPath.row];
                        changeDateCell.prepTimeLabel.text = [NSString stringWithFormat:@"Time: %@:00",[[prepDatesArrayPreFormat objectAtIndex:indexPath.row]valueForKey:@"dateToBeEatenHour"]];
                        changeDateCell.changeDateLabel.text = [NSString stringWithFormat:@"Cooked on: %@",[[prepDatesArrayPreFormat objectAtIndex:indexPath.row]valueForKey:@"datePreppedDate"]];
                        
                        changeDateCell.datePicker.minimumDate = [NSDate date];

                        changeDateCell.datePicker.date = [[prepDatesArrayPreFormat objectAtIndex:indexPath.row]valueForKey:@"datePrepped"];
                        
                        
                        
                        
                        changeDateCell.datePicker.backgroundColor = [UIColor clearColor];
                        
                        return changeDateCell;
                    } else {
                    
                    if (prepDateCell == nil) {
                        prepDateCell = [[prepDateTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cookedDate"];
                    }
                    
                    cookedDateCell.prepDateLabel.text = [prepDatesArray objectAtIndex:indexPath.row];
                    cookedDateCell.prepTimeLabel.text = [NSString stringWithFormat:@"Time: %@:00",[[prepDatesArrayPreFormat objectAtIndex:indexPath.row]valueForKey:@"dateToBeEatenHour"]];
                    cookedDateCell.cookedDateLabel.text = [NSString stringWithFormat:@"Cooked on: %@",[[prepDatesArrayPreFormat objectAtIndex:indexPath.row]valueForKey:@"datePreppedDate"]];
                   
  
                        
                    
                    return cookedDateCell;
                    }
                    
                } else {
                    
                    if (prepDateCell == nil) {
                        prepDateCell = [[prepDateTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"prepDate"];
                    }
                    prepDateCell.prepDateLabel.text = [prepDatesArray objectAtIndex:indexPath.row];
                    prepDateCell.prepTimeLabel.text = [NSString stringWithFormat:@"Time: %@:00",[[prepDatesArrayPreFormat objectAtIndex:indexPath.row]valueForKey:@"dateToBeEatenHour"]];
                    return prepDateCell;
                }
            }
            break;
            
            
        case 2:
            //surplus meals
            if (showSteps) {
                return 0;
            } else {
                if (surplusMealPreps) {
                    
                    
                    
                    if (indexPath == selectedDate) {
                        
                        
                        if (surplusPlanDateCell == nil) {
                            surplusPlanDateCell = [[surplusPlanDateTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"surplusPlanDate"];
                        }
                        
                        surplusPlanDateCell.cookedDateLabel.text = [NSString stringWithFormat:@"Cooked on: %@",[surplusMealPreps objectAtIndex:indexPath.row]];
                        surplusPlanDateCell.planDatePicker.minimumDate = [NSDate date];
                        surplusPlanDateCell.planDatePicker.backgroundColor = [UIColor clearColor];
                        
                        return surplusPlanDateCell;
                    } else {
                        
                        if (surplusPrepCell == nil) {
                            surplusPrepCell = [[surplusPrepTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"surplusPrep"];
                        }
                        
                        surplusPrepCell.unplannedMealLabel.text = [NSString stringWithFormat:@"Unplanned Prep %ld",indexPath.row+1];
                        
                        surplusPrepCell.cookedDateLabel.text = [NSString stringWithFormat:@"Cooked on: %@",[surplusMealPreps objectAtIndex:indexPath.row]];
                        
                        return surplusPrepCell;
                    }
                    
                } else {
                    return 0;
                }
            }
            break;
            
        case 3:
            //cook now button
            if (showSteps) {
                return 0;
            } else {
                if (cookNowCell == nil) {
                    cookNowCell = [[cookNowTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cookNow"];
                }
                
                //if all meals cooked, say 'all meals have been cooked, cook more?
                
                if (allPrepped == prepDatesArrayPreFormat.count) {
                    cookNowCell.cookNowLabel.text = @"All Meals Are Prepped, Cook More?";
                } else {
                    int i = (int)prepDatesArrayPreFormat.count - allPrepped;
                    
                    //display label with correct number of meals to be prepped
                    if (i==1) {
                        cookNowCell.cookNowLabel.text = [NSString stringWithFormat:@"1 meal needs to be prepped. Begin prepping for above dates?"];
                    } else {
                        cookNowCell.cookNowLabel.text = [NSString stringWithFormat:@"%d meals need to be prepped. Begin prepping for above dates?",i];
                    }
                }
                
                
                return cookNowCell;
            }
            break;
            
        case 4:
            //steps cells
            if (showSteps) {
                if (stepsCell == nil) {
                    stepsCell = [[stepsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"stepsCell"];
                }
                stepsCell.stepPosition.text = [NSString stringWithFormat:@"%@", [[stepsArray objectAtIndex:indexPath.row]valueForKey:@"position"]];
                stepsCell.stepLabel.text = [NSString stringWithFormat:@"%@", [[stepsArray objectAtIndex:indexPath.row]valueForKey:@"step" ]];
                return stepsCell;
            } else {
                return 0;
            }
            break;
        default:
            return mealInfoCell;
            break;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    stepsTableViewCell *stepsCell = [prepTableView dequeueReusableCellWithIdentifier:@"stepsCell"];

    switch (indexPath.section) {
        case 0:
            //segue to meal detail vc
            break;

        case 1:
            //dates

                //this will show the dates, also need to determine which dates cell will display depending if dateprepped and then if dateprepped and tapped
                
                if ([[prepDatesArrayPreFormat objectAtIndex:indexPath.row]valueForKey:@"datePrepped"]) {
                    
                    if (indexPath == selectedDate) {
 
                        selectedDate = nil;
                        //reload
                        
                        NSIndexPath *indexa = indexPath;
                        NSArray *array = [NSArray arrayWithObjects:indexa, nil];
                        
                        [prepTableView beginUpdates];
                        [prepTableView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationFade];
                        [prepTableView reloadData];
                        [prepTableView endUpdates];

                    } else {
                        
                        selectedDate = indexPath;
                        
                        NSIndexPath *indexa = indexPath;
                        NSArray *array = [NSArray arrayWithObjects:indexa, nil];
                        
                        [prepTableView beginUpdates];
                        [prepTableView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationFade];
                        [prepTableView reloadData];
                        [prepTableView endUpdates];
                    }
                    
                } else {
                }
     
            break;
            
        case 2:
            //surplus meals
            if (showSteps) {
                
            } else {
                
                if (indexPath == selectedDate) {
                    
                    selectedDate = nil;
                    //reload
                    
                    NSIndexPath *indexa = indexPath;
                    NSArray *array = [NSArray arrayWithObjects:indexa, nil];
                    
                    [prepTableView beginUpdates];
                    [prepTableView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationFade];
                    [prepTableView reloadData];
                    [prepTableView endUpdates];
                    
                } else {
                    
                    selectedDate = indexPath;
                    
                    NSIndexPath *indexa = indexPath;
                    NSArray *array = [NSArray arrayWithObjects:indexa, nil];
                    
                    [prepTableView beginUpdates];
                    [prepTableView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationFade];
                    [prepTableView reloadData];
                    [prepTableView endUpdates];
                }

                
            }
            break;
      
        case 3:
            //cook now
            if (showSteps) {
                
            } else {
                
            }
            break;
            
            
        case 4:
            //steps cells
            if (showSteps) {
                stepsCell.backgroundColor = [UIColor redColor];
            } else {
                
            }
            break;
            
        default:
            break;
    }
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    switch (indexPath.section) {
    case 0:
        
        if (showSteps) {
            return 132;
        } else {
            return 199;
        }
        break;

    case 1:
        //dates cell
        if (showSteps) {
                return 0;
            } else {
                
                if ([[prepDatesArrayPreFormat objectAtIndex:indexPath.row]valueForKey:@"datePrepped"]) {
                    
                    if (indexPath == selectedDate) {
                        return 285; //updateDateCell;
                    } else {
                    
                    return 76; //cookedDateCell
                    }
                } else {
                    return 54; //prepDateCell
                }
            }
            
            break;
            
    case 2:
        //surplus meals
        if (showSteps) {
            return 0;
        } else {
            if (indexPath == selectedDate) {
                return 270;
            } else {
                return 103;
            }
        }
        break;
            
        
    case 3:
        //cook now cell
        if (showSteps) { //change to if datesArray
            return 0;
        } else {
            return 64;
        }
        break;
            
    case 4:
        //steps cell
        if (showSteps) {
            return 99;
        } else {
            return 0;
        }
        break;
            
            
    default:
            return 100;;
        break;
    }
}



#pragma mark - Cook now cell

- (IBAction)cookNowAction:(id)sender {
    
    showSteps = 1;
    [prepTableView reloadData];
    completeCookingView.alpha = 1;
    
    [prepTableView setFrame:CGRectMake(0, prepTableY, prepTableWidth, prepTableHeight)];

}



- (IBAction)completePreppingAction:(id)sender {
    
    completePreppingButton.alpha = 0;
    
    [UIView animateKeyframesWithDuration:0.4 delay:0.0 options:0 animations:^{
        completeCookingView.frame = CGRectMake(completeCookingView.frame.origin.x, completeCookingView.frame.origin.y-300, completeCookingView.frame.size.width, completeCookingView.frame.size.height+300);
    } completion:^(BOOL finished) {
    }];
    
    
    
    
    //create label
    headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(headerLabelx, headerLabely, headerLabelWidth, headerLabelHeight)];
    headerLabel.text = @"How many servings have you cooked?";
    //headerLabel.font = [UIFont fontWithName:@"" size:20];
    [headerLabel setTextAlignment:NSTextAlignmentCenter];
    [self.completeCookingView addSubview:headerLabel];
    headerLabel.alpha = 1;
    
    
    //create pickerview and place on completeCookingView UIView
    pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(pickerViewx, pickerViewy, pickerViewWidth, pickerViewHeight)];
    pickerView.backgroundColor = [UIColor whiteColor];
    [pickerView setDelegate:self];
    [pickerView setDataSource:self];
    [self.completeCookingView addSubview:pickerView];
    pickerView.alpha = 1;
    
    
    //add confirm button to the view
    UIButton *confirmButton = [[UIButton alloc]initWithFrame:CGRectMake(confirmButtonx, confirmButtony, confirmButtonWidth, confirmButtonHeight)];
    
    [confirmButton.titleLabel setTextColor:[UIColor whiteColor]];
    confirmButton.titleLabel.text = @"Confirm";
    confirmButton.backgroundColor = [UIColor colorWithRed:69.0f/255.0f green:146.0f/255.0f blue:206.0f/255.0f alpha:1];
    confirmButton .titleLabel.backgroundColor = [UIColor whiteColor];
    [confirmButton addTarget:self action:@selector(confirmButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.completeCookingView addSubview:confirmButton];
}


-(void)confirmButtonAction {
    
    //get picker value
    NSLog(@"picker value: %d",pickerValue);
    
    
    //format date for datePreppedDate value
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/YYYY"];
    NSString *formattedDateString = [dateFormatter stringFromDate:[NSDate date]];
    
    //set new dates for previously uncooked meals
    int n;
    for (n=0; n<prepDatesArrayPreFormat.count; n++) {
        
        if (pickerValue) {
            MealPrep *mealPrepCooked = (MealPrep *)[prepDatesArrayPreFormat objectAtIndex:n];
            
            if ([mealPrepCooked datePrepped] == nil) {
                [mealPrepCooked setDatePrepped:[NSDate date]];
                [mealPrepCooked setDatePreppedDate:formattedDateString];
                pickerValue --;
                
                //save data
                NSError *error = nil;
                if (![managedObjectContext save:&error]) {
                    //handle error
                }
            }
        }
    }
    
    
    //set any surplus meals
    if (pickerValue) {
        int s;
        for (s=0; s<pickerValue; s++) {
            
            MealPrep *mealSurplus = [NSEntityDescription insertNewObjectForEntityForName:@"MealPrep" inManagedObjectContext:managedObjectContext];
            [mealSurplus setMeal:[mealPrep meal]];
            [mealSurplus setDatePrepped:[NSDate date]];
            [mealSurplus setDatePreppedDate:formattedDateString];
            [mealSurplus setMealName:[mealPrep mealName]];
            
            
            //save data
            NSError *error = nil;
            if (![managedObjectContext save:&error]) {
                //handle error
            }
        }
    }
    
    
    //save data
    NSError *error = nil;
    if (![managedObjectContext save:&error]) {
        //handle error
    }
    
    //reload array
    [self setTheSurplusMealsArray];
    
    
    //close view and reload table
    [UIView animateKeyframesWithDuration:0.4 delay:0.0 options:0 animations:^{
        completeCookingView.frame = CGRectMake(completeCookingView.frame.origin.x, completeCookingView.frame.origin.y+300, completeCookingView.frame.size.width, completeCookingView.frame.size.height);
        headerLabel.text = @"Thank you :)";
        
    } completion:^(BOOL finished) {
        
        showSteps = 0;
        [prepTableView reloadData];
        completeCookingView.alpha = 0;
        headerLabel.alpha = 0;
        pickerView.alpha = 0;
        completePreppingButton.alpha = 1;
    }];

    
    [prepTableView setFrame:CGRectMake(0, 64, 320, 524)];
}


#pragma mark - Picker View

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return pickerViewArray.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [pickerViewArray objectAtIndex:row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    pickerValue = (int)row;
    NSLog(@"picker value: %d",pickerValue);
}



#pragma mark - Change date cell actions


- (IBAction)deleteDateAction:(id)sender {
    
    
    mealPrepToBeUpdated = (MealPrep *)[prepDatesArrayPreFormat objectAtIndex:selectedDate.row];
    
    //update prep
    [mealPrepToBeUpdated setDatePrepped:nil];
    [mealPrepToBeUpdated setDatePreppedDate:nil];
    //save data
    NSError *error = nil;
    if (![managedObjectContext save:&error]) {
        //handle error
    }
    
    
    
    NSIndexPath *indexa = selectedDate;
    NSArray *array = [NSArray arrayWithObjects:indexa, nil];
    
    selectedDate = nil;
    [prepTableView beginUpdates];
    [prepTableView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationFade];
    [prepTableView reloadData];
    [prepTableView endUpdates];
    
}




- (IBAction)updateDateAction:(id)sender {
    
    //set the mealprep to be updated using the selectedDate variable
    mealPrepToBeUpdated = (MealPrep *)[prepDatesArrayPreFormat objectAtIndex:selectedDate.row];
    
    ///get nsuserdefault value from the picker view value change method
    NSUserDefaults *pickerValueDefault = [NSUserDefaults standardUserDefaults];
    NSDate *updatedDate = [[NSDate alloc]init];
    updatedDate = [pickerValueDefault objectForKey:@"pickerValue"];
    NSLog(@"Updated Date is: %@",updatedDate);
    
    
    //format date for datePreppedDate value
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/YYYY"];
    NSString *formattedDateString = [dateFormatter stringFromDate:[NSDate date]];
    
    
    ///update the meal prep
    [mealPrepToBeUpdated setDatePrepped:updatedDate];
    [mealPrepToBeUpdated setDatePreppedDate:formattedDateString];
    //save data
    NSError *error = nil;
    if (![managedObjectContext save:&error]) {
        //handle error
    }
    
    //reload cell
    NSIndexPath *indexa = selectedDate;
    NSArray *array = [NSArray arrayWithObjects:indexa, nil];
    selectedDate = nil;
    [prepTableView beginUpdates];
    [prepTableView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationFade];
    [prepTableView reloadData];
    [prepTableView endUpdates];
    
}




#pragma mark - Change Surplus Plan Time Actions

- (IBAction)deleteSurplusPrepAction:(id)sender {
    
    NSManagedObject *prepToBeDeleted = (MealPrep *)[surplusMealPrepsPreFormat objectAtIndex:selectedDate.row];
    
    //delete the meal here
    [managedObjectContext deleteObject:prepToBeDeleted];
    NSError *erro = nil;
    if (![managedObjectContext save:&erro]) {
        //handle error
    } else {
        
    }


    [self setTheSurplusMealsArray];
    
    NSIndexPath *indexa = selectedDate;
    NSArray *array = [NSArray arrayWithObjects:indexa, nil];
    
    selectedDate = nil;
    [prepTableView beginUpdates];
    [prepTableView deleteRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationFade];
    [prepTableView reloadData];
    [prepTableView endUpdates];

    
    [prepTableView reloadData];
}


- (IBAction)addSurplusPlanDateAction:(id)sender {
    
    //set the mealprep to be updated using the selectedDate variable
    mealPrepToBeUpdated = (MealPrep *)[surplusMealPrepsPreFormat objectAtIndex:selectedDate.row];
    
    ///get nsuserdefault value from the picker view value change method
    NSUserDefaults *pickerValueDefault = [NSUserDefaults standardUserDefaults];
    NSDate *updatedDate = [[NSDate alloc]init];
    updatedDate = [pickerValueDefault objectForKey:@"planDateValue"];
    NSLog(@"Updated Date is: %@",updatedDate);
    
    ///update the meal prep
    [mealPrepToBeUpdated setDateToBeEaten:updatedDate];
    
    
    //set new field, for just the date
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd MMM YYYY"];
    NSString *formattedDateString = [dateFormatter stringFromDate:updatedDate];
    [mealPrepToBeUpdated setDateToBeEatenDate:formattedDateString];
    
    
    //set new field just for the hour
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"HH"];
    NSString *formattedHour = [df stringFromDate:updatedDate];
    [mealPrepToBeUpdated setDateToBeEatenHour:formattedHour];

    //save data
    NSError *error = nil;
    if (![managedObjectContext save:&error]) {
        //handle error
    }
    
    [self setTheSurplusMealsArray];
    [self setThePrepDatesArray];

    selectedDate = nil;
    [prepTableView reloadData];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//close view
- (IBAction)closeViewAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        //
    }];
}


@end
