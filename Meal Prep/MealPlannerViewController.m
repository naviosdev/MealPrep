//
//  MealPlannerViewController.m
//  Meal Prep
//
//  Created by Naveed Ahmed on 23/07/2016.
//  Copyright © 2016 Naveed Ahmed. All rights reserved.
//

#import "MealPlannerViewController.h"

@interface MealPlannerViewController ()

@end

@implementation MealPlannerViewController

@synthesize calendar, floatWidth, floatHeight, navBar, tableView1, addButtonIndexPath, addMealCellIndexPath, managedObjectModel,managedObjectContext,persistentStoreCoordinator, mealDate, prepsArray, dayArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    managedObjectContext = [appDelegate managedObjectContext];
    
    
    //set the correct calendar size for the app
    int screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    switch (screenHeight) {
            
            //iphone 4s
        case 480:
            floatHeight = 300;
            floatWidth = 320;
            break;
            //iphone 5s
        case 568:
            floatHeight = 300;
            floatWidth = 320;
            break;
            
            //iphone 6s
        case 667:
            floatHeight = 300;
            floatWidth = 375;
            break;
            
            //iphone 6s Plus
        case 736:
            floatHeight = 300;
            floatWidth = 414;
            break;
            
        default:
            break;
    }
    

    //create calendar
    calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, 37, floatWidth, floatHeight)];
    self.calendar.dataSource = self;
    self.calendar.delegate = self;
    
   
    self.calendar.scope = FSCalendarScopeWeek;
    self.calendar.clipsToBounds = YES;
    self.calendar.appearance.headerMinimumDissolvedAlpha = 0.0;
    self.calendar.appearance.weekdayTextColor = [UIColor whiteColor];
    self.calendar.appearance.titleDefaultColor = [UIColor whiteColor];
    self.calendar.appearance.selectionColor = [UIColor whiteColor];
    self.calendar.appearance.todayColor = [UIColor darkGrayColor];
    self.calendar.appearance.titleSelectionColor = [UIColor colorWithRed:69.0f/255.0f
                                                                   green:146.0f/255.0f
                                                                    blue:206.0f/255.0f
                                                                   alpha:1.0f];
    
    //self.calendar.showsScopeHandle = YES;
    self.calendar.locale = [NSLocale localeWithLocaleIdentifier:@"en-UK"];
    

    [self.calendar.appearance setHeaderTitleColor:[UIColor clearColor]];
    self.calendar.backgroundColor = [UIColor colorWithRed:69.0f/255.0f
                                                     green:146.0f/255.0f
                                                      blue:206.0f/255.0f
                                                     alpha:1.0f];
    
    self.calendar = self.calendar;
    [self.view addSubview:self.calendar];
    [self.view insertSubview:self.calendar atIndex:0];
     

    
    mealDate = self.calendar.today;
    
    //calendar date is hour behind..adding hour
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.hour = 1;
    NSCalendar *theCalendar = [NSCalendar autoupdatingCurrentCalendar];
    mealDate = [theCalendar dateByAddingComponents:dayComponent toDate:mealDate options:0];
    

    //blending bar bar with calendar
    [navBar setBackgroundImage:[UIImage imageNamed:@"navbar_bg"]
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
    
    [navBar setShadowImage:[UIImage new]];
    
    
    

    //tableview
    self.tableView1.delegate = self;
    self.tableView1.dataSource = self;
    //fetch calendar entries for the day (needs own method as days can be changed)
    [self calendarEntriesForDate];

    
    //scroll calendar to relevant time, make this scroll to the earliest meal set, or set to 7am (in settings have this set by user)
    NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:10 inSection:0];
    [tableView1 scrollToRowAtIndexPath:indexPath1
                     atScrollPosition:UITableViewScrollPositionTop
                             animated:YES];

}


