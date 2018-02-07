//
//  WLIbeaconTableViewCell.m
//  LocalDemo
//
//  Created by QingCan on 2017/12/16.
//  Copyright © 2017年 Baidu. All rights reserved.
//

#import "WLIbeaconTableViewCell.h"

@implementation WLIbeaconTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setItem:(WLIbeaconItem *)item{
    if (_item) {
        [_item removeObserver:self forKeyPath:@"lastSeenBeacon"];
    }
    
    _item = item;
    [_item addObserver:self
            forKeyPath:@"lastSeenBeacon"
               options:NSKeyValueObservingOptionNew
               context:NULL];
    
    self.textLabel.text = _item.name;
}

- (NSString *)nameForProximity:(CLProximity)proximity {
    switch (proximity) {
        case CLProximityUnknown:
            return @"Unknown";
            break;
        case CLProximityImmediate:
            return @"Immediate";
            break;
        case CLProximityNear:
            return @"Near";
            break;
        case CLProximityFar:
            return @"Far";
            break;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if ([object isEqual:self.item] && [keyPath isEqualToString:@"lastSeenBeacon"]) {
        NSString *proximity = [self nameForProximity:self.item.lastSeenBeacon.proximity];
        self.detailTextLabel.text = [NSString stringWithFormat:@"Location: %@", proximity];
    }
}



- (void)dealloc {
    [_item removeObserver:self forKeyPath:@"lastSeenBeacon"];
}

@end
