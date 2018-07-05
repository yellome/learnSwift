var anArray = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

func numberOfOdds(numbers: [Int]) -> Int{
    var counter = 0
    for number in numbers{
        if number % 2 == 1{
            counter += 1
        }
        else{
        }
    }
    return counter
}

print(numberOfOdds(numbers: anArray))
