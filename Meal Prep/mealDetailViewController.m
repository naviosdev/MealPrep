//
//  mealDetailViewController.m
//  Meal Prep
//
//  Created by Naveed Ahmed on 09/06/2016.
//  Copyright © 2016 Naveed Ahmed. All rights reserved.
//

#import "mealDetailViewController.h"

@interface mealDetailViewController ()

@end

@implementation mealDetailViewController

@synthesize detailTableView, managedObjectModel,managedObjectContext,persistentStoreCoordinator, sentObj, sentString, mainImage, mealDetailsSave, cellHeightArray, navBar;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    managedObjectContext = [appDelegate managedObjectContext];
    
    
    NSError *error;
    [managedObjectContext existingObjectWithID:sentObj.objectID error:&error];
    
    
    mealDetailTableViewCell *mdtvc = [[mealDetailTableViewCell alloc]init];
    [mdtvc setMealObject:sentObj];
    [mdtvc mealObjectLog];
    

    imageSelectTableViewCell *istvc = [[imageSelectTableViewCell alloc]init];
    [istvc setMealObject:sentObj];
    [istvc mealObjectLog];
    
    
    categoryDetailTableViewCell *cdtvc = [[categoryDetailTableViewCell alloc]init];
    [cdtvc setMealObject:sentObj];

    
    
    //blend nav bar with view
    [navBar setBackgroundImage:[UIImage imageNamed:@"navbar_bg"]
                forBarPosition:UIBarPositionAny
                    barMetrics:UIBarMetricsDefault];
    [navBar setShadowImage:[UIImage new]];
    
    
    
    //setting main image
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"defaultImage = %@",[NSNumber numberWithBool:YES]];
    NSLog(@"meal imageee %@",[[sentObj valueForKey:@"mealImage"]filteredSetUsingPredicate:pred]);
    
    NSManagedObject *mealImageMo = [[[sentObj valueForKey:@"mealImage"]filteredSetUsingPredicate:pred]anyObject];
    
    mainImage = [mealImageMo valueForKey:@"mealImage"];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:mainImage];
    
    NSUserDefaults *imageDefault = [NSUserDefaults standardUserDefaults];
    [imageDefault setObject:data forKey:@"mainImage"];
    [imageDefault synchronize];
    
    [self setTheCellHeightArray];
    
}




-(void)viewDidUnload {
    [self setView:nil];
}


-(void)viewWillAppear:(BOOL)animated {

    NSLog(@"to be passed: %@",sentObj); //works
    imageSelectTableViewCell *isvc = [[imageSelectTableViewCell alloc]init];
    [isvc setMealObject:sentObj];

    NSString *mealNameString = [NSString stringWithFormat:@"%@",[sentObj valueForKey:@"mealName"]];
    NSUserDefaults *object = [NSUserDefaults standardUserDefaults];
    [object setObject:mealNameString forKey:@"mealName"];
    [object synchronize];
}




#pragma mark - Camera 

- (IBAction)cameraAction:(id)sender {
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        ipc = [[UIImagePickerController alloc]init];
        ipc.delegate = self;
        ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        
        [self presentViewController:ipc animated:YES completion:NULL];
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Camera Unavailable"
                                                       message:@"Unable to find a camera on your device."
                                                      delegate:nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil, nil];
        [alert show];
        alert = nil;
    }
}



- (IBAction)albumAction:(id)sender {
    
    
    ipc = [[UIImagePickerController alloc]init];
    ipc.delegate = self;
    ipc.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) {
        [self presentViewController:ipc animated:YES completion:NULL];
    }
    
    else
    {
        NSLog(@"no camera available");
    }

    
}



-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    } else {
        [popever dismissPopoverAnimated:YES];
    }
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    
    float newWidth = image.size.width / 3;
    float newHeight = image.size.height / 3;
    
    NSLog(@"new: %f %f", newWidth, newHeight);
    
    UIImage *resizedImage = nil;
    CGSize targetSize = CGSizeMake(newWidth, newHeight);
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumnbnailRect = CGRectMake(0, 0, 0, 0);
    thumnbnailRect.origin= CGPointMake(0.0, 0.0);
    thumnbnailRect.size.height = targetSize.height;
    thumnbnailRect.size.width = targetSize.width;
    
    [image drawInRect:thumnbnailRect];
    
    resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    
    
    //thumbnail image
    UIImage *thumbnailImage = [self squareImageWithImage:image scaledToSize:CGSizeMake(100, 92)];
    
    
    
    
    
    
    //adds image into db
    MealImages *mealImage = [NSEntityDescription insertNewObjectForEntityForName:@"MealImages" inManagedObjectContext:managedObjectContext];
    
    [mealImage setMealImage:resizedImage];
    [mealImage setMealThumbnailImage:thumbnailImage];
    [mealImage setDateAdded:[NSDate date]];
    [mealImage setDefaultImage:[NSNumber numberWithBool:NO]];
    
    //add image object with meal
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Meals" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"mealName = %@", [sentObj valueForKey:@"mealName"]];
    [fetchRequest setPredicate:predicate];

    NSError *error = nil;
    NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
    //error
    }
    
    Meals *meal = [fetchedObjects firstObject];
    [meal addMealImageObject:mealImage];
    
    if (![managedObjectContext save:&error]) {
        //handle error
    }
    
    //reload cell
    [self reloadAlbumRow];
}




