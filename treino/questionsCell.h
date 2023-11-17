//
//  TableViewCell.h
//  
//
//  Created by Rubens Rosa on 10/04/2018.
//  Copyright © 2018 4mobi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface questionsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *questionsTitle;
@property (weak, nonatomic) IBOutlet UILabel *questionsDescription;
@property (weak, nonatomic) IBOutlet UILabel *questionsStatus;
@end
