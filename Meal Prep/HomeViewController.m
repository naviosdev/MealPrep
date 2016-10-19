//
//  HomeViewController.m
//  Meal Prep
//
//  Created by Naveed Ahmed on 23/07/2016.
//  Copyright © 2016 Naveed Ahmed. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

@synthesize prepArray, mainTable, managedObjectContext, managedObjectModel, persistentStoreCoordinator, sectionHeaders, dict1, sendObj,homeScrollView,homeViewPageControl, homeView, homeViewSurplusTable, surplusPrepArray, numberToPrepLabel, totalMealsLabel, tapToPrepLabel, numberOfSurplusMealsLabel, numberOfPreppedMeals, numberOfMealsPlanned, progressViewseg, progressPercentage, noPrepsImageView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"Food Prepper";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(newMealPrep)];

    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    managedObjectContext = [appDelegate managedObjectContext];
    
    sendObj = nil;
    
    
    //set the scroll view
    int screenHeight = [UIScreen mainScreen].bounds.size.height;
    double scrollViewWidth;
    //set the correct storyboard for the app
    switch (screenHeight) {
            
            //iphone 4s
        case 480:
            scrollViewWidth = 640;
            break;
            //iphone 5s
        case 568:
            scrollViewWidth = 640;
            break;
            //iphone 6s
        case 667:
            scrollViewWidth = 750;
            break;
            //iphone 6s Plus
        case 736:
            scrollViewWidth = 828;
            break;
        default:
            scrollViewWidth = 640;
            break;
    }

    [homeScrollView setContentSize:CGSizeMake(scrollViewWidth, 148)];
    [homeScrollView setScrollEnabled:YES];
    [homeScrollView setPagingEnabled:YES];
    [homeScrollView setShowsHorizontalScrollIndicator:NO];
    [self.homeScrollView setDelegate:self];
    
    [self getNumberOfMealsToBeCooked];
    
    
    
}


//this method reloads table if any meals have been added from the calendar
-(void)viewWillAppear:(BOOL)animated {
    [self getTableAndSectionData];
    [self setTheSurplusPrepArray];
    [self getNumberOfMealsToBeCooked];
    [mainTable reloadData];
}


-(void)viewDidDisappear:(BOOL)animated {
    //removes progress view, so a new progress view updates correctly when returning to home view controller
    [self.progressViewseg removeFromSuperview];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = self.homeScrollView.frame.size.width;     float fractionalPage = self.homeScrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    self.homeViewPageControl.currentPage = page;
    
    [homeViewSurplusTable reloadData];
}


-(NSMutableArray *)getTableAndSectionData {

    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *mealPrep = [NSEntityDescription entityForName:@"MealPrep" inManagedObjectContext:managedObjectContext];
    [request setEntity:mealPrep];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"dateToBeEaten" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc]initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    
    
    //only show future meals, past meals may need to be managed/archived automatically
    
    ///.....
    NSDate *setdate = [[NSDate alloc]init];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:(NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:setdate];
    [dateComponents setCalendar:[NSCalendar currentCalendar]];
    setdate = [[NSCalendar currentCalendar]dateFromComponents:dateComponents];
    
    NSLog(@"setdate: %@",setdate);
    //NSDate *date = [[NSDate alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"dateToBeEaten > %@", setdate];
    [request setPredicate:predicate];
    
    [request setReturnsObjectsAsFaults:NO];
    
    
    NSError *error = nil;
    NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error]mutableCopy];
    if (mutableFetchResults == nil) {
        
        //handle errorn
        NSLog(@"its nil");
    }
    
    //////////
    ////////
    
    prepArray = mutableFetchResults;
    
    NSLog(@"prepaaarray: %@",prepArray);
    
    

    if (prepArray.count > 0) {
        sectionHeaders = [[NSMutableArray alloc]init];
        [sectionHeaders addObject:[prepArray objectAtIndex:0]];
        
        NSLog(@"prepArray: %@",[prepArray valueForKey:@"dateToBeEatenDate"]);
        
        int a;
        
        for (a=1; a<prepArray.count; a++) {
            int b = a - 1;
            if ([[[prepArray objectAtIndex:a]valueForKey:@"dateToBeEatenDate"] isEqualToString:[[prepArray objectAtIndex:b]valueForKey:@"dateToBeEatenDate"]]) {
                
            } else {
                [sectionHeaders addObject:[prepArray objectAtIndex:a]];
            }
            NSLog(@"%@",[[prepArray objectAtIndex:a]valueForKey:@"dateToBeEatenDate"]);
            
        }
        
        NSLog(@"%@",[[prepArray objectAtIndex:0]valueForKey:@"dateToBeEatenDate"]);
        NSLog(@"section headers %@",[sectionHeaders valueForKey:@"dateToBeEatenDate"]);

        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        
        int i;
        for (i=0; i <sectionHeaders.count; i++) {
            
            NSString *sectionDate = [NSString stringWithFormat:@"%@",[[sectionHeaders objectAtIndex:i]valueForKey:@"dateToBeEatenDate"]];
            NSLog(@"section date string: %@",sectionDate);
            NSMutableArray *array = [[NSMutableArray alloc]init];
            
            int a;
            for (a = 0; a <prepArray.count; a++) {
                
                if ([[[prepArray objectAtIndex:a]valueForKey:@"dateToBeEatenDate"] isEqualToString:sectionDate]) {
                    [array addObject:[prepArray objectAtIndex:a]];
                    NSLog(@"sectionDate: %@",sectionDate);
                    NSLog(@"value: %@",[[prepArray objectAtIndex:a]valueForKey:@"dateToBeEatenDate"]);
                }
            }
            
            [dict setObject:array forKey:sectionDate];
        }
        NSLog(@"dict: %@",dict);
        
        dict1 = dict;
    } else {
        //if prep array is nil follow this code to stop from crashing
        prepArray = nil;
    }

    return prepArray;
}




