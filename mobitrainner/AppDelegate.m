//
//  AppDelegate.m
//  treino
//
//  Created by Reginaldo Lopes on 25/11/14.
//  Copyright (c) 2014 4mobi. All rights reserved.
//

#import "AppDelegate.h"
#import "RadioKit.h"
#import <AVFoundation/AVFoundation.h>
//#import <FBSDKCoreKit/FBSDKCoreKit.h>

RadioKit *radioKit;
NSString *lastStation;
NSIndexPath *lastIndexPath;

@interface AppDelegate()

@end

@implementation AppDelegate

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
  //  [FBSDKAppEvents activateApp];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
	
    utils = [[UtilityClass alloc] init];
	
    coreDataService = [[CoreDataService alloc] init];
    [coreDataService initialize];
    [[IMManager sharedManager] startIMManager];
    // Pega o status do usuário, logado ou não.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL checkUpdate = [defaults boolForKey:kUPDATE_CHECK];
	
    // Se Não existe é a primeira vez que esta rodando.
    if (checkUpdate == FALSE)
    {
        [coreDataService dropExercisesTable];
        [coreDataService dropDesignTable];
        [coreDataService dropUserTable];
        [coreDataService dropTrainerInfoTable];
        [coreDataService dropRadioTable];
        [coreDataService dropPersonalTreineesTable];
        [coreDataService dropLastUpdatesTable];
        [coreDataService dropHistoryTable];
        [coreDataService dropFeaturedImagesTable];
        [coreDataService dropBlogTable];
        [coreDataService dropTrainingTable];
		 
        NSUserDefaults *Defaults = [NSUserDefaults standardUserDefaults];
        [Defaults setBool:TRUE forKey:kUPDATE_CHECK];
        [Defaults setBool:FALSE forKey:@"userStatus"];
        [Defaults setBool:FALSE forKey:@"DidTutorialKey"];
        [Defaults setBool:TRUE forKey:@"ExerciseListNeedUpdate"];
		  [Defaults setBool:TRUE forKey:@"TrainingNeedUpdate"];
		  [Defaults setBool:TRUE forKey:@"TraineesListNeedUpdate"];
		  [Defaults setInteger:30 forKey:@"TimerDescanso"];
		  [Defaults setBool:FALSE forKey:@"purchaseNeedUpdate"];
		  [Defaults setInteger:0 forKey:@"UnreadCounter"];
		  [Defaults synchronize];
		 
//		  [Defaults setInteger:0 forKey:@"training_id"];
//		  [Defaults setInteger:PENDENTE forKey:@"DStatus"];
//		  [Defaults setInteger:PENDENTE forKey:@"QStatus"];
//		  [Defaults setInteger:PENDENTE forKey:@"PStatus"];
//		  [Defaults setInteger:PENDENTE forKey:@"EStatus"];
//        [Defaults synchronize];
		 
        ////////////////////////////////////////////////////////////////////////
        /// CARREGA A TELA DE LOGIN ////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////
 
        [self callLoginViewController];
    }
	
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *setCategoryError = nil;
    if (![audioSession setCategory:AVAudioSessionCategoryPlayback
         withOptions:AVAudioSessionCategoryOptionMixWithOthers
         error:&setCategoryError]) {
    // handle error
	}
	
	
    //register to receive notifications
  //  UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
	
   // UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
	
  //  [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
	
  //  [application registerForRemoteNotifications];


