struct Player {
    var playerName: String
    var playerScore: Int
    var playerZipCode: Int
    var playerNumberOfGames = 1
    init(name: String, score: Int, zipCode: Int){
        playerName = name
        playerScore = score
        playerZipCode = zipCode
    }
    
}

var players: [Player] = []
var numberOfPlayers = 0

func initialize (){
    numberOfPlayers = 0
}

func reportScore(name: String, zipCode: Int, score: Int){
    var isNew = true
    if numberOfPlayers != 0 {
        for person in 0...(numberOfPlayers - 1){
            if name == players[person].playerName{
                isNew = false
                players[person].playerNumberOfGames += 1
                if score > players[person].playerScore{
                    players[person].playerScore = score
                }
            }
        }
    }
    if isNew{
        numberOfPlayers += 1
        let aPlayer = Player(name: name, score: score, zipCode: zipCode)
        players.append(aPlayer)
    }
}

func sortScores(of: [Player]){
    for i in 0...(players.count - 2) {
        for j in (i + 1)...(players.count - 1) {
            if players[i].playerScore < players[j].playerScore{
                let hold = players[i]
                players[i] = players[j]
                players[j] = hold
            }
        }
    }
    print("NAME        SCORE")
    for i in 0...4{
        print(players[i].playerName + "         " + String(players[i].playerScore))
    }
}

reportScore(name: "Hermione", zipCode: 94022, score: 98)
reportScore(name: "Harry", zipCode: 94040, score: 85)
reportScore(name: "Ron", zipCode: 78731, score: 46)
reportScore(name: "Ginny", zipCode: 78701, score: 68)
reportScore(name: "Neville", zipCode: 94040, score: 79)
reportScore(name: "Hermione", zipCode: 94022, score: 75)

//print(players)
sortScores(of: players)
