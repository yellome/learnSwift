var playerName: [String] = []
var playerZip: [Int] = []
var playerNumberOfGames: [Int] = []
var playerScore: [Int] = []

var numberOfPlayers = 0

func initialize() {
    numberOfPlayers = 0
}

func reportScore(name: String, zipCode: Int, score: Int){
    var isNew = true
    if numberOfPlayers != 0 {
        for person in 1...numberOfPlayers {
            if name == playerName[person - 1] {
                isNew = false
                playerNumberOfGames[person - 1] += 1
                if score > playerScore[person - 1] {
                    playerScore[person - 1] = score
                }
            }
        }
    }
    if isNew {
        numberOfPlayers += 1
        playerName.append(name)
        playerZip.append(zipCode)
        playerNumberOfGames.append(1)
        playerScore.append(score)
    }
}

func sortScores(of: [Int]){
    for i in 0...(playerScore.count - 2) {
        for j in (i + 1)...(playerScore.count - 1) {
            if playerScore[i] < playerScore[j] {
                let holdScore = playerScore[i]
                playerScore[i] = playerScore[j]
                playerScore[j] = holdScore
                let holdName = playerName[i]
                playerName[i] = playerName[j]
                playerName[j] = holdName
                let holdZip = playerZip[i]
                playerZip[i] = playerZip[j]
                playerZip[j] = holdZip
                let holdGames = playerNumberOfGames[i]
                playerNumberOfGames[i] = playerNumberOfGames[j]
                playerNumberOfGames[j] = holdGames
            }
        }
    }
    print("NAME      SCORE")
    for i in 0...4 {
        print(playerName[i] + "         " + String(playerScore[i]))
    }
}

func printHighScore(of: [Int]){
    var highScore = playerScore[0]
    var highScoreIndex = 0
    for number in 1...numberOfPlayers {
        if highScore < playerScore[number - 1]{
            highScore = playerScore[number - 1]
            highScoreIndex = number - 1
        }
    }
    print("HIGH SCORE:" + "\n name: " + playerName[highScoreIndex] + "\n zipcode: " +  String(playerZip[highScoreIndex]) + "\n number of games played: " + String(playerNumberOfGames[highScoreIndex]) + "\n score: " + String(playerScore[highScoreIndex]))
}

initialize()

reportScore(name: "A", zipCode: 94022, score: 98)
reportScore(name: "B", zipCode: 94040, score: 85)
reportScore(name: "C", zipCode: 78731, score: 46)
reportScore(name: "D", zipCode: 78701, score: 68)
reportScore(name: "E", zipCode: 94040, score: 79)
reportScore(name: "A", zipCode: 94022, score: 75)

//print(playerScore)
//printHighScore(of: playerScore)
sortScores(of: playerScore)
