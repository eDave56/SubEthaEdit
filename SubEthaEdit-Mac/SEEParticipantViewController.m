//
//  SEEParticipantViewController.m
//  SubEthaEdit
//
//  Created by Michael Ehrmann on 27.01.14.
//  Copyright (c) 2014 TheCodingMonkeys. All rights reserved.
//

// this file needs arc - either project wide,
// or add -fobjc-arc on a per file basis in the compile build phase
#if !__has_feature(objc_arc)
#error ARC must be enabled!
#endif

#import "SEEParticipantViewController.h"

#import "PlainTextEditor.h"
#import "PlainTextWindowControllerTabContext.h"
#import "PlainTextWindowController.h"
#import "PlainTextDocument.h"

#import "TCMMMUser.h"
#import "TCMMMUserSEEAdditions.h"

@interface SEEParticipantViewController ()
@property (nonatomic, readwrite, strong) TCMMMUser *participant;
@property (nonatomic, readwrite, weak) PlainTextWindowControllerTabContext *tabContext;

@property (nonatomic, strong) IBOutlet NSView *participantViewOutlet;
@property (nonatomic, weak) IBOutlet NSTextField *nameLabelOutlet;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *userViewButtonLeftConstraintOutlet;
@property (nonatomic, weak) IBOutlet NSButton *userViewButtonOutlet;
@property (nonatomic, weak) IBOutlet NSProgressIndicator *connectingProgressIndicatorOutlet;

@property (nonatomic, strong) IBOutlet NSView *participantActionOverlayOutlet;
@property (nonatomic, weak) IBOutlet NSButton *closeConnectionButtonOutlet;
@property (nonatomic, weak) IBOutlet NSButton *toggleEditModeButtonOutlet;
@property (nonatomic, weak) IBOutlet NSButton *toggleFollowButtonOutlet;

@property (nonatomic, strong) IBOutlet NSView *pendingUserActionOverlayOutlet;
@property (nonatomic, weak) IBOutlet NSButton *pendingUserKickButtonOutlet;
@property (nonatomic, weak) IBOutlet NSButton *chooseEditModeButtonOutlet;
@property (nonatomic, weak) IBOutlet NSButton *chooseReadOnlyModeButtonOutlet;
@property (nonatomic, weak) IBOutlet NSTextField *pendingUserQuestionMarkOutlet;

@property (nonatomic, weak) IBOutlet NSImageView *hasFollowerOverlayImageOutlet;
@property (nonatomic, weak) IBOutlet NSImageView *readOnlyOverlayImageOutlet;

@property (nonatomic, weak) id plainTextEditorFollowUserNotificationHandler;

@end

@implementation SEEParticipantViewController

- (id)initWithParticipant:(TCMMMUser *)aParticipant tabContext:(PlainTextWindowControllerTabContext *)aTabContext
{
    self = [super initWithNibName:@"SEEParticipantView" bundle:nil];
    if (self) {
		self.participant = aParticipant;
		self.tabContext = aTabContext;

		__weak __typeof__(self) weakSelf = self;
		self.plainTextEditorFollowUserNotificationHandler =
		[[NSNotificationCenter defaultCenter] addObserverForName:PlainTextEditorDidFollowUserNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
			__typeof__(self) strongSelf = weakSelf;
			if ([strongSelf.tabContext.plainTextEditors containsObject:note.object])
			[strongSelf updateParticipantFollowed];
		}];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self.plainTextEditorFollowUserNotificationHandler];
}

