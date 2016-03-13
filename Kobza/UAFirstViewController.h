//
//  UAFirstViewController.h
//  Kobza
//
//  Created by San on 09.03.16.
//  Copyright © 2016 kovalov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UAFirstViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *citationTextView;
@property (weak, nonatomic) IBOutlet UILabel *authorTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorInfoTextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *authorPhotoImageView;


- (IBAction)actionNextCitation:(id)sender;


@end