[self registerForRemoteNotifications];

    NSFileManager *fm = [NSFileManager new];
    NSError *err = nil;
	
    NSURL *docsurl = [fm URLForDirectory:NSDocumentDirectory
                                inDomain:NSUserDomainMask
                       appropriateForURL:nil
                                  create:YES
                                   error:&err];
	
    ///////////////////////////////////////////////////////////////////////////////////////////
    /// CRIA AS PASTAS DAS IMAGENS DE DESTAQUE SE NECESSARIO //////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////

    NSURL* pathExercisesImagesTemp = [docsurl URLByAppendingPathComponent:@"/Caches/FeaturedImagesTemp"];
    [fm createDirectoryAtURL:pathExercisesImagesTemp withIntermediateDirectories:YES attributes:nil error:&err];
    [self addSkipBackupAttributeToItemAtURL:pathExercisesImagesTemp];
	
    ///////////////////////////////////////////////////////////////////////////////////////////
    /// CRIA AS PASTAS DAS IMAGENS DE DESTAQUE SE NECESSARIO //////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////

    NSURL* pathFeaturedImages = [docsurl URLByAppendingPathComponent:@"/Caches/FeaturedImages"];
    [fm createDirectoryAtURL:pathFeaturedImages withIntermediateDirectories:YES attributes:nil error:&err];
    [self addSkipBackupAttributeToItemAtURL:pathFeaturedImages];
	
    ///////////////////////////////////////////////////////////////////////////////////////////
    /// CRIA AS PASTAS DAS IMAGENS DE EXERCICIOS SE NECESSARIO ////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////
	
    NSURL* pathExercisesImages = [docsurl URLByAppendingPathComponent:@"/Caches/ExercisesImages"];
    [fm createDirectoryAtURL:pathExercisesImages withIntermediateDirectories:YES attributes:nil error:&err];
    [self addSkipBackupAttributeToItemAtURL:pathExercisesImages];
	
    ///////////////////////////////////////////////////////////////////////////////////////////
    /// CRIA AS PASTAS DAS IMAGENS DE PROFILE SE NECESSARIO ///////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////
	
    NSURL* pathProfileImages = [docsurl URLByAppendingPathComponent:@"/Caches/ProfileImages"];
    [fm createDirectoryAtURL:pathProfileImages withIntermediateDirectories:YES attributes:nil error:&err];
    [self addSkipBackupAttributeToItemAtURL:pathProfileImages];
	
	
    ///////////////////////////////////////////////////////////////////////////////////////////
    /// CRIA AS PASTAS DAS IMAGENS DA LOJA ///////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////
	
    NSURL* pathStoreImages = [docsurl URLByAppendingPathComponent:@"/Caches/StoreImages"];
    [fm createDirectoryAtURL:pathStoreImages withIntermediateDirectories:YES attributes:nil error:&err];
    [self addSkipBackupAttributeToItemAtURL:pathStoreImages];
	
	
    ///////////////////////////////////////////////////////////////////////////////////////////
    /// DEFAULT UPDATES DATES  ////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////
	
    NSError *error = nil;

    NSFetchRequest *fetchRequestUpdates = [NSFetchRequest fetchRequestWithEntityName:@"LastUpdates"];
    NSMutableArray *mutableFetchResultsUpdates = [[self.managedObjectContext executeFetchRequest:fetchRequestUpdates error:&error] mutableCopy];

    if ([mutableFetchResultsUpdates count] == 0)
    {
        // Se não existe, inicializa as datas de atualização com 1970-01-01 00:00:00 para todos os campos.
        [coreDataService setDefaultDataFromLastUpdatesTable];
    }

    ///////////////////////////////////////////////////////////////////////////////////////////
    /// DEFAULT DESIGN ////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////

	
    Design *appDesign;

//    if ([mutableFetchResultsDesign count] == 0)
//    {
//        appDesign = (Design *) [NSEntityDescription insertNewObjectForEntityForName:@"Design"
//                                                             inManagedObjectContext:self.managedObjectContext];
//
//        appDesign.navColor = UIColorFromRGB(kTAB_GLOBAL_COLOR);kPRIMARY_COLOR;
//        appDesign.navTint =  @"0xf5e908";
//        appDesign.navTitleColor =  @"0xEDBF2B";
//        appDesign.blackStatusBar = [NSNumber numberWithBool:FALSE];
//
//        [self.managedObjectContext save:&error];
//
//        if(!([self.managedObjectContext save:&error]))
//        {
//            // Handle Error here.
//            NSLog(@"LOG: %@", [error localizedDescription]);
//        }
//    }
//    else
//    {
//        appDesign = (Design *) [mutableFetchResultsDesign objectAtIndex:0];
//    }
//
//    // COR DA NAVIGATION
	
    [[UINavigationBar appearance] setBarTintColor: UIColorFromRGB(kPRIMARY_COLOR)];
    //[[UINavigationBar appearance] setBarTintColor: UIColorFromRGB(0x00AEDB)];
//
//    // COR DOS ITENS (TINT) DA NAVBAR.
    [[UINavigationBar appearance] setTintColor: UIColorFromRGB(kSECONDARY_COLOR)];
    //[[UINavigationBar appearance] setTintColor: UIColorFromRGB(0xFFFFFF)];
//
//    // COR DO TITULO DA NAVIGATION.
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(kSECONDARY_COLOR)}];
//    //[[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0xFFFFFF)}];
//
	 // Referencia da TabBar do StoryBoard
    UITabBarController *tabController = (UITabBarController *)self.window.rootViewController;
	
    // Troca as imagens da Tabbar
    UITabBar *tabBar = tabController.tabBar;
	
	
    // Set the selected text color
	
	 // Cor da Tabbar e tint do icone setado
    tabBar.barTintColor =UIColorFromRGB(kTAB_GLOBAL_COLOR);
	 tabBar.tintColor =UIColorFromRGB(kTAB_TINT_COLOR);
	 tabBar.unselectedItemTintColor=UIColorFromRGB(kTAB_UNSEL_TINT_COLOR);
	
    BOOL flagBlackStatusBar = appDesign.blackStatusBar.boolValue;

    // COR DO TEXTO NA STATUSBAR.
    if (flagBlackStatusBar)
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
    else
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
	
    // Pega o status do usuário, logado ou não.
    BOOL login = [defaults boolForKey:@"userStatus"];
	
    // Verifica se o usuário esta logado.
    if (login == FALSE)
    {
        dispatch_async(dispatch_get_main_queue(), ^(void){
			  
            // Carrega a tela de login.
            [self performSelector:@selector(callLoginViewController) withObject:nil afterDelay:0.01];
        });
    }

    [SVProgressHUD setFont:[UIFont systemFontOfSize:16]];

    NSLog(@"LOG: %@",[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject]);
	
    NSLog(@"IOS VERSION: %f",[[[UIDevice currentDevice] systemVersion] floatValue]);
	
    if(IS_OS_9_OR_LATER)
    {
        [[WatchSessionManager sharedManager] startSession];
    }

	


	// [[FBSDKApplicationDelegate sharedInstance] application:application
   //                        didFinishLaunchingWithOptions:launchOptions];
    return YES;
}
#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

