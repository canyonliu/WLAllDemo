//
//  WLIbeaconsViewController.m
//  LocalDemo
//
//  Created by QingCan on 2017/12/16.
//  Copyright © 2017年 Baidu. All rights reserved.
//

#import "WLIbeaconsViewController.h"
#import "WLIbeaconItem.h"
#import "WLAddIbeaconViewController.h"
#import "WLIbeaconTableViewCell.h"
#import <CoreBluetooth/CoreBluetooth.h>

static NSString * const kRWTStoredItemsKey = @"storedItems";
@interface WLIbeaconsViewController ()<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate,CBPeripheralManagerDelegate>
@property (strong, nonatomic) UITableView *itemsTableView;
@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong,nonatomic)WLAddIbeaconViewController *addIbeaconVC;
@property (strong,nonatomic)CBPeripheralManager *manager;
@property (strong,nonatomic)CLBeaconRegion *beaconRegion;



@end

@implementation WLIbeaconsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.itemsTableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    self.itemsTableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.itemsTableView];

    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"添加ibeacon" style:UIBarButtonItemStylePlain target:self action:@selector(addIbeacon)];
    [self.navigationItem setRightBarButtonItem:rightItem];
    
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.itemsTableView.delegate = self;
    self.itemsTableView.dataSource = self;
    [self.locationManager requestWhenInUseAuthorization];
    [self registerPower];
    
    [self loadItems];
}

//- (void)loadView{
//
//
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)registerPower{
    CLAuthorizationStatus stat = [CLLocationManager authorizationStatus] ;
    if (stat == kCLAuthorizationStatusDenied || stat == kCLAuthorizationStatusRestricted) {
        NSLog(@"not allowed!");
        return;
    }
    
    if (stat == kCLAuthorizationStatusNotDetermined) {
        [self.locationManager requestAlwaysAuthorization];
    }
}


- (void)addBluetooth{
    
}


- (void)addIbeacon{
     self.addIbeaconVC = [[WLAddIbeaconViewController alloc]init];
    __weak typeof (self) Wself = self;
    [self.addIbeaconVC setAddItemCompletionBlock:^(WLIbeaconItem *item) {
        [Wself.items addObject:item];
        [Wself.itemsTableView beginUpdates];
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:Wself.items.count-1 inSection:0];
        [Wself.itemsTableView insertRowsAtIndexPaths:@[newIndexPath]
                                   withRowAnimation:UITableViewRowAnimationAutomatic];
        [Wself.itemsTableView endUpdates];
        [Wself startMonitoringItem:item]; // Add this statement
        [Wself persistItems];
    }];
    [self.navigationController pushViewController:self.addIbeaconVC animated:YES];
}


- (void)loadItems {
    NSArray *storedItems = [[NSUserDefaults standardUserDefaults] arrayForKey:kRWTStoredItemsKey];
    self.items = [NSMutableArray array];
    
    if (storedItems) {
        for (NSData *itemData in storedItems) {
            WLIbeaconItem *item = [NSKeyedUnarchiver unarchiveObjectWithData:itemData];
            [self.items addObject:item];
            [self startMonitoringItem:item]; // Add this statement
        }
    }
}


- (CLBeaconRegion *)beaconRegionWithItem:(WLIbeaconItem *)item {
    
//    CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:item.uuid identifier:@"nameees"];
    NSUUID *uuid = [[NSUUID alloc]initWithUUIDString:@"23A01AF0-232A-4518-9C0E-323FB773F5EF"];
    CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:item.name];
    beaconRegion.notifyEntryStateOnDisplay = YES;
    beaconRegion.notifyOnEntry = YES;
    beaconRegion.notifyOnExit = NO;
    
    //Passing nil will use the device default power
    
//    CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:item.uuid
//                                                                           major:item.majorValue
//                                                                           minor:item.minorValue
//                                                                      identifier:item.name];
    return beaconRegion;
}


- (void)startMonitoringItem:(WLIbeaconItem *)item {
    self.beaconRegion = [self beaconRegionWithItem:item];
    NSDictionary *beaconPeripheralData = [self.beaconRegion peripheralDataWithMeasuredPower:nil];
    self.manager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil options:nil];
    [self.manager startAdvertising:beaconPeripheralData];

    
//    beaconRegion.notifyEntryStateOnDisplay = YES;
//    beaconRegion.notifyOnEntry = YES;
//    beaconRegion.notifyOnExit = NO;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [self.locationManager startMonitoringForRegion:self.beaconRegion];
    if ([CLLocationManager isRangingAvailable]) {
        [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
    }
    
}

- (void)stopMonitoringItem:(WLIbeaconItem *)item {
    CLBeaconRegion *beaconRegion = [self beaconRegionWithItem:item];
    [self.locationManager stopMonitoringForRegion:beaconRegion];
    [self.locationManager stopRangingBeaconsInRegion:beaconRegion];
}



- (void)persistItems{
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    for (WLIbeaconItem *item in self.items){
        NSData *itemData = [NSKeyedArchiver archivedDataWithRootObject:item];
        [arr addObject:itemData];
    }
    [[NSUserDefaults standardUserDefaults] setObject:arr forKey:kRWTStoredItemsKey];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

#pragma mark tableview Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WLIbeaconTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[WLIbeaconTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        WLIbeaconItem *item = [self.items objectAtIndex:indexPath.row];
        cell.item = item;
        cell.textLabel.text = item.name;
        cell.detailTextLabel.text = [item.uuid UUIDString];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        WLIbeaconItem *itemToRemove = [self.items objectAtIndex:indexPath.row];
        [self stopMonitoringItem:itemToRemove];
        [tableView beginUpdates];
        [self.items removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView endUpdates];
        [self persistItems];
    }
}


#pragma mark clmanager delegate
- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
    NSLog(@"Failed monitoring region: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Location manager failed: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region{
    // 发现有iBeacon设备进入扫描范围回调
    NSLog(@"Location manager failed: %@", region);
}


- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{

    switch (status) {
        case kCLAuthorizationStatusAuthorizedAlways:
            manager.allowsBackgroundLocationUpdates = true;
//            [self startMonitoring];
            break;
        default:
            break;
    }

}


-(void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    if (state == CLRegionStateInside)
    {
        //Start Ranging
        [manager startRangingBeaconsInRegion:self.beaconRegion];
        
    }
    else
    {
        NSLog(@"Started monitoring %@ region", region.identifier);
        //Stop Ranging here
    }
}



- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
}

- (void)locationManager:(CLLocationManager *)manager
        didRangeBeacons:(NSArray *)beacons
               inRegion:(CLBeaconRegion *)region
{
    for (CLBeacon *beacon in beacons) {
        for (WLIbeaconItem *item in self.items) {
            if ([item isEqualToCLBeacon:beacon]) {
                item.lastSeenBeacon = beacon;
//                [self.itemsTableView reloadData];
            }
        }
    }
}

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral{
//    if (peripheral.state != CBPeripheralManagerStatePoweredOn) {
//        return;
//    }
////
//    NSString *identifier = @"MyBeacon";
//    //Construct the region
//    CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID: [[NSUUID alloc]initWithUUIDString:@"0B677EBD-D6EB-49EB-87DD-41E52B57BB91"] identifier:identifier];
//
//    //Passing nil will use the device default power
//    NSDictionary *payload = [beaconRegion peripheralDataWithMeasuredPower:nil];
//
//    //Start advertising
//    [self.manager startAdvertising:payload];
}


@end