-(void)getNumberOfMealsToBeCooked {

    numberOfMealsPlanned = (int)prepArray.count;
    numberOfPreppedMeals = 0;
    
    //sets numberOfPreppedMeals int varible
    if (prepArray.count > 0) {
        
        int i;
        for (i=0; i<prepArray.count; i++) {
            
            if ([[prepArray objectAtIndex:i]valueForKey:@"datePrepped"]) {
                numberOfPreppedMeals ++;
            }
        }
    }
    //both variables are now set
    
    //total meals label
    totalMealsLabel.text = [NSString stringWithFormat:@"%lu Meals Total",(unsigned long)prepArray.count];
    
    
    //now set labels
    if (prepArray.count == 0) {
        tapToPrepLabel.text = @"Tap + to add a new prep";
    } else {
        tapToPrepLabel.text = @"Tap meal below to begin prepping";
    }
    
    
    
    /*
    if (surplusPrepArray == nil) {
        [tapToPrepLabel setFrame:CGRectMake(158, 65, 154, 80)];
        tapToPrepLabel.frame = CGRectMake(158, 65, 154, 80);
    } else {
        [tapToPrepLabel setFrame:CGRectMake(158, 98, 154, 40)];
    }
    */
    
    
    NSLog(@"df: %d",numberOfMealsPlanned - numberOfPreppedMeals);
    
    //meals to prep label
    if (prepArray.count == 0) {
        numberToPrepLabel.text = @"No Meals Planned";
    } else if (prepArray.count > 0) {
        if ((numberOfMealsPlanned - numberOfPreppedMeals) == 0) {
            numberToPrepLabel.text = @"All Meals Prepped";
        } else if ((numberOfMealsPlanned - numberOfPreppedMeals) == 1) {
            numberToPrepLabel.text = [NSString stringWithFormat:@"1 Meal To Be Prepped"];
        } else if ((numberOfMealsPlanned - numberOfPreppedMeals) > 1) {
            numberToPrepLabel.text = [NSString stringWithFormat:@"%d Meals To Be Prepped",numberOfMealsPlanned - numberOfPreppedMeals];
        }
    }
    
    
    //percentage value for progress view
    progressPercentage = (CGFloat)numberOfPreppedMeals / (CGFloat)numberOfMealsPlanned;
    NSLog(@"percentage: %f",progressPercentage);
    
    
    //update progress view (if no meals prepped dont update?)
     if (prepArray.count > 0) {
         [self updateProgressView];
         noPrepsImageView.alpha = 0;
     } else {
         noPrepsImageView.alpha = 1;
     }
}



