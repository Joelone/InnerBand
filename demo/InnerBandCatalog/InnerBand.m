//
//  InnerBand
//
//  InnerBand - Making the iOS SDK greater from within!
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "InnerBand.h"



@implementation IBAlertView

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message dismissTitle:(NSString *)dismissTitle okTitle:(NSString *)okTitle dismissBlock:(void (^)(void))dismissBlock okBlock:(void (^)(void))okBlock {
    [[IBAlertView alertWithTitle:title message:message dismissTitle:dismissTitle okTitle:okTitle dismissBlock:dismissBlock okBlock:okBlock] show];
}

+ (id)alertWithTitle:(NSString *)title message:(NSString *)message dismissTitle:(NSString *)dismissTitle okTitle:(NSString *)okTitle dismissBlock:(void (^)(void))dismissBlock okBlock:(void (^)(void))okBlock {
    return [[[IBAlertView alloc] initWithTitle:title message:message dismissTitle:dismissTitle okTitle:okTitle dismissBlock:dismissBlock okBlock:okBlock] autorelease];
}

+ (void)showDismissWithTitle:(NSString *)title message:(NSString *)message dismissBlock:(void (^)(void))dismissBlock {
    [[IBAlertView alertWithTitle:title message:message dismissTitle:NSLocalizedString(@"Dismiss", nil) okTitle:nil dismissBlock:dismissBlock okBlock:nil] show];
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message dismissTitle:(NSString *)dismissTitle okTitle:(NSString *)okTitle dismissBlock:(void (^)(void))dismissBlock okBlock:(void (^)(void))okBlock {
    self = [super initWithTitle:title message:message delegate:self cancelButtonTitle:dismissTitle otherButtonTitles:okTitle, nil];
    
    if (self) {
        okCallback_ = Block_copy(okBlock);
        dismissCallback_ = Block_copy(dismissBlock);
    }
    
    return self;
}

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message dismissTitle:(NSString *)dismissTitle dismissBlock:(void (^)(void))dismissBlock {
    [[IBAlertView alertWithTitle:title message:message dismissTitle:dismissTitle dismissBlock:dismissBlock] show];
}

+ (id)alertWithTitle:(NSString *)title message:(NSString *)message dismissTitle:(NSString *)dismissTitle dismissBlock:(void (^)(void))dismissBlock {
    return [[[IBAlertView alloc] initWithTitle:title message:message dismissTitle:dismissTitle dismissBlock:dismissBlock] autorelease];    
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message dismissTitle:(NSString *)dismissTitle dismissBlock:(void (^)(void))dismissBlock {
    self = [super initWithTitle:title message:message delegate:self cancelButtonTitle:dismissTitle otherButtonTitles:nil];
    
    if (self) {
        dismissCallback_ = Block_copy(dismissBlock);
    }
    
    return self;
}                                                                                                                                                      

- (void)dealloc {
    Block_release(okCallback_);
    Block_release(dismissCallback_);
    
    [super dealloc];
}

#pragma mark -

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (self.numberOfButtons == 2) {
        if (buttonIndex == 0) {
            if (dismissCallback_) {
                dismissCallback_();
            }
        } else {
            if (okCallback_) {
                okCallback_();
            }
        }
    } else {
        if (dismissCallback_) {
            dismissCallback_();
        }
    }
}

@end




@implementation IBButton
@synthesize color = _color;
@synthesize shineColor = _shineColor;
@synthesize type = _type;
@synthesize cornerRadius = _cornerRadius;
@synthesize borderColor = _borderColor;
@synthesize borderSize = _borderSize;

+(IBButton*) glossButtonWithTitle:(NSString*)title color:(UIColor*)color {
	IBButton *button = [[[IBButton alloc] init] autorelease];
	[button setTitle:title forState:UIControlStateNormal];
	button.type = IBButtonTypeGlossy;
	button.color = color;
	button.shineColor = [color colorBrighterByPercent:65.0];
	button.cornerRadius = 10;
	button.borderSize = 1;
	button.borderColor = [color colorDarkerByPercent:15.0];
	button.titleLabel.font = [UIFont boldSystemFontOfSize:16];
	button.titleLabel.shadowOffset = CGSizeMake (-1.0, -0.0);
	return button;
}
+(IBButton*) softButtonWithTitle:(NSString*)title color:(UIColor*)color {
	IBButton *button = [[[IBButton alloc] init] autorelease];
	[button setTitle:title forState:UIControlStateNormal];
	button.type = IBButtonTypeSoft;
	button.color = color;
	button.shineColor = [color colorBrighterByPercent:50.0];
	button.cornerRadius = 10;
	button.borderSize = 1;
	button.borderColor = [color colorDarkerByPercent:15.0];
	button.titleLabel.font = [UIFont boldSystemFontOfSize:16];
	button.titleLabel.shadowOffset = CGSizeMake (-1.0, -0.0);
	return button;
}
+(IBButton*) flatButtonWithTitle:(NSString*)title color:(UIColor*)color {
	IBButton *button = [[[IBButton alloc] init] autorelease];
	[button setTitle:title forState:UIControlStateNormal];
	button.type = IBButtonTypeFlat;
	button.color = color;
	button.cornerRadius = 10;
	button.borderSize =	1;
	button.borderColor = [color colorDarkerByPercent:15.0];
	button.titleLabel.font = [UIFont boldSystemFontOfSize:16];
	button.titleLabel.shadowOffset = CGSizeMake (-1.0, -0.0);
	return button;
}

- (void)setHighlighted:(BOOL)highlighted {
	[super setHighlighted:highlighted];
	[self setNeedsDisplay];
}

- (void)setEnabled:(BOOL)enabled {
	[super setEnabled:enabled];
	[self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
	
	UIColor *baseColor = self.color;
	UIColor *edgeColor = self.borderColor;
	UIColor *highColor = self.shineColor;

	if (self.highlighted && self.adjustsImageWhenHighlighted) {
		baseColor = [self.color colorDarkerByPercent:40.0];
		edgeColor = [self.borderColor colorDarkerByPercent:40.0];
		highColor = [self.shineColor colorDarkerByPercent:40.0];
	}
	if (!self.enabled && self.adjustsImageWhenDisabled) {
		baseColor = [UIColor colorWithRGB:0x999999];
		edgeColor = [UIColor colorWithRGB:0x777777];
		highColor = [UIColor colorWithRGB:0xEEEEEE];
	}
	
	float half = (float)self.borderSize/2;
	CGRect inset = CGRectInset(rect, half, half);
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	if (self.type == IBButtonTypeFlat) {
		//draw flat fill
		CGContextSaveGState(context);
		CGContextAddRoundedRect(context, inset, self.cornerRadius);
		CGContextSetFillColorWithColor(context, baseColor.CGColor);
		CGContextFillPath(context);
		CGContextRestoreGState(context);
		
	}else if(self.type == IBButtonTypeSoft) {
		//draw gradient fill
		CGContextSaveGState(context);
		
		CGContextAddRoundedRect(context, inset, self.cornerRadius);
		CGContextClip(context);
		
		CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
		NSArray *colors = [NSArray arrayWithObjects:(id)highColor.CGColor, (id)baseColor.CGColor, nil];
		CGFloat locations[2] = { 0.0, 0.6 };
		
		CGGradientRef gradient = CGGradientCreateWithColors(space, (CFArrayRef)colors, locations);
		CGPoint start = CGPointMake(0, inset.origin.y);
		CGPoint end = CGPointMake(0, inset.origin.y+inset.size.height);
		CGContextDrawLinearGradient (context, gradient, start, end, 0);
		
		CGColorSpaceRelease(space);
		CGGradientRelease(gradient);
		CGContextRestoreGState(context);
		
	}else if(self.type == IBButtonTypeGlossy) {
		//draw flat fill
		CGContextAddRoundedRect(context, inset, self.cornerRadius);
		CGContextSetFillColorWithColor(context, baseColor.CGColor);
		CGContextFillPath(context);
		
		//draw glossy fill
		CGContextSaveGState(context);
		CGContextAddRoundedRect(context, inset, self.cornerRadius);
		CGContextClip(context);
		
		CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
		UIColor *shineMinor = [highColor colorWithAlphaComponent:0.3];
		NSArray *colors = [NSArray arrayWithObjects:(id)highColor.CGColor, (id)shineMinor.CGColor, nil];
		CGFloat locations[2] = { 0.0, 1.0 };
		
		CGGradientRef gradient = CGGradientCreateWithColors(space, (CFArrayRef)colors, locations);
		CGPoint start = CGPointMake(0, inset.origin.y);
		CGPoint end = CGPointMake(0, inset.origin.y+(inset.size.height/2));
		CGContextDrawLinearGradient (context, gradient, start, end, 0);
		
		CGColorSpaceRelease(space);
		CGGradientRelease(gradient);
		CGContextRestoreGState(context);
	}
	
	//draw border
	CGContextAddRoundedRect(context, inset, self.cornerRadius);
	CGContextSetStrokeColorWithColor(context, edgeColor.CGColor);
	CGContextSetLineWidth(context, self.borderSize);
	CGContextStrokePath(context);
}

- (void)dealloc {
	[_color release];
	[_shineColor release];
    [super dealloc];
}

@end



#import <CoreText/CoreText.h>

@interface IBCoreTextLabel (PRIVATE)

- (NSString *)catalogTagsInText;
- (NSMutableAttributedString *)createAttributesStringFromCatalog:(NSString *)str;
- (NSMutableAttributedString *)createMutableAttributedStringFromText;

@end

@implementation IBCoreTextLabel

@synthesize text;
@synthesize textColor;
@synthesize font;
@synthesize measuredHeight = measuredHeight_;

- (id)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {
		_boldRanges = [[NSMutableArray alloc] init];
		_italicRanges = [[NSMutableArray alloc] init];
		_underlineRanges = [[NSMutableArray alloc] init];
		_fontRanges = [[NSMutableArray alloc] init];
		
		self.textColor = [UIColor blackColor];
	}
	
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	if ((self = [super initWithCoder:aDecoder])) {
		_boldRanges = [[NSMutableArray alloc] init];
		_italicRanges = [[NSMutableArray alloc] init];
		_underlineRanges = [[NSMutableArray alloc] init];
		_fontRanges = [[NSMutableArray alloc] init];
		
		self.textColor = [UIColor blackColor];
	}
	
	return self;
}

- (void)dealloc {
	[_text release];
	[_attrStr release];
	[_boldRanges release];
	[_italicRanges release];
	[_fontRanges release];
	[_underlineRanges release];
	[super dealloc];
}

- (void)calculateHeightForAttributedString {
    CGFloat H = 0;
    
    // Create the framesetter with the attributed string.
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString( (CFMutableAttributedStringRef) _attrStr); 
    
    CGRect box = CGRectMake(0,0, self.bounds.size.width, CGFLOAT_MAX);
    
    CFIndex startIndex = 0;
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, box);
    
    // Create a frame for this column and draw it.
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(startIndex, 0), path, NULL);
    
    // Start the next frame at the first character not visible in this frame.
    CFArrayRef lineArray = CTFrameGetLines(frame);
    CFIndex j = 0, lineCount = CFArrayGetCount(lineArray);
    CGFloat h, ascent, descent, leading;
    
    for (j=0; j < lineCount; j++) {
        CTLineRef currentLine = (CTLineRef)CFArrayGetValueAtIndex(lineArray, j);
        CTLineGetTypographicBounds(currentLine, &ascent, &descent, &leading);
        h = ascent + descent + leading;
        
        H+=h;
    }
    
    CFRelease(frame);
    CFRelease(path);
    CFRelease(framesetter);
    
    measuredHeight_ = H;
}

