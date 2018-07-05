
func sieve(n: Int)  -> [Int] {
    var anArray: [Bool] = []
    for _ in 1...n {
        anArray.append(true)
    }
    for number in 2...n {                                   //cycle through all numbers 2-n (2 - 100)
        var i = 2                                           //cycle through multiples of n by multiplying by i
        while i * number <= n {                             //cycle through multiples of said number
            anArray[i * number - 1] = false
            i += 1
        }
    }
    var primes: [Int] = []
    for number in 2...anArray.count {
        if anArray[number - 1] {
            primes.append(number)
        }
    }
    return primes
}

print(sieve(n: 100))