- (void)loadView {
	[super loadView];

	NSButton *userViewButton = self.userViewButtonOutlet;
	NSRect userViewButtonFrame = userViewButton.frame;
	NSImage *userImage = self.participant.image;
	if (userImage) {
		userViewButton.image = self.participant.image;
	}
	userViewButton.layer.cornerRadius = NSHeight(userViewButtonFrame) / 2.0;
	userViewButton.layer.borderWidth = 3.0;

	
	NSColor *changeColor = [self.participant changeColor];
	userViewButton.layer.borderColor = // [[changeColor colorWithAlphaComponent:0.8] CGColor];
									   [[NSColor colorWithCalibratedHue:changeColor.hueComponent saturation:0.85 brightness:1.0 alpha:1.0] CGColor];

	NSTextField *nameLabel = self.nameLabelOutlet;
	nameLabel.stringValue = self.participant.name;

	// participant users action overlay
	{
		NSButton *button = self.closeConnectionButtonOutlet;
		button.image = [NSImage pdfBasedImageNamed:@"SharingIconCloseCross"TCM_PDFIMAGE_SEP@"16"TCM_PDFIMAGE_SEP@""TCM_PDFIMAGE_NORMAL];
	}
	{
		NSButton *button = self.toggleEditModeButtonOutlet;
		button.image = [NSImage pdfBasedImageNamed:@"SharingIconReadOnly"TCM_PDFIMAGE_SEP@"16"TCM_PDFIMAGE_SEP@""TCM_PDFIMAGE_NORMAL];
		button.alternateImage = [NSImage pdfBasedImageNamed:@"SharingIconWrite"TCM_PDFIMAGE_SEP@"16"TCM_PDFIMAGE_SEP@""TCM_PDFIMAGE_NORMAL];
	}
	{
		NSButton *button = self.toggleFollowButtonOutlet;
		button.image = [NSImage pdfBasedImageNamed:@"SharingIconEye"TCM_PDFIMAGE_SEP@"16"TCM_PDFIMAGE_SEP@""TCM_PDFIMAGE_NORMAL];
		button.alternateImage = [NSImage pdfBasedImageNamed:@"SharingIconEye"TCM_PDFIMAGE_SEP@"16"TCM_PDFIMAGE_SEP@""TCM_PDFIMAGE_SELECTED];
	}

	{
		NSImageView *imageView = self.hasFollowerOverlayImageOutlet;
		imageView.image = [NSImage pdfBasedImageNamed:@"SharingIconEye"TCM_PDFIMAGE_SEP@"20"TCM_PDFIMAGE_SEP@""TCM_PDFIMAGE_NORMAL];
	}
	{
		NSImageView *imageView = self.readOnlyOverlayImageOutlet;
		imageView.image = [NSImage pdfBasedImageNamed:@"SharingIconReadOnly"TCM_PDFIMAGE_SEP@"20"TCM_PDFIMAGE_SEP@""TCM_PDFIMAGE_NORMAL];
		imageView.hidden = YES;
	}


	// pending users action overlay
	{
		NSButton *button = self.pendingUserKickButtonOutlet;
		button.image = [NSImage pdfBasedImageNamed:@"SharingIconCloseCross"TCM_PDFIMAGE_SEP@"16"TCM_PDFIMAGE_SEP@""TCM_PDFIMAGE_NORMAL];
	}
	{
		NSButton *button = self.chooseEditModeButtonOutlet;
		button.image = [NSImage pdfBasedImageNamed:@"SharingIconWrite"TCM_PDFIMAGE_SEP@"16"TCM_PDFIMAGE_SEP@""TCM_PDFIMAGE_NORMAL];
	}
	{
		NSButton *button = self.chooseReadOnlyModeButtonOutlet;
		button.image = [NSImage pdfBasedImageNamed:@"SharingIconReadOnly"TCM_PDFIMAGE_SEP@"16"TCM_PDFIMAGE_SEP@""TCM_PDFIMAGE_NORMAL];
	}
}

- (void)mouseEntered:(NSEvent *)theEvent {
	[self updateParticipantFollowed];
	self.participantActionOverlayOutlet.hidden = NO;
}

- (void)mouseExited:(NSEvent *)theEvent {
	self.participantActionOverlayOutlet.hidden = YES;
}


#pragma mark Actions

- (IBAction)closeConnection:(id)sender {
	TCMMMSession *documentSession = self.tabContext.document.session;
	if (documentSession.isServer) {
		NSDictionary *participants = documentSession.participants;
        NSDictionary *invitedUsers = documentSession.invitedUsers;
		NSArray *pendingUsers = documentSession.pendingUsers;
		TCMMMUser *user = self.participant;

		if ([pendingUsers containsObject:user]) {
			[documentSession denyPendingUser:user];
		} else if ([[invitedUsers objectForKey:TCMMMSessionReadWriteGroupName] containsObject:user] || [[invitedUsers objectForKey:TCMMMSessionReadOnlyGroupName] containsObject:user]) {
			[documentSession cancelInvitationForUserWithID:[user userID]];
		} else if ([[participants objectForKey:TCMMMSessionReadWriteGroupName] containsObject:user] || [[participants objectForKey:TCMMMSessionReadOnlyGroupName] containsObject:user]) {
			[documentSession setGroup:TCMMMSessionPoofGroupName forParticipantsWithUserIDs:@[[user userID]]];
		}
	}
}

