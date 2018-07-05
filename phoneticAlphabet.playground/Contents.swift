let words = ["alfa", "bravo", "charlie", "delta", "echo", "foxtrot", "golf", "hotel", "india", "juliett", "kilo", "lima", "mike", "november", "oscar", "papa", "quebec", "romeo", "sierra", "tango", "uniform", "victor", "whiskey", "x-ray", "yankee", "zulu"]

var ints: [Int] = []

var firstChars: [String] = []

//create ints
for number in 1...words.count {
    var int = words[number - 1].characters.count
    ints.append(int)
}
//print(ints)

//create firstChars
for number in 1...words.count {
    var firstChar = words[number - 1][words[number - 1].startIndex]
    firstChars.append(String(firstChar))
}
//print(firstChars)

func findLength(letter: String) -> String {
    let intsIndex = firstChars.index(of: letter)
    if intsIndex != nil {
        return String(ints[intsIndex!])
    }
    else {
        return "oops. problemo."
    }
    
}

print(findLength(letter: "c"))
