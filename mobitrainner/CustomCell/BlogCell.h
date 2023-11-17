//
//  BlogCell.h
//  mobitrainer
//
//  Created by Reginaldo Lopes on 28/01/15.
//  Copyright (c) 2015 4mobi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlogCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageBlog;
@property (weak, nonatomic) IBOutlet UILabel *labelTitleBlog;
@property (weak, nonatomic) IBOutlet UILabel *labelContentBlog;
@property (weak, nonatomic) IBOutlet UILabel *labelMore;
@property (weak, nonatomic) IBOutlet UILabel *labelData;
@property (weak, nonatomic) IBOutlet UITextField *dataText;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////
/// FIM DO ARQUIVO /////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
