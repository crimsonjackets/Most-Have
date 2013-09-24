//
//  BRNewsViewController.m
//  BridgeSPB
//
//  Created by Stas on 09.04.13.
//  Copyright (c) 2013 Stas. All rights reserved.
//

#import "BRNewsViewController.h"
#import "BRAppDelegate.h"
#import "APICache.h"
#import "InitSlViewController.h"


@interface BRNewsViewController ()
{
    UIImageView * rightImage;
    UIImageView * leftImage;

    NSMutableString * newGraphic;
    
}
@end



@implementation BRNewsViewController

@synthesize rssData;
@synthesize news;
@synthesize currentElement;
@synthesize currentTitle;
@synthesize pubDate;
@synthesize infoNew;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.bridges refreshLoad:NO];
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        self.slidingViewController.underLeftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    self.slidingViewController.underRightViewController = nil;
    
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    
    
    self.bridges=[Bridge initWithView:self.view belowBiew:self.tableView];
    leftImage=[[UIImageView alloc]initWithFrame:CGRectMake(20, 25, 15, 11)];
    rightImage=[[UIImageView alloc]initWithFrame:CGRectMake(260, 30, 35, 5)];
    NSArray *imageLeftRight=[NSArray arrayWithObjects:rightImage,leftImage, nil];
    self.view=[BRAppHelpers addHeadonView:self.view andImages:imageLeftRight withTarget:self];

    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *newsArray = nil;

    
    
    if ([standardUserDefaults objectForKey:@"news"])
        newsArray = [standardUserDefaults objectForKey:@"news"];
    


    BRAppDelegate * appDelegate = (BRAppDelegate *) [[UIApplication sharedApplication] delegate];

    
    if (appDelegate.netStatus == NotReachable) {
        if(newsArray==nil)
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Нет подключения к интернету" message:@"Отсутсвует подключение к интернету и ранее загруженные новости" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];

        }
        else
        {

            
                self.news=newsArray;
                [self.tableView reloadData];
        }
    } else {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [self parsRSSBridge];
    }
    
    
	// Do any additional setup after loading the view.
}


-(void)parsRSSBridge
{
    
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSURL *url = [NSURL URLWithString:@"http://crimsonjackets.ru/mosthave/feed.rss"];
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:url
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:60.0];
    
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if (theConnection) {
        self.rssData = [NSMutableData data];

    } else {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Нет подключения к интернету" message:@"Отсутсвует подключение к интернету и ранее загруженные новости" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];

    }

}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [rssData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {

 //   NSLog(@"%@",rssData);
    self.news = [NSMutableArray array];
    NSXMLParser *rssParser = [[NSXMLParser alloc] initWithData:rssData];
    rssParser.delegate = self;
    [rssParser parse];

}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Нет подключения к интернету" message:@"error find news" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];

}



- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Нет подключения к интернету" message:@"error find news" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    alert=[[UIAlertView alloc]initWithTitle:@"Нет подключения к интернету" message:@"Отсутсвует подключение к интернету и ранее загруженные новости" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];

}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict  {
   // NSLog(@"%@",elementName);
//    if ([elementName isEqualToString:@"enclosure"])
//    {
//        NSString *url = [attributeDict objectForKey:@"url"];
//        NSLog(@"%@",url);
//    }
    self.currentElement = elementName;
    if ([elementName isEqualToString:@"item"]) {
        self.currentTitle = [NSMutableString string];
        self.pubDate = [NSMutableString string];
        self.infoNew = [NSMutableString string];
        newGraphic = [NSMutableString string];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {

  //  NSLog(@"gfhfhf%@",string);
 //   NSLog(@"%@ %@",currentElement,string);
    if ([currentElement isEqualToString:@"url"]) {
            [newGraphic appendString:string];
            
        }
    if ([currentElement isEqualToString:@"title"]) {
		[currentTitle appendString:string];
	} else if ([currentElement isEqualToString:@"pubDate"]) {
		[pubDate appendString:string];
    }else if ([currentElement isEqualToString:@"description"]) {
		[infoNew appendString:string];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {

    if ([elementName isEqualToString:@"item"]) {
        if([currentTitle hasPrefix:@"change"])
        {
           // NSLog(@"change it!");
            
            
        }
        else
        {
        NSDictionary *newsItem = [NSDictionary dictionaryWithObjectsAndKeys:currentTitle, @"title", pubDate, @"pubDate",infoNew,@"description",  nil];
        [news addObject:newsItem];
        self.currentTitle = nil;
        self.pubDate = nil;
        self.currentElement = nil;
        self.infoNew = nil;
            newGraphic=nil;
        }
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    //NSLog(@"%@",self.news);
    [standardUserDefaults setObject:self.news forKey:@"news"];
    [standardUserDefaults synchronize];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self.tableView reloadData];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPnt = [touch locationInView:self.view];

    NSInteger index=[self.bridges findBridge:touchPnt];
    if(index>=0)
    {
        self.slidingViewController.panGesture.enabled=NO;
    }
    else
    {
        self.slidingViewController.panGesture.enabled=YES;
    }
    [self.bridges Information:index];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPnt = [touch locationInView:self.view];
    NSInteger index=[self.bridges findBridge:touchPnt];
    if(index>=0)
    {
        self.slidingViewController.panGesture.enabled=NO;
    }
    else
    {
        self.slidingViewController.panGesture.enabled=YES;
    }
    [self.bridges Information:index];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPnt = [touch locationInView:self.view];
    [self.bridges Information:-1];
    NSInteger index=[self.bridges findBridge:touchPnt];
    if (index>=0) {
                self.slidingViewController.panGesture.enabled=NO;
        BRBridgeViewController *back=[self.storyboard instantiateViewControllerWithIdentifier:@"bridgeTop"];
        OneBridge *bridge=[self.bridges.bridges objectForKey:[NSNumber numberWithInt:index]] ;
        back.bridge=bridge;
        [self.navigationController pushViewController:back animated:YES];
    }
    else
    {
                self.slidingViewController.panGesture.enabled=YES;
    }
}

-(void)leftMenu:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}


-(void)hideBridge:(id)sender//спрятать вид с иконками мостов
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    CGRect frameSep=self.lineSep.frame;
    CGRect frame=self.tableView.frame;
    if(frame.origin.y!=60)
    {
        frame.origin.y=60;
        frameSep.origin.y-=80;
        self.tableView.frame=frame;
        self.lineSep.frame=frameSep;
        [UIView commitAnimations];
        rightImage.image=[UIImage imageNamed:@"butClose.png"];
    }
    else
    {
        frame.origin.y=140;
        frameSep.origin.y+=80;
        self.tableView.frame=frame;
        self.lineSep.frame=frameSep;
        [UIView commitAnimations];
        rightImage.image=[UIImage imageNamed:@"butOpen.png"];
    }
        [self.bridges refreshLoad:NO];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [news count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

        return 140;
}





// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    BRCellNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NewsCell"owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }

    NSDictionary *newsItem = [news objectAtIndex:[news count] - indexPath.row - 1];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];

   // NSMutableString *strDate = [NSMutableString stringWithString:[newsItem objectForKey:@"pubDate"]];
  //  [strDate deleteCharactersInRange:NSMakeRange(24, 6)];
    
    //NSLog(@"%@", news);

    cell.titleNews.text = [newsItem objectForKey:@"title"];
    cell.timeNews.text = [newsItem objectForKey:@"pubDate"];
    cell.infoNews.text=[newsItem objectForKey:@"description"];

    return cell;
}



-(void)updateStuff
{
    [self.bridges refreshLoad:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)goHome
{
    
    NSString *identifier = @"InitSlider";
    UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
    
    [self.navigationController pushViewController:newTopViewController animated:YES];
    
}

-(void)goToPush
{
    InitSlViewController * pushView=[self.storyboard instantiateViewControllerWithIdentifier:@"InitSlider"];
    pushView.controller=@"PUSHTop";
    [self.navigationController pushViewController:pushView animated:YES];
}
- (BOOL)shouldAutorotate {

    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {

    return UIInterfaceOrientationPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

@end
