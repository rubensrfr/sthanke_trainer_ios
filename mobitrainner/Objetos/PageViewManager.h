//
//  PageViewManager.h
//  Scheeeins
//
//  Created by Naldo Lopes on 01/08/14.
//  Copyright (c) 2014 4Mobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

////////////////////////////////////////////////////////////////////////////////////////
/// INTERFACE //////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

@interface PageViewManager : NSObject <UIScrollViewDelegate>
{
    UIScrollView *scrollView_;
    UIPageControl *pageControl_;
    NSArray *pages_;
    BOOL pageControlUsed_;
    NSInteger pageIndex_;
	BOOL pageAnimation_;
}

////////////////////////////////////////////////////////////////////////////////////////
/// PROPERTY ///////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

@property (strong, nonatomic) NSTimer *timerScroll;

////////////////////////////////////////////////////////////////////////////////////////
///METHOD //////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (id)initWithScrollView:(UIScrollView *)scrollView pageControl:(UIPageControl*)pageControl showAnimation:(BOOL)flag;
- (void)loadPages:(NSArray *)pages;
- (void)loadControllerViews:(NSArray *)pageControllers;
- (void)changePage:(NSInteger)pageNumber;

@end

////////////////////////////////////////////////////////////////////////////////////////
/// FIM DO ARQUIVO /////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////