- (UIImage *)squareImageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    double ratio;
    double delta;
    CGPoint offset;
    
    //make a new square size, that is the resized imaged width
    CGSize sz = CGSizeMake(newSize.width, newSize.width);
    
    //figure out if the picture is landscape or portrait, then
    //calculate scale factor and offset
    if (image.size.width > image.size.height) {
        ratio = newSize.width / image.size.width;
        delta = (ratio*image.size.width - ratio*image.size.height);
        offset = CGPointMake(delta/2, 0);
    } else {
        ratio = newSize.width / image.size.height;
        delta = (ratio*image.size.height - ratio*image.size.width);
        offset = CGPointMake(0, delta/2);
    }
    
    //make the final clipping rect based on the calculated values
    CGRect clipRect = CGRectMake(-offset.x, -offset.y,
                                 (ratio * image.size.width) + delta,
                                 (ratio * image.size.height) + delta);
    
    
    //start a new context, with scale factor 0.0 so retina displays get
    //high quality image
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(sz, YES, 0.0);
    } else {
        UIGraphicsBeginImageContext(sz);
    }
    UIRectClip(clipRect);
    [image drawInRect:clipRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}






-(void)reloadAlbumRow {
    
    NSLog(@"reload select cell method called");
    NSIndexPath *indexa = [NSIndexPath indexPathForRow:1 inSection:0];
    NSArray *array = [NSArray arrayWithObjects:indexa, nil];
    
    [detailTableView beginUpdates];
    [detailTableView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationFade];
    [detailTableView reloadData];
    [detailTableView endUpdates];
    
}

-(void)reloadRecipeRow {
    
    NSLog(@"reload cell recipe method called");
    NSIndexPath *indexa = [NSIndexPath indexPathForRow:2 inSection:0];
    NSArray *array = [NSArray arrayWithObjects:indexa, nil];
    
    [detailTableView beginUpdates];
    [detailTableView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationFade];
    [detailTableView reloadData];
    [detailTableView endUpdates];
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - TableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 9;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    mealDetailTableViewCell *cell = [detailTableView dequeueReusableCellWithIdentifier:@"mealName"];
    imageSelectTableViewCell *cell3 = [detailTableView dequeueReusableCellWithIdentifier:@"mealSelectCell"];
    mealDetailTableViewCell *cell4 = [detailTableView dequeueReusableCellWithIdentifier:@"recipeCell"];
    mealDetailTableViewCell *cell5 = [detailTableView dequeueReusableCellWithIdentifier:@"prepTimeCell"];
    mealDetailTableViewCell *cell6 = [detailTableView dequeueReusableCellWithIdentifier:@"stepsCell"];
    mealDetailTableViewCell *cell7 = [detailTableView dequeueReusableCellWithIdentifier:@"macroCell"];
    categoryDetailTableViewCell *cell8 = [detailTableView dequeueReusableCellWithIdentifier:@"categoryCell"];
    mealDetailTableViewCell *cell9 = [detailTableView dequeueReusableCellWithIdentifier:@"deleteCell"];
    storageDetailTableViewCell *storageCell = [detailTableView dequeueReusableCellWithIdentifier:@"storageCell"];
    

    
    switch (indexPath.row) {
        case 0:
            cell.mealObject = sentObj;
            return cell;
            break;
            
        case 1:
            [cell3.mainImageView setImage:mainImage];
            [cell3.imageSelectColView reloadData];
            return cell3;
            break;
            
        case 2:
            return cell4;
            break;
            
        case 3:
            return cell5;
            break;
            
        case 4:
            return cell6;
            break;
            
        case 5:
            
            return cell7;
            break;
            
        case 6:
            
            return storageCell;
            break;
        
        case 7:
            [cell8 setMealObject:sentObj];
            [cell8 setTheString:@"er"];
            
            
            return cell8;
            break;
            
        case 8:
            
            return cell9;
            break;
            
        default:
            return 0;
            break;
    }
}