-(void)updateProgressView {
    
    // Create the progress view.
    progressViewseg = [[M13ProgressViewSegmentedRing alloc] initWithFrame:CGRectMake(30.0, 25.0, 100.0, 100.0)];
    
    // Add it to the view.
    [self.homeView addSubview: progressViewseg];
    
    // Update the progress as needed
    [progressViewseg setProgress: progressPercentage animated: YES];
    [progressViewseg setNumberOfSegments:(NSInteger)numberOfMealsPlanned];
    [progressViewseg setShowPercentage:YES];
    [progressViewseg setPrimaryColor:[UIColor colorWithRed:69.0f/255.0f green:146.0f/255.0f blue:206.0f/255.0f alpha:1]];
    [progressViewseg setAnimationDuration:1.3];
    [progressViewseg setSegmentSeparationAngle:1100];
    [progressViewseg setProgressRingWidth:15];
    
    if ([progressViewseg numberOfSegments]==1) {
        [progressViewseg setSegmentSeparationAngle:1175];
    }
}




-(NSString *)getTimeRemaining:(NSDate *)date {
    //retrieves how long left till meal for the home table view cell
    
    NSDate *now = [[NSDate alloc]init];
    NSDate *aDate = date;

    NSTimeInterval startTime = [aDate timeIntervalSinceReferenceDate];
    NSTimeInterval endTime = [now timeIntervalSinceReferenceDate];
    NSTimeInterval elapsed = startTime - endTime;
    
    //days left
    int days = (int)(elapsed / 86400);
    NSLog(@"days left: %i",days);
    elapsed -= days * 86400;
    NSLog(@"minus: %f",elapsed);
    //hours left
    int hour = (int)(elapsed /3600);
    NSLog(@"hours left: %i",hour);
    elapsed -= hour * 3600;
    //mins left
    int mins = (int)(elapsed / 60);
    NSLog(@"mins left: %i", mins);
    
    elapsed -= mins * 60;
    NSLog(@"seconds left: %i", (int)elapsed);
    
    if ((startTime - endTime) < 86400) {
        return [NSString stringWithFormat:@"%ihrs, %imins till meal",hour,mins];
    } else if ((startTime - endTime) > 86400 && (startTime-endTime) < 172800) {
        return [NSString stringWithFormat:@"%i Day, %ihrs till meal",days,hour];
    } else {
        return [NSString stringWithFormat:@"%i Days, %ihrs till meal",days,hour];
    }
}



