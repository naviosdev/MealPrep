//
//  newAddMealViewController.m
//  Meal Prep
//
//  Created by Naveed Ahmed on 18/05/2016.
//  Copyright © 2016 Naveed Ahmed. All rights reserved.
//

#import "newAddMealViewController.h"
#import "AppDelegate.h"
#import "Meals.h"
#import "MealImages.h"
#import "Categories.h"

@interface newAddMealViewController ()

@end

@implementation newAddMealViewController

@synthesize addMealTable, managedObjectModel,managedObjectContext,persistentStoreCoordinator, albumArray1, albumArray2thumb, copAlbumArray1, catArray, cellHeightArray,navBar;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    managedObjectContext = [appDelegate managedObjectContext];
    
    
    [navBar setBackgroundImage:[UIImage imageNamed:@"navbar_bg"]
                forBarPosition:UIBarPositionAny
                    barMetrics:UIBarMetricsDefault];
    
    [navBar setShadowImage:[UIImage new]];
    
    
    
    albumArray1 = [[NSMutableArray alloc]init];
    albumArray2thumb = [[NSMutableArray alloc]init];
    copAlbumArray1 = [[NSMutableArray alloc]init];
    
    
    [self setArrayForCats];
    [self setTheCellHeightArray];
}

-(void)viewDidUnload {
    [self setView:nil];
}


-(void)setArrayForCats {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Categories" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"catName" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        
        //error
    }
    
    
    
    catArray = [[NSMutableArray alloc]initWithArray:fetchedObjects];
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(void)cell:(newAddMealTableViewCell *)cell presentViewController:(UIViewController *)controller {
    
    [self presentViewController:controller animated:YES completion:NULL];
}




- (IBAction)CameraAction:(id)sender {

    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        ipc = [[UIImagePickerController alloc]init];
        ipc.delegate = self;
        ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
        ipc.allowsEditing = YES;

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


- (IBAction)albumSelectAction:(id)sender {
    
    
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
    
    
    //create resized image for meal
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    
    NSLog(@"image info, %f, %f, %ld",image.size.width, image.size.height, (long)image.leftCapWidth);
    
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
    
    
    //UIImage *resizedImage = [self imageWithImage:image scaledToSize:CGSizeMake(560, 460)];
    
    UIImage *thumbnailImage = [self squareImageWithImage:image scaledToSize:CGSizeMake(100, 92)];
    

    [albumArray1 addObject:resizedImage];
    [albumArray2thumb addObject:thumbnailImage];
    
    newAddMealTableViewCell *cell = [[newAddMealTableViewCell alloc]init];
    [cell updateArray:albumArray1];
    
    copAlbumArray1 = albumArray1;
    [self copArrayCount];
    [cell reloaddata];
    
    //store resized image array
    NSData *nsarrayData = [NSKeyedArchiver archivedDataWithRootObject:[NSArray arrayWithArray:copAlbumArray1]];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:nsarrayData forKey:@"array"];
    [defaults synchronize];
    
    //store thumbnail image array
    NSData *nsarrayThumbnailData = [NSKeyedArchiver archivedDataWithRootObject:[NSArray arrayWithArray:albumArray2thumb]];

    [defaults setObject:nsarrayThumbnailData forKey:@"arrayThumbs"];
    [defaults synchronize];
    
    [self reloadAlbumRow];
}



- (UIImage*)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
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







-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}



-(void)reloadAlbumRow {
    
    
    NSIndexPath *indexa = [NSIndexPath indexPathForRow:4 inSection:0];
    NSArray *array = [NSArray arrayWithObjects:indexa, nil];
    
    [addMealTable beginUpdates];
    [addMealTable reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationFade];
    [addMealTable endUpdates];
}



-(NSMutableArray *)retrieveArray1 {
    
    NSLog(@"al1 : %lu",(unsigned long)albumArray1.count);
    return albumArray1;
}


-(NSMutableArray *)copArrayCount {
    
    NSLog(@"copArraycount: %lu",(unsigned long)copAlbumArray1.count);
    
    return copAlbumArray1;
}


#pragma mark - Table View


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 7;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    newAddMealTableViewCell *cell = [addMealTable dequeueReusableCellWithIdentifier:@"1"];
    newAddMealTableViewCell *cell2 = [addMealTable dequeueReusableCellWithIdentifier:@"2"];
    newAddMealTableViewCell *cell3 = [addMealTable dequeueReusableCellWithIdentifier:@"3"];
    newAddMealTableViewCell *cell4 = [addMealTable dequeueReusableCellWithIdentifier:@"4"];
    newAddMealTableViewCell *cell5 = [addMealTable dequeueReusableCellWithIdentifier:@"5"];
    newAddMealTableViewCell *cell6 = [addMealTable dequeueReusableCellWithIdentifier:@"catCell"];
    StorageAddMealTableViewCell *storageCell = [addMealTable dequeueReusableCellWithIdentifier:@"storageCell"];

    
    switch (indexPath.row) {
        case 0:
            return cell;
            break;
            
        case 1:
            
            
            [cell6.catColView reloadData];
            return cell6;
            break;
            
        case 2:
            
            return cell2;
            
            break;
            
        case 3:
            cell3.carbLabel.text = [NSString stringWithFormat:@"%lu%%",(unsigned long)cell3.carbSlider.value];
            cell3.proLabel.text = [NSString stringWithFormat:@"%lu%%",(unsigned long)cell3.proSlider.value];
            cell3.fatLabel.text = [NSString stringWithFormat:@"%lu%%",(unsigned long)cell3.fatSlider.value];
            return cell3;
            break;
            
        case 4:
        
            return storageCell;
            break;
            
        case 5:
            
            //this is the line that made it all work fsr
            [cell4.albumColView reloadData];
            [cell4.albumColView setClipsToBounds:YES];
            return cell4;
            break;
            
        case 6:
            return cell5;
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
    
    //cell sizes for each storyboard
    NSArray *sizesFor4s = [[NSArray alloc]initWithObjects:@97, @171, @172, @177, @186, @182, @56, nil];
    NSArray *sizesFor5s = [[NSArray alloc]initWithObjects:@97, @171, @172, @177, @186, @182, @56, nil];
    NSArray *sizesFor6s = [[NSArray alloc]initWithObjects:@97, @171, @172, @177, @178, @182, @48, nil];
    NSArray *sizesFor6P = [[NSArray alloc]initWithObjects:@97, @171, @172, @177, @178, @182, @48, nil];
    
    
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
    

    
    [addMealTable reloadData];
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
            
        default:
            return 0;
            break;
    }
}