- (void)registerForRemoteNotifications {
    if(SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"10.0")){
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
             if(!error){
                 [[UIApplication sharedApplication] registerForRemoteNotifications];
             }
         }];
    }
    else {
        // Code for old versions
    }
}

//Called when a notification is delivered to a foreground app.
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    NSLog(@"User Info : %@",notification.request.content.userInfo);
    completionHandler(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge);
}

//Called to let your app know which action was selected by the user for a given notification.
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
    NSLog(@"User Info : %@",response.notification.request.content.userInfo);
    completionHandler();
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory
{
    // The directory the application uses to store the Core Data store file.
    // This code uses a directory named "br.com.4mobi.treino" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSManagedObjectModel *)managedObjectModel
{
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil)
    {
        return _managedObjectModel;
    }
	
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    // The persistent store coordinator for the application.
    // This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil)
    {
        return _persistentStoreCoordinator;
    }
	
    NSURL *applicationDocumentsDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *storeURL = [applicationDocumentsDirectory URLByAppendingPathComponent:@"Done.sqlite"];
	
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
	
    NSDictionary *options = @{
                                NSMigratePersistentStoresAutomaticallyOption : @YES,
                                NSInferMappingModelAutomaticallyOption : @YES
                             };
	
	
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
	
    return _persistentStoreCoordinator;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSManagedObjectContext *)managedObjectContext
{
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil)
    {
        return _managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
	
    if (!coordinator)
    {
        return nil;
    }
	
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
	
    return _managedObjectContext;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Core Data Saving support

- (void)saveContext
{
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
	
    if (managedObjectContext != nil)
    {
        NSError *error = nil;
		 
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate.
            // You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            //abort();
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)callLoginViewController
{
   // [[NSNotificationCenter defaultCenter] postNotificationName:@"stopTimerUpdateThread" object:self];
	
    // Carrega a tela de login.
   // UIStoryboard *storyboard = [UIApplication sharedApplication].delegate.window.rootViewController.storyboard;
   // LoginViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"Login"];
   // LoginViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    //[self.window.rootViewController presentViewController:LoginViewController animated:YES completion:nil];
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - PUSH REMOTE NOTIFICATION

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSString *strToken = [NSString stringWithFormat:@"%@",deviceToken];
    NSLog(@"LOG: TOKEN DO DISPOSITIVO: %@",strToken);
	
    // Se existir o token salva no defaults.
    if (strToken.length > 0)
    {
        NSUserDefaults *Defaults = [NSUserDefaults standardUserDefaults];
        [Defaults setObject:strToken forKey:@"deviceTokenKey"];
        [Defaults synchronize];
    }
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
	
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    if (notificationSettings.types)
    {
        NSLog(@"user allowed notifications");
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        UIWindow* topWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        topWindow.rootViewController = [UIViewController new];
        topWindow.windowLevel = UIWindowLevelAlert + 1;
		 
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Por Favor habilite as Notificações"
                                                                       message:@"Vá em Settings > Notifications > App.\n Habilite Som, Badge & Alerta"
                                                                preferredStyle:UIAlertControllerStyleAlert];

        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
			  
            topWindow.hidden = YES;
        }]];
		 
        [topWindow makeKeyAndVisible];
        [topWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    }
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"]) {
		 
    }
    else if ([identifier isEqualToString:@"answerAction"]) {
		 
    }
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Custom Methods

- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
	
    NSError *error = nil;
	
    BOOL success = [URL setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error: &error];
    if(!success)
    {
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
	
    return success;
}





//- (BOOL)application:(UIApplication *)application
//            openURL:(NSURL *)url
//  sourceApplication:(NSString *)sourceApplication
//         annotation:(id)annotation {
//  return [[FBSDKApplicationDelegate sharedInstance] application:application
//                                                         openURL:url
//                                               sourceApplication:sourceApplication
//                                                      annotation:annotation];
//}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////
/// FIM DO ARQUIVO /////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
