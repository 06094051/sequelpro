//
//  SPParserUtilsTest.m
//  sequel-pro
//
//  Created by Max Lohrmann on 27.01.15.
//  Copyright (c) 2015 Max Lohrmann. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//
//  More info at <https://github.com/sequelpro/sequelpro>

#define USE_APPLICATION_UNIT_TEST 1

#import <Cocoa/Cocoa.h>
#import <SenTestingKit/SenTestingKit.h>

#include "SPParserUtils.h"

@interface SPParserUtilsTest : SenTestCase

- (void)testUtf8strlen;

@end

@implementation SPParserUtilsTest

- (void)testUtf8strlen {
	const char *empty = "";
	NSString *emptyString = [NSString stringWithCString:empty encoding:NSUTF8StringEncoding];
	STAssertEquals(utf8strlen(empty),[emptyString length], @"empty string");
	
	const char *singleByteSeq = "Hello World!";
	NSString *singleByteString = [NSString stringWithCString:singleByteSeq encoding:NSUTF8StringEncoding];
	STAssertEquals(utf8strlen(singleByteSeq), [singleByteString length], @"ASCII UTF-8 subset");
	
	const char *twoByteSeq = "H\xC3\xA4ll\xC3\xB6 W\xC3\x9Crld\xC3\x9F!"; // Hällö WÜrldß!
	NSString *twoByteString = [NSString stringWithCString:twoByteSeq encoding:NSUTF8StringEncoding];
	STAssertEquals(utf8strlen(twoByteSeq), [twoByteString length], @"String containing two-byte utf8 characters");
	
	const char *threeByteSeq = "\xE3\x81\x93.\xE3\x82\x93.\xE3\x81\xAB.\xE3\x81\xA1.\xE3\x81\xAF"; // こ.ん.に.ち.は
	NSString *threeByteString = [NSString stringWithCString:threeByteSeq encoding:NSUTF8StringEncoding];
	STAssertEquals(utf8strlen(threeByteSeq), [threeByteString length], @"String containing three-byte utf8 characters");
	
	const char *fourByteSeq = "\xF0\x9F\x8D\x8F\xF0\x9F\x8D\x8B\xF0\x9F\x8D\x92"; //🍏🍋🍒
	NSString *fourByteString = [NSString stringWithCString:fourByteSeq encoding:NSUTF8StringEncoding];
	STAssertEquals(utf8strlen(fourByteSeq), [fourByteString length], @"String containing only 4-byte utf8 characters (outside BMP)");

	const char *mixedSeq = "\xE3\x81\x82\xE3\x82\x81\xE3\x80\x90\xE9\xA3\xB4\xE3\x80\x91\xF0\x9F\x8D\xAD \xE2\x89\x88 S\xC3\xBC\xC3\x9Figkeit"; // あめ【飴】🍭 ≈ Süßigkeit
	NSString *mixedString = [NSString stringWithCString:mixedSeq encoding:NSUTF8StringEncoding];
	STAssertEquals(utf8strlen(mixedSeq), [mixedString length], @"utf8 characters with all 4 lengths mixed together.");
}

@end