- (IBAction)userViewButtonDoubleClicked:(id)sender {
	NSEvent *event = [NSApp currentEvent];
	if (event.clickCount == 2) {
		[self toggleFollow:sender];
	}
}

- (IBAction)toggleEditMode:(id)sender {
	TCMMMSession *documentSession = self.tabContext.document.session;
	if (documentSession.isServer) {
		NSDictionary *participants = documentSession.participants;
		TCMMMUser *user = self.participant;

		if ([[participants objectForKey:TCMMMSessionReadWriteGroupName] containsObject:user]) {
			[documentSession setGroup:TCMMMSessionReadOnlyGroupName forParticipantsWithUserIDs:@[[user userID]]];
		} else if ([[participants objectForKey:TCMMMSessionReadOnlyGroupName] containsObject:user]) {
			[documentSession setGroup:TCMMMSessionReadWriteGroupName forParticipantsWithUserIDs:@[[user userID]]];
		}
	}
}

- (IBAction)toggleFollow:(id)sender {
	TCMMMUser *user = self.participant;
	if (! user.isMe) {
		PlainTextWindowController *windowController = self.view.window.windowController;
		PlainTextEditor *activeEditor = windowController.activePlainTextEditor;

		BOOL activeEditorIsFollowing = [activeEditor.followUserID isEqualToString:user.userID];
		if (activeEditorIsFollowing) {
			[activeEditor setFollowUserID:nil];
		} else {
			[activeEditor setFollowUserID:user.userID];
		}

		[self updateParticipantFollowed];
	}
}

- (IBAction)chooseReadOnlyMode:(id)sender {
	TCMMMSession *documentSession = self.tabContext.document.session;
	if (documentSession.isServer) {
		NSDictionary *participants = documentSession.participants;
		NSArray *pendingUsers = documentSession.pendingUsers;
		TCMMMUser *user = self.participant;

		if ([pendingUsers containsObject:user]) {
			[documentSession addPendingUser:user toGroup:TCMMMSessionReadOnlyGroupName];
		} else if ([[participants objectForKey:TCMMMSessionReadWriteGroupName] containsObject:user]) {
			[documentSession setGroup:TCMMMSessionReadOnlyGroupName forParticipantsWithUserIDs:@[[user userID]]];
		}
	}
}

- (IBAction)chooseReadWriteMode:(id)sender {
	TCMMMSession *documentSession = self.tabContext.document.session;
	if (documentSession.isServer) {
		NSDictionary *participants = documentSession.participants;
		NSArray *pendingUsers = documentSession.pendingUsers;
		TCMMMUser *user = self.participant;

		if ([pendingUsers containsObject:user]) {
			[documentSession addPendingUser:user toGroup:TCMMMSessionReadWriteGroupName];
		} else if ([[participants objectForKey:TCMMMSessionReadOnlyGroupName] containsObject:user]) {
			[documentSession setGroup:TCMMMSessionReadWriteGroupName forParticipantsWithUserIDs:@[[user userID]]];
		}
	}
}


#pragma mark - Preparing Views

- (void)updateForParticipantUserState {
	if (self.participant.isMe) {
		self.participantActionOverlayOutlet = nil;
	} else {
		TCMMMUser *user = self.participant;

		[self updateParticipantFollowed];

		BOOL userCanEditDocument = [self.tabContext.document.session isEditableByUser:user];
		self.toggleEditModeButtonOutlet.state = userCanEditDocument?NSOffState:NSOnState;
		self.readOnlyOverlayImageOutlet.hidden = userCanEditDocument;

		if (! self.tabContext.document.session.isServer) {
			[self.closeConnectionButtonOutlet removeFromSuperview];
			[self.toggleEditModeButtonOutlet removeFromSuperview];
		}

		// add action overlay to view hierarchy
		NSView *userView = self.participantViewOutlet;
		NSView *overlayView = self.participantActionOverlayOutlet;
		overlayView.hidden = YES;
		NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:overlayView
																	  attribute:NSLayoutAttributeRight
																	  relatedBy:NSLayoutRelationEqual
																		 toItem:userView
																	  attribute:NSLayoutAttributeRight
																	 multiplier:1
																	   constant:-5];

		NSLayoutConstraint *verticalConstraint = [NSLayoutConstraint constraintWithItem:overlayView
																			  attribute:NSLayoutAttributeTop
																			  relatedBy:NSLayoutRelationEqual
																				 toItem:userView
																			  attribute:NSLayoutAttributeTop
																			 multiplier:1
																			   constant:0];
		[userView addSubview:self.participantActionOverlayOutlet];
		[userView addConstraints:@[constraint, verticalConstraint]];

		// install tracking for action overlay
		[self.participantViewOutlet addTrackingArea:[[NSTrackingArea alloc] initWithRect:NSZeroRect options:NSTrackingMouseEnteredAndExited|NSTrackingActiveInKeyWindow|NSTrackingInVisibleRect owner:self userInfo:nil]];

		// add double click target for follow action
		[self.userViewButtonOutlet setAction:@selector(userViewButtonDoubleClicked:)];
		[self.userViewButtonOutlet setTarget:self];
	}
}

