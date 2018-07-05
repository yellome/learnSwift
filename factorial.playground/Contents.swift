//write a function that computes factorial recursively. use input type of integer and return type of double.

func factorial(number: Int) -> Double {
    if number > 1 {
        return Double(number) * factorial(number: number - 1)
    }
    else{
        return 1
    }
}

print(factorial(number: 4))
