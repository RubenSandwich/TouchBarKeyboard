//
//  AppDelegate.m
//  TouchBarKeyboard
//
//  Created by Ruben Nic on 5/3/19.
//  Copyright © 2019 Ruben Nic. All rights reserved.
//

#import "AppDelegate.h"
#import "TouchBar.h"

static const NSTouchBarItemIdentifier kCapsLockIdentifier =
    @"com.rubennic.CapsLock";
static const NSTouchBarItemIdentifier kScrollGroupIdentifier =
    @"com.rubennic.ScrollGroup";
static const NSTouchBarItemIdentifier kKeyboardIdentifier =
    @"com.rubennic.Keyboard";

static const int kLeftShiftKeyCode = 56;
static const int kRightShiftKeyCode = 60;
static const int kCapsLockKeyCode = 57;
static const NSEventModifierFlags kKeyUpModifierFlag = 0x100;

@interface AppDelegate () <NSTouchBarDelegate>

@property(weak) IBOutlet NSWindow *aboutWindow;
@property(weak) IBOutlet NSMenu *statusMenu;
@property(strong, nonatomic) NSStatusItem *statusBar;

@property(nonatomic) NSTouchBar *groupTouchBar;
@property(nonatomic) NSCustomTouchBarItem *capsLockButton;
@property Boolean capsLockDown;
@property Boolean shiftDown;
@property(strong) NSArray *keys;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  DFRSystemModalShowsCloseBoxWhenFrontMost(YES);

  self.statusBar = [[NSStatusBar systemStatusBar]
      statusItemWithLength:NSVariableStatusItemLength];

  // touch bar by mikicon from the Noun Project
  NSImage *image = [NSImage imageNamed:@"menuBar"];
  [image setTemplate:YES];
  self.statusBar.image = image;

  self.statusBar.menu = self.statusMenu;
  self.statusBar.highlightMode = YES;

  NSCustomTouchBarItem *keyboard =
      [[NSCustomTouchBarItem alloc] initWithIdentifier:kKeyboardIdentifier];
  keyboard.view = [NSButton buttonWithImage:image
                                     target:self
                                     action:@selector(present:)];

  [NSTouchBarItem addSystemTrayItem:keyboard];

  NSTouchBar *groupTouchBar = [[NSTouchBar alloc] init];
  groupTouchBar.defaultItemIdentifiers =
      @[ kCapsLockIdentifier, kScrollGroupIdentifier ];
  groupTouchBar.delegate = self;
  self.groupTouchBar = groupTouchBar;

  DFRElementSetControlStripPresenceForIdentifier(kKeyboardIdentifier, YES);

  // http://www.jacobward.co.uk/cgkeycode-list-objective-c/
  self.keys = @[
    [[NSMutableDictionary alloc] initWithDictionary:@{
      @"keyCode" : @0,
      @"lowerCase" : @"a",
      @"upperCase" : @"A",
      @"nsbutton" : [NSNull null],
    }],
    [[NSMutableDictionary alloc] initWithDictionary:@{
      @"keyCode" : @11,
      @"lowerCase" : @"b",
      @"upperCase" : @"B",
      @"nsbutton" : [NSNull null],
    }],
    [[NSMutableDictionary alloc] initWithDictionary:@{
      @"keyCode" : @8,
      @"lowerCase" : @"c",
      @"upperCase" : @"C",
      @"nsbutton" : [NSNull null],
    }],
    [[NSMutableDictionary alloc] initWithDictionary:@{
      @"keyCode" : @2,
      @"lowerCase" : @"d",
      @"upperCase" : @"D",
      @"nsbutton" : [NSNull null],
    }],
    [[NSMutableDictionary alloc] initWithDictionary:@{
      @"keyCode" : @14,
      @"lowerCase" : @"e",
      @"upperCase" : @"E",
      @"nsbutton" : [NSNull null],
    }],
    [[NSMutableDictionary alloc] initWithDictionary:@{
      @"keyCode" : @3,
      @"lowerCase" : @"f",
      @"upperCase" : @"F",
      @"nsbutton" : [NSNull null],
    }],
    [[NSMutableDictionary alloc] initWithDictionary:@{
      @"keyCode" : @5,
      @"lowerCase" : @"g",
      @"upperCase" : @"G",
      @"nsbutton" : [NSNull null],
    }],
    [[NSMutableDictionary alloc] initWithDictionary:@{
      @"keyCode" : @4,
      @"lowerCase" : @"h",
      @"upperCase" : @"H",
      @"nsbutton" : [NSNull null],
    }],
    [[NSMutableDictionary alloc] initWithDictionary:@{
      @"keyCode" : @34,
      @"lowerCase" : @"i",
      @"upperCase" : @"I",
      @"nsbutton" : [NSNull null],
    }],
    [[NSMutableDictionary alloc] initWithDictionary:@{
      @"keyCode" : @38,
      @"lowerCase" : @"j",
      @"upperCase" : @"J",
      @"nsbutton" : [NSNull null],
    }],
    [[NSMutableDictionary alloc] initWithDictionary:@{
      @"keyCode" : @40,
      @"lowerCase" : @"k",
      @"upperCase" : @"K",
      @"nsbutton" : [NSNull null],
    }],
    [[NSMutableDictionary alloc] initWithDictionary:@{
      @"keyCode" : @37,
      @"lowerCase" : @"l",
      @"upperCase" : @"L",
      @"nsbutton" : [NSNull null],
    }],
    [[NSMutableDictionary alloc] initWithDictionary:@{
      @"keyCode" : @46,
      @"lowerCase" : @"m",
      @"upperCase" : @"M",
      @"nsbutton" : [NSNull null],
    }],
    [[NSMutableDictionary alloc] initWithDictionary:@{
      @"keyCode" : @45,
      @"lowerCase" : @"n",
      @"upperCase" : @"N",
      @"nsbutton" : [NSNull null],
    }],
    [[NSMutableDictionary alloc] initWithDictionary:@{
      @"keyCode" : @31,
      @"lowerCase" : @"o",
      @"upperCase" : @"O",
      @"nsbutton" : [NSNull null],
    }],
    [[NSMutableDictionary alloc] initWithDictionary:@{
      @"keyCode" : @35,
      @"lowerCase" : @"p",
      @"upperCase" : @"P",
      @"nsbutton" : [NSNull null],
    }],
    [[NSMutableDictionary alloc] initWithDictionary:@{
      @"keyCode" : @12,
      @"lowerCase" : @"q",
      @"upperCase" : @"Q",
      @"nsbutton" : [NSNull null],
    }],
    [[NSMutableDictionary alloc] initWithDictionary:@{
      @"keyCode" : @15,
      @"lowerCase" : @"r",
      @"upperCase" : @"R",
      @"nsbutton" : [NSNull null],
    }],
    [[NSMutableDictionary alloc] initWithDictionary:@{
      @"keyCode" : @1,
      @"lowerCase" : @"s",
      @"upperCase" : @"S",
      @"nsbutton" : [NSNull null],
    }],
    [[NSMutableDictionary alloc] initWithDictionary:@{
      @"keyCode" : @17,
      @"lowerCase" : @"t",
      @"upperCase" : @"T",
      @"nsbutton" : [NSNull null],
    }],
    [[NSMutableDictionary alloc] initWithDictionary:@{
      @"keyCode" : @32,
      @"lowerCase" : @"u",
      @"upperCase" : @"U",
      @"nsbutton" : [NSNull null],
    }],
    [[NSMutableDictionary alloc] initWithDictionary:@{
      @"keyCode" : @9,
      @"lowerCase" : @"v",
      @"upperCase" : @"V",
      @"nsbutton" : [NSNull null],
    }],
    [[NSMutableDictionary alloc] initWithDictionary:@{
      @"keyCode" : @13,
      @"lowerCase" : @"w",
      @"upperCase" : @"W",
      @"nsbutton" : [NSNull null],
    }],
    [[NSMutableDictionary alloc] initWithDictionary:@{
      @"keyCode" : @7,
      @"lowerCase" : @"x",
      @"upperCase" : @"X",
      @"nsbutton" : [NSNull null],
    }],
    [[NSMutableDictionary alloc] initWithDictionary:@{
      @"keyCode" : @16,
      @"lowerCase" : @"y",
      @"upperCase" : @"Y",
      @"nsbutton" : [NSNull null],
    }],
    [[NSMutableDictionary alloc] initWithDictionary:@{
      @"keyCode" : @6,
      @"lowerCase" : @"z",
      @"upperCase" : @"Z",
      @"nsbutton" : [NSNull null],
    }],
    [[NSMutableDictionary alloc] initWithDictionary:@{
      @"keyCode" : @18,
      @"lowerCase" : @"1",
      @"upperCase" : @"!",
      @"nsbutton" : [NSNull null],
    }],
    [[NSMutableDictionary alloc] initWithDictionary:@{
      @"keyCode" : @19,
      @"lowerCase" : @"2",
      @"upperCase" : @"@",
      @"nsbutton" : [NSNull null],
    }],
    [[NSMutableDictionary alloc] initWithDictionary:@{
      @"keyCode" : @20,
      @"lowerCase" : @"3",
      @"upperCase" : @"#",
      @"nsbutton" : [NSNull null],
    }],
    [[NSMutableDictionary alloc] initWithDictionary:@{
      @"keyCode" : @21,
      @"lowerCase" : @"4",
      @"upperCase" : @"$",
      @"nsbutton" : [NSNull null],
    }],
    [[NSMutableDictionary alloc] initWithDictionary:@{
      @"keyCode" : @23,
      @"lowerCase" : @"5",
      @"upperCase" : @"%",
      @"nsbutton" : [NSNull null],
    }],
    [[NSMutableDictionary alloc] initWithDictionary:@{
      @"keyCode" : @22,
      @"lowerCase" : @"6",
      @"upperCase" : @"^",
      @"nsbutton" : [NSNull null],
    }],
    [[NSMutableDictionary alloc] initWithDictionary:@{
      @"keyCode" : @26,
      @"lowerCase" : @"7",
      @"upperCase" : @"&",
      @"nsbutton" : [NSNull null],
    }],
    [[NSMutableDictionary alloc] initWithDictionary:@{
      @"keyCode" : @28,
      @"lowerCase" : @"8",
      @"upperCase" : @"*",
      @"nsbutton" : [NSNull null],
    }],
    [[NSMutableDictionary alloc] initWithDictionary:@{
      @"keyCode" : @25,
      @"lowerCase" : @"9",
      @"upperCase" : @"(",
      @"nsbutton" : [NSNull null],
    }],
    [[NSMutableDictionary alloc] initWithDictionary:@{
      @"keyCode" : @29,
      @"lowerCase" : @"0",
      @"upperCase" : @")",
      @"nsbutton" : [NSNull null],
    }],
    [[NSMutableDictionary alloc] initWithDictionary:@{
      @"keyCode" : @27,
      @"lowerCase" : @"-",
      @"upperCase" : @"_",
      @"nsbutton" : [NSNull null],
    }],
    [[NSMutableDictionary alloc] initWithDictionary:@{
      @"keyCode" : @24,
      @"lowerCase" : @"=",
      @"upperCase" : @"+",
      @"nsbutton" : [NSNull null],
    }],
    [[NSMutableDictionary alloc] initWithDictionary:@{
      @"keyCode" : @33,
      @"lowerCase" : @"[",
      @"upperCase" : @"{",
      @"nsbutton" : [NSNull null],
    }],
    [[NSMutableDictionary alloc] initWithDictionary:@{
      @"keyCode" : @30,
      @"lowerCase" : @"]",
      @"upperCase" : @"}",
      @"nsbutton" : [NSNull null],
    }],
    [[NSMutableDictionary alloc] initWithDictionary:@{
      @"keyCode" : @42,
      @"lowerCase" : @"\\",
      @"upperCase" : @"|",
      @"nsbutton" : [NSNull null],
    }],
    [[NSMutableDictionary alloc] initWithDictionary:@{
      @"keyCode" : @41,
      @"lowerCase" : @";",
      @"upperCase" : @":",
      @"nsbutton" : [NSNull null],
    }],
    [[NSMutableDictionary alloc] initWithDictionary:@{
      @"keyCode" : @39,
      @"lowerCase" : @"'",
      @"upperCase" : @"\"",
      @"nsbutton" : [NSNull null],
    }],
    [[NSMutableDictionary alloc] initWithDictionary:@{
      @"keyCode" : @43,
      @"lowerCase" : @",",
      @"upperCase" : @"<",
      @"nsbutton" : [NSNull null],
    }],
    [[NSMutableDictionary alloc] initWithDictionary:@{
      @"keyCode" : @47,
      @"lowerCase" : @".",
      @"upperCase" : @">",
      @"nsbutton" : [NSNull null],
    }],
    [[NSMutableDictionary alloc] initWithDictionary:@{
      @"keyCode" : @44,
      @"lowerCase" : @"/",
      @"upperCase" : @"?",
      @"nsbutton" : [NSNull null],
    }],
    [[NSMutableDictionary alloc] initWithDictionary:@{
      @"keyCode" : @50,
      @"lowerCase" : @"`",
      @"upperCase" : @"~",
      @"nsbutton" : [NSNull null],
    }],
  ];

  self.shiftDown =
      (NSEventModifierFlagShift & [NSEvent modifierFlags]) ? true : false;
  self.capsLockDown =
      (NSEventModifierFlagCapsLock & [NSEvent modifierFlags]) ? true : false;

  [NSEvent
      addGlobalMonitorForEventsMatchingMask:NSEventMaskFlagsChanged
                                    handler:^void(NSEvent *_Nonnull event) {
                                      [self updateModifierKeys:event];
                                    }];
  // Global monitoring doesn't cover local monitoring ¯\_(ツ)_/¯
  [NSEvent addLocalMonitorForEventsMatchingMask:NSEventMaskFlagsChanged
                                        handler:^NSEvent *_Nullable(
                                            NSEvent *_Nonnull event) {
                                          [self updateModifierKeys:event];
                                          return event;
                                        }];

  NSDictionary *options = @{(__bridge id)kAXTrustedCheckOptionPrompt : @NO};
  BOOL accessibilityEnabled =
      AXIsProcessTrustedWithOptions((CFDictionaryRef)options);
  if (!accessibilityEnabled) {
    // Show trust app with accesabilty features alert
    AXIsProcessTrustedWithOptions(
        (CFDictionaryRef) @{(__bridge id)kAXTrustedCheckOptionPrompt : @YES});
  }
}