-(void)calendarEntriesForDate {
    
    
    //formate the meal date so that it can be used as a predicate to compare
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd MMM YYYY"];
    NSString *formattedDateString = [dateFormatter stringFromDate:mealDate];
    
    
    //fetch array of MealPreps for the given date as a predicate
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MealPrep" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"dateToBeEatenDate == %@", formattedDateString];
    [fetchRequest setPredicate:predicate];
    // Specify how the fetched objects should be sorted
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateToBeEatenHour" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];

    NSError *error = nil;
    NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:fetchRequest error:&error]mutableCopy];
    if (mutableFetchResults == nil) {
    //
    }
    
    [self setPrepsArray:mutableFetchResults];
    NSLog(@"prepArray1: %@",prepsArray);
    
    //prepare array for tableview (24 rows)
    //create array for 24hours slots
    dayArray = [[NSMutableArray alloc]init];
    int n;
    for (n=0; n<24; n++) {
        NSString *string = [NSString stringWithFormat:@""];
        [dayArray addObject:string];
    }
    
    
    //get preps from prep array and insert into dayarray
    if (prepsArray.count != 0) {
        
        int hour;
        int l;
        for (l=0; l<prepsArray.count; l++) {
            
            if ([[prepsArray objectAtIndex:l]valueForKey:@"dateToBeEatenHour"] != nil) {
                hour = [[[prepsArray objectAtIndex:l]valueForKey:@"dateToBeEatenHour"] intValue];
                [dayArray replaceObjectAtIndex:hour withObject:[prepsArray objectAtIndex:l]];
            } else {
            }
        }
    } else {
        NSLog(@"prep array is empty");
    }
    

    //reload table
    [UIView animateKeyframesWithDuration:0.5 delay:0 options:0 animations:^{
        tableView1.alpha = 0;
    } completion:^(BOOL finished) {
        [UIView animateKeyframesWithDuration:0.5 delay:0 options:0 animations:^{
            [tableView1 reloadData];
            tableView1.alpha = 1;
        } completion:^(BOOL finished) {
        }];
    }];
}



-(void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date {
    

    mealDate = date;
    
    //calendar date is hour behind..adding hour
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.hour = 1;
    NSCalendar *theCalendar = [NSCalendar autoupdatingCurrentCalendar];
    mealDate = [theCalendar dateByAddingComponents:dayComponent toDate:mealDate options:0];
    
    NSLog(@"date selected: %@",mealDate);
    
    //format the date, then save it to variable
    [self calendarEntriesForDate];
}





-(void)calendarCurrentPageDidChange:(FSCalendar *)calendar {
    
    //setting up calendar
    [self.calendar selectDate:self.calendar.currentPage];
    
    mealDate = self.calendar.currentPage;
    //calendar date is hour behind..adding hour
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.hour = 1;
    
    NSCalendar *theCalendar = [NSCalendar autoupdatingCurrentCalendar];
    mealDate = [theCalendar dateByAddingComponents:dayComponent toDate:mealDate options:0];

    //refreshing tableview
    [UIView animateKeyframesWithDuration:0.5 delay:0 options:0 animations:^{
        tableView1.alpha = 0;
    } completion:^(BOOL finished) {
        [UIView animateKeyframesWithDuration:0.5 delay:0 options:0 animations:^{
            tableView1.alpha = 1;
        } completion:^(BOOL finished) {
   
        }];
    }];
    
}


// For manual layout
- (void)calendar:(FSCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated
{
    self.calendar.frame = (CGRect){self.calendar.frame.origin,bounds.size};
}


- (NSDate *)minimumDateForCalendar:(FSCalendar *)calendar
{
    return [NSDate date];
}



#pragma mark - Table View

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 24;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    MealPlannerTableViewCell *cell = [tableView1 dequeueReusableCellWithIdentifier:@"emptyCell"];
    MealPlannerTableViewCell *selectCell = [tableView1 dequeueReusableCellWithIdentifier:@"selectCell"];
    MealPlannerTableViewCell *plannedCell = [tableView1 dequeueReusableCellWithIdentifier:@"plannedCell"];
    
    
    MealPrep *mealPrep = (MealPrep *)[dayArray objectAtIndex:indexPath.row];
   
    
    if (addButtonIndexPath == indexPath) {
        //return select cell
        selectCell.timeLabel.text = [NSString stringWithFormat:@"%ld:00",(long)indexPath.row];
        selectCell.selectedMealImageView.image = [UIImage imageNamed:@"noImage.png"];
        
        
        selectCell.selectedMealImageView.clipsToBounds = YES;
        
        selectCell.selectedMealNameLabel.text = @"Meal Name";
        selectCell.selectedPrepTimeLabel.text = @"Prep Time";
        
        
        if ([[dayArray objectAtIndex:indexPath.row] isKindOfClass:[NSString class]]) {
            selectCell.deletePrepButton.alpha = 0;

        } else {
            selectCell.deletePrepButton.alpha = 1;
            selectCell.selectedMealNameLabel.text = [mealPrep mealName];
            selectCell.selectedPrepTimeLabel.text = [NSString stringWithFormat:@"Prep Time: %@",[mealPrep valueForKeyPath:@"meal.timePrep"]];
            
            //displays default image for the meal
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"defaultImage = %@",[NSNumber numberWithBool:YES]];
            NSManagedObject *mealImageMo = [[[mealPrep valueForKeyPath:@"meal.mealImage"]filteredSetUsingPredicate:pred]anyObject];
            UIImage *theDefaultImage = [mealImageMo valueForKey:@"mealImage"];
            if (theDefaultImage != nil) {
                selectCell.selectedMealImageView.image = theDefaultImage;
            } else {
                selectCell.selectedMealImageView.image = [UIImage imageNamed:@"noImage.png"];
            }
        }
        

        return selectCell;
    } else {
        
        
        
        //display either cell 1 or 3
        if ([[dayArray objectAtIndex:indexPath.row] isKindOfClass:[NSString class]]) {
            
            cell.addMealButton.alpha = 0;
            if (cell == nil) {
                cell = [[MealPlannerTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                                       reuseIdentifier:@"emptyCell"];
            }
            cell.timeLabel.text = [NSString stringWithFormat:@"%ld:00",(long)indexPath.row];
            
            return cell;
        } else {
            plannedCell.timeLabel.text = [NSString stringWithFormat:@"%ld:00",(long)indexPath.row];
            plannedCell.mealNameLabel.text = [mealPrep mealName];
            plannedCell.prepTimeLabel.text = [NSString stringWithFormat:@"Prep Time: %@",[mealPrep valueForKeyPath:@"meal.timePrep"]];
            //[[dayArray objectAtIndex:indexPath.row] valueForKeyPath:@"meal.timePrep"];
            
            
            //displays default image for the meal
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"defaultImage = %@",[NSNumber numberWithBool:YES]];
            NSManagedObject *mealImageMo = [[[mealPrep valueForKeyPath:@"meal.mealImage"]filteredSetUsingPredicate:pred]anyObject];
            UIImage *theDefaultImage = [mealImageMo valueForKey:@"mealImage"];
            if (theDefaultImage != nil) {
                plannedCell.mealImageView.clipsToBounds = YES;
                plannedCell.mealImageView.image = theDefaultImage;
            } else {
                plannedCell.mealImageView.clipsToBounds = YES;
                plannedCell.mealImageView.image = [UIImage imageNamed:@"noImage.png"];
            }

            return plannedCell;
        }
    }
}





