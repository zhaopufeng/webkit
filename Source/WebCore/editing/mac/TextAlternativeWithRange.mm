/*
 * Copyright (C) 2012, 2020 Apple Inc. All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY APPLE INC. AND ITS CONTRIBUTORS ``AS IS''
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
 * THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 * PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL APPLE INC. OR ITS CONTRIBUTORS
 * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
 * THE POSSIBILITY OF SUCH DAMAGE.
 */
#import "config.h"
#import "TextAlternativeWithRange.h"

#if USE(DICTATION_ALTERNATIVES)

#if USE(APPKIT)
#import <AppKit/NSTextAlternatives.h>
#elif PLATFORM(IOS_FAMILY)
#import <pal/spi/cocoa/NSAttributedStringSPI.h>
#import <pal/spi/ios/UIKitSPI.h>
#endif

namespace WebCore {

TextAlternativeWithRange::TextAlternativeWithRange(NSTextAlternatives *anAlternatives, NSRange aRange)
    : range { aRange }
    , alternatives { anAlternatives }
{
}

void collectDictationTextAlternatives(NSAttributedString *string, Vector<TextAlternativeWithRange>& alternatives) {
    NSRange effectiveRange = NSMakeRange(0, 0);
    NSUInteger length = [string length];
    do {
        NSDictionary *attributes = [string attributesAtIndex:effectiveRange.location effectiveRange:&effectiveRange];
        if (!attributes)
            break;
        NSTextAlternatives *textAlternatives = [attributes objectForKey:NSTextAlternativesAttributeName];
        if (textAlternatives)
            alternatives.append(TextAlternativeWithRange(textAlternatives, effectiveRange));
        effectiveRange.location = NSMaxRange(effectiveRange);
    } while (effectiveRange.location < length);
}

} // namespace WebCore

#endif // USE(DICTATION_ALTERNATIVES)
