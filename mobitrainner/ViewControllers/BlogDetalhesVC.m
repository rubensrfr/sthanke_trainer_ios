//
//  BlogDetalhesViewController.m
//  mobitrainner
//
//  Created by Reginaldo Lopes on 28/11/14.
//  Copyright (c) 2014 4mobi. All rights reserved.
//

#import "BlogDetalhesVC.h"

@interface BlogDetalhesVC()

@end

@implementation BlogDetalhesVC

@synthesize blogDetalhesWeb;
@synthesize titulo;
@synthesize tituloBlog;
@synthesize item;

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - VIEW LIFECYCLE

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Inicializa objeto Utility.
    utils = [[UtilityClass alloc] init];
    
    // Inicializa objeto Utility.
    coreDataService = [[CoreDataService alloc] init];
    [coreDataService initialize];
    
	

    blogDetalhesWeb.hidden = YES;
    blogDetalhesWeb.alpha = 0;
   // blogDetalhesWeb.delegate = self;
  //  blogDetalhesWeb.allowsInlineMediaPlayback = YES;
    blogDetalhesWeb.opaque = NO;
    
 //   blogDetalhesWeb.scalesPageToFit = YES;
    blogDetalhesWeb.autoresizesSubviews = YES;
  //  blogDetalhesWeb.backgroundColor = [UIColor clearColor];

    Blog *blogData = [coreDataService getDataFromBlogTable];
  //  Blog *blogDataFeed = [coreDataService getDataFromBlogTable];
	 tituloBlog.text=titulo;
// 	[blogDetalhesWeb loadHTMLString:[NSString stringWithFormat:@"<html><body style=\"background-color: transparent\"><font size=\"16\"  color=\"black\">" <h2>%@</h2>%@</body></html>",titulo, [item objectForKey:@"content"]] baseURL:[NSURL URLWithString:blogData.blogURL]]; // URL BASE BLOG
   
    [blogDetalhesWeb loadHTMLString:[NSString stringWithFormat:@"<html><body style=\"background-color: transparent\"><font-size=\"12\"  color=\"black\">"
                                 "%@"
                                 "</font></body> </html>", [item objectForKey:@"content"]] baseURL:[NSURL URLWithString:blogData.blogURL]];
    
 //   [myUIWebView loadHTMLString:myHTML baseURL:nil];
    [SVProgressHUD showWithStatus:@"Atualizando..." maskType: SVProgressHUDMaskTypeGradient];

[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    blogDetalhesWeb.hidden = NO;
    blogDetalhesWeb.alpha = 1;
    [UIView commitAnimations];
    
    //Remove o HUD.
    [SVProgressHUD dismiss];

}

//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
#if 0
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [SVProgressHUD dismiss];
    
    NSString *css = @"\"body {padding-top:20px; padding-bottom:20px; max-width: 100%; word-break: break-word} a {color: #444444} h1 {font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; font-size: 800%; margin-bottom: 0.1em;}h1 {font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; font-size: 800%; margin-bottom: 0.1em;} h2 {font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; font-size: 800%; text-align: left; font-weight: bold; margin: 0.8em 0.8em 0.8em 0.8em;} h3 {font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; font-size: 800%; text-align: left; font-weight: bold; margin: 0.8em 0.8em 0.8em 0.8em;} h4 {font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; font-size: 500%; text-align: left; font-weight: bold; margin: 0.8em 0.8em 0.8em 0.8em;}p {font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; font-size:700%; margin: 0.8em 0.8em 0.8em 0.8em; padding-top:2px; padding-bottom:2px;} img {width:120%; height:auto; padding-bottom:20px;} img {display: block;margin-left:auto; margin-right: auto;} pre {white-space: pre-wrap;} blockquote {margin: 0.8em 0 0.8em 1.2em; padding: 0;} \"";

    NSString *js = [NSString stringWithFormat:
                    @"var styleNode = document.createElement('style');\n"
                    "styleNode.type = \"text/css\";\n"
                    "var styleText = document.createTextNode(%@);\n"
                    "styleNode.appendChild(styleText);\n"
                    "document.getElementsByTagName('head')[0].appendChild(styleNode);\n",css];
    
    [webView stringByEvaluatingJavaScriptFromString:js];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    blogDetalhesWeb.hidden = NO;
    blogDetalhesWeb.alpha = 1;
    
    [UIView commitAnimations];
    
    // Remove o HUD.
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        // Mostra Mensagem de sucesso.
        [SVProgressHUD dismiss];
        
    });
}
#endif
#if 0
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // Animação para fazer um fade in na webview.
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    blogDetalhesWeb.hidden = NO;
    blogDetalhesWeb.alpha = 1;
    [UIView commitAnimations];
    
    //Remove o HUD.
    [SVProgressHUD dismiss];
}
#endif

@end

////////////////////////////////////////////////////////////////////////////////////////////////////
/// FIM DO ARQUIVO /////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
