//
//  PageViewManager.m
//  Scheeeins
//
//  Created by Naldo Lopes on 01/08/14.
//  Copyright (c) 2014 4Mobi. All rights reserved.
//

#import "PageViewManager.h"

#define kTIMER_UPDATE_TIME 7.0f // TROCA A PAGINA A CADA x SEGUNDOS

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

@interface PageViewManager()

- (void)pageControlChanged;

@end

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

@implementation PageViewManager

@synthesize timerScroll;

- (id)initWithScrollView:(UIScrollView *)scrollView pageControl:(UIPageControl*)pageControl showAnimation:(BOOL)flag
{
    self = [super init];
	
    if (self)
    {
        scrollView_ = scrollView;
        pageControl_ = pageControl;
        pageControlUsed_ = NO;
        pageIndex_ = 0;

		if (flag == TRUE)
		{
			pageAnimation_ = YES;
		}
		else
		{
			pageAnimation_ = NO;
		}
		
		if (pageAnimation_ == YES)
		{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                // Seta o timer para scroll automatico.
                timerScroll = [NSTimer scheduledTimerWithTimeInterval:kTIMER_UPDATE_TIME
                                                               target:self
                                                             selector:@selector(pageControlChanged)
                                                             userInfo:nil
                                                              repeats:YES];
                [timerScroll fire];
            });
			
		}
		else
		{
			[pageControl_ addTarget:self
                             action:@selector(pageControlChanged) forControlEvents:UIControlEventValueChanged];
		}
    }
    
    return self;
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

/*  Setup the PageViewManager with an array of UIViews. */
- (void)loadPages:(NSArray *)pages
{
    pages_ = pages;
    
    scrollView_.delegate = self;
    pageControl_.numberOfPages = [pages count];
	
    CGFloat pageWidth  = scrollView_.frame.size.width;
    CGFloat pageHeight = scrollView_.frame.size.height;
	
    scrollView_.pagingEnabled = YES;
    scrollView_.contentSize = CGSizeMake(pageWidth * [pages_ count], pageHeight);
    scrollView_.scrollsToTop = NO;
    scrollView_.delaysContentTouches = NO;
	
    [pages_ enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *stop){
		
		 UIView *page = obj;
		 
		 page.frame = CGRectMake(pageWidth * index, 0, pageWidth, pageHeight);
        
        [scrollView_ addSubview:page];

	 }];
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

/*  Setup the PageViewManager with an array of UIViewControllers. */
- (void)loadControllerViews:(NSArray *)pageControllers
{
    NSMutableArray* pages = [NSMutableArray arrayWithCapacity: pageControllers.count];
	
    [pageControllers enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop){
		
		 UIViewController *controller = obj;
        [pages addObject:controller.view];
		 
	 }];
	
    [self loadPages:pages];
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (void)pageControlChanged
{
	static int page_num = 0;
	
    if(pages_==nil)
        return;

	if (pageAnimation_ == TRUE)
	{
        //RFR
        //		if(page_num == [pages_ count])
        //		{
        //            page_num = 0;
        //		}
	
		
		pageIndex_ =  page_num;
		
		pageControl_.currentPage = page_num;
	//RFR
		page_num=(page_num+1)%[pages_ count];
	}
	else
	{
		pageIndex_ = pageControl_.currentPage;
	}

    // Set the boolean used when scrolls originate from the page control.
    pageControlUsed_ = YES;
	
    // Update the scroll view to the appropriate page
    CGFloat pageWidth  = scrollView_.frame.size.width;
    CGFloat pageHeight = scrollView_.frame.size.height;
	
    CGRect rect = CGRectMake(pageWidth * pageIndex_, 0, pageWidth, pageHeight);

	if (pageAnimation_ == TRUE)
	{
        CATransition *transition = [CATransition animation];
        transition.type = kCATransitionFade;
        transition.duration = 0.6f;
        [scrollView_.layer addAnimation:transition forKey:nil];
        
		[scrollView_ scrollRectToVisible:rect animated:NO];
	}
	else
	{
		[scrollView_ scrollRectToVisible:rect animated:YES];
	}
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    // If the scroll was initiated from the page control, do nothing.
    if (!pageControlUsed_)
    {
        /*  Switch the page control when more than 50% of the previous/next page is visible. */
        CGFloat pageWidth = scrollView_.frame.size.width;
		
        CGFloat xOffset = scrollView_.contentOffset.x;
		
        int index = floor((xOffset - pageWidth/2) / pageWidth) + 1;
		
        if (index != pageIndex_)
        {
            pageIndex_ = index;
            pageControl_.currentPage = index;
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    pageControlUsed_ = NO;
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView
{
    pageControlUsed_ = NO;
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

- (void)changePage:(NSInteger)pageNumber
{
    CGRect frame = scrollView_.frame;
    frame.origin.x = frame.size.width * pageNumber;
    frame.origin.y = 0;
    [scrollView_ scrollRectToVisible:frame animated:YES];
}

@end

////////////////////////////////////////////////////////////////////////////////////////
/// FIM DO ARQUIVO /////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
