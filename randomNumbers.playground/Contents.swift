import Darwin

func randomNumbers(n: Int) -> [Double] {
    var anArray: [Double] = []
    for _ in 1...n{
        let x = (drand48())
        anArray.append(x)
    }
    return anArray
}

func standardDeviation (of numbers: [Double]) {
    var sum = 0.0
    for number in numbers {
        sum += number
    }
    let average = sum/Double(numbers.count)
    print("average: " + String(average))
    
    var sumOfDifferences: Double = 0
    for number in numbers {
        sumOfDifferences += (Double(number) - average)*(Double(number) - average)
    }
    let standardDevation = sumOfDifferences/Double(numbers.count-1).squareRoot()
    print("standard devation: " + String(standardDevation))
}

for _ in 1...3{
    let arr = randomNumbers(n: 100)
    //print(arr)
    standardDeviation(of: arr) //prints average and standard deviation
    print("\n \n")
}