- (IBAction)closeAction:(id)sender {
    
    //cancel
    [self dismissViewControllerAnimated:YES completion:^{
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults removeObjectForKey:@"array"];
        [defaults removeObjectForKey:@"arrayThumbs"];
        [defaults synchronize];
        
        NSUserDefaults *newMealSave = [NSUserDefaults standardUserDefaults];
        [newMealSave removeObjectForKey:@"mealName"];
        [newMealSave removeObjectForKey:@"cats"];
        [newMealSave removeObjectForKey:@"macros"];
        [newMealSave removeObjectForKey:@"prepTime"];
        [newMealSave synchronize];
        
    }];
}





- (IBAction)addNewMealContentAction:(id)sender {
    
    //add to core data
    NSUserDefaults *newMealSave = [NSUserDefaults standardUserDefaults];
    NSLog(@"meal Name: %@",[newMealSave objectForKey:@"mealName"]); //string
    NSLog(@"squibble: %@",[newMealSave objectForKey:@"cats"]); //marray
    NSLog(@"macro: %@",[newMealSave objectForKey:@"macros"]);//dict
    NSLog(@"prep time: %@",[newMealSave objectForKey:@"prepTimePicked"]);//string
    
    
    
    //create new entry for meal list
    Meals *meal = [NSEntityDescription insertNewObjectForEntityForName:@"Meals" inManagedObjectContext:managedObjectContext];
    [meal setMealName:[newMealSave objectForKey:@"mealName"]];
    [meal setMealDescription:@"tbd desc"];
    [meal setTimePrep:[newMealSave objectForKey:@"prepTimePicked"]];
    [meal setRecipeAmount:@"tbd recip"];
    [meal setMacro:@"tbd macro"];
    [meal setArchived:@"no"];

    [meal setFridgeStorageDays:[newMealSave objectForKey:@"fridgeValue"]];
    [meal setFreezerStorageDays:[newMealSave objectForKey:@"freezerValue"]];
    
    
    
    NSArray *selectedCats = [[NSArray alloc]initWithArray:[newMealSave objectForKey:@"cats"]];
    NSLog(@"selected Array %@",selectedCats);
    
    int i;
    for (i=0; i<catArray.count; i++) {
        Categories *cat = (Categories *)[catArray objectAtIndex:i];
        
        int a;
        for (a=0; a<selectedCats.count; a++) {
            if ([[selectedCats objectAtIndex:a] isEqualToString:[cat catName]]) {
                
                
                [meal addMealCategoryObject:cat];
                NSError *error = nil;
                if (![managedObjectContext save:&error]) {
                    //handle error
                }
                
            }
        }
    }
    
    

    

    //set macrostats
     NSData *macroData = [NSKeyedArchiver archivedDataWithRootObject:[newMealSave objectForKey:@"macros"]];
    [meal setMacroStats:macroData];
    
    
    

    //set photos

    //unarchive it
    NSData *data = [newMealSave objectForKey:@"array"];
    NSArray *arrayFromData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    NSData *thumbData = [newMealSave objectForKey:@"arrayThumbs"];
    NSArray *arrayThumbsFromData = [NSKeyedUnarchiver unarchiveObjectWithData:thumbData];
    
    
    
    int n;
    for (n=0; n<arrayFromData.count; n++) {
        
        MealImages *mealImage = [NSEntityDescription insertNewObjectForEntityForName:@"MealImages" inManagedObjectContext:managedObjectContext];
        
        
        [mealImage setMealImage:[arrayFromData objectAtIndex:n]];
        [mealImage setMealThumbnailImage:[arrayThumbsFromData objectAtIndex:n]];
        [mealImage setDateAdded:[NSDate date]];
        [mealImage setMealCaption:[NSString stringWithFormat:@"image %d",n+1]];
        
        
        if (n == 0) {
            [mealImage setDefaultImage:[NSNumber numberWithBool:YES]];
        } else {
            [mealImage setDefaultImage:[NSNumber numberWithBool:NO]];
        }
     
        [meal addMealImageObject:mealImage];
        
        NSError *error = nil;
        if (![managedObjectContext save:&error]) {
            //handle error
        }
        
    }
    
    
    
    //save data
    NSError *error = nil;
    if (![managedObjectContext save:&error]) {
        //handle error
    }
    
    
    //dismiss and clear all userdefault data
    [self dismissViewControllerAnimated:YES completion:^{
        
        //clear data
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults removeObjectForKey:@"array"];
        [defaults removeObjectForKey:@"arrayThumbs"];
        [defaults synchronize];
        
        
        [newMealSave removeObjectForKey:@"mealName"];
        [newMealSave removeObjectForKey:@"cats"];
        [newMealSave removeObjectForKey:@"macros"];
        [newMealSave removeObjectForKey:@"prepTime"];
        [newMealSave synchronize];
    }];
}



@end