- (void)updateParticipantFollowed
{
	// update hidden of status view
	BOOL isFollowing = NO;
	NSArray *editors = self.tabContext.plainTextEditors;
	for (PlainTextEditor *currentEditor in editors) {
		isFollowing = [[currentEditor followUserID] isEqualToString:self.participant.userID];
		if (isFollowing) {
			break;
		}
	}
	self.isParticipantFollowed = isFollowing;

	// update action button state
	PlainTextWindowController *windowController = self.view.window.windowController;
	PlainTextEditor *activeEditor = windowController.activePlainTextEditor;
	TCMMMUser *user = self.participant;

	BOOL activeEditorIsFollowing = [activeEditor.followUserID isEqualToString:user.userID];
	self.toggleFollowButtonOutlet.state = activeEditorIsFollowing?NSOnState:NSOffState;
}


- (void)updateForPendingUserState {
	if (self.tabContext.document.session.isServer) {
		NSView *userView = self.participantViewOutlet;
		NSView *overlayView = self.pendingUserActionOverlayOutlet;
		overlayView.hidden = NO;
		[userView addSubview:overlayView];

		NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:overlayView
																	  attribute:NSLayoutAttributeRight
																	  relatedBy:NSLayoutRelationEqual
																		 toItem:userView
																	  attribute:NSLayoutAttributeRight
																	 multiplier:1
																	   constant:-5];

		NSLayoutConstraint *verticalConstraint = [NSLayoutConstraint constraintWithItem:overlayView
																	  attribute:NSLayoutAttributeTop
																	  relatedBy:NSLayoutRelationEqual
																		 toItem:userView
																	  attribute:NSLayoutAttributeTop
																	 multiplier:1
																	   constant:0];
		[userView addConstraints:@[constraint, verticalConstraint]];
		self.userViewButtonLeftConstraintOutlet.constant = 16;
	}

	self.pendingUserQuestionMarkOutlet.hidden = NO;
	self.userViewButtonOutlet.enabled = NO;
}

- (void)updateForInvitationState {
	self.connectingProgressIndicatorOutlet.usesThreadedAnimation = YES;
	[self.connectingProgressIndicatorOutlet startAnimation:self];
	self.nameLabelOutlet.alphaValue = 0.8;
	self.userViewButtonOutlet.alphaValue = 0.6;
	self.userViewButtonOutlet.enabled = NO;

	if (! self.tabContext.document.session.isServer) {
		self.participantActionOverlayOutlet = nil;
	} else {
		[self.toggleEditModeButtonOutlet removeFromSuperview];
		[self.toggleFollowButtonOutlet removeFromSuperview];
		
		// add action overlay to view hierarchy
		NSView *userView = self.participantViewOutlet;
		NSView *overlayView = self.participantActionOverlayOutlet;
		overlayView.hidden = YES;
		NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:overlayView
																	  attribute:NSLayoutAttributeRight
																	  relatedBy:NSLayoutRelationEqual
																		 toItem:userView
																	  attribute:NSLayoutAttributeRight
																	 multiplier:1
																	   constant:-5];

		NSLayoutConstraint *verticalConstraint = [NSLayoutConstraint constraintWithItem:overlayView
																			  attribute:NSLayoutAttributeTop
																			  relatedBy:NSLayoutRelationEqual
																				 toItem:userView
																			  attribute:NSLayoutAttributeTop
																			 multiplier:1
																			   constant:0];
		[userView addSubview:self.participantActionOverlayOutlet];
		[userView addConstraints:@[constraint, verticalConstraint]];

		// install tracking for action overlay
		[self.participantViewOutlet addTrackingArea:[[NSTrackingArea alloc] initWithRect:NSZeroRect options:NSTrackingMouseEnteredAndExited|NSTrackingActiveInKeyWindow|NSTrackingInVisibleRect owner:self userInfo:nil]];
	}
}

@end
