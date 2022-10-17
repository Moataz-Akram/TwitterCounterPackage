//
//  TweetValidator.swift
//  
//
//  Created by Moataz Akram on 17/10/2022.
//

import Foundation


import Foundation

class TweetValidator {
    static let shared = TweetValidator()
    
    private init() {}
    
    func calculateTweetLength(text: String) -> Int {
        if text.isEmpty { return 0 }
        let regexArray = [Regex.emojiPattern, Regex.URLPatternString, Regex.CJKCharacters]
        var tweetText = text
        var addedCount = 0
        var count = 0
        regexArray.forEach { regex in
            (tweetText, addedCount) = calculateRegexWeight(text: tweetText, regexPattern: regex)
            count += addedCount
        }
        print("remaining text: \(tweetText)/nremaining count: \(tweetText.count)")
        count = count + tweetText.count
        return count
    }
    
    func calculateRegexWeight(text: String, regexPattern: String) -> (String, Int) {
        if text.isEmpty {
            return (text, 0)
        }
        var count = 0
        var currentText = text
        // URL is counted as 24 because it way calculates the space before the url as a part of the url
        let addedWeight = regexPattern == Regex.URLPatternString ? 24 : 2
        let regexOptions: NSRegularExpression.Options = regexPattern == Regex.URLPatternString ? .caseInsensitive : []
        let matchOptions: NSRegularExpression.MatchingOptions =  regexPattern == Regex.URLPatternString ? .withoutAnchoringBounds : []
        let textLength = text.utf16.count
        let range = NSMakeRange(0, textLength)
        
        var regexRanges: [NSRange] = []
        let regex = try! NSRegularExpression(pattern: regexPattern, options: regexOptions)
        let regexMatches = regex.matches(in: text, options: matchOptions, range: range)
        for match in regexMatches {
            regexRanges.append(match.range)
        }
        // check if the first url starts at the beginning of the tweet the calculate it as 23
        if regexPattern == Regex.URLPatternString && !regexRanges.isEmpty && regexRanges[0].location == 0 {
            count -= 1
        }
        
        var firstLocation = 0
        var subRange = 0
        for range in regexRanges {
            firstLocation = range.location - subRange
            subRange = subRange + range.length
            var newRange = NSRange()
            newRange.length = range.length
            newRange.location = firstLocation
            let removedRange = Range(newRange, in: currentText)
            if let removedRange {
                currentText.removeSubrange(removedRange)
                count += addedWeight
            }
        }
        return (currentText, count)
    }
    
}