-(void)setTheSurplusPrepArray {
    
    
    //fetch the current preps that need to be made (from current date)
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MealPrep" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    
    
    //PREDICATES
    //we need to get meals that were cooked a certain number of days ago, for now 3,
    //so any meal cooked 3 days earlier without a planned date..
    NSDate *setdate = [[NSDate alloc]init];
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = -3;
    NSCalendar *theCalendar = [NSCalendar autoupdatingCurrentCalendar];
    setdate = [theCalendar dateByAddingComponents:dayComponent toDate:setdate options:0];
    
    NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"dateToBeEaten == %@", nil];
    NSPredicate *predicate3 = [NSPredicate predicateWithFormat:@"datePrepped > %@",setdate];
    NSCompoundPredicate *compPred = [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects:predicate2, predicate3, nil]];
    
    [fetchRequest setPredicate:compPred];
    // Specify how the fetched objects should be sorted
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"mealName" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        //
    }
    
    
    NSLog(@"fetch count: %lu",(unsigned long)fetchedObjects.count);
    
    surplusPrepArray = [[NSMutableArray alloc]init];
    NSMutableArray *surplusMealCountArray = [[NSMutableArray alloc]init];

    surplusPrepArray = [[NSMutableArray alloc]initWithArray:fetchedObjects];
    

    NSLog(@"surplusDatesArray: %@",surplusPrepArray);
    NSLog(@"meal count Array: %@",surplusMealCountArray);
    
    
    if (surplusPrepArray.count == 0) {
        [numberOfSurplusMealsLabel setHidden:YES];
    } else {
        [numberOfSurplusMealsLabel setHidden:NO];
        numberOfSurplusMealsLabel.text = [NSString stringWithFormat:@"You have %lu surplus cooked, swipe to plan now >",(unsigned long)surplusPrepArray.count];
    }
    [homeViewSurplusTable reloadData];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - TableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (tableView == mainTable) {
        //main table view
        if (prepArray == nil) {
            return 1;
        } else {
            return sectionHeaders.count;
        }
        
    } else {
        //home view surplus table
        return 1;
    }
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == mainTable) {
        //main table view
        if (prepArray == nil) {
            return 1;
        } else {
            NSString *sectionTitle = [[sectionHeaders objectAtIndex:section]valueForKey:@"dateToBeEatenDate"];
            NSArray *sectionMeals = [dict1 objectForKey:sectionTitle];
            return sectionMeals.count
            ;
        }
    } else {
        //home view surplus table
        
        if (surplusPrepArray.count == 0) {
            return 1;
        } else {
            return surplusPrepArray.count;
        }
        
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (tableView == mainTable) {
        
        //main table view
        if (prepArray == nil) {
            
            UITableViewCell *aCell = [mainTable dequeueReusableCellWithIdentifier:@"cell"];
            
            aCell.textLabel.numberOfLines = 3;
            [aCell.textLabel setAdjustsFontSizeToFitWidth:YES];
            
            if (aCell == nil) {
                aCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                               reuseIdentifier:@"cell"];
            }
            
            aCell.textLabel.text = @"No Meals Planned...";
            [aCell.textLabel setFont:[UIFont fontWithName:@"Avenir Next Condensed" size:15]];

            return aCell;
            
            
        } else {

            static NSString *cellIdentifier = @"mealCell";
            
            HomeTableViewCell *cell  = [mainTable dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[HomeTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                                reuseIdentifier:cellIdentifier];
            }

            NSString * sectionTitle = [[sectionHeaders objectAtIndex:indexPath.section]valueForKey:@"dateToBeEatenDate"];
            NSArray *sectionMeals = [dict1 objectForKey:sectionTitle];
            
            cell.mealNameLabel.text = [[sectionMeals objectAtIndex:indexPath.row]valueForKey:@"mealName"];
            

            //time label text..
            //time remaining
            NSString *timeRemaining = [self getTimeRemaining:[[sectionMeals objectAtIndex:indexPath.row]valueForKey:@"dateToBeEaten"]];

            if ([[[sectionMeals objectAtIndex:indexPath.row]valueForKey:@"dateToBeEatenHour"]intValue] < 12) {
                cell.timeLabel.text = [NSString stringWithFormat:@"%@:00am (%@)",[[sectionMeals objectAtIndex:indexPath.row]valueForKey:@"dateToBeEatenHour"],timeRemaining];
            } else {
                cell.timeLabel.text = [NSString stringWithFormat:@"%@:00pm (%@)",[[sectionMeals objectAtIndex:indexPath.row]valueForKey:@"dateToBeEatenHour"],timeRemaining];
            }
            
            
 
            //cell Image View - used MealPrep class to retrieve and set content for image
            MealPrep *mealPrep = (MealPrep *)[sectionMeals objectAtIndex:indexPath.row];
            
            //displays default image for the meal
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"defaultImage = %@",[NSNumber numberWithBool:YES]];
            
            NSManagedObject *mealImageMo = [[[mealPrep valueForKeyPath:@"meal.mealImage"]filteredSetUsingPredicate:pred]anyObject];
            
            UIImage *theDefaultImage = [mealImageMo valueForKey:@"mealImage"];

            if (theDefaultImage != nil) {
                cell.mealImageView.image = theDefaultImage;
            } else {
                cell.mealImageView.image = [UIImage imageNamed:@"noImage.png"];
            }
            
            

            //cooked status
            
            if ([mealPrep valueForKey:@"datePrepped"]) {
                
                cell.cookedStatus.text = [NSString stringWithFormat:@"Cooked on: %@",[mealPrep valueForKey:@"datePreppedDate"]];
            } else {
                cell.cookedStatus.text = @"Uncooked Meal (!)";
                
            }
            
            
            
            //prep time info
            cell.prepTimeInfo.textColor = [UIColor colorWithRed:137.0f/255.0f
                                                       green:32.0f/255.0f
                                                        blue:18.0f/255.0f
                                                          alpha:1.0f];
            //next update determine correct cook times for the labels below...
            //if too early
            cell.prepTimeInfo.text = @"Too early to prep (2days)";
            //if prepped
            cell.prepTimeInfo.text = @"place in freezer";
            //if waiting
            cell.prepTimeInfo.text = @"Waiting to be prepped";
            //etc
            
            //for now
            if ([mealPrep valueForKey:@"datePrepped"]) {
                cell.prepTimeInfo.textColor = [UIColor colorWithRed:29.0f/255.0f
                                                       green:137.0f/255.0f
                                                        blue:4.0f/255.0f
                                                       alpha:1.0f];
                cell.prepTimeInfo.text = @"Ready: place in fridge";
            } else {
                cell.prepTimeInfo.textColor = [UIColor redColor];
                cell.prepTimeInfo.text = @"Waiting to be prepped";
            }
            
            return cell;
        }
        
        
    
    } else {
        ////home view surplus table
        if (surplusPrepArray.count != 0) {
            
            static NSString *cellIdentifier = @"surplusMeal";
            
            homeViewSurplusPrepsTableViewCell *surplusMealCell  = [homeViewSurplusTable dequeueReusableCellWithIdentifier:cellIdentifier];
            if (surplusMealCell == nil) {
                surplusMealCell = [[homeViewSurplusPrepsTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                                                           reuseIdentifier:cellIdentifier];
            }
            
            
            //displays default image for the meal
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"defaultImage = %@",[NSNumber numberWithBool:YES]];
            
            NSManagedObject *mealImageMo = [[[[surplusPrepArray objectAtIndex:indexPath.row]valueForKeyPath:@"meal.mealImage"]filteredSetUsingPredicate:pred]anyObject];
            
            UIImage *theDefaultImage = [mealImageMo valueForKey:@"mealImage"];
            
            surplusMealCell.mealImageView.image = theDefaultImage;
            surplusMealCell.mealNameLabel.text = [[surplusPrepArray objectAtIndex:indexPath.row]valueForKey:@"mealName"];
            surplusMealCell.numberOfMealsLabel.text = @"Tap to plan this meal now";
            return surplusMealCell;
            
        } else {
            
            static NSString *cellIdentifier = @"NoMeals";
            
            noSurplusMealsTableViewCell *surplusMealCell  = [homeViewSurplusTable dequeueReusableCellWithIdentifier:cellIdentifier];
            if (surplusMealCell == nil) {
                surplusMealCell = [[noSurplusMealsTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                                                           reuseIdentifier:cellIdentifier];
            }
            return surplusMealCell;
        }
    }
}