- (void)drawRect:(CGRect)rect {
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	
	// bounds
	UIBezierPath *textPath = [UIBezierPath bezierPathWithRect:self.bounds];
	
	// clear
	[textColor setStroke];
	[self.backgroundColor setFill];
	CGContextFillRect(ctx, self.bounds);	
    
	if (_attrStr) {
		// create the frame
		CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)_attrStr);
		CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), textPath.CGPath, NULL);
        
		if (frame) {
			// flip text rightways up
			CGContextTranslateCTM(ctx, 0, textPath.bounds.origin.y);
			CGContextScaleCTM(ctx, 1, -1);
			CGContextTranslateCTM(ctx, 0, -(textPath.bounds.origin.y + textPath.bounds.size.height));
            
			CTFrameDraw(frame, ctx);
			CFRelease(frame);
		}
	}
}


- (void)setBackgroundColor:(UIColor *)value {
    [super setBackgroundColor:value];
    [self setNeedsDisplay];
}

- (void)setTextColor:(UIColor *)value {
	[value retain];
	[_textColor release];
	_textColor = value;
    
	if (_text) {
		NSMutableAttributedString *attrStr = [self createMutableAttributedStringFromText];
        SAFE_RELEASE(_attrStr);
		_attrStr = [attrStr retain];
	}
	
	[self setNeedsDisplay];
}

- (void)setFont:(UIFont *)aFont {
    SAFE_RELEASE(font);
    font = [aFont retain];
    
    if (_text) {
		NSMutableAttributedString *attrStr = [self createMutableAttributedStringFromText];
        SAFE_RELEASE(_attrStr);
		_attrStr = [attrStr retain];
	}
    
    [self calculateHeightForAttributedString];
}

- (void)setText:(NSString *)value {
	[value retain];
	[_text release];
	_text = value;
    
	[_boldRanges removeAllObjects];
	[_italicRanges removeAllObjects];
	[_underlineRanges removeAllObjects];
	[_fontRanges removeAllObjects];
	
	if (_text) {
		NSMutableAttributedString *attrStr = [self createMutableAttributedStringFromText];
        SAFE_RELEASE(_attrStr);
		_attrStr = [attrStr retain];
	}
    
    [self calculateHeightForAttributedString];
	[self setNeedsDisplay];
}

- (NSMutableAttributedString *)createMutableAttributedStringFromText {
	NSString *str = [self catalogTagsInText];
	return [self createAttributesStringFromCatalog:str];
}

- (NSString *)catalogTagsInText {
	NSScanner *scanner = [NSScanner scannerWithString:_text];
	[scanner setCharactersToBeSkipped:nil];
	NSMutableString *scannedStr = [NSMutableString string];		
	NSString *scanStr = nil;
	NSInteger scanIndex = -1;
	NSInteger medicalLoss = 0;
	
	while ([scanner scanUpToString:@"<" intoString:&scanStr]) {
		scanIndex = [scanner scanLocation];
		[scannedStr appendString:scanStr];
		
		if ([scanner scanString:@"<b>" intoString:nil]) {
			// bold
			[scanner scanUpToString:@"</b>" intoString:&scanStr];
			[scannedStr appendString:scanStr];
			[_boldRanges addObject:[NSValue valueWithRange:NSMakeRange(scanIndex - medicalLoss, scanStr.length)]];
            
			[scanner scanString:@"</b>" intoString:nil];
			medicalLoss += 7;
		} else if ([scanner scanString:@"<i>" intoString:nil]) {
			// italic
			[scanner scanUpToString:@"</i>" intoString:&scanStr];
			[scannedStr appendString:scanStr];
			[_italicRanges addObject:[NSValue valueWithRange:NSMakeRange(scanIndex - medicalLoss, scanStr.length)]];
            
			[scanner scanString:@"</i>" intoString:nil];
			medicalLoss += 7;
		} else if ([scanner scanString:@"<u>" intoString:nil]) {
			// underline
			[scanner scanUpToString:@"</u>" intoString:&scanStr];
			[scannedStr appendString:scanStr];
			[_underlineRanges addObject:[NSValue valueWithRange:NSMakeRange(scanIndex - medicalLoss, scanStr.length)]];
            
			[scanner scanString:@"</u>" intoString:nil];
			medicalLoss += 7;
		} else if ([scanner scanString:@"<font " intoString:nil]) {
			[scanner scanUpToString:@">" intoString:&scanStr];
			NSString *fontName = [[scanStr copy] autorelease];
			[scanner scanString:@">" intoString:nil];
			
			// font
			[scanner scanUpToString:@"</font>" intoString:&scanStr];
			[scannedStr appendString:scanStr];
			[_fontRanges addObject:[NSValue valueWithRange:NSMakeRange(scanIndex - medicalLoss, scanStr.length)]];
			[_fontRanges addObject:fontName];
			
			[scanner scanString:@"</font>" intoString:nil];
			medicalLoss += 14 + fontName.length;
		}
	}
	
	return scannedStr;
}

- (NSMutableAttributedString *)createAttributesStringFromCatalog:(NSString *)str {
	NSMutableAttributedString *attrString = [[[NSMutableAttributedString alloc] initWithString:str] autorelease];
	
	[attrString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)_textColor.CGColor range:NSMakeRange(0, str.length)];
    
	
    if (font) {
        CTFontRef globalFont = CTFontCreateWithName((CFStringRef)font.fontName, font.pointSize, nil);
        [attrString addAttribute:(NSString *)(kCTFontAttributeName) value:(id)globalFont range:NSMakeRange(0, str.length)];
        CFRelease(globalFont);
    }
    
	for (NSValue *iValue in _boldRanges) {
		[attrString addAttribute:(NSString *)(kCTStrokeWidthAttributeName) value:BOX_FLOAT(-3.0) range:iValue.rangeValue];
	}
    
	for (NSValue *iValue in _italicRanges) {
		CTFontRef iFont = CTFontCreateWithName((CFStringRef)([UIFont italicSystemFontOfSize:font.pointSize].fontName), font.pointSize, nil);
		[attrString addAttribute:(NSString *)(kCTFontAttributeName) value:(id)iFont range:iValue.rangeValue];
        CFRelease(iFont);
	}
    
    for (NSValue *iValue in _underlineRanges) {
		[attrString addAttribute:(NSString *)(kCTUnderlineStyleAttributeName) value:BOX_FLOAT(1.0) range:iValue.rangeValue];
	}
    
	for (NSInteger i=0; i < _fontRanges.count; i += 2) {
		NSValue *iValue = (NSValue *)[_fontRanges objectAtIndex:i];
		NSString *iFontName = (NSString *)[_fontRanges objectAtIndex:i+1];
        
		CTFontRef iFont = CTFontCreateWithName((CFStringRef)iFontName, font.pointSize, nil);
		[attrString addAttribute:(NSString *)(kCTFontAttributeName) value:(id)iFont range:iValue.rangeValue];
        CFRelease(iFont);
	}
	
	return attrString;
}


@end




@interface IBHTMLLabel (PRIVATE)

- (void)calculateHTML;

@end

@implementation IBHTMLLabel

@synthesize text = _text;
@synthesize textAlignment = _textAlignment;
@synthesize textColor = _textColor;
@synthesize linkColor = _linkColor;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.backgroundColor = [UIColor clearColor];
		self.opaque = NO;
		self.textColor = [UIColor blackColor];
		self.linkColor = [UIColor blueColor];
		self.textAlignment = UITextAlignmentLeft;
    }

    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        self.backgroundColor = [UIColor clearColor];
		self.opaque = NO;
		self.textColor = [UIColor blackColor];
		self.linkColor = [UIColor blueColor];
		self.textAlignment = UITextAlignmentLeft;
    }
    
    return self;
}

- (void)dealloc {
	[_text release];
	[_textColor release];
	[_linkColor release];
    [super dealloc];
}

#pragma mark -

- (void)setText:(NSString *)value {
	[_text autorelease];
	_text = [value copy];
	[self calculateHTML];
}

- (void)setTextAlignment:(UITextAlignment)value {
	_textAlignment = value;
	[self calculateHTML];
}

- (void)setTextColor:(UIColor *)value {
	[value retain];
	[_textColor release];
	_textColor = value;
	[self calculateHTML];
}

- (void)setLinkColor:(UIColor *)value {
	[value retain];
	[_linkColor release];
	_linkColor = value;
	[self calculateHTML];
}

- (void)calculateHTML {
	NSString *htmlText = (_text) ? _text : @"";
	NSString *htmlAlignmentValue = nil;
	
	switch (_textAlignment) {
		case UITextAlignmentRight:
			htmlAlignmentValue = @"right";
			break;
		case UITextAlignmentCenter:
			htmlAlignmentValue = @"center";
			break;
		default:
			htmlAlignmentValue = @"left";
			break;
	}
	
	if (_textColor) {
		htmlText = [NSString stringWithFormat:@"<span style=\"color:%@;\">%@</span>", [_textColor hexString], htmlText];
	}

	if (htmlAlignmentValue) {
		htmlText = [NSString stringWithFormat:@"<div align=\"%@\">%@</div>", htmlAlignmentValue, htmlText];
	}

	if (_linkColor) {
		htmlText = [NSString stringWithFormat:@"<style type=\"text/css\">a { color: %@; }</style>%@", [_linkColor hexString], htmlText];
	}
		
	[self loadHTMLString:htmlText baseURL:nil];
}

@end





@implementation IBHTableView

@dynamic delegate;
@synthesize dataSource = _dataSource;
@synthesize columnWidth = _columnWidth;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		self.columnWidth = 320;
        _colWidths = [[NSMutableArray alloc] init];
		_colCells = [[NSMutableArray alloc] init];
		_colIndex = [[NSMutableArray alloc] init];
		_leftIndex = 0;
		_rightIndex = 0;
    }
    return self;
}

-(void) coverIndices {
	if (!_variableWidths) {
		for(int i=_leftIndex; i<=_rightIndex; i++){
			NSNumber *num = [NSNumber numberWithInt:i];
			if (![_colIndex containsObject:num]) {
				[_colIndex addObject:num];
				UITableViewCell *cell = [self.dataSource tableView:self cellForColumnAtIndex:i];
				cell.frame = CGRectMake(i*self.columnWidth, 0, self.columnWidth, self.frame.size.height);
				[self insertSubview:cell atIndex:0];
				[_colCells addObject:cell];
			}
		}
	}
}

-(void) setContentOffset:(CGPoint)contentOffset {
	super.contentOffset = contentOffset;
	CGFloat xpos = contentOffset.x;
	int newLeftIndex = 0;
	int newRightIndex = 0;
	if(!_variableWidths){
		if (xpos == 0.0) {
			newLeftIndex = 0;
		}else {
			newLeftIndex = xpos / self.columnWidth;
		}
		newRightIndex = newLeftIndex + (self.frame.size.width / self.columnWidth);
		newRightIndex = MIN(newRightIndex, _totalCols-1);
	}
	if (newLeftIndex != _leftIndex || newRightIndex != _rightIndex) {
		_leftIndex = newLeftIndex;
		_rightIndex = newRightIndex;
		[self coverIndices];
	}
}

-(void) reloadData {
	_totalCols = 0;
	_totalWidth = 0;
	_variableWidths = NO;
	if (self.dataSource) {
		_totalCols = [self.dataSource numberOfColumnsInTableView:self];
		_totalWidth = self.columnWidth*_totalCols;
	}
	if (self.delegate) {
		if([self.delegate respondsToSelector:@selector(tableView:widthForColumnAtIndex:)]){
			_totalWidth = 0;
			_variableWidths = YES;
			[_colWidths removeAllObjects];
			for (int i=0; i<_totalCols; i++) {
				CGFloat wid = [self.delegate tableView:self widthForColumnAtIndex:i];
				_totalWidth += wid;
				[_colWidths addObject:[NSNumber numberWithFloat:_totalWidth]];
			}
		}
	}
	self.contentSize = CGSizeMake(_totalWidth, self.frame.size.height);
}