-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    addButtonIndexPath = indexPath;
    

    //if meal is already set, get the date so that it can be deleted if a new meal is selected
    MealPrep *mealPrep = (MealPrep *)[dayArray objectAtIndex:indexPath.row];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([[dayArray objectAtIndex:indexPath.row] isKindOfClass:[NSString class]]) {

    } else {
        [userDefault setObject:[mealPrep dateToBeEaten] forKey:@"prepToBeDeleted"];
    }

    
    //set the time to selected hour
    NSCalendar *calendar1 = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar1 components:(NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:mealDate];
    [dateComponents setHour:indexPath.row];
    [dateComponents setMinute:00];
    [dateComponents setSecond:00];
    [dateComponents setCalendar:[NSCalendar currentCalendar]];
    mealDate = [[NSCalendar currentCalendar]dateFromComponents:dateComponents];
    NSLog(@"seetDate: %@",mealDate);
    

    [tableView1 beginUpdates];
    [tableView1 reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [tableView1 endUpdates];
    

    //clean old cell
    if (_previousCellIndexPath) {
        [tableView1 beginUpdates];
        [tableView1 reloadRowsAtIndexPaths:@[_previousCellIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView1 endUpdates];
    }
    _previousCellIndexPath = indexPath;
}


-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView1 reloadData];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (addButtonIndexPath == indexPath) {
        return 206;
    } else {
        return 44;
    }
}



