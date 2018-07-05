var anArray = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0]
var anotherArray = [3.2, 5.3, 7.0, 4.0, 98.0, 65.4]

//compute standard deviation
func standardDeviation (of numbers: [Double]) -> Double {
    var sum = 0.0
    for number in numbers {
        sum += number
    }
    let average = sum/Double(numbers.count)
    var sumOfDifferences: Double = 0
    for number in numbers {
        sumOfDifferences += (Double(number) - average)*(Double(number) - average)
    }
    return (sumOfDifferences/Double(numbers.count-1)).squareRoot()
}

print(standardDeviation(of: anArray))