- (UITableViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier {
	for (int i=0; i<_colCells.count; i++) {
		UITableViewCell *cell = [_colCells objectAtIndex:i];
		if([cell.reuseIdentifier isEqualToString:identifier]){
			NSNumber *num = [_colIndex objectAtIndex:i];
			NSInteger index = [num intValue];
			if(index < _leftIndex || index > _rightIndex){
				[cell retain];
				[_colCells removeObjectAtIndex:i];
				[_colIndex removeObjectAtIndex:i];
				[cell prepareForReuse];
				return [cell autorelease];
			}
		}
	}
	return nil;
}

- (void)dealloc {
	[_colIndex release];
	[_colCells release];
	[_colWidths release];
    [super dealloc];
}


@end




static NSManagedObjectModel *gManagedObjectModel;
static NSPersistentStoreCoordinator *gPersistentStoreCoordinator;

static CoreDataStore *gMainStoreInstance;

@interface CoreDataStore ()

- (void)createManagedObjectContext;

@end

@implementation CoreDataStore

+ (CoreDataStore *)mainStore {
	@synchronized (self) {
		if (!gMainStoreInstance) {
			gMainStoreInstance = [[CoreDataStore alloc] init];
		}
	}
	
	return gMainStoreInstance;
}

+ (CoreDataStore *)createStore {
	return [[[CoreDataStore alloc] init] autorelease];
}

+ (void)initialize {
	NSError *error = nil;

	// create the global managed object model
	gManagedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    

	// create the global persistent store
    gPersistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:gManagedObjectModel];
	
	NSString *storeLocation = [DOCUMENTS_DIR() stringByAppendingPathComponent:@"CoreDataStore.sqlite"];
	NSURL *storeURL = [NSURL fileURLWithPath:storeLocation];
	
	if (![gPersistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
		NSLog(@"Error creating persistantStoreCoordinator: %@, %@", error, [error userInfo]);
		abort();
    }    
}

- (id)init {
	if ((self = [super init])) {
		[self createManagedObjectContext];
	}
	
	return self;
}
				 
- (void)dealloc {
    [_managedObjectContext release];
    
	[super dealloc];
}

#pragma mark -

- (NSManagedObjectContext *)context {
	return _managedObjectContext;
}

- (void)clearAllData {
	NSError *error = nil;
	
	// clear existing stack
	SAFE_RELEASE(gManagedObjectModel);
	SAFE_RELEASE(gPersistentStoreCoordinator);
	SAFE_RELEASE(_managedObjectContext);
	
	// remove persistence file
	NSString *storeLocation = [DOCUMENTS_DIR() stringByAppendingPathComponent:@"CoreDataStore.sqlite"];
	NSURL *storeURL = [NSURL fileURLWithPath:storeLocation];
	
	// remove
	@try {
		[[NSFileManager defaultManager] removeItemAtPath:storeURL.path error:&error];
	} @catch (NSException *exception) {
		// ignore, totally normal
	}
	
	// init again
	[CoreDataStore initialize];
	[self createManagedObjectContext];
}

/**
 Save the context.
 */
- (void)save { 
	NSError *error = nil;
	
	if ([_managedObjectContext hasChanges] && ![_managedObjectContext save:&error]) {
		NSArray* detailedErrors = [[error userInfo] objectForKey:NSDetailedErrorsKey];
		
		if(detailedErrors != nil && [detailedErrors count] > 0) {
			for(NSError* detailedError in detailedErrors) {
				NSLog(@"  DetailedError: %@", [detailedError userInfo]);
			}
		}
		else {
			NSLog(@"  %@", [error userInfo]);
		}
		
		abort();
	} 
}

#pragma mark - Deprecated Accessors (Use NSManagedObject+InnerBand)

- (NSArray *)allForEntity:(NSString *)entityName error:(NSError **)error {
	NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
	
	// entity
	[request setEntity:[self entityDescriptionForEntity:entityName]];
	
	// execute
	NSArray *ret = [_managedObjectContext executeFetchRequest:request error:error];

	return ret;
}

- (NSArray *)allForEntity:(NSString *)entityName predicate:(NSPredicate *)predicate error:(NSError **)error {
	NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
	
	// entity
	[request setEntity:[self entityDescriptionForEntity:entityName]];
	[request setPredicate:predicate];
	
	// execute
	return [_managedObjectContext executeFetchRequest:request error:error];
}

- (NSArray *)allForEntity:(NSString *)entityName predicate:(NSPredicate *)predicate orderBy:(NSString *)key ascending:(BOOL)ascending error:(NSError **)error {
	NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
	NSSortDescriptor *sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:key ascending:ascending] autorelease];
	
	// entity
	[request setEntity:[self entityDescriptionForEntity:entityName]];
	[request setPredicate:predicate];
	[request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
	
	// execute
	return [_managedObjectContext executeFetchRequest:request error:error];
}

- (NSArray *)allForEntity:(NSString *)entityName orderBy:(NSString *)key ascending:(BOOL)ascending error:(NSError **)error {
	NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
	NSSortDescriptor *sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:key ascending:ascending] autorelease];
	
	// entity
	[request setEntity:[self entityDescriptionForEntity:entityName]];
	[request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
	 
	// execute
	return [_managedObjectContext executeFetchRequest:request error:error];
}

- (NSManagedObject *)entityByName:(NSString *)entityName error:(NSError **)error {
	NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
	
	// entity
	[request setEntity:[self entityDescriptionForEntity:entityName]];
	
	// execute
	NSArray *values = [_managedObjectContext executeFetchRequest:request error:error];
	
	if (values.count > 0) {
		// this method is designed for accessing a single object, but if there's more just give the first
		return (NSManagedObject *)[values objectAtIndex:0];
	}
	
	return nil;
}

- (NSManagedObject *)entityByName:(NSString *)entityName key:(NSString *)key value:(NSObject *)value error:(NSError **)error {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", key, value];
	NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
	
	[request setPredicate:predicate];
	 
	// entity
	[request setEntity:[self entityDescriptionForEntity:entityName]];
	
	// execute
	NSArray *values = [_managedObjectContext executeFetchRequest:request error:error];
	
	if (values.count > 0) {
		// this method is designed for accessing a single object, but if there's more just give the first
		return (NSManagedObject *)[values objectAtIndex:0];
	}
	
	return nil;
}

- (NSManagedObject *)entityByURI:(NSURL *)uri {
	NSManagedObjectID *oid = [gPersistentStoreCoordinator managedObjectIDForURIRepresentation:uri]; 

    return [self entityByObjectID:oid];
}

- (NSManagedObject *)entityByObjectID:(NSManagedObjectID *)oid {
	if (oid) {
		return [_managedObjectContext objectWithID:oid];
	}
    
	return nil;    
}

- (NSManagedObject *)createNewEntityByName:(NSString *)entityName {
	return [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:_managedObjectContext]; 
}

- (void)removeEntity:(NSManagedObject *)entity {
	@try {
		[_managedObjectContext deleteObject:entity];
	} @catch(id exception) {}
}

/* Remove all objects of an entity. */
- (void)removeAllEntitiesByName:(NSString *)entityName {
	NSError *error = nil;
	
	// get all objects for entity
	// TODO: we can fetch these in a more minimalistic way, would be faster, so do it if we have time
	NSArray *objects = [self allForEntity:entityName error:&error];
	
	for (NSManagedObject *iObject in objects) {
		[_managedObjectContext deleteObject:iObject];
	}
}

- (NSEntityDescription *)entityDescriptionForEntity:(NSString *)entityName {
	return [NSEntityDescription entityForName:entityName inManagedObjectContext:_managedObjectContext];
}

#pragma mark -

- (void)createManagedObjectContext {
	_managedObjectContext = [[NSManagedObjectContext alloc] init];
	[_managedObjectContext setPersistentStoreCoordinator:gPersistentStoreCoordinator];
}

@end



#import <Foundation/Foundation.h>


NSNumber *BOX_BOOL(BOOL x) { return [NSNumber numberWithBool:x]; }
NSNumber *BOX_INT(NSInteger x) { return [NSNumber numberWithInt:x]; }
NSNumber *BOX_SHORT(short x) { return [NSNumber numberWithShort:x]; }
NSNumber *BOX_LONG(long x) { return [NSNumber numberWithLong:x]; }
NSNumber *BOX_UINT(NSUInteger x) { return [NSNumber numberWithUnsignedInt:x]; }
NSNumber *BOX_FLOAT(float x) { return [NSNumber numberWithFloat:x]; }
NSNumber *BOX_DOUBLE(double x) { return [NSNumber numberWithDouble:x]; }

BOOL UNBOX_BOOL(NSNumber *x) { return [x boolValue]; }
NSInteger UNBOX_INT(NSNumber *x) { return [x intValue]; }
short UNBOX_SHORT(NSNumber *x) { return [x shortValue]; }
long UNBOX_LONG(NSNumber *x) { return [x longValue]; }
NSUInteger UNBOX_UINT(NSNumber *x) { return [x unsignedIntValue]; }
float UNBOX_FLOAT(NSNumber *x) { return [x floatValue]; }
double UNBOX_DOUBLE(NSNumber *x) { return [x doubleValue]; }


NSString *STRINGIFY_BOOL(BOOL x) { return (x ? @"true" : @"false"); }
NSString *STRINGIFY_INT(NSInteger x) { return [NSString stringWithFormat:@"%i", x]; }
NSString *STRINGIFY_SHORT(short x) { return [NSString stringWithFormat:@"%i", x]; }
NSString *STRINGIFY_LONG(long x) { return [NSString stringWithFormat:@"%li", x]; }
NSString *STRINGIFY_UINT(NSUInteger x) { return [NSString stringWithFormat:@"%u", x]; }
NSString *STRINGIFY_FLOAT(float x) { return [NSString stringWithFormat:@"%f", x]; }
NSString *STRINGIFY_DOUBLE(double x) { return [NSString stringWithFormat:@"%f", x]; }


CGRect RECT_WITH_X(CGRect rect, float x) { return CGRectMake(x, rect.origin.y, rect.size.width, rect.size.height); }
CGRect RECT_WITH_Y(CGRect rect, float y) { return CGRectMake(rect.origin.x, y, rect.size.width, rect.size.height); }
CGRect RECT_WITH_X_Y(CGRect rect, float x, float y) { return CGRectMake(x, y, rect.size.width, rect.size.height); }

CGRect RECT_WITH_WIDTH_HEIGHT(CGRect rect, float width, float height) { return CGRectMake(rect.origin.x, rect.origin.y, width, height); }
CGRect RECT_WITH_WIDTH(CGRect rect, float width) { return CGRectMake(rect.origin.x, rect.origin.y, width, rect.size.height); }
CGRect RECT_WITH_HEIGHT(CGRect rect, float height) { return CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, height); }

CGRect RECT_INSET_BY_LEFT_TOP_RIGHT_BOTTOM(CGRect rect, float left, float top, float right, float bottom) { return CGRectMake(rect.origin.x + left, rect.origin.y + top, rect.size.width - left - right, rect.size.height - top - bottom); }
CGRect RECT_INSET_BY_TOP_BOTTOM(CGRect rect, float top, float bottom) { return CGRectMake(rect.origin.x, rect.origin.y + top, rect.size.width, rect.size.height - top - bottom); }
CGRect RECT_INSET_BY_LEFT_RIGHT(CGRect rect, float left, float right) { return CGRectMake(rect.origin.x + left, rect.origin.y, rect.size.width - left - right, rect.size.height); }

