//
//  newMealListViewController.m
//  Trucks
//
//  Created by Naveed Ahmed on 04/05/2016.
//  Copyright © 2016 Naveed Ahmed. All rights reserved.
//

#import "newMealListViewController.h"

@interface newMealListViewController ()

@end

@implementation newMealListViewController

@synthesize managedObjectContext,managedObjectModel,persistentStoreCoordinator,trucksArray, tmpdict,sendstring, sendObj, mealListTable, memLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
    
    [self setTrucksArray:mutableFetchResults];
 
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"array"];
    [defaults synchronize];
}





-(void)viewDidUnload {
    [self setView:nil];
    [super viewDidUnload];
}



//method for reloading any new data when detail vc is dismissed (or loading in general view)
-(void)viewWillAppear:(BOOL)animated {
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    managedObjectContext = [appDelegate managedObjectContext];
    
    
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *trucks = [NSEntityDescription entityForName:@"Meals" inManagedObjectContext:managedObjectContext];
    [request setEntity:trucks];

    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"mealName" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc]initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    
    NSLog(@"managd context: %@",managedObjectContext.description);
    
    NSError *error = nil;
    NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error]mutableCopy];
    if (mutableFetchResults == nil) {
        //handle error
    }
    
    [self setTrucksArray:mutableFetchResults];
    NSLog(@"there are %lu in the trucks array",(unsigned long)trucksArray.count);
    
    
    [self.mealListTable reloadData];
    
    [super viewWillAppear:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return trucksArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    mealCell *cell = [mealListTable dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    Meals *trucks = (Meals *)[trucksArray objectAtIndex:indexPath.row];
    
    cell.mealNameLabel.text = [trucks mealName];
    [cell.mealNameLabel setPreferredMaxLayoutWidth:248];
    cell.timeLabel.text = [NSString stringWithFormat:@"Time:\n%@",[trucks timePrep]];
    cell.recipeLabel.text = [trucks recipeAmount];
    cell.macroLabel.text = [trucks macro];
    
    
    
    //recipe label
    cell.recipeLabel.text = [NSString stringWithFormat:@"   %lu recipes needed",[[[[trucksArray objectAtIndex:indexPath.row]valueForKeyPath:@"mealRecipes.recipeName"]allObjects]count]];
    
    //steps label
    cell.mealDescLabel.text = [NSString stringWithFormat:@"   Complete in %lu steps",[[[[trucksArray objectAtIndex:indexPath.row]valueForKeyPath:@"mealSteps.step"]allObjects]count]];
    
    
    //category label
    NSLog(@"catcat: %@",[[[trucksArray objectAtIndex:indexPath.row]valueForKeyPath:@"mealCategory.catName"]allObjects]);
    
    
    NSArray *catArray1 = [[NSArray alloc]initWithArray:[[[trucksArray objectAtIndex:indexPath.row]valueForKeyPath:@"mealCategory.catName"]allObjects]];

    
    if (catArray1.count == 0) {
        cell.catLabel.text = @"All";
        cell.catLabel.alpha = 0;
    } else {
        
        int c = (int)catArray1.count;
        
        if (c>1) {
            cell.catLabel.text = [NSString stringWithFormat:@"%@, +%d more",[catArray1 firstObject],c-1];
        } else {
            cell.catLabel.text = [NSString stringWithFormat:@"%@",[catArray1 firstObject]];
        }
    }

    

    //displays default image for the meal
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"defaultImage = %@",[NSNumber numberWithBool:YES]];
    NSLog(@"meal imageee %@",[[trucks mealImage]filteredSetUsingPredicate:pred]);
    
    NSManagedObject *mealImageMo = [[[trucks mealImage]filteredSetUsingPredicate:pred]anyObject];
    
    UIImage *theDefaultImage = [mealImageMo valueForKey:@"mealImage"];
    
    
    
    if (theDefaultImage != nil) {
        cell.mealImage.image = theDefaultImage;
        //cell.mealImage.bounds = CGRectMake(0, 0, 321, 231);
        [cell.mealImage setClipsToBounds:YES];
    
    } else {
        cell.mealImage.image = [UIImage imageNamed:@"noImage.png"];
    }
    
    
    
    
    //macro
    //unarchive macro data
    NSData *data = [trucks macroStats];
    
    NSDictionary *dict = [NSDictionary dictionary];
    dict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    //get variables
    NSNumber *carbn = [dict valueForKey:@"carb"];
    NSNumber *pron = [dict valueForKey:@"pro"];
    NSNumber *fatn = [dict valueForKey:@"fat"];
    
    
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
    VBPieChart *chart = [[VBPieChart alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    //[self.view addSubview:chart];
    
    // Setup some options:
    //[chart setEnableStrokeColor:YES];
    [chart setHoleRadiusPrecent:0.0]; /* hole inside of chart */
    //[chart setLabelBloc;
    [chart setLabelsPosition:1];
    
    
    // Prepare your data
    NSArray *chartValues = @[
                             @{@"name":@"Carb", @"value":carbn, @"color":carbColour},
                             @{@"name":@"Pro", @"value":pron, @"color":proColour},
                             @{@"name":@"Fat", @"value":fatn, @"color":fatColour}
                             ];
    
    // Present pie chart with animation
    if (([carbn  isEqual: @0]) || ([pron  isEqual: @0]) || ([fatn  isEqual: @0])) {
        
    } else {
    
    
    [chart setChartValues:chartValues animation:YES duration:0.4 options:VBPieChartAnimationFan];
    [cell.pieView addSubview:chart];
    
    }
    
    
    
    return cell;
}






// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // Delete the row from the data source
        
        NSManagedObject *eventToDelete = [trucksArray objectAtIndex:indexPath.row];
        [managedObjectContext deleteObject:eventToDelete];
        [trucksArray removeObjectAtIndex:indexPath.row];
        [mealListTable deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        NSError *error = nil;
        if (![managedObjectContext save:&error]) {
            //handle the error
        }
        
        
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"row selected %@", [self.trucksArray objectAtIndex:indexPath.row]);
    
    
    mealDetailViewController *nvc = [[mealDetailViewController alloc]init];
    
    
    sendObj = [self.trucksArray objectAtIndex:indexPath.row];
    nvc.sentObj = sendObj;
    nvc.sentString = @"hello";
    
    
    /*
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:sendObj.objectID forKey:@"obID"];
    [defaults synchronize];
    */
    
    categoryDetailTableViewCell *cdtvc = [[categoryDetailTableViewCell alloc]init];
    [cdtvc setMealObject:sendObj];
    cdtvc.mealObject = sendObj;
    
    
    
    [mealListTable deselectRowAtIndexPath:indexPath animated:YES];
    
    [self performSegueWithIdentifier:@"segue" sender:self];
    
    
}



#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    mealDetailViewController *nvc = segue.destinationViewController;

    if ([segue.identifier isEqualToString:@"segue"]) {
        nvc.sentObj = sendObj;
    }
}



- (IBAction)openAddVCAction:(id)sender {
    
    
    //newAddMealViewController *amvc = [[newAddMealViewController alloc]init];
    
    [self performSegueWithIdentifier:@"addSegue" sender:nil];
    
    
}







@end