//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

func printAndCount(stringToPrint: String) -> Int {
    print(stringToPrint)
    return stringToPrint.characters.count
}

func printWithoutCounting(stringToPrint: String) -> Int{
    let strCount2 = printAndCount(stringToPrint)
    return strCount2
}

let strCount = printAndCount("hello, world")
print(strCount)
// prints "hello, world" and returns a value of 12
let strCount2 = printWithoutCounting("hello, world")
print(strCount2)
// prints "hello, world" but does not return a value