-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == mainTable) {
        if (prepArray == nil) {
            return nil;
        }
        else  {
            return [[sectionHeaders objectAtIndex:section]valueForKey:@"dateToBeEatenDate"];
        }
    } else {
        return @"Surplus Meals";
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 22;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    
    if (tableView == mainTable) {
        
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,  tableView.bounds.size.width, 30)];
        [headerView setBackgroundColor:[UIColor colorWithRed:69.0f/255.0f green:146.0f/255.0f blue:206.0f/255.0f alpha:0.6]];
        [headerView setTintColor:[UIColor whiteColor]];
        
        UILabel *labelHeader = [[UILabel alloc]initWithFrame:CGRectMake (0,0,320,22)];
        /*
        [labelHeader setTextColor:[UIColor colorWithRed:220.0f/255.0f
                                                       green:220.0f/255.0f
                                                        blue:220.0f/255.0f
                                                       alpha:1.0f]];
         */
        [labelHeader setAdjustsFontSizeToFitWidth:YES];
        labelHeader.textColor = [UIColor whiteColor];
        [labelHeader setTextAlignment:NSTextAlignmentCenter];
        [labelHeader setFont:[UIFont fontWithName:@"Oriya Sangam MN" size:18]];
        [headerView addSubview:labelHeader];
        
        if (prepArray) {
            labelHeader.text = [[sectionHeaders objectAtIndex:section]valueForKey:@"dateToBeEatenDate"];
        }
        return headerView;
    } else {
        return nil;
    }
}





-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == mainTable) {
        if (prepArray == nil) {
            return 40;
        } else {
            return 75;
        }
    } else {
        //surplus table view cell
        if (surplusPrepArray.count == 0) {
            return 52;
            
        } else {
            
            return 52;
        }
    }
}




-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == mainTable) {
        //main table view
        //get meal
        NSString * sectionTitle = [[sectionHeaders objectAtIndex:indexPath.section]valueForKey:@"dateToBeEatenDate"];
        NSArray *sectionMeals = [dict1 objectForKey:sectionTitle];
        
        //set meal
        sendObj = [sectionMeals objectAtIndex:indexPath.row];
        
        
        [self performSegueWithIdentifier:@"newPrep" sender:self];
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
    } else {
        //surplus table view cell
        
        if (surplusPrepArray.count == 0) {
        } else {
        sendObj = [surplusPrepArray objectAtIndex:indexPath.row];
        
            
        [self performSegueWithIdentifier:@"newPrep" sender:self];
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
    }
}



-(void)newMealPrep {
    [self performSegueWithIdentifier:@"addMeal" sender:self];

    [progressViewseg setNumberOfSegments:7];
    
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    newPrepViewController *pvc = segue.destinationViewController;
    
    if ([segue.identifier isEqualToString:@"newPrep"]) {
       //pvc.string = @"meal";
        pvc.sentObj = sendObj;
    }
    
    sendObj = nil;
}


@end
