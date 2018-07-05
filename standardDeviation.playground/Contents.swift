//write a function that computes the standard deviation of an array of numbers. assume the numbers will be of the type double. to compute the standard deviation, first find the average of all numbers. then sum the square of the difference between each number and the average. the standard deviation is the square root of  (sum divided by (N-1)) where N is the number of numbers in the array. you can google the formula. swift has a function for computing the square root.

var anArray = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0]
var anotherArray = [3.2, 5.3, 7.0, 4.0, 98.0, 65.4]

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
