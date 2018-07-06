var playerName: [String] = []
var playerZip: [Int] = []
var playerNumberOfGames: [Int] = []
var playerHighScore: [Int] = []

var numberOfPlayers = 0

func initialize() {
    numberOfPlayers = 0
}

func reportScore(name: String, zipCode: Int, numberOfGames: Int, highScore: Int){
    playerName.append(name)
    playerZip.append(zipCode)
    playerNumberOfGames.append(numberOfGames)
    playerHighScore.append(highScore)
    
    numberOfPlayers += 1
}

func printHighScore(of: [Int]){
    var highScore = playerHighScore[0]
    var highScoreIndex = 0
    for number in 1...numberOfPlayers - 1{
            if highScore < playerHighScore[number]{
            highScore = playerHighScore[number]
            highScoreIndex = number
        }
    }
    print("HIGH SCORE:" + "\n name: " + playerName[highScoreIndex] + "\n zipcode: " +  String(playerZip[highScoreIndex]) + "\n number of games played: " + String(playerNumberOfGames[highScoreIndex]) + "\n high score: " + String(playerHighScore[highScoreIndex]))
}

initialize()

reportScore(name: "A", zipCode: 94022, numberOfGames: 20, highScore: 98)
reportScore(name: "B", zipCode: 94040, numberOfGames: 13, highScore: 85)
reportScore(name: "C", zipCode: 78731, numberOfGames: 79, highScore: 46)
reportScore(name: "D", zipCode: 78701, numberOfGames: 3, highScore: 68)
reportScore(name: "E", zipCode: 94040, numberOfGames: 25, highScore: 79)

printHighScore(of: playerHighScore) 
 
//need to have error message for high score if there are 0 players