- (IBAction)showAboutWindow:(NSMenuItem *)sender {
  [self.aboutWindow setIsVisible:true];
}

- (IBAction)closeAboutWindow:(NSButtonCell *)sender {
  [self.aboutWindow close];
}

- (void)updateModifierKeys:(NSEvent *)event {
  if (event.keyCode == kCapsLockKeyCode) {
    if (event.modifierFlags == kKeyUpModifierFlag) {
      self.capsLockDown = false;
    } else {
      self.capsLockDown = true;
    }

    [self.capsLockButton.view setTitle:[self capLockTitle]];
  } else if (event.keyCode == kLeftShiftKeyCode ||
             event.keyCode == kRightShiftKeyCode) {
    if (event.modifierFlags == kKeyUpModifierFlag) {
      self.shiftDown = false;
    } else {
      self.shiftDown = true;
    }
  }

  [self updateKeys];
}

- (void)sendCapsLock {
  self.capsLockDown = !self.capsLockDown;
  [self.capsLockButton.view setTitle:[self capLockTitle]];

  [self updateKeys];
}

- (void)updateKeys {
  for (NSMutableDictionary *key in self.keys) {
    if (key[@"nsbutton"] != [NSNull null]) {
      NSButton *button = key[@"nsbutton"];
      NSString *keyTitle = (self.capsLockDown || self.shiftDown)
                               ? key[@"upperCase"]
                               : key[@"lowerCase"];

      [button setTitle:keyTitle];
    }
  }
}

- (NSString *)capLockTitle {
  return self.capsLockDown ? @"CAPS LOCK" : @"Caps Lock";
}

- (void)sendKeyCode:(NSButton *)sender {
  // Using this deprecated function because CGEventCreateKeyboardEvent with
  // CGEventPostToPSN don't seem to work with the shift keycode
  if (self.capsLockDown || self.shiftDown) {
    CGPostKeyboardEvent((CGCharCode)0, (CGKeyCode)kLeftShiftKeyCode, true);
  }

  NSDictionary *key = [self.keys objectAtIndex:sender.tag];
  int keyCode = [key[@"keyCode"] intValue];

  CGPostKeyboardEvent((CGCharCode)0, (CGKeyCode)keyCode, true);
  CGPostKeyboardEvent((CGCharCode)0, (CGKeyCode)keyCode, false);

  if (self.capsLockDown || self.shiftDown) {
    CGPostKeyboardEvent((CGCharCode)0, (CGKeyCode)kLeftShiftKeyCode, false);
  }
}

- (void)present:(id)sender {
  if (@available(macOS 10.14, *)) {
    [NSTouchBar presentSystemModalTouchBar:self.groupTouchBar
                  systemTrayItemIdentifier:kKeyboardIdentifier];
  } else {
    [NSTouchBar presentSystemModalFunctionBar:self.groupTouchBar
                     systemTrayItemIdentifier:kKeyboardIdentifier];
  }
}

