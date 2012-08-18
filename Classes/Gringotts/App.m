//
//  App.m
//  myGringotts
//
//  Created by SUNGHAK NAM on 12. 7. 12..
//  Copyright 2012 SUNGHAK NAM. All rights reserved.
//
//  Contact shnamace@gmail.com
//
#import "App.h"
#import "MainViewController.h"

@implementation App

@synthesize mainViewCtl;

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
	[super didReceiveMemoryWarning];

	//NSLog(@"App didReceiveMemoryWarning ...\n");
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	[super viewDidUnload];
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.mainViewCtl = nil;
	
	
}

- (void)dealloc {
	[mainViewCtl release];
	[super dealloc];
}

@end
