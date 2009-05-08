//
//  ScriptTextBase.m
//  SubEthaEdit
//
//  Created by Dominik Wagner on 03.05.06.
//  Copyright 2006 TheCodingMonkeys. All rights reserved.
//

#import "ScriptTextBase.h"
#import "ScriptLine.h"
#import "ScriptCharacters.h"
#import "ScriptTextSelection.h"
#import "FoldableTextStorage.h"
#import "PlainTextDocument.h"


@implementation ScriptTextBase

- (id)initWithTextStorage:(FoldableTextStorage *)aTextStorage {
    if ((self=[super init])) {
        I_textStorage = [aTextStorage retain];
    }
    return self;
}

- (void)dealloc {
    [I_textStorage release];
    [super dealloc];
}

- (NSRange)rangeRepresentation {
    return NSMakeRange(0,NSNotFound);
}

- (int)scriptedLength {
    return [self rangeRepresentation].length;
}

- (int)scriptedStartCharacterIndex {
    return [self rangeRepresentation].location+1;
}

- (int)scriptedNextCharacterIndex {
    return (int)NSMaxRange([self rangeRepresentation])+1;
}

- (int)scriptedStartLine {
    return [I_textStorage lineNumberForLocation:[self rangeRepresentation].location];
}

- (int)scriptedEndLine {
    return [I_textStorage lineNumberForLocation:EndCharacterIndex([self rangeRepresentation])];
}

- (NSArray *)scriptedLines {
    int index    = [self scriptedStartLine];
    int endIndex = [self scriptedEndLine];
    NSMutableArray *result = [NSMutableArray array];
    for (;index<=endIndex;index++) {
        [result addObject:[ScriptLine scriptLineWithTextStorage:I_textStorage lineNumber:index]];
    }
    return result;
}

- (void)insertObject:(id)anObject inScriptedLinesAtIndex:(unsigned)anIndex {
    // has to be there for KVC not to mourn
}

- (void)removeObjectFromScriptedLinesAtIndex:(unsigned)anIndex {
    // NSLog(@"%s: %d", __FUNCTION__, anIndex);
    [[[self scriptedLines] objectAtIndex:anIndex] setScriptedContents:@""];
}

- (NSArray *)words {
    return [[[[NSTextStorage alloc] initWithAttributedString:
    	[[I_textStorage fullTextStorage] attributedSubstringFromRange:[I_textStorage fullRangeForFoldedRange:[self rangeRepresentation]]]] autorelease] words];
}

- (void)setWords:(NSArray *)wordArray {
    NSBeep();
}

- (NSArray *)scriptedCharacters {
    // NSLog(@"%s", __FUNCTION__);
    NSMutableArray *result=[NSMutableArray array];
    NSRange range=[self rangeRepresentation];
    int nextIndex=NSMaxRange(range);
    int index=range.location;
    while (index<nextIndex) {
        [result addObject:[ScriptCharacters scriptCharactersWithTextStorage:I_textStorage characterRange:NSMakeRange(index++,1)]];
    }
    return result;
}

- (NSUInteger)countOfScriptedCharacters {
    return [self rangeRepresentation].length;
}

- (id)valueInScriptedCharactersAtIndex:(unsigned)index {
    // NSLog(@"%s: %d", __FUNCTION__, index);
    return [ScriptCharacters scriptCharactersWithTextStorage:I_textStorage characterRange:NSMakeRange(index+[self rangeRepresentation].location,1)];
}

- (void)insertObject:(id)anObject inScriptedCharactersAtIndex:(unsigned)anIndex {
    // has to be there for KVC not to mourn
}

- (void)removeObjectFromScriptedCharactersAtIndex:(unsigned)anIndex {
//    NSLog(@"%s: %d", __FUNCTION__, anIndex);
    [[self valueInScriptedCharactersAtIndex:anIndex] setScriptedContents:@""];
}

- (id)scriptedContents
{
    return [[[I_textStorage fullTextStorage] string] substringWithRange:[I_textStorage fullRangeForFoldedRange:[self rangeRepresentation]]];
}

- (void)setScriptedContents:(id)value {
    // NSLog(@"%s: %@", __FUNCTION__, value);
    [[I_textStorage delegate] replaceTextInRange:[self rangeRepresentation] withString:value];
}

- (id)insertionPoints
{
    NSMutableArray *resultArray=[NSMutableArray new];
    NSRange range = [self rangeRepresentation];
    int index=range.location;
    int endIndex=NSMaxRange(range);
    for (;index<=endIndex;index++) {
        [resultArray addObject:[ScriptTextSelection insertionPointWithTextStorage:I_textStorage index:index]];
    }
    return resultArray;
}

- (id)valueInInsertionPointsAtIndex:(unsigned)anIndex {
    return [ScriptTextSelection insertionPointWithTextStorage:I_textStorage index:[self rangeRepresentation].location+anIndex];
}


@end