-(void)setTheCellHeightArray{
    
    //sets heights of cells depending on the storyboard being used at runtime
    
    
    
    NSUserDefaults *screenDefault = [NSUserDefaults standardUserDefaults];
    int i = [[screenDefault objectForKey:@"screenHeight"]intValue];
    NSLog(@"i: %d",i);
    
    //cell sizes for each storyboard
    NSArray *sizesFor4s = [[NSArray alloc]initWithObjects:@62, @344, @264, @55, @243, @158, @178, @164, @56, nil];
    NSArray *sizesFor5s = [[NSArray alloc]initWithObjects:@62, @347, @287, @67, @243, @158, @178, @180, @56, nil];
    NSArray *sizesFor6s = [[NSArray alloc]initWithObjects:@62, @379, @287, @82, @243, @158, @178, @164, @56, nil];
    NSArray *sizesFor6P = [[NSArray alloc]initWithObjects:@62, @420, @287, @82, @243, @172, @178, @176, @56, nil];
    
    
    //set the array
    
    switch (i) {
        case 480:
            cellHeightArray = [[NSArray alloc]initWithArray:sizesFor4s];
            break;
            
            //iphone 5s
        case 568:
            cellHeightArray = [[NSArray alloc]initWithArray:sizesFor5s];
            break;
            
            //iphone 6s
        case 667:
            cellHeightArray = [[NSArray alloc]initWithArray:sizesFor6s];
            break;
            
            //iphone 6s Plus
        case 736:
            cellHeightArray = [[NSArray alloc]initWithArray:sizesFor6P];
            break;
            
        default:
            //set default sizes
            cellHeightArray = [[NSArray alloc]initWithArray:sizesFor6s];
            break;
    }

    [detailTableView reloadData];
}




-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    switch (indexPath.row) {
        case 0:
            return [[cellHeightArray objectAtIndex:0]intValue];
            break;
            
        case 1:
            return [[cellHeightArray objectAtIndex:1]intValue];
            break;
            
        case 2:
            return [[cellHeightArray objectAtIndex:2]intValue];
            break;
            
        case 3:
            return [[cellHeightArray objectAtIndex:3]intValue];
            break;
            
        case 4:
            return [[cellHeightArray objectAtIndex:4]intValue];
            break;
            
        case 5:
            return [[cellHeightArray objectAtIndex:5]intValue];
            break;
            
        case 6:
            return [[cellHeightArray objectAtIndex:6]intValue];
            break;
            
        case 7:
            return [[cellHeightArray objectAtIndex:7]intValue];
            break;
            
        case 8:
            return [[cellHeightArray objectAtIndex:8]intValue];
            break;
            
            
        default:
            return 0;
            break;
    }
}



-(void)reloadImageMainCell:(UIImage *)image{
    
    mainImage = image;
    
    NSIndexPath *indexa = [NSIndexPath indexPathForRow:1 inSection:0];
    NSArray *indexpath = [NSArray arrayWithObjects:indexa, nil];
    
    [detailTableView beginUpdates];
    [detailTableView reloadRowsAtIndexPaths:indexpath withRowAnimation:UITableViewRowAnimationFade];
    [detailTableView reloadData];
    [detailTableView endUpdates];
    
    NSLog(@"reload method called");
    
}






/*
//add this method later for the meal option button..
-(void)actionSheetBoth:(NSManagedObject *)object {
    sentObj = object;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *button0 = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        //view automaitcally dismissed
    }];
    
    UIAlertAction *button1 = [UIAlertAction actionWithTitle:@"Set As Default Image" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
        //imageSelectTableViewCell *istvc = [[imageSelectTableViewCell alloc]init];
        
        //[istvc setDefaultImageAction];
        
    }];
    
    UIAlertAction *button2 = [UIAlertAction actionWithTitle:@"Delete Image" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
    }];
    
    imageSelectTableViewCell *istvc = [[imageSelectTableViewCell alloc]init];
    istvc.mealObject = sentObj;
    

    [alert addAction:button0];
    [alert addAction:button1];
    [alert addAction:button2];
    [self presentViewController:alert animated:YES completion:nil];

}
*/





- (IBAction)deleteMealAction:(id)sender {

    //display alert to ask whether or not to detele the meal 
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Delete Meal?"
                                                                   message:@"This cannot be undone."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                          
                                                          
                                                         //delete meal
                                                              Meals *meal = (Meals *)sentObj;
                                                              NSLog(@"delete: %@",meal);
                                                                                                                            [managedObjectContext deleteObject:meal];
                                                              
                                                              NSError *error = nil;
                                                              if (![managedObjectContext save:&error]) {
                                                                  //handle the error
                                                              }
                                                
                                                              [self dismissViewControllerAnimated:YES completion:^{
                                                                  
                                                              }];
                                              
                                                          }];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * action) {}];
    

    
    [alert addAction:cancelAction];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
    
    
}






- (IBAction)closeAction:(id)sender {
    
    //changes are not saved and view is closed
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}










@end
