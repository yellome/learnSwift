//compute factorial recursively
func factorial(number: Int) -> Double {
    if number > 1 {
        return Double(number) * factorial(number: number - 1)
    }
    else{
        return 1
    }
}

print(factorial(number: 4))
