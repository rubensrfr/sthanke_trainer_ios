//
//  productCell.h
//  Tips4Life
//
//  Created by Rubens Rosa on 12/07/14.
//  Copyright (c) 2014 Rubens Rosa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface productCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *productTitle;
@property (weak, nonatomic) IBOutlet UIImageView *productIcon;
@property (weak, nonatomic) IBOutlet UILabel *productDescription;
@property (weak, nonatomic) IBOutlet UILabel *productValue;
@property (weak, nonatomic) IBOutlet UILabel *productData;
@property (weak, nonatomic) IBOutlet UILabel *productStatus;

@end