CGRect RECT_STACKED_OFFSET_BY_X(CGRect rect, float offset) { return CGRectMake(rect.origin.x + rect.size.width + offset, rect.origin.y, rect.size.width, rect.size.height); }
CGRect RECT_STACKED_OFFSET_BY_Y(CGRect rect, float offset) { return CGRectMake(rect.origin.x, rect.origin.y + rect.size.height + offset, rect.size.width, rect.size.height); }


UIImage *IMAGE(NSString *x) { return [UIImage imageNamed:x]; }


double DEG_TO_RAD(double degrees) { return degrees * M_PI / 180.0; }
double RAD_TO_DEG(double radians) { return radians * 180.0 / M_PI; }

NSInteger CONSTRAINED_INT_VALUE(NSInteger val, NSInteger min, NSInteger max) { return MIN(MAX(val, min), max); }
float CONSTRAINED_FLOAT_VALUE(float val, float min, float max) { return MIN(MAX(val, min), max); }
double CONSTRAINED_DOUBLE_VALUE(double val, double min, double max) { return MIN(MAX(val, min), max); }


BOOL IS_EMPTY_STRING(NSString *str) { return !str || ![str isKindOfClass:NSString.class] || [str length] == 0; }
BOOL IS_POPULATED_STRING(NSString *str) { return str && [str isKindOfClass:NSString.class] && [str length] > 0; }


NSString *RECT_TO_STR(CGRect r) { return [NSString stringWithFormat:@"X=%0.1f Y=%0.1f W=%0.1f H=%0.1f", r.origin.x, r.origin.y, r.size.width, r.size.height]; }
NSString *POINT_TO_STR(CGPoint p) { return [NSString stringWithFormat:@"X=%0.1f Y=%0.1f", p.x, p.y]; }
NSString *SIZE_TO_STR(CGSize s) { return [NSString stringWithFormat:@"W=%0.1f H=%0.1f", s.width, s.height]; }


float RGB256_TO_COL(NSInteger rgb) { return rgb / 255.0f; }
NSInteger COL_TO_RGB256(float col) { return (NSInteger)(col * 255.0); }


NSString *DOCUMENTS_DIR(void) { return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]; }