- (NSTouchBarItem *)touchBar:(NSTouchBar *)touchBar
       makeItemForIdentifier:(NSTouchBarItemIdentifier)identifier {
  if ([identifier isEqualToString:kScrollGroupIdentifier]) {
    NSScrollView *scrollView = [[NSScrollView alloc] init];

    NSMutableDictionary *constraintViews = [NSMutableDictionary dictionary];
    NSView *documentView = [[NSView alloc] initWithFrame:NSZeroRect];

    CGFloat spacing = 8;
    CGFloat buttonWidth = 60;
    CGFloat touchBarHeight = 30;

    NSString *layoutFormat = [NSString stringWithFormat:@"H:|-%f-", spacing];
    NSSize size = NSMakeSize(spacing, touchBarHeight);

    for (int i = 0; i <= self.keys.count - 1; i++) {
      NSMutableDictionary *key = [self.keys objectAtIndex:i];
      NSString *title = (self.capsLockDown || self.shiftDown)
                            ? key[@"upperCase"]
                            : key[@"lowerCase"];

      NSButton *button = [NSButton buttonWithTitle:title
                                            target:self
                                            action:@selector(sendKeyCode:)];
      button.tag = i;
      button.translatesAutoresizingMaskIntoConstraints = NO;
      key[@"nsbutton"] = button;

      NSString *constraintName = [NSString stringWithFormat:@"_%d", i];
      layoutFormat = [layoutFormat
          stringByAppendingString:[NSString stringWithFormat:@"[%@(%f)]-%f-",
                                                             constraintName,
                                                             buttonWidth,
                                                             spacing]];
      [constraintViews setObject:button forKey:constraintName];

      size.width += buttonWidth + spacing;
      [documentView addSubview:button];
    }

    layoutFormat =
        [layoutFormat stringByAppendingString:[NSString stringWithFormat:@"|"]];

    NSArray *hConstraints = [NSLayoutConstraint
        constraintsWithVisualFormat:layoutFormat
                            options:NSLayoutFormatAlignAllTop
                            metrics:nil
                              views:constraintViews];

    [documentView setFrame:NSMakeRect(0, 0, size.width, size.height)];
    [NSLayoutConstraint activateConstraints:hConstraints];
    scrollView.documentView = documentView;

    NSCustomTouchBarItem *item = [[NSCustomTouchBarItem alloc]
        initWithIdentifier:kScrollGroupIdentifier];
    item.view = scrollView;

    return item;
  } else if ([identifier isEqualToString:kCapsLockIdentifier]) {
    NSCustomTouchBarItem *capsLockButton =
        [[NSCustomTouchBarItem alloc] initWithIdentifier:identifier];

    capsLockButton.view = [NSButton buttonWithTitle:[self capLockTitle]
                                             target:self
                                             action:@selector(sendCapsLock)];
    self.capsLockButton = capsLockButton;
    return capsLockButton;

  } else if ([identifier isEqualToString:kKeyboardIdentifier]) {
    NSCustomTouchBarItem *keyboard =
        [[NSCustomTouchBarItem alloc] initWithIdentifier:kKeyboardIdentifier];

    // touch bar by mikicon from the Noun Project
    NSImage *image = [NSImage imageNamed:@"menuBar"];
    [image setTemplate:YES];
    keyboard.view = [NSButton buttonWithImage:image
                                       target:self
                                       action:@selector(present:)];

    return keyboard;
  } else {
    return nil;
  }
}

@end