- (IBAction)selectCellCancel:(id)sender {
    addButtonIndexPath = nil;
    [tableView1 beginUpdates];
    [tableView1 reloadRowsAtIndexPaths:@[_previousCellIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    [tableView1 endUpdates];
}




- (IBAction)selectCellConfirm:(id)sender {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"meal"]) { //(if meal has been selected)
    
    addButtonIndexPath = nil;
    
    [tableView1 beginUpdates];
    [tableView1 reloadRowsAtIndexPaths:@[_previousCellIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    [tableView1 endUpdates];
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSLog(@"meal selected: %@, for %@",[defaults objectForKey:@"meal"],[NSString stringWithFormat:@"%2@:00",[defaults objectForKey:@"time"]]);
    
    NSLog(@"int %@",[defaults objectForKey:@"time"]);
    
    
    //if there is already a meal in this slot delete it so that it can be replaced with new prep
    
    if ([defaults objectForKey:@"prepToBeDeleted"]) {
        
        //fetch prep with this date and delete,save, done
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"MealPrep" inManagedObjectContext:managedObjectContext];
        [fetchRequest setEntity:entity];
        // Specify criteria for filtering which objects to fetch
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"dateToBeEaten == %@", [defaults objectForKey:@"prepToBeDeleted"]];
        [fetchRequest setPredicate:predicate];
        
        NSError *e = nil;
        NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&e];
        if (fetchedObjects == nil) {
            //error
        }
        
        
        NSManagedObject *eventToDelete = [fetchedObjects firstObject];
        [managedObjectContext deleteObject:eventToDelete];
        NSError *erro = nil;
        if (![managedObjectContext save:&erro]) {
            //handle error
        }
        
        [defaults removeObjectForKey:@"prepToBeDeleted"];
        [defaults synchronize];
        
    }
    //now add the new meal..

    //retrieving and preparing data to be saved to core data...
    MealPrep *mealPrep = [NSEntityDescription insertNewObjectForEntityForName:@"MealPrep" inManagedObjectContext:managedObjectContext];

    //set date of meal
    [mealPrep setDateToBeEaten:mealDate];

    //set meal
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Meals" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"mealName = %@", [defaults objectForKey:@"meal"]];
    [fetchRequest setPredicate:predicate];
    NSError *error = nil;
    NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
    //
    }
    Meals *meal = (Meals *)[fetchedObjects firstObject];
    [mealPrep setMeal:meal];
    [mealPrep setMealName:[meal mealName]];
    
    //set new field, for just the date
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd MMM YYYY"];
    NSString *formattedDateString = [dateFormatter stringFromDate:mealDate];
    [mealPrep setDateToBeEatenDate:formattedDateString];
    
    //set new field just for the hour
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"HH"];
    NSString *formattedHour = [df stringFromDate:mealDate];
    [mealPrep setDateToBeEatenHour:formattedHour];
    

    //save data and reload data/table
    NSError *error1 = nil;
    if (![managedObjectContext save:&error1]) {
        //handle error
    } else {
        [self calendarEntriesForDate];
    }
    
    [defaults removeObjectForKey:@"meal"];
    [defaults removeObjectForKey:@"time"];
    [defaults synchronize];
    } else {
        //[default @"meal"] is empty prep cannot be confirmed = show alert
        
        //alert view
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Select a Meal"
                                                                       message:@"Meal needs to be selected before planning a prep."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction * action) {}];

        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}





- (IBAction)selectCellDeletePrepAction:(id)sender {
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    if ([defaults objectForKey:@"prepToBeDeleted"]) {
        
        //fetch prep with this date and delete,save, done
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"MealPrep" inManagedObjectContext:managedObjectContext];
        [fetchRequest setEntity:entity];
        // Specify criteria for filtering which objects to fetch
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"dateToBeEaten == %@", [defaults objectForKey:@"prepToBeDeleted"]];
        [fetchRequest setPredicate:predicate];
        
        NSError *e = nil;
        NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&e];
        if (fetchedObjects == nil) {
            //error
        }
        
        
        NSManagedObject *eventToDelete = [fetchedObjects firstObject];
        [managedObjectContext deleteObject:eventToDelete];
        NSError *erro = nil;
        if (![managedObjectContext save:&erro]) {
            //handle error
        } else {
            addButtonIndexPath = nil;
            [self calendarEntriesForDate];
        }
        
        [defaults removeObjectForKey:@"prepToBeDeleted"];
        [defaults synchronize];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)doneAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        //
    }];
}


@end