BOOL IS_IPAD(void) {
    return [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad;
}

BOOL IS_IPHONE(void) {
    return [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone;
}

BOOL IS_MULTITASKING_AVAILABLE(void) {
    return [[UIDevice currentDevice] respondsToSelector:@selector(isMultitaskingSupported)] && [[UIDevice currentDevice] isMultitaskingSupported] == YES;
}

BOOL IS_CAMERA_AVAILABLE(void) {
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

BOOL IS_GAME_CENTER_AVAILABLE(void) {
    return NSClassFromString(@"GKLocalPlayer") && [[[UIDevice currentDevice] systemVersion] compare:@"4.1" options:NSNumericSearch] != NSOrderedAscending;
}

BOOL IS_EMAIL_ACCOUNT_AVAILABLE(void) {
    Class composerClass = NSClassFromString(@"MFMailComposeViewController");
    return [composerClass respondsToSelector:@selector(canSendMail)];
}

BOOL IS_GPS_ENABLED(void) {
    return IS_GPS_ENABLED_ON_DEVICE() && IS_GPS_ENABLED_FOR_APP();
}

BOOL IS_GPS_ENABLED_ON_DEVICE(void) {
    BOOL isLocationServicesEnabled;
    
    Class locationClass = NSClassFromString(@"CLLocationManager");
    NSMethodSignature *signature = [locationClass instanceMethodSignatureForSelector:@selector(locationServicesEnabled)];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    
    [invocation invoke];
    [invocation getReturnValue:&isLocationServicesEnabled];
    
    return locationClass && isLocationServicesEnabled;    
}

BOOL IS_GPS_ENABLED_FOR_APP(void) {
    // for 4.2+ only, we can check down to the app level
    #ifdef kCLAuthorizationStatusAuthorized
        Class locationClass = NSClassFromString(@"CLLocationManager");
    
        if ([locationClass respondsToSelector:@selector(authorizationStatus)]) {
            NSInteger authorizationStatus;
            
            NSMethodSignature *signature = [locationClass instanceMethodSignatureForSelector:@selector(authorizationStatus)];
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
            
            [invocation invoke];
            [invocation getReturnValue:&authorizationStatus];
            
            return locationClass && (authorizationStatus == kCLAuthorizationStatusAuthorized);    
        }
    #endif
    
    // we can't know this
    return YES;
}





@implementation DispatchMessage

@synthesize asynchronous = asynchronous_;
@synthesize name = name_;
@synthesize userInfo = userInfo_;

- (id)init {
	self = [super init];
	
	if (self) {
		name_ = nil;
		userInfo_ = nil;
		asynchronous_ = NO;
	}
	
	return self;
}

- (id)initWithName:(NSString *)name userInfo:(NSDictionary *)userInfo {
	self = [super init];

	if (self) {
		name_ = [name copy];
		userInfo_ = [userInfo mutableCopy];
	}
	
	return self;
}

- (id)initWithName:(NSString *)name andObjectsAndKeys:(id)firstObject, ... {
	self = [super init];
    
	if (self) {
        // construct user info
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        id currentObject = nil;
        id currentKey = nil;
        va_list argList;
        
        if (firstObject) {
            va_start(argList, firstObject);
            currentObject = firstObject;
            
            do {
                currentKey = va_arg(argList, id);
                [userInfo setObject:currentObject forKey:currentKey];
            } while ((currentObject = va_arg(argList, id)));
            
            va_end(argList);        
        }
        
		name_ = [name copy];
        userInfo_ = [userInfo mutableCopy];
	}
	
	return self;    
}

+ (id)messageWithName:(NSString *)name andObjectsAndKeys:(id)firstObject, ... {
    // construct user info
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    id currentObject = nil;
    id currentKey = nil;
    va_list argList;
    
    if (firstObject) {
        va_start(argList, firstObject);
        currentObject = firstObject;
        
        do {
            currentKey = va_arg(argList, id);
            [userInfo setObject:currentObject forKey:currentKey];
        } while ((currentObject = va_arg(argList, id)));
        
        va_end(argList);        
    }
    
	DispatchMessage *message = [[DispatchMessage alloc] initWithName:name userInfo:userInfo];
    
    va_end(argList);
    
	// autorelease
	return [message autorelease];
}

+ (id)messageWithName:(NSString *)name userInfo:(NSDictionary *)userInfo {
	DispatchMessage *message = [[DispatchMessage alloc] initWithName:name userInfo:userInfo];

	// autorelease
	return [message autorelease];
}

- (void)dealloc {
	[name_ release];
	[userInfo_ release];
	[super dealloc];
}

#pragma mark -

- (void)setUserInfo:(NSDictionary *)userInfo {
    NSDictionary *value = [userInfo copy];
    [userInfo_ release];
    userInfo_ = value;
}

#pragma mark -

- (void)inputData:(NSData *)input {
	// input and do nothing
}

- (NSData *)outputData {
	// output nothing
	return nil;
}

@end




@interface MessageCenter (private)

+ (NSMutableArray *)getTargetActionsForMessageName:(NSString *)name source:(NSObject *)source;
+ (NSMutableArray *)getTargetActionsForMessageName:(NSString *)name sourceDescription:(NSString *)sourceDescription;
+ (void)runProcessorInThread:(DispatchMessage *)message targetActions:(NSArray *)targetActions;

@end

static NSMutableDictionary *_messageListeners = nil;

static BOOL _debuggingEnabled = NO;

static NSString *getSourceIdentifier(NSObject *obj) {
	return [NSString stringWithFormat:@"%p", obj];
}

@implementation MessageCenter

+ (NSInteger)getCountOfListeningSources {
	return [_messageListeners count];
}

+ (void)setDebuggingEnabled:(BOOL)enabled {
	_debuggingEnabled = enabled;
}

+ (BOOL)isDebuggingEnabled {
	return _debuggingEnabled;
}

#pragma mark -

+ (void)initialize {
	_messageListeners = [[NSMutableDictionary alloc] init];
}

#pragma mark -

+ (void)addGlobalMessageListener:(NSString *)name target:(NSObject *)target action:(SEL)action {
	[MessageCenter addMessageListener:name source:nil target:target action:action];
}

+ (void)addMessageListener:(NSString *)name source:(NSObject *)source target:(NSObject *)target action:(SEL)action {
	// remove existing listener (avoids duplication)
	[MessageCenter removeMessageListener:name source:source target:target action:action];
	
	// add listener
	NSMutableArray *targetActions = [MessageCenter getTargetActionsForMessageName:name source:source];
	NSDictionary *targetAction = [NSDictionary dictionaryWithObjectsAndKeys:target, @"target", NSStringFromSelector(action), @"action", nil]; 
	[targetActions addObject:targetAction];
}

#pragma mark -

+ (void)removeMessageListener:(NSString *)name source:(NSObject *)source target:(NSObject *)target action:(SEL)action {
	NSMutableArray *targetActions = [MessageCenter getTargetActionsForMessageName:name source:source];
	
	// remove all matching target/action pairs
	for (NSInteger i = targetActions.count - 1; i >= 0; --i) {
		NSDictionary *iDictionary = (NSDictionary *)[targetActions objectAtIndex:i];
		NSObject *iTarget = (NSObject *)[iDictionary objectForKey:@"target"];
		
		// remove if matched
		if (iTarget == target) {
			SEL iAction = NSSelectorFromString((NSString *)[iDictionary objectForKey:@"action"]);
			
			if (iAction == action) {
				[targetActions removeObjectAtIndex:i];
			}
		}
	}
}

+ (void)removeMessageListener:(NSString *)name source:(NSObject *)source target:(NSObject *)target {
	NSMutableArray *targetActions = [MessageCenter getTargetActionsForMessageName:name source:source];
	
	// remove all matching targets
	for (NSInteger i = targetActions.count - 1; i >= 0; --i) {
		NSDictionary *iDictionary = (NSDictionary *)[targetActions objectAtIndex:i];
		NSObject *iTarget = (NSObject *)[iDictionary objectForKey:@"target"];
		
		// remove if matched
		if (iTarget == target) {
			[targetActions removeObjectAtIndex:i];
		}
	}
}

+ (void)removeMessageListener:(NSString *)name target:(NSObject *)target action:(SEL)action {
	for (NSMutableDictionary *iMessageNames in _messageListeners) {
		for (NSMutableArray *iTargetActions in iMessageNames) {
			// remove all matching target/action pairs
			for (NSInteger i = iTargetActions.count - 1; i >= 0; --i) {
				NSDictionary *iDictionary = (NSDictionary *)[iTargetActions objectAtIndex:i];
				NSObject *iTarget = (NSObject *)[iDictionary objectForKey:@"target"];
				
				// remove if matched
				if (iTarget == target) {
					SEL iAction = NSSelectorFromString((NSString *)[iDictionary objectForKey:@"action"]);
					
					if (iAction == action) {
						[iTargetActions removeObjectAtIndex:i];
					}
				}
			}
		}
	}
}

+ (void)removeMessageListenersForTarget:(NSObject *)target {
	for (NSString *iSourceDescription in _messageListeners) {
		NSMutableDictionary *targetActionsByName = [_messageListeners objectForKey:iSourceDescription];
		for (NSString *iTargetActionName in targetActionsByName) {
			NSMutableArray *iTargetActions = [targetActionsByName objectForKey:iTargetActionName];
			
			// remove all matching target/action pairs
			for (NSInteger i = iTargetActions.count - 1; i >= 0; --i) {
				NSDictionary *iDictionary = (NSDictionary *)[iTargetActions objectAtIndex:i];
				NSObject *iTarget = (NSObject *)[iDictionary objectForKey:@"target"];
				
				// remove if matched
				if (iTarget == target) {
					[iTargetActions removeObjectAtIndex:i];
				}
			}
		}
	}
}

#pragma mark -

+ (void)sendGlobalMessageNamed:(NSString *)name {
	[MessageCenter sendMessageNamed:name forSource:nil];
}

+ (void)sendGlobalMessageNamed:(NSString *)name withUserInfo:(NSDictionary *)userInfo {
	[MessageCenter sendMessageNamed:name withUserInfo:userInfo forSource:nil];
}

+ (void)sendGlobalMessageNamed:(NSString *)name withUserInfoKey:(NSObject *)key andValue:(NSObject *)value {
	NSDictionary *userInfo = [NSDictionary dictionaryWithObject:value forKey:key];
	[MessageCenter sendGlobalMessageNamed:name withUserInfo:userInfo];
}

+ (void)sendGlobalMessageNamed:(NSString *)name withObjectsAndKeys:(id)firstObject, ... {
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    id currentObject = nil;
    id currentKey = nil;
    va_list argList;
    
    if (firstObject) {
        va_start(argList, firstObject);
        currentObject = firstObject;
        
        do {
            currentKey = va_arg(argList, id);
            [userInfo setObject:currentObject forKey:currentKey];
        } while ((currentObject = va_arg(argList, id)));
        
        va_end(argList);        
    }

    [MessageCenter sendMessageNamed:name withUserInfo:userInfo forSource:nil ];
}

+ (void)sendGlobalMessage:(DispatchMessage *)message {
	[MessageCenter sendMessage:message forSource:nil];
}

+ (void)sendMessageNamed:(NSString *)name forSource:(NSObject *)source {
	DispatchMessage *message = [DispatchMessage messageWithName:name userInfo:nil];
	
	// dispatch
	[MessageCenter sendMessage:message forSource:source];
}

+ (void)sendMessageNamed:(NSString *)name withUserInfo:(NSDictionary *)userInfo forSource:(NSObject *)source {
	DispatchMessage *message = [DispatchMessage messageWithName:name userInfo:userInfo];
	
	// dispatch
	[MessageCenter sendMessage:message forSource:source];
}

+ (void)sendMessageNamed:(NSString *)name withUserInfoKey:(NSObject *)key andValue:(NSObject *)value forSource:(NSObject *)source {
	NSDictionary *userInfo = [NSDictionary dictionaryWithObject:value forKey:key];
	[MessageCenter sendMessageNamed:name withUserInfo:userInfo forSource:source];
}

+ (void)sendMessageNamed:(NSString *)name forSource:(NSObject *)source withObjectsAndKeys:(id)firstObject, ... {
    // construct user info
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    id currentObject = nil;
    id currentKey = nil;
    va_list argList;
    
    if (firstObject) {
        va_start(argList, firstObject);
        currentObject = firstObject;
        
        do {
            currentKey = va_arg(argList, id);
            [userInfo setObject:currentObject forKey:currentKey];
        } while ((currentObject = va_arg(argList, id)));
        
        va_end(argList);        
    }

	// dispatch
	[MessageCenter sendMessageNamed:name withUserInfo:userInfo forSource:source];
}

+ (void)sendMessage:(DispatchMessage *)message forSource:(NSObject *)source {
	// global or local delivery only
	NSArray *targetActions = [MessageCenter getTargetActionsForMessageName:message.name source:source];
	
	if (message.isAsynchronous) {
		// run completely in thread
		[MessageCenter performSelectorInBackground:@selector(runProcessorInThread:targetActions:) withObject:message withObject:targetActions];
	} else {
		// process message in sync
		MessageProcessor *processor = [[MessageProcessor alloc] initWithMessage:message targetActions:targetActions];

		[processor process];
		[processor release];
	}
}

+ (void)runProcessorInThread:(DispatchMessage *)message targetActions:(NSArray *)targetActions {
	// pool
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

	// process message
	MessageProcessor *processor = [[MessageProcessor alloc] initWithMessage:message targetActions:targetActions];

	// process
	[processor process];

	// release
	[processor release];
	
	// pool
	[pool release];
}

#pragma mark -

+ (NSMutableArray *)getTargetActionsForMessageName:(NSString *)name source:(NSObject *)source {
	// if no source given, treat as global listener (use self as key)
	if (!source) {
		source = [NSNull null];
	}
	
	return [self.class getTargetActionsForMessageName:name sourceDescription:getSourceIdentifier(source)];
}

+ (NSMutableArray *)getTargetActionsForMessageName:(NSString *)name sourceDescription:(NSString *)sourceDescription {
	NSMutableDictionary *messageNames = [_messageListeners objectForKey:sourceDescription];
	
	// add a new dictionary if there isn't one
	if (!messageNames) {
		[_messageListeners setObject:(messageNames = [NSMutableDictionary dictionary]) forKey:sourceDescription];
	}
	
	NSMutableArray *targetActions = [messageNames objectForKey:name];
	
	// add a new array if there isn't one
	if (!targetActions) {
		[messageNames setObject:(targetActions = [NSMutableArray array]) forKey:name];
	}
	
	return targetActions;
}

@end





@implementation MessageProcessor

- (id)initWithMessage:(DispatchMessage *)message targetActions:(NSArray *)targetActions {
	self = [super init];
	
	if (self) {
		_message = [message retain];
		_targetActions = [targetActions copy];
	}
	
	return self;
}

- (void)dealloc {
	[_message release];
	[_targetActions release];
	[super dealloc];
}

- (void)process {
	// process
	[_message inputData:nil];
	
	// dispatch for all target/action pairs
	for (NSInteger i = _targetActions.count - 1; i >= 0; --i) {
		NSDictionary *iDictionary = (NSDictionary *)[_targetActions objectAtIndex:i];
		NSObject *iTarget = (NSObject *)[iDictionary objectForKey:@"target"];
		SEL iAction = NSSelectorFromString((NSString *)[iDictionary objectForKey:@"action"]);
		
		// perform on main thread
		if (_message.isAsynchronous) {
			[iTarget performSelectorOnMainThread:iAction withObject:_message waitUntilDone:NO];
		} else {
			[iTarget performSelector:iAction withObject:_message];			
		}
	}
}

- (void)processInThread {
}

@end




void CGContextAddRoundedRect(CGContextRef context, CGRect rect, CGFloat radius) {
	CGFloat minx = CGRectGetMinX(rect), midx = CGRectGetMidX(rect), maxx = CGRectGetMaxX(rect);
	CGFloat miny = CGRectGetMinY(rect), midy = CGRectGetMidY(rect), maxy = CGRectGetMaxY(rect);	
	CGContextMoveToPoint(context, minx, midy);
	CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
	CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
	CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
	CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
	CGContextClosePath(context);
}
void CGContextAddRoundedRectComplex(CGContextRef context, CGRect rect, const CGFloat radiuses[]) {
	CGFloat minx = CGRectGetMinX(rect), midx = CGRectGetMidX(rect), maxx = CGRectGetMaxX(rect);
	CGFloat miny = CGRectGetMinY(rect), midy = CGRectGetMidY(rect), maxy = CGRectGetMaxY(rect);	
	CGContextMoveToPoint(context, minx, midy);
	CGContextAddArcToPoint(context, minx, miny, midx, miny, radiuses[0]);
	CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radiuses[1]);
	CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radiuses[2]);
	CGContextAddArcToPoint(context, minx, maxy, minx, midy, radiuses[3]);
	CGContextClosePath(context);
}




@implementation NSArray (InnerBand)

- (NSArray *)sortedArrayAsDiacriticInsensitiveCaseInsensitive {
	return [self sortedArrayUsingSelector:@selector(diacriticInsensitiveCaseInsensitiveSort:)];
}

- (NSArray *)sortedArrayAsDiacriticInsensitive {
	return [self sortedArrayUsingSelector:@selector(diacriticInsensitiveSort:)];
}

- (NSArray *)sortedArrayAsCaseInsensitive {
	return [self sortedArrayUsingSelector:@selector(caseInsensitiveSort:)];
}

- (NSArray *)sortedArray {
	return [self sortedArrayUsingSelector:@selector(compare:)];
}

- (NSArray *)reversedArray {
    NSMutableArray *reversedArray = [NSMutableArray arrayWithCapacity:self.count];
    NSEnumerator *enumerator = [self reverseObjectEnumerator];
    
    for (id iObject in enumerator) {
        [reversedArray addObject:iObject];
    }
    
    return [[reversedArray copy] autorelease];
}

- (NSArray *)shuffledArray {
    NSMutableArray *shuffledArray = [NSMutableArray arrayWithArray:self];
    
    [shuffledArray shuffle];
    
    return [[shuffledArray copy] autorelease];
}

- (id)firstObject {
    return (self.count > 0) ? [self objectAtIndex:0] : nil;
}

#pragma mark -


- (NSArray *)map:(ib_enum_id_t)blk {
    NSMutableArray *mappedArray = [NSMutableArray array];
    
    for (NSInteger i = (self.count - 1); i >= 0; --i) {
        [mappedArray unshiftObject:blk([self objectAtIndex:i])];
    }
    
    return mappedArray;
}

@end



#import <time.h>

@implementation NSDate (InnerBand)

+ (NSDate *)dateDaysAgo:(NSInteger)numDays {
    NSCalendar *_calendar = [NSCalendar currentCalendar];
    NSDateComponents *_datecomp = [_calendar components:NSDayCalendarUnit fromDate:[NSDate date]];
    [_datecomp setDay:[_datecomp day] - numDays];
    return [_calendar dateFromComponents:_datecomp];
}

+ (NSDate *)dateWeeksAgo:(NSInteger)numWeeks {
    NSCalendar *_calendar = [NSCalendar currentCalendar];
    NSDateComponents *_datecomp = [_calendar components:NSWeekCalendarUnit fromDate:[NSDate date]];
    [_datecomp setWeek:[_datecomp week] - numWeeks];
    return [_calendar dateFromComponents:_datecomp];
}

- (NSInteger)utcYear {
    NSCalendar *_calendar = [NSCalendar currentCalendar];
    [_calendar setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDateComponents *_datecomp = [_calendar components:NSYearCalendarUnit fromDate:self];
    return [_datecomp year];
}

- (NSInteger)utcMonth {
    NSCalendar *_calendar = [NSCalendar currentCalendar];
    [_calendar setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDateComponents *_datecomp = [_calendar components:NSMonthCalendarUnit fromDate:self];
    return [_datecomp month];
}

- (NSInteger)utcDay {
    NSCalendar *_calendar = [NSCalendar currentCalendar];
    [_calendar setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDateComponents *_datecomp = [_calendar components:NSDayCalendarUnit fromDate:self];
    return [_datecomp day];
}

- (NSInteger)utcHour {
    NSCalendar *_calendar = [NSCalendar currentCalendar];
    [_calendar setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDateComponents *_datecomp = [_calendar components:NSHourCalendarUnit fromDate:self];
    return [_datecomp hour];
}

- (NSInteger)utcMinute {
    NSCalendar *_calendar = [NSCalendar currentCalendar];
    [_calendar setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDateComponents *_datecomp = [_calendar components:NSMinuteCalendarUnit fromDate:self];
    return [_datecomp minute];
}

- (NSInteger)utcSecond {
    NSCalendar *_calendar = [NSCalendar currentCalendar];
    [_calendar setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDateComponents *_datecomp = [_calendar components:NSSecondCalendarUnit fromDate:self];
    return [_datecomp second];
}

- (NSInteger)year {
    NSCalendar *_calendar = [NSCalendar currentCalendar];
    NSDateComponents *_datecomp = [_calendar components:NSYearCalendarUnit fromDate:self];
    return [_datecomp year];
}

- (NSInteger)month {
    NSCalendar *_calendar = [NSCalendar currentCalendar];
    NSDateComponents *_datecomp = [_calendar components:NSMonthCalendarUnit fromDate:self];
    return [_datecomp month];
}

- (NSInteger)day {
    NSCalendar *_calendar = [NSCalendar currentCalendar];
    NSDateComponents *_datecomp = [_calendar components:NSDayCalendarUnit fromDate:self];
    return [_datecomp day];
}

- (NSInteger)hour {
    NSCalendar *_calendar = [NSCalendar currentCalendar];
    NSDateComponents *_datecomp = [_calendar components:NSHourCalendarUnit fromDate:self];
    return [_datecomp hour];
}

- (NSInteger)minute {
    NSCalendar *_calendar = [NSCalendar currentCalendar];
    NSDateComponents *_datecomp = [_calendar components:NSMinuteCalendarUnit fromDate:self];
    return [_datecomp minute];
}

- (NSInteger)second {
    NSCalendar *_calendar = [NSCalendar currentCalendar];
    NSDateComponents *_datecomp = [_calendar components:NSSecondCalendarUnit fromDate:self];
    return [_datecomp second];
}

- (NSString *)formattedUTCDateStyle:(NSDateFormatterStyle)dateStyle {
	NSDateFormatter *format = [[[NSDateFormatter alloc] init] autorelease];
	[format setDateStyle:dateStyle];
	[format setTimeStyle:NSDateFormatterNoStyle];
	[format setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
	
	return [format stringFromDate:self];
}

- (NSString *)formattedUTCTimeStyle:(NSDateFormatterStyle)timeStyle {
	NSDateFormatter *format = [[[NSDateFormatter alloc] init] autorelease];
	[format setDateStyle:NSDateFormatterNoStyle];
	[format setTimeStyle:timeStyle];
	[format setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
	
	return [format stringFromDate:self];
}

- (NSString *)formattedUTCDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle {
	NSDateFormatter *format = [[[NSDateFormatter alloc] init] autorelease];
	[format setDateStyle:dateStyle];
	[format setTimeStyle:timeStyle];
	[format setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
	
	return [format stringFromDate:self];
}

- (NSString *)formattedUTCDatePattern:(NSString *)datePattern {
	//
	// format document: http://unicode.org/reports/tr35/tr35-6.html#Date_Format_Patterns
	//
	NSDateFormatter *format = [[[NSDateFormatter alloc] init] autorelease];
	[format setDateFormat:datePattern];
	[format setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
	
	return [format stringFromDate:self];
}

- (NSString *)formattedDateStyle:(NSDateFormatterStyle)dateStyle {
	NSDateFormatter *format = [[[NSDateFormatter alloc] init] autorelease];
	[format setDateStyle:dateStyle];
	[format setTimeStyle:NSDateFormatterNoStyle];
	
	return [format stringFromDate:self];
}

- (NSString *)formattedTimeStyle:(NSDateFormatterStyle)timeStyle {
	NSDateFormatter *format = [[[NSDateFormatter alloc] init] autorelease];
	[format setDateStyle:NSDateFormatterNoStyle];
	[format setTimeStyle:timeStyle];

	return [format stringFromDate:self];
}

- (NSString *)formattedDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle {
	NSDateFormatter *format = [[[NSDateFormatter alloc] init] autorelease];
	[format setDateStyle:dateStyle];
	[format setTimeStyle:timeStyle];
	
	return [format stringFromDate:self];
}

- (NSString *)formattedDatePattern:(NSString *)datePattern {
	//
	// format document: http://unicode.org/reports/tr35/tr35-6.html#Date_Format_Patterns
	//
	NSDateFormatter *format = [[[NSDateFormatter alloc] init] autorelease];
	[format setDateFormat:datePattern];
	
	return [format stringFromDate:self];
}

- (NSDate *)dateAsMidnight {
    NSCalendar *_calendar = [NSCalendar currentCalendar];
    [_calendar setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDateComponents *_datecomp = [_calendar components:NSMonthCalendarUnit|NSDayCalendarUnit|NSYearCalendarUnit fromDate:self];
    NSLog(@"Current Date: %@",[_calendar dateFromComponents:_datecomp]);
	return [_calendar dateFromComponents:_datecomp];
}
@end




#import <objc/runtime.h>

@class CoreDataStore;

@implementation NSManagedObject (InnerBand)

+ (id)create {
    return [self createInStore:[CoreDataStore mainStore]];
}

+ (id)createInStore:(CoreDataStore *)store {
    return [store createNewEntityByName:NSStringFromClass(self.class)];
}

+ (NSArray *)all {
    return [self allInStore:[CoreDataStore mainStore]];
}

+ (NSArray *)allForPredicate:(NSPredicate *)predicate {
    return [self allForPredicate:predicate inStore:[CoreDataStore mainStore]];
}

+ (NSArray *)allForPredicate:(NSPredicate *)predicate orderBy:(NSString *)key ascending:(BOOL)ascending {
    return [self allForPredicate:predicate orderBy:key ascending:ascending inStore:[CoreDataStore mainStore]];
}

+ (NSArray *)allOrderedBy:(NSString *)key ascending:(BOOL)ascending {
    return [self allOrderedBy:key ascending:ascending inStore:[CoreDataStore mainStore]];
}

+ (NSArray *)allInStore:(CoreDataStore *)store {
    NSError *error = nil;
    return [store allForEntity:NSStringFromClass(self.class) error:&error];    
}

+ (NSArray *)allForPredicate:(NSPredicate *)predicate inStore:(CoreDataStore *)store {
    NSError *error = nil;
    return [store allForEntity:NSStringFromClass(self.class) predicate:predicate error:&error];
}

+ (NSArray *)allForPredicate:(NSPredicate *)predicate orderBy:(NSString *)key ascending:(BOOL)ascending inStore:(CoreDataStore *)store {
    NSError *error = nil;
    return [store allForEntity:NSStringFromClass(self.class) predicate:predicate orderBy:key ascending:ascending error:&error];    
}

+ (NSArray *)allOrderedBy:(NSString *)key ascending:(BOOL)ascending inStore:(CoreDataStore *)store {
    NSError *error = nil;
    return [store allForEntity:NSStringFromClass(self.class) orderBy:key ascending:ascending error:&error];
}

+ (id)first {
    return [self firstInStore:[CoreDataStore mainStore]];
}

+ (id)firstWithKey:(NSString *)key value:(NSObject *)value {
    return [self firstWithKey:key value:value inStore:[CoreDataStore mainStore]];
}

+ (id)firstInStore:(CoreDataStore *)store {
    NSError *error = nil;
    return [store entityByName:NSStringFromClass(self.class) error:&error];    
}

+ (id)firstWithKey:(NSString *)key value:(NSObject *)value inStore:(CoreDataStore *)store {
    NSError *error = nil;
    return [store entityByName:NSStringFromClass(self.class) key:key value:value error:&error];    
}

- (void)destroy {
    [[CoreDataStore mainStore] removeEntity:self];
}

+ (void)destroyAll {
    return [self destroyAllInStore:[CoreDataStore mainStore]];
}

+ (void)destroyAllInStore:(CoreDataStore *)store {
    return [store removeAllEntitiesByName:NSStringFromClass(self.class)];
}

@end




static const void* IBRetainNoOp(CFAllocatorRef allocator, const void *value) { return value; }
static void IBReleaseNoOp(CFAllocatorRef allocator, const void *value) { }

@implementation NSMutableArray (InnerBand)

+ (NSMutableArray *)arrayUnretaining {
	CFArrayCallBacks callbacks = kCFTypeArrayCallBacks;
	callbacks.retain = IBRetainNoOp;
	callbacks.release = IBReleaseNoOp;
	return [(NSMutableArray*)CFArrayCreateMutable(nil, 0, &callbacks) autorelease];
}

- (void)sortDiacriticInsensitiveCaseInsensitive {
	[self sortUsingSelector:@selector(diacriticInsensitiveCaseInsensitiveSort:)];
}

- (void)sortDiacriticInsensitive {
	[self sortUsingSelector:@selector(diacriticInsensitiveSort:)];
}

- (void)sortCaseInsensitive {
	[self sortUsingSelector:@selector(caseInsensitiveSort:)];
}

#pragma mark -

- (void)pushObject:(id)obj {
    [self addObject:obj];
}

- (id)popObject {
    id pop = [[self lastObject] retain];
    [self removeLastObject];

    return [pop autorelease];
}

- (id)shiftObject {
    if (self.count > 0) {
        id shft = [[self objectAtIndex:0] retain];
        [self removeObjectAtIndex:0];
        return [shft autorelease];
    }

    return nil;
}

- (void)unshiftObject:(id)obj {
    [self insertObject:obj atIndex:0];
}

#pragma mark -

- (void)deleteIf:(ib_enum_bool_t)blk {
    for (NSInteger i = (self.count - 1); i >= 0; --i) {
        if (blk([self objectAtIndex:i])) {
            [self removeObjectAtIndex:i];
        }
    }
}

#pragma mark -

- (void)shuffle {
    // shuffle it 3 times because 3 is magical
    for (NSInteger times=0; times < 3; ++times) {
        for (NSInteger i=self.count - 1; i >= 0; --i) {
            NSInteger fromIndex = arc4random() % self.count;
            NSInteger toIndex = arc4random() % self.count;
            
            [self exchangeObjectAtIndex:fromIndex withObjectAtIndex:toIndex];
        }
    }
}

- (void)reverse {
    for (NSInteger i=0, j=self.count - 1; i < j; ++i, --j) {
        [self exchangeObjectAtIndex:i withObjectAtIndex:j];
    }
}

@end




@implementation NSMutableString (InnerBand)

- (void)trim {
    NSString *trimmedString = [self trimmedString];
    
    // replace self
    [self replaceCharactersInRange:NSMakeRange(0, self.length) withString:trimmedString];
}

@end





@implementation NSNumber (InnerBand)

- (NSString *)formattedCurrency {
	NSNumberFormatter *format = [[[NSNumberFormatter alloc] init] autorelease];
	[format setNumberStyle:NSNumberFormatterCurrencyStyle];
	
	return [format stringFromNumber:self];
}

- (NSString *)formattedFlatCurrency {
    NSNumberFormatter *format = [[[NSNumberFormatter alloc] init] autorelease];
    [format setNumberStyle:NSNumberFormatterDecimalStyle];
    [format setMinimumFractionDigits:2];
    [format setMaximumFractionDigits:2];
    
    return [format stringFromNumber:self];
}

- (NSString *)formattedCurrencyWithMinusSign {
	NSNumberFormatter *format = [[[NSNumberFormatter alloc] init] autorelease];
	[format setNumberStyle:NSNumberFormatterCurrencyStyle];
	[format setNegativeFormat:@"-$#,##0.00"];

	return [format stringFromNumber:self];
}

- (NSString *)formattedDecimal {
	NSNumberFormatter *format = [[[NSNumberFormatter alloc] init] autorelease];
	[format setNumberStyle:NSNumberFormatterDecimalStyle];
	
	return [format stringFromNumber:self];
}

- (NSString *)formattedFlatDecimal {
	NSNumberFormatter *format = [[[NSNumberFormatter alloc] init] autorelease];
	[format setNumberStyle:NSNumberFormatterDecimalStyle];
	[format setGroupingSeparator:@""];
	
	return [format stringFromNumber:self];
}

- (NSString *)formattedSpellOut {
	NSNumberFormatter *format = [[[NSNumberFormatter alloc] init] autorelease];
	[format setNumberStyle:NSNumberFormatterSpellOutStyle];
	
	return [format stringFromNumber:self];
}

@end





@implementation NSObject (InnerBand)

- (id)performSelector:(SEL)selector withObject:(id)p1 withObject:(id)p2 withObject:(id)p3 {
	NSMethodSignature *sig = [self methodSignatureForSelector:selector];
	if (sig) {
		NSInvocation* invo = [NSInvocation invocationWithMethodSignature:sig];
		[invo setTarget:self];
		[invo setSelector:selector];
		[invo setArgument:&p1 atIndex:2];
		[invo setArgument:&p2 atIndex:3];
		[invo setArgument:&p3 atIndex:4];
		[invo invoke];
		if (sig.methodReturnLength) {
			id anObject;
			[invo getReturnValue:&anObject];
			return anObject;
		} else {
			return nil;
		}
	} else {
		return nil;
	}
}

- (id)performSelector:(SEL)selector withObject:(id)p1 withObject:(id)p2 withObject:(id)p3 withObject:(id)p4 {
	NSMethodSignature *sig = [self methodSignatureForSelector:selector];
	if (sig) {
		NSInvocation* invo = [NSInvocation invocationWithMethodSignature:sig];
		[invo setTarget:self];
		[invo setSelector:selector];
		[invo setArgument:&p1 atIndex:2];
		[invo setArgument:&p2 atIndex:3];
		[invo setArgument:&p3 atIndex:4];
		[invo setArgument:&p4 atIndex:5];
		[invo invoke];
		if (sig.methodReturnLength) {
			id anObject;
			[invo getReturnValue:&anObject];
			return anObject;
		} else {
			return nil;
		}
	} else {
		return nil;
	}
}

- (void)performSelectorInBackground:(SEL)selector withObject:(id)p1 withObject:(id)p2 {
	NSMethodSignature *sig = [self methodSignatureForSelector:selector];

	if (sig) {
		NSInvocation* invo = [NSInvocation invocationWithMethodSignature:sig];
		[invo setTarget:self];
		[invo setSelector:selector];
		[invo setArgument:&p1 atIndex:2];
		[invo setArgument:&p2 atIndex:3];
        [invo retainArguments];        
		[invo performSelectorInBackground:@selector(invoke) withObject:nil];
	}
}

- (void)performSelectorInBackground:(SEL)selector withObject:(id)p1 withObject:(id)p2 withObject:(id)p3 {
	NSMethodSignature *sig = [self methodSignatureForSelector:selector];
	
	if (sig) {
		NSInvocation* invo = [NSInvocation invocationWithMethodSignature:sig];
		[invo setTarget:self];
		[invo setSelector:selector];
		[invo setArgument:&p1 atIndex:2];
		[invo setArgument:&p2 atIndex:3];
		[invo setArgument:&p3 atIndex:4];
        [invo retainArguments];        
		[invo performSelectorInBackground:@selector(invoke) withObject:nil];
	}
}

- (void)performSelectorInBackground:(SEL)selector withObject:(id)p1 withObject:(id)p2 withObject:(id)p3 withObject:(id)p4{
	NSMethodSignature *sig = [self methodSignatureForSelector:selector];
	
	if (sig) {
		NSInvocation* invo = [NSInvocation invocationWithMethodSignature:sig];
		[invo setTarget:self];
		[invo setSelector:selector];
		[invo setArgument:&p1 atIndex:2];
		[invo setArgument:&p2 atIndex:3];
		[invo setArgument:&p3 atIndex:4];
		[invo setArgument:&p4 atIndex:5];
        [invo retainArguments];        
		[invo performSelectorInBackground:@selector(invoke) withObject:nil];
	}
}

@end





@implementation NSString (InnerBand)

- (NSComparisonResult)diacriticInsensitiveCaseInsensitiveSort:(NSString *)rhs {
	return [self compare:rhs options:NSDiacriticInsensitiveSearch | NSCaseInsensitiveSearch];	
}

- (NSComparisonResult)diacriticInsensitiveSort:(NSString *)rhs {
	return [self compare:rhs options:NSDiacriticInsensitiveSearch];	
}

- (NSComparisonResult)caseInsensitiveSort:(NSString *)rhs {
	return [self compare:rhs options:NSCaseInsensitiveSearch];	
}

- (NSString *)asBundlePath {
	NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
	return [resourcePath stringByAppendingPathComponent:self];
}

- (NSString *)asDocumentsPath {
	static NSString* documentsPath = nil;

	if (!documentsPath) {
		NSArray *dirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		documentsPath = [[dirs objectAtIndex:0] retain];
	}
	
	return [documentsPath stringByAppendingPathComponent:self];
}

- (BOOL)contains:(NSString *)substring {
    return ([self rangeOfString:substring].location != NSNotFound);
}

- (BOOL)contains:(NSString *)substring options:(NSStringCompareOptions)options {
    return ([self rangeOfString:substring options:options].location != NSNotFound);
}

- (NSString *)trimmedString {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end




const NSInteger MAX_RGB_COLOR_VALUE = 0xff;
const NSInteger MAX_RGB_COLOR_VALUE_FLOAT = 255.0f;

@implementation UIColor (InnerBand)

+ (UIColor *)colorWith256Red:(NSInteger)r green:(NSInteger)g blue:(NSInteger)b {
	return [UIColor colorWithRed:RGB256_TO_COL(r) green:RGB256_TO_COL(g) blue:RGB256_TO_COL(b) alpha:1.0];
}

+ (UIColor *)colorWith256Red:(NSInteger)r green:(NSInteger)g blue:(NSInteger)b alpha:(NSInteger)a {
	return [UIColor colorWithRed:RGB256_TO_COL(r) green:RGB256_TO_COL(g) blue:RGB256_TO_COL(b) alpha:RGB256_TO_COL(a)];
}
			
+ (UIColor *) colorWithRGBA:(uint) hex {
	return [UIColor colorWithRed:(CGFloat)((hex>>24) & MAX_RGB_COLOR_VALUE) / MAX_RGB_COLOR_VALUE_FLOAT 
						   green:(CGFloat)((hex>>16) & MAX_RGB_COLOR_VALUE) / MAX_RGB_COLOR_VALUE_FLOAT 
							blue:(CGFloat)((hex>>8) & MAX_RGB_COLOR_VALUE) / MAX_RGB_COLOR_VALUE_FLOAT 
						   alpha:(CGFloat)((hex) & MAX_RGB_COLOR_VALUE) / MAX_RGB_COLOR_VALUE_FLOAT];
}

+ (UIColor *) colorWithARGB:(uint) hex {
	return [UIColor colorWithRed:(CGFloat)((hex>>16) & MAX_RGB_COLOR_VALUE) / MAX_RGB_COLOR_VALUE_FLOAT 
						   green:(CGFloat)((hex>>8) & MAX_RGB_COLOR_VALUE) / MAX_RGB_COLOR_VALUE_FLOAT 
							blue:(CGFloat)(hex & MAX_RGB_COLOR_VALUE) / MAX_RGB_COLOR_VALUE_FLOAT 
						   alpha:(CGFloat)((hex>>24) & MAX_RGB_COLOR_VALUE) / MAX_RGB_COLOR_VALUE_FLOAT];
}

+ (UIColor *) colorWithRGB:(uint) hex {
	return [UIColor colorWithRed:(CGFloat)((hex>>16) & MAX_RGB_COLOR_VALUE) / MAX_RGB_COLOR_VALUE_FLOAT 
						   green:(CGFloat)((hex>>8) & MAX_RGB_COLOR_VALUE) / MAX_RGB_COLOR_VALUE_FLOAT 
							blue:(CGFloat)(hex & MAX_RGB_COLOR_VALUE) / MAX_RGB_COLOR_VALUE_FLOAT 
						   alpha:1.0];
}

+ (UIColor *)colorWithHexString:(NSString *)hexString {
	uint hex;
	
	// chop off hash
	if ([hexString characterAtIndex:0] == '#') {
		hexString = [hexString substringFromIndex:1];
	}
	
	// depending on character count, generate a color
	NSInteger hexStringLength = hexString.length;
	
	if (hexStringLength == 3) {
		// RGB, once character each (each should be repeated)
		hexString = [NSString stringWithFormat:@"%c%c%c%c%c%c", [hexString characterAtIndex:0], [hexString characterAtIndex:0], [hexString characterAtIndex:1], [hexString characterAtIndex:1], [hexString characterAtIndex:2], [hexString characterAtIndex:2]];
		hex = strtoul([hexString UTF8String], NULL, 16);	

		return [self colorWithRGB:hex];
	} else if (hexStringLength == 4) {
		// RGBA, once character each (each should be repeated)
		hexString = [NSString stringWithFormat:@"%c%c%c%c%c%c%c%c", [hexString characterAtIndex:0], [hexString characterAtIndex:0], [hexString characterAtIndex:1], [hexString characterAtIndex:1], [hexString characterAtIndex:2], [hexString characterAtIndex:2], [hexString characterAtIndex:3], [hexString characterAtIndex:3]];
		hex = strtoul([hexString UTF8String], NULL, 16);		

		return [self colorWithRGBA:hex];
	} else if (hexStringLength == 6) {
		// RGB
		hex = strtoul([hexString UTF8String], NULL, 16);		
		
		return [self colorWithRGB:hex];
	} else if (hexStringLength == 8) {
		// RGBA
		hex = strtoul([hexString UTF8String], NULL, 16);		

		return [self colorWithRGBA:hex];
	}
	
	// illegal
	[NSException raise:@"Invalid Hex String" format:@"Hex string invalid: %@", hexString];
	
	return nil;
}

- (NSString *) hexString {
	const CGFloat *components = CGColorGetComponents(self.CGColor);
	
	NSInteger red = (int)(components[0] * MAX_RGB_COLOR_VALUE);
	NSInteger green = (int)(components[1] * MAX_RGB_COLOR_VALUE);
	NSInteger blue = (int)(components[2] * MAX_RGB_COLOR_VALUE);
	NSInteger alpha = (int)(components[3] * MAX_RGB_COLOR_VALUE);
	
	if (alpha < 255) {
		return [NSString stringWithFormat:@"#%02x%02x%02x%02x", red, green, blue, alpha];
	}
	
	return [NSString stringWithFormat:@"#%02x%02x%02x", red, green, blue];
}

- (UIColor*) colorBrighterByPercent:(float) percent {
	percent = MAX(percent, 0.0f);
	percent = (percent + 100.0f) / 100.0f;
	const CGFloat* rgba = CGColorGetComponents(self.CGColor);
	CGFloat r = rgba[0];
	CGFloat g = rgba[1];
	CGFloat b = rgba[2];
	CGFloat a = rgba[3];
	CGFloat newR = r * percent;
	CGFloat newG = g * percent;
	CGFloat newB = b * percent;
	return [UIColor colorWithRed:newR green:newG blue:newB alpha:a];
}

- (UIColor*) colorDarkerByPercent:(float) percent {
	percent = MAX(percent, 0.0f);
	percent /= 100.0f;
	const CGFloat* rgba = CGColorGetComponents(self.CGColor);
	CGFloat r = rgba[0];
	CGFloat g = rgba[1];
	CGFloat b = rgba[2];
	CGFloat a = rgba[3];
	CGFloat newR = r - (r * percent);
	CGFloat newG = g - (g * percent);
	CGFloat newB = b - (b * percent);
	return [UIColor colorWithRed:newR green:newG blue:newB alpha:a];
}

- (CGFloat)r {
	const CGFloat* rgba = CGColorGetComponents(self.CGColor);
	return rgba[0];
}

- (CGFloat)g {
	const CGFloat* rgba = CGColorGetComponents(self.CGColor);
	return rgba[1];
}

- (CGFloat)b {
	const CGFloat* rgba = CGColorGetComponents(self.CGColor);
	return rgba[2];
}

- (CGFloat)a {
	const CGFloat* rgba = CGColorGetComponents(self.CGColor);
	return rgba[3];
}
						
@end





@implementation UIImage (InnerBand)

- (void)drawInRect:(CGRect)rect contentMode:(UIViewContentMode)contentMode {
	BOOL clip = NO;
	CGRect originalRect = rect;
	if (self.size.width != rect.size.width || self.size.height != rect.size.height) {
		clip = contentMode != UIViewContentModeScaleAspectFill
		&& contentMode != UIViewContentModeScaleAspectFit;
		rect = [self convertRect:rect withContentMode:contentMode];
	}
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	if (clip) {
		CGContextSaveGState(context);
		CGContextAddRect(context, originalRect);
		CGContextClip(context);
	}
	
	[self drawInRect:rect];
	
	if (clip) {
		CGContextRestoreGState(context);
	}
}

- (CGRect)convertRect:(CGRect)rect withContentMode:(UIViewContentMode)contentMode {
	if (self.size.width != rect.size.width || self.size.height != rect.size.height) {
		if (contentMode == UIViewContentModeLeft) {
			return CGRectMake(rect.origin.x,
							  rect.origin.y + floor(rect.size.height/2 - self.size.height/2),
							  self.size.width, self.size.height);
		} else if (contentMode == UIViewContentModeRight) {
			return CGRectMake(rect.origin.x + (rect.size.width - self.size.width),
							  rect.origin.y + floor(rect.size.height/2 - self.size.height/2),
							  self.size.width, self.size.height);
		} else if (contentMode == UIViewContentModeTop) {
			return CGRectMake(rect.origin.x + floor(rect.size.width/2 - self.size.width/2),
							  rect.origin.y,
							  self.size.width, self.size.height);
		} else if (contentMode == UIViewContentModeBottom) {
			return CGRectMake(rect.origin.x + floor(rect.size.width/2 - self.size.width/2),
							  rect.origin.y + floor(rect.size.height - self.size.height),
							  self.size.width, self.size.height);
		} else if (contentMode == UIViewContentModeCenter) {
			return CGRectMake(rect.origin.x + floor(rect.size.width/2 - self.size.width/2),
							  rect.origin.y + floor(rect.size.height/2 - self.size.height/2),
							  self.size.width, self.size.height);
		} else if (contentMode == UIViewContentModeBottomLeft) {
			return CGRectMake(rect.origin.x,
							  rect.origin.y + floor(rect.size.height - self.size.height),
							  self.size.width, self.size.height);
		} else if (contentMode == UIViewContentModeBottomRight) {
			return CGRectMake(rect.origin.x + (rect.size.width - self.size.width),
							  rect.origin.y + (rect.size.height - self.size.height),
							  self.size.width, self.size.height);
		} else if (contentMode == UIViewContentModeTopLeft) {
			return CGRectMake(rect.origin.x,
							  rect.origin.y,
							  
							  self.size.width, self.size.height);
		} else if (contentMode == UIViewContentModeTopRight) {
			return CGRectMake(rect.origin.x + (rect.size.width - self.size.width),
							  rect.origin.y,
							  self.size.width, self.size.height);
		} else if (contentMode == UIViewContentModeScaleAspectFill) {
			CGSize imageSize = self.size;
			if (imageSize.height < imageSize.width) {
				imageSize.width = floor((imageSize.width/imageSize.height) * rect.size.height);
				imageSize.height = rect.size.height;
			} else {
				imageSize.height = floor((imageSize.height/imageSize.width) * rect.size.width);
				imageSize.width = rect.size.width;
			}
			return CGRectMake(rect.origin.x + floor(rect.size.width/2 - imageSize.width/2),
							  rect.origin.y + floor(rect.size.height/2 - imageSize.height/2),
							  imageSize.width, imageSize.height);
		} else if (contentMode == UIViewContentModeScaleAspectFit) {
			CGSize imageSize = self.size;
			if (imageSize.height < imageSize.width) {
				imageSize.height = floor((imageSize.height/imageSize.width) * rect.size.width);
				imageSize.width = rect.size.width;
			} else {
				imageSize.width = floor((imageSize.width/imageSize.height) * rect.size.height);
				imageSize.height = rect.size.height;
			}
			return CGRectMake(rect.origin.x + floor(rect.size.width/2 - imageSize.width/2),
							  rect.origin.y + floor(rect.size.height/2 - imageSize.height/2),
							  imageSize.width, imageSize.height);
		}
	}
	return rect;
}

@end




@implementation UIView (InnerBand)

- (CGFloat)left {
	return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
	CGRect frame = self.frame;
	frame.origin.x = x;
	self.frame = frame;
}

- (CGFloat)top {
	return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
	CGRect frame = self.frame;
	frame.origin.y = y;
	self.frame = frame;
}

- (CGFloat)right {
	return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
	CGRect frame = self.frame;
	frame.origin.x = right - frame.size.width;
	self.frame = frame;
}

- (CGFloat)bottom {
	return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
	CGRect frame = self.frame;
	frame.origin.y = bottom - frame.size.height;
	self.frame = frame;
}

- (CGFloat)centerX {
	return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
	self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY {
	return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
	self.center = CGPointMake(self.center.x, centerY);
}

- (CGFloat)width {
	return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
	CGRect frame = self.frame;
	frame.size.width = width;
	self.frame = frame;
}

- (CGFloat)height {
	return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
	CGRect frame = self.frame;
	frame.size.height = height;
	self.frame = frame;
}

- (void)setVisible:(BOOL)value {
	self.hidden = !value;
}

- (BOOL)visible {
	return !self.hidden;
}

@end





@implementation ViewUtil

+ (id) loadInstanceOfView:(Class)clazz fromNibNamed:(NSString *)name {
	id obj = nil;
	NSArray *topObjects = [[NSBundle mainBundle] loadNibNamed:name owner:nil options:nil];
	for (id currentObject in topObjects) {
		if ([currentObject isKindOfClass:clazz]) {
			obj = currentObject;
			break;
		}
	}
	return obj;
}

@end




@implementation BlockBasedDispatchMessage

+ (id)messageWithName:(NSString *)name isAsynchronous:(BOOL)isAsync input:(void (^)(NSData *))inputBlock output:(NSData * (^)(void))outputBlock {
    BlockBasedDispatchMessage *msg = [[BlockBasedDispatchMessage alloc] initWithName:name userInfo:nil];
    msg.asynchronous = isAsync;
    
    msg->inputBlock_ = Block_copy(inputBlock);
    msg->outputBlock_ = Block_copy(outputBlock);
    
    return [msg autorelease];
}

- (void)dealloc {
    Block_release(inputBlock_);
    Block_release(outputBlock_);

    [super dealloc];
}

- (void)inputData:(NSData *)input {
    inputBlock_(input);
}

- (NSData *)outputData {
    return outputBlock_();    
}

@end



#import <UIKit/UIKit.h>

@implementation HTTPGetRequestMessage

+ (id)messageWithName:(NSString *)name userInfo:(NSDictionary *)userInfo url:(NSString *)url {
	HTTPGetRequestMessage *message = [[HTTPGetRequestMessage alloc] initWithName:name userInfo:userInfo];
	
	// must be async
	message.asynchronous = YES;
	
	message->_url = [url copy];
	
	// autorelease
	return [message autorelease];
}

- (void)dealloc {
	[_url release];
	[_responseData release];
	[super dealloc];
}

#pragma mark -

- (void)inputData:(NSData *)input {
	NSString *subbedURL = _url;
	NSError *error = nil;
	NSHTTPURLResponse *response = nil;
	
	// perform substitutions on URL
	for (NSString *key in self.userInfo) {
		NSString *subToken = [NSString stringWithFormat:@"[%@]", key];

		if ([[self.userInfo objectForKey:key] isKindOfClass:NSString.class]) {
            subbedURL = [subbedURL stringByReplacingOccurrencesOfString:subToken withString:[(NSString *)[self.userInfo objectForKey:key] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }
	}

	// debug
    if ([MessageCenter isDebuggingEnabled]) {
        NSLog(@"OPEN URL: %@", subbedURL);
    }
	
	// generate request
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:subbedURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
	NSData *content = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];

	if (!error) {
		_responseData = [content mutableCopy];

		if (response) {
            NSMutableDictionary *updatedUserInfo = [[self.userInfo mutableCopy] autorelease];
            [updatedUserInfo setObject:BOX_INT(response.statusCode) forKey:HTTP_STATUS_CODE];
            self.userInfo = updatedUserInfo;
		}
	} else {
		_responseData = nil;
	}
}

- (NSData *)outputData {
	return _responseData;
}

@end



#import <UIKit/UIKit.h>

@implementation HTTPPostRequestMessage

+ (id)messageWithName:(NSString *)name userInfo:(NSDictionary *)userInfo url:(NSString *)url body:(NSString *)body {
	HTTPPostRequestMessage *message = [[HTTPPostRequestMessage alloc] initWithName:name userInfo:userInfo];
	
	// must be async
	message.asynchronous = YES;
	
	message->_url = [url copy];
	message->_body = [body copy];
	
	// autorelease
	return [message autorelease];
}

- (void)dealloc {
	[_url release];
    [_body release];
	[_responseData release];
	[super dealloc];
}

#pragma mark -

- (void)inputData:(NSData *)input {
	NSString *subbedURL = _url;
	NSError *error = nil;
	NSHTTPURLResponse *response = nil;
	
	// perform substitutions on URL
	for (NSString *key in self.userInfo) {
		NSString *subToken = [NSString stringWithFormat:@"[%@]", key];
        
		if ([[self.userInfo objectForKey:key] isKindOfClass:NSString.class]) {
            subbedURL = [subbedURL stringByReplacingOccurrencesOfString:subToken withString:[(NSString *)[self.userInfo objectForKey:key] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }
	}
    
	// debug
    if ([MessageCenter isDebuggingEnabled]) {
        NSLog(@"OPEN URL: %@", subbedURL);
    }
	
	// generate request
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:subbedURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[_body dataUsingEncoding:NSUTF8StringEncoding]];
	NSData *content = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
	if (!error) {
		_responseData = [content mutableCopy];
        
		if (response) {
            NSMutableDictionary *updatedUserInfo = [[self.userInfo mutableCopy] autorelease];
            [updatedUserInfo setObject:BOX_INT(response.statusCode) forKey:HTTP_STATUS_CODE];
            self.userInfo = updatedUserInfo;
		}
	} else {
		_responseData = nil;
	}
}

- (NSData *)outputData {
	return _responseData;
}

@end





@implementation SequencedMessage

- (id)initWithName:(NSString *)name userInfo:(NSDictionary *)userInfo sequence:(NSArray *)messageSequence {
	self = [super initWithName:name userInfo:userInfo];
	
	if (self) {
		_messageSequence = [messageSequence mutableCopy];

		// if any message in the sequence is asynchronous, the whole thing is asynchronous
		for (DispatchMessage *iMessage in _messageSequence) {
			if (iMessage.isAsynchronous) {
				self.asynchronous = YES;
				break;
			}
		}
	}
	
	return self;
}

+ (id)messageWithName:(NSString *)name userInfo:(NSDictionary *)userInfo sequence:(NSArray *)messageSequence {
	SequencedMessage *message = [[SequencedMessage alloc] initWithName:name userInfo:userInfo sequence:messageSequence];
	
	// autorelease
	return [message autorelease];
}

- (void)dealloc {
	[_messageSequence release];
    [_outputOfLastMessage release];
	[super dealloc];
}

#pragma mark -

- (void)inputData:(NSData *)input {
	_outputOfLastMessage = nil;
	
	// process each message in sequence
	for (DispatchMessage *iMessage in _messageSequence) {
		// process
		[iMessage inputData:_outputOfLastMessage];
		
		// release
		[_outputOfLastMessage release];
		
		// gather output
		_outputOfLastMessage = [[iMessage outputData] retain];
	}
}

- (NSData *)outputData {
	// this is the output of the last message we processed in inputData
	return _outputOfLastMessage;
}

@end

