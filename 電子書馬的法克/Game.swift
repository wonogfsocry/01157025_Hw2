//
//  GameView.swift
//  電子書馬的法克
//
//  Created by user10 on 2024/11/13.
//

import SwiftUI
import Foundation

// 定義卡片結構
protocol Card: Identifiable {
    var id: UUID { get }
    var image: Image { get }
}

@Observable
class PokemonCard: Card {
    let id = UUID()
    let image: Image
    let name: String
    var hp: Int
    let maxHp: Int
    var elementnow : Int
    var elementneed : Int
    let attack: Int
    let type: String
    let weakness : String
    let elementtype : String

    init(pokemon: Pokemon) {
        self.image = pokemon.image
        self.name = pokemon.name
        self.hp = pokemon.hp
        self.maxHp = pokemon.hp
        self.elementnow = 0
        self.elementneed = pokemon.moveneed
        self.attack = pokemon.damage
        self.type = pokemon.type
        self.weakness = pokemon.weakness
        self.elementtype = "ele"+pokemon.type
    }
}

struct ItemCard: Card {
    let id = UUID()
    let itemEffect: ItemEffect
    let image: Image
    let effectValue: Int
    let description: String

    init(itemEffect: ItemEffect) {
        self.itemEffect = itemEffect
        self.image = itemEffect.image
        self.effectValue = itemEffect.effectValue
        self.description = itemEffect.description
    }
}
enum ItemEffect: String {
    case heal
    case boostDamage
    case viewOpponentHand
    
    // 每個效果的固定圖片
    var image: Image {
        switch self {
        case .heal:
            return Image("healImage") // heal 的圖片名稱
        case .boostDamage:
            return Image("boostDamageImage") // boostDamage 的圖片名稱
        case .viewOpponentHand:
            return Image("viewOpponentHandImage") // viewOpponentHand 的圖片名稱
        }
    }
    
    // 每個效果的固定數值
    var effectValue: Int {
        switch self {
        case .heal:
            return 20 // 回血的數值
        case .boostDamage:
            return 10 // 增加傷害的數值
        case .viewOpponentHand:
            return 0 // 查看對手手牌沒有直接數值
        }
    }
    
    var description: String {
        switch self {
        case .heal:
            return "回復場上寶可夢20hp"
        case .boostDamage:
            return "本回合招式傷害增加10"
        case .viewOpponentHand:
            return "本回合可以查看對手手牌"
        }
    }
}

class DeckSelection: ObservableObject {
    @Published var playerDeck: [any Card] = []
    @Published var opponentDeck: [any Card] = []
    @Published var isPlayerReady = false
    @Published var isOpponentReady = false
}

struct PreparationPage: View {
    @StateObject var deckSelection = DeckSelection()
    @Binding var playerDeck: [any Card]
    @Binding var opponentDeck: [any Card]
    @Binding var Firsttime: Bool
    @State private var showPlayerDeckSheet = false
    @State private var showOpponetDeckSheet = false
    @State private var showrules = false
    @State private var tempPlayerDeck: [any Card] = [] // 臨時儲存玩家選擇的牌組
    @State private var tempOpponentDeck: [any Card] = [] // 臨時儲存對手選擇的牌組
    @StateObject private var audioManager = AudioManager.shared
    let resetGame: () -> Void
    
    var body: some View {
        VStack {
            // 顯示雙方牌組的照片
            HStack {
                Text("OpponentDeck")
                    .font(.custom("PokemonSolidNormal", size: 30))
                    .foregroundStyle(.white)
                if deckSelection.isOpponentReady {
                    Text("ready!!")
                        .font(.custom("PokemonSolidNormal", size: 20))
                        .foregroundStyle(.red)
                }
            }
            VStack{
                HStack {
                    Button(action: {
                        showOpponetDeckSheet.toggle()
                        tempOpponentDeck = waterDeck
                        audioManager.playSoundEffect(named: "buttonclick")
                    }) {
                        Image(.watPoke)
                            .resizable()
                            .frame(width: 150, height: 150)
                    }
                    Button(action: {
                        showOpponetDeckSheet.toggle()
                        tempOpponentDeck = eletricDeck
                        audioManager.playSoundEffect(named: "buttonclick")
                    }) {
                        Image(.elePoke)
                            .resizable()
                            .frame(width: 150, height: 150)
                    }
                }
                Button(action: {
                    showOpponetDeckSheet.toggle()
                    tempOpponentDeck = fireDeck
                    audioManager.playSoundEffect(named: "buttonclick")
                }) {
                    Image(.firePoke)
                        .resizable()
                        .frame(width: 150, height: 150)
                        .offset(x:-90, y:10)
                }
                .sheet(isPresented: $showOpponetDeckSheet) {
                    DeckDetailView(temporaryDeck: $tempOpponentDeck,
                                   finalDeck: $deckSelection.opponentDeck,
                                   isReady: $deckSelection.isOpponentReady,
                                   showSheet: $showOpponetDeckSheet)
                }
            }
            
            Spacer()
            
            VStack{
                VStack{
                    Button(action: {
                        showPlayerDeckSheet.toggle()
                        tempPlayerDeck = fireDeck
                        audioManager.playSoundEffect(named: "buttonclick")
                    }) {
                        Image(.firePoke) // 假設這是玩家牌組的圖示
                            .resizable()
                            .frame(width: 150, height: 150)
                    }
                    .offset(x:80, y:10)
                    HStack {
                        Button(action: {
                            showPlayerDeckSheet.toggle()
                            tempPlayerDeck = eletricDeck
                            audioManager.playSoundEffect(named: "buttonclick")
                        }) {
                            Image(.elePoke) // 假設這是玩家牌組的圖示
                                .resizable()
                                .frame(width: 150, height: 150)
                        }
                        Button(action: {
                            showPlayerDeckSheet.toggle()
                            tempPlayerDeck = waterDeck
                            audioManager.playSoundEffect(named: "buttonclick")
                        }) {
                            Image(.watPoke) // 假設這是玩家牌組的圖示
                                .resizable()
                                .frame(width: 150, height: 150)
                        }
                    }
                }
                .sheet(isPresented: $showPlayerDeckSheet) {
                    DeckDetailView(temporaryDeck: $tempPlayerDeck,
                                   finalDeck: $deckSelection.playerDeck,
                                   isReady: $deckSelection.isPlayerReady,
                                   showSheet: $showPlayerDeckSheet)
                }
                .onAppear{
                    audioManager.stopBackgroundMusic()
                    audioManager.playBackgroundMusic(named: "prepare")
                }
                HStack {
                    Text("PlayerDeck")
                        .font(.custom("PokemonSolidNormal", size: 30))
                        .foregroundStyle(.white)
                    if deckSelection.isPlayerReady {
                        Text("ready!!")
                            .font(.custom("PokemonSolidNormal", size: 20))
                            .foregroundStyle(.red)
                    }
                }
            }
        }
        
        
        Spacer()
        
        // 顯示戰鬥開始按鈕，只有雙方都選擇完畢後才顯示
        if deckSelection.isPlayerReady && deckSelection.isOpponentReady {
            Button(action: {
                playerDeck = deckSelection.playerDeck
                opponentDeck = deckSelection.opponentDeck
                audioManager.stopBackgroundMusic()
                audioManager.playBackgroundMusic(named: "battle")
                audioManager.playSoundEffect(named: "gamestart")
                resetGame() // 重設遊戲
                Firsttime = false // 切換到遊戲畫面
            }){
                Text("Go Go!")
                    .padding()
                    .foregroundStyle(.white)
                    .font(.custom("PokemonSolidNormal", size: 30))
                
            }
        }
        else{
            NavigationLink{
                RulesView()
            }label:{
                ZStack{
                    Capsule()
                        .frame(width: 125.0, height: 55.0)
                        .foregroundColor(.black)
                    Capsule()
                        .frame(width: 120.0, height: 50.0)
                        .foregroundColor(.white)
                        .overlay(content:{
                            Text("對戰規則")
                                .font(.custom("HanyiSentyCrayon", size: 30))
                                .foregroundColor(.black)
                                .padding()
                                .cornerRadius(10)
                        })
                }
            }
        }
    }
}

struct DeckDetailView: View {
    @Binding var temporaryDeck: [any Card] // 臨時的牌組
    @Binding var finalDeck: [any Card] // 最終的牌組
    @Binding var isReady: Bool
    @Binding var showSheet: Bool
    @StateObject private var audioManager = AudioManager.shared
    let columns = Array(repeating: GridItem(), count: 3)
    var body: some View {
        VStack {
            Text("牌組頁面")
                .font(.custom("HanyiSentyCrayon", size: 40))
                .padding()
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(temporaryDeck, id: \.id) { card in
                        card.image
                            .resizable()
                            .scaledToFit()
                            .frame(width:100, height: 200)
                            .padding(-20)
                    }
                }
            }
        }
        HStack{
            Button("確定") {
                finalDeck = temporaryDeck // 將臨時牌組設為最終牌組
                audioManager.playSoundEffect(named: "buttonclick")
                isReady = true
                showSheet = false
            }
            .font(.custom("Cubic_11", size: 18))
            .padding()
            .buttonStyle(.borderedProminent)
            
            Button("取消") {
                audioManager.playSoundEffect(named: "buttonclick")
                showSheet = false
            }
            .font(.custom("Cubic_11", size: 18))
            .padding()
            .buttonStyle(.borderedProminent)
        }
    }
}
var waterDeck: [any Card] = [
    PokemonCard(pokemon:waterPokemon[0]),
    PokemonCard(pokemon:waterPokemon[1]),
    PokemonCard(pokemon:waterPokemon[3]),
    PokemonCard(pokemon:waterPokemon[4]),
    PokemonCard(pokemon:waterPokemon[5]),
    ItemCard(itemEffect: .heal),
    ItemCard(itemEffect: .heal),
    ItemCard(itemEffect: .boostDamage),
    ItemCard(itemEffect: .boostDamage),
    ItemCard(itemEffect: .viewOpponentHand)
]

var fireDeck: [any Card] = [
    PokemonCard(pokemon:firPokemon[0]),
    PokemonCard(pokemon:firPokemon[1]),
    PokemonCard(pokemon:firPokemon[2]),
    PokemonCard(pokemon:firPokemon[4]),
    PokemonCard(pokemon:firPokemon[5]),
    ItemCard(itemEffect: .heal),
    ItemCard(itemEffect: .heal),
    ItemCard(itemEffect: .boostDamage),
    ItemCard(itemEffect: .boostDamage),
    ItemCard(itemEffect: .viewOpponentHand)
]

var eletricDeck: [any Card] = [
    PokemonCard(pokemon:electricPokemon[1]),
    PokemonCard(pokemon:electricPokemon[2]),
    PokemonCard(pokemon:electricPokemon[3]),
    PokemonCard(pokemon:electricPokemon[4]),
    PokemonCard(pokemon:electricPokemon[5]),
    ItemCard(itemEffect: .heal),
    ItemCard(itemEffect: .heal),
    ItemCard(itemEffect: .boostDamage),
    ItemCard(itemEffect: .boostDamage),
    ItemCard(itemEffect: .viewOpponentHand)
]

struct TurnIndicatorView: View {
    @State private var showTurnText = false
    @Binding var currentTurn: String // 現在的回合，綁定到外部變數
    var body: some View {
        ZStack {
            // 回合提示文字動畫
            if showTurnText {
                Text("\(currentTurn) 的回合")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.blue)
                    .scaleEffect(showTurnText ? 1 : 0.5) // 從小到大
                    .opacity(showTurnText ? 1 : 0) // 漸顯到漸隱
                    .transition(.scale.combined(with: .opacity)) // 動畫過渡
                    .onAppear {
                        withAnimation(.easeOut(duration: 1.0)) {
                            showTurnText = true
                        }
                        // 延遲一段時間後隱藏
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            withAnimation(.easeIn(duration: 1.0)) {
                                showTurnText = false
                            }
                        }
                    }
            }
        }
        .onChange(of: currentTurn) { _ in
            showTurnText = true // 每次回合改變時觸發動畫
            
        }
    }
}


struct HPGaugeView: View {
    var currentHP: CGFloat// 寶可夢當前HP
    var maxHP: CGFloat // 最大HP

    var body: some View {
        VStack(spacing: 20) {
            // 顯示膠囊HP條
            ZStack(alignment: .leading) {
                // 背景膠囊 (灰色部分)
                Capsule()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 80, height: 20)
                
                // 動態顯示的綠色膠囊 (剩餘HP)
                Capsule()
                    .fill(Color.green)
                    .frame(width: 80 * ( currentHP / maxHP ), height: 20)
                    .animation(.easeInOut, value: currentHP) // 動畫效果
            }
            .padding(.bottom, -10.0)
            // 顯示當前HP數值
            Text("HP: \(Int(currentHP)) / \(Int(maxHP))")
                .font(.custom("PokemonSolidNormal", size: 15))
            
        }
        .padding()
    }
}
    

struct PokemonTCGView: View {
    // 玩家和對手的牌庫
    @State private var playerDeck: [any Card] = waterDeck
    @State private var opponentDeck: [any Card] = fireDeck
    
    // 玩家和對手的手牌
    @State private var playerHand: [any Card] = []
    @State private var opponentHand: [any Card] = []
    
    // 放大顯示卡片
    @State private var selectedPokemonCard: PokemonCard? = nil
    @State private var selectedItemCard: ItemCard? = nil
    
    // 場上寶可夢卡片
    @State private var playerActiveCard: (any Card)? = nil
    @State private var opponentActiveCard: (any Card)? = nil
    
    // 用於顯示場上寶可夢詳細資訊
    @State private var selectedActivePokemon: PokemonCard? = nil
    @State private var showCoinFlipSheet = false
    
    //分數
    @State private var opponentScore: Int = 0
    @State private var playerScore: Int = 0
    
    //誰的回合
    @State private var isPlayerTurn: Bool = true
    @State private var cansee: Bool = false
    @State private var attackboost: Bool = false
    
    // 判定遊戲是否結束
    // 儲存勝利方，"Player" 或 "Opponent"
    // 用來顯示獲勝寶可夢的放大效果
    @State private var isGameOver: Bool = false
    @State private var winner: String? = nil
    @State private var winPokemonCard: PokemonCard? = nil
    @State private var Firsttime: Bool = true
    @State private var canCoin: Bool = true
    @State private var isAnimating1 = false
    @State private var isAnimating2 = false
    @State private var isdraw = false
    @StateObject var timerModel = TimerViewModel()
    
    @StateObject private var audioManager = AudioManager.shared
    @State private var currentTurn = "紅方"

    var body: some View {
        NavigationStack{
            ZStack {
                Image("gameback") // 背景圖片
                    .resizable()
                    .ignoresSafeArea()
                if Firsttime{
                    PreparationPage(playerDeck: $playerDeck, opponentDeck: $opponentDeck, Firsttime: $Firsttime, resetGame: resetGame)
                }
                else if isGameOver {
                    gameOverView()
                        .onAppear{
                            audioManager.stopBackgroundMusic()
                            audioManager.playBackgroundMusic(named: "victory")
                        }
                }
                else {
                    VStack {
                        // 對手區域
                        VStack {
                            HStack {
                                // 對手計分區
                                HStack {
                                    Image(systemName: opponentScore >= 1 ? "star.circle.fill" : "star.circle")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                    Image(systemName: opponentScore >= 2 ? "star.circle.fill" : "star.circle")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                    Image(systemName: opponentScore >= 3 ? "star.circle.fill" : "star.circle")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                }
                                Spacer()
                                // 對手牌庫
                                VStack {
                                    Button(action: {
                                        audioManager.playSoundEffect(named: "buttonclick")
                                        if !isPlayerTurn{ drawOpponentCard()}
                                    })
                                    {
                                        Image(systemName: "rectangle.stack")
                                            .resizable()
                                            .frame(width: 50, height: 70)
                                            .padding()
                                    }
                                }
                            }
                            // 對手的手牌區
                            HStack(spacing: 10) {
                                ForEach(opponentHand, id: \.id) { card in
                                    if !isPlayerTurn || cansee{
                                        card.image
                                            .resizable()
                                            .frame(width: 90, height: 120)
                                            .onTapGesture {
                                                audioManager.playSoundEffect(named: "buttonclick")
                                                if !isPlayerTurn {
                                                    if let pokemonCard = card as? PokemonCard {
                                                        selectedPokemonCard = pokemonCard
                                                    } else if let itemCard = card as? ItemCard {
                                                        selectedItemCard = itemCard
                                                    }
                                                }
                                            }
                                    }
                                    else{
                                        Image(.cardback)
                                            .resizable()
                                            .frame(width: 90, height: 120)
                                    }
                                }
                            }
                            .padding(.bottom, 30)
                        }
                        
                        // 場上唯一的寶可夢
                        
                        VStack {
                            HStack{
                                if let opponentCard = opponentActiveCard as? PokemonCard{
                                    HPGaugeView(currentHP: CGFloat(opponentCard.hp), maxHP: CGFloat(opponentCard.maxHp))
                                        .padding(-120)
                                        .offset(x:-20, y:60)
                                    opponentCard.image
                                        .resizable()
                                        .frame(width: 120, height: 150)
                                        .padding(.bottom, 10)
                                        .offset(x:0, y: isAnimating1 ? 30 : 0) // y 偏移量
                                        .animation(
                                            Animation.interpolatingSpring(stiffness: 300, damping: 10) // 彈性動畫
                                                .repeatCount(1, autoreverses: true), // 撞擊後回到原位
                                            value: isAnimating1
                                        )
                                        .onTapGesture {
                                            audioManager.playSoundEffect(named: "buttonclick")
                                            if !isPlayerTurn{
                                                selectedActivePokemon = opponentCard
                                            }
                                        }
                                        .padding(.bottom, -40)
                                } else {
                                    Image(.battleback)
                                        .resizable()
                                        .frame(width: 140, height: 170)
                                        .padding(.bottom, -40)
                                }
                            }
                            HStack{
                                VStack{
                                    ZStack{
                                        Capsule()
                                            .frame(width: 105.0, height: 55.0)
                                            .foregroundColor(isPlayerTurn ? Color.orange : Color.purple)
                                        Capsule()
                                            .frame(width: 100.0, height: 50.0)
                                            .foregroundColor(.white)
                                            .overlay(content:{
                                                Text("\(currentTurn)回合")
                                                    .foregroundColor(isPlayerTurn ? Color.orange : Color.purple)
                                                    .font(.custom("HanyiSentyCrayon", size: 25))
                                            })
                                    }
                                    .padding(-100)
                                    .offset(x:-160, y:130)
                                    TimerView()
                                        .environmentObject(timerModel)
                                        .padding(-100)
                                        .offset(x:-170, y:50)
                                        .onChange(of: timerModel.timerValue) { newValue in
                                            if newValue == 0 {
                                                endTurn() // 時間到，換下一個人
                                            }
                                        }
                                }
                                Button(action: {
                                    audioManager.playSoundEffect(named: "transition")
                                    endTurn()
                                }) {
                                    ZStack{
                                        Capsule()
                                            .frame(width: 105.0, height: 55.0)
                                            .foregroundColor(isPlayerTurn ? Color.orange : Color.purple)
                                        Capsule()
                                            .frame(width: 100.0, height: 50.0)
                                            .foregroundColor(.white)
                                            .overlay(content:{
                                                Text("結束回合")
                                                    .font(.custom("HanyiSentyCrayon", size: 23))
                                                    .foregroundColor(isPlayerTurn ? Color.orange : Color.purple)
                                                    .padding()
                                                    .cornerRadius(10)
                                            })
                                    }
                                }
                            }
                            .offset(x:130, y:0)
                            HStack{
                                if let playerCard = playerActiveCard as? PokemonCard{
                                    playerCard.image
                                        .resizable()
                                        .frame(width: 120, height: 150)
                                        .offset(x:5, y: isAnimating2 ? -30 : 0) // y 偏移量
                                        .animation(
                                            Animation.interpolatingSpring(stiffness: 300, damping: 10) // 彈性動畫
                                                .repeatCount(1, autoreverses: true), // 撞擊後回到原位
                                            value: isAnimating2
                                        )
                                        .onTapGesture {
                                            audioManager.playSoundEffect(named: "buttonclick")
                                            if isPlayerTurn{
                                                selectedActivePokemon = playerCard
                                            }
                                        }
                                    HPGaugeView(currentHP: CGFloat(playerCard.hp), maxHP: CGFloat(playerCard.maxHp))
                                        .padding(-120)
                                        .offset(x:120, y:40)
                                } else {
                                    Image(.battleback)
                                        .resizable()
                                        .frame(width: 140, height: 170)
                                        .padding(.bottom, -40)
                                }
                            }
                        }
                        .padding(.bottom, 30)
                        // 玩家區域
                        VStack {
                            // 玩家手牌區
                            HStack(spacing: 10) {
                                ForEach(playerHand, id: \.id) { card in
                                    if isPlayerTurn || cansee{
                                        card.image
                                            .resizable()
                                            .frame(width: 90, height: 120)
                                            .onTapGesture {
                                                audioManager.playSoundEffect(named: "buttonclick")
                                                if isPlayerTurn {
                                                    if let pokemonCard = card as? PokemonCard {
                                                        selectedPokemonCard = pokemonCard
                                                    } else if let itemCard = card as? ItemCard {
                                                        selectedItemCard = itemCard
                                                    }
                                                }
                                            }
                                    }
                                    else{
                                        Image(.cardback)
                                            .resizable()
                                            .frame(width: 90, height: 120)
                                    }
                                }
                            }
                            
                            HStack {
                                // 玩家牌庫
                                VStack {
                                    Button(action: {
                                        audioManager.playSoundEffect(named: "buttonclick")
                                        if isPlayerTurn {
                                            drawPlayerCard()}
                                    })
                                    {
                                        Image(systemName: "rectangle.stack")
                                            .resizable()
                                            .frame(width: 50, height: 70)
                                            .padding()
                                    }
                                }
                                Spacer()
                                // 玩家計分區
                                HStack {
                                    Image(systemName: playerScore >= 1 ? "star.circle.fill" : "star.circle")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                    Image(systemName: playerScore >= 2 ? "star.circle.fill" : "star.circle")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                    Image(systemName: playerScore >= 3 ? "star.circle.fill" : "star.circle")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                }
                            }
                            .padding()
                        }
                        TurnIndicatorView(currentTurn: $currentTurn)
                            .padding(-100)
                            .offset(x:100, y:100)
                    }
                    .padding()
                }
            }
        }
        // 彈出視窗顯示選中的卡片
        .sheet(item: $selectedPokemonCard) { card in
            VStack {
                card.image
                    .resizable()
                    .scaledToFit()
                    .padding()
                HStack{
                    Text("持有能量:")
                        .font(.custom("HanyiSentyCrayon", size: 40))
                        .padding()
                    EnergyView(energyCount: card.elementnow, energyIcon: card.elementtype)
                }
                HStack{
                    Text("HP: \(card.hp)")
                        .font(.custom("HanyiSentyCrayon", size: 40))
                    Text("Attack: \(card.attack)")
                        .font(.custom("HanyiSentyCrayon", size: 40))
                }
                HStack{
                    Button("上場") {
                        audioManager.playSoundEffect(named: "buttonclick")
                        if let index = playerHand.firstIndex(where: { $0.id == card.id }) {
                            playerActiveCard = playerHand.remove(at: index)
                        }
                        else if let index2 = opponentHand.firstIndex(where: { $0.id == card.id }) {
                            opponentActiveCard = opponentHand.remove(at: index2)
                        }
                        selectedPokemonCard = nil
                    }
                    .font(.custom("Cubic_11", size: 18))
                    .padding()
                    .buttonStyle(.borderedProminent)
                    if canCoin{
                        Button("填能量") {
                            audioManager.playSoundEffect(named: "buttonclick")
                            showCoinFlipSheet = true
                            canCoin = false
                        }
                        .font(.custom("Cubic_11", size: 18))
                        .padding()
                        .buttonStyle(.borderedProminent)
                    }
                    Button("關閉") {
                        audioManager.playSoundEffect(named: "buttonclick")
                        selectedPokemonCard = nil
                    }
                    .font(.custom("Cubic_11", size: 18))
                    .padding()
                    .buttonStyle(.borderedProminent)
                }
            }
            .sheet(isPresented: $showCoinFlipSheet) {
                CoinFlipSheetView(isPresented: $showCoinFlipSheet, pokemon: $selectedPokemonCard)
                    .presentationDetents([.fraction(0.3)])
                    .presentationCornerRadius(50)
            }
            .padding()
        }
        .sheet(item: $selectedItemCard) { card in
            VStack {
                card.image
                    .resizable()
                    .scaledToFit()
                    .padding()
                
                Text(card.description)
                    .font(.custom("HanyiSentyCrayon", size: 40))
                    .padding()
                HStack{
                    Button("使用") {
                        audioManager.playSoundEffect(named: "itemeffect")
                        switch card.itemEffect {
                        case .heal:
                            // 回復生命
                            print("回復 \(card.effectValue) HP")
                            if isPlayerTurn{
                                if let playerCard = playerActiveCard as? PokemonCard {
                                    playerCard.hp += 20
                                    if playerCard.hp > playerCard.maxHp{
                                        playerCard.hp = playerCard.maxHp
                                    }
                                }
                            }
                            else{
                                if let opponentCard = opponentActiveCard as? PokemonCard {
                                    opponentCard.hp += 20
                                    if opponentCard.hp > opponentCard.maxHp{
                                        opponentCard.hp = opponentCard.maxHp
                                    }
                                }
                            }
                        case .boostDamage:
                            // 提升攻擊力
                            print("提升本回合 \(card.effectValue) 攻擊力")
                            attackboost = true
                        case .viewOpponentHand:
                            // 展示對方的手牌
                            print("查看對方手牌")
                            cansee = true
                        }
                        if let index = playerHand.firstIndex(where: { $0.id == card.id }) {
                            playerHand.remove(at: index)
                        }
                        else if let index2 = opponentHand.firstIndex(where: { $0.id == card.id }) {
                            opponentHand.remove(at: index2)
                        }
                        selectedItemCard = nil
                    }
                    .font(.custom("Cubic_11", size: 18))
                    .padding()
                    .buttonStyle(.borderedProminent)
                    
                    Button("    關閉") {
                        audioManager.playSoundEffect(named: "buttonclick")
                        selectedItemCard = nil
                    }
                    .font(.custom("Cubic_11", size: 18))
                }
            }
            .padding()
        }
        .sheet(item: $selectedActivePokemon) { card in
            VStack {
                card.image
                    .resizable()
                    .scaledToFit()
                    .padding()
                HStack{
                    Text("持有能量: ")
                        .font(.custom("HanyiSentyCrayon", size: 40))
                    EnergyView(energyCount: card.elementnow, energyIcon: card.elementtype)
                }
                HStack{
                    Text("HP: \(card.hp)  ")
                        .font(.custom("HanyiSentyCrayon", size: 40))
                    Text("Attack: \(card.attack)")
                        .font(.custom("HanyiSentyCrayon", size: 40))
                }
                HStack{
                    Text("Moveneed: ")
                        .font(.custom("HanyiSentyCrayon", size: 40))
                    EnergyView(energyCount: card.elementneed, energyIcon: card.elementtype)
                }
                HStack{
                    Text("type:")
                        .font(.custom("HanyiSentyCrayon", size: 40))
                    Image(card.type)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 35, height:35)
                    Text("  weak:")
                        .font(.custom("HanyiSentyCrayon", size: 40))
                    Image(card.weakness)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 35, height:35)
                }
                .padding(2)
                HStack{
                    if card.elementnow >= card.elementneed{
                        Button("Attack!") {
                                audioManager.playSoundEffect(named: "hit")
                                performAttack(on: card)
                            }
                        .font(.custom("Cubic_11", size: 18))
                        .padding()
                        .buttonStyle(.borderedProminent)
                    }
                    if canCoin{
                        Button("填能量") {
                            audioManager.playSoundEffect(named: "buttonclick")
                            showCoinFlipSheet = true
                            canCoin = false
                        }
                        .font(.custom("Cubic_11", size: 18))
                        .padding()
                        .buttonStyle(.borderedProminent)
                    }
                    Button("Close") {
                        audioManager.playSoundEffect(named: "buttonclick")
                        selectedActivePokemon = nil
                    }
                    .font(.custom("Cubic_11", size: 18))
                    .padding()
                    .buttonStyle(.borderedProminent)
                }
                .padding(.bottom, -5.0)
            }
            .sheet(isPresented: $showCoinFlipSheet) {
                CoinFlipSheetView(isPresented: $showCoinFlipSheet, pokemon: $selectedActivePokemon)
                    .presentationDetents([.fraction(0.4)])
                    .presentationCornerRadius(50)
            }
            .padding()
        }
    }
    
    // 攻擊邏輯
    private func performAttack(on card: PokemonCard) {
        // 檢查攻擊者是誰，並根據攻擊者進行攻擊邏輯處理
        if isPlayerTurn {
            if let playerCard = playerActiveCard as? PokemonCard {
                // 玩家攻擊對方寶可夢
                if let opponentCard = opponentActiveCard as? PokemonCard {
                    isAnimating2 = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        isAnimating2 = false
                    }
                    opponentCard.hp -= playerCard.attack  // 假設玩家寶可夢的攻擊力為 attack
                    if attackboost{
                        opponentCard.hp -= 10
                    }
                    if playerCard.type == opponentCard.weakness {
                        opponentCard.hp -= 20
                    }
                    if opponentCard.hp <= 0 {
                        opponentCard.hp = 0
                        // 移除對方場上寶可夢
                        opponentActiveCard = nil
                        // 檢查對方是否還有寶可夢
                        if opponentHand.filter({ $0 is PokemonCard }).isEmpty {
                            winner = "Player"
                            isGameOver = true
                            winPokemonCard = playerCard
                        }
                        opponentActiveCard = nil
                        // 更新玩家計分區
                        audioManager.playSoundEffect(named: "scoreget")
                        updatePlayerScore()
                    }
                }
            }
        }
        else{
             if let opponentCard = opponentActiveCard as? PokemonCard {
                // 對手攻擊玩家寶可夢
                if let playerCard = playerActiveCard as? PokemonCard {
                    isAnimating1 = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        isAnimating1 = false
                    }
                    playerCard.hp -= opponentCard.attack  // 假設對手寶可夢的攻擊力為 attack
                    if attackboost{
                        playerCard.hp -= 10
                    }
                    if opponentCard.type == playerCard.weakness {
                        playerCard.hp -= 20
                    }
                    if playerCard.hp <= 0 {
                        playerCard.hp = 0
                        // 移除玩家場上寶可夢
                        playerActiveCard = nil
                        // 檢查玩家是否還有寶可夢
                        if playerHand.filter({ $0 is PokemonCard }).isEmpty {
                            winner = "Opponent"
                            isGameOver = true
                            winPokemonCard = opponentCard
                        }
                        playerActiveCard = nil
                        // 更新對方計分區
                        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
                            audioManager.playSoundEffect(named: "scoreget")
                        }
                        updateOpponentScore()
                        
                    }
                }
            }
        }
        // 攻擊後切換回合
        endTurn()
        selectedActivePokemon = nil
    }
    // 當遊戲結束時顯示"Player Win" 或 "Opponent Win"的訊息和動畫
    private func gameOverView() -> some View {
        VStack {
            if let winner = winner {
                Text("👑")
                    .font(.custom("PokemonSolidNormal", size: 80))
                    .padding(-30)
                    
                Text("🏆 \(winner) Win 🏆")
                    .font(.custom("PokemonSolidNormal", size: 40))
                    .bold()
                    .foregroundColor(.white)
                    .transition(.scale)
                    .padding(.bottom, 30)
                if let winCard = winPokemonCard {
                    ZStack{
                        Image(.背板)
                            .resizable()
                            .frame(width: 230.0, height: 310.0)
                        winCard.image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 225.0, height: 240.0)
                            .transition(.scale)
                            .padding(20)
                    }
                }
            }
            Button("🎮 再來一局 🎮") {
                audioManager.stopBackgroundMusic()
                audioManager.playBackgroundMusic(named: "battle")
                audioManager.playSoundEffect(named: "gamestart")
                resetGame() // 重新開始遊戲
            }
            .padding(20)
            .font(.custom("HanyiSentyCrayon", size: 40))
            .foregroundColor(.white)
            .cornerRadius(10)
            Image(.victor1)
                .resizable()
                .scaledToFit()
                .padding(-100)
                .frame(width: 30.0)
                .offset(x:130, y:90)
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    private func updateOpponentScore() {
        opponentScore += 1
        if opponentScore >= 3 {
            winner = "Opponent"
            isGameOver = true
            winPokemonCard = opponentActiveCard as? PokemonCard
        }
    }
    
    private func updatePlayerScore() {
        playerScore += 1
        if playerScore >= 3 {
            winner = "Player"
            isGameOver = true
            winPokemonCard = playerActiveCard as? PokemonCard
        }
    }
    
    // 抽玩家卡片函數
    private func drawPlayerCard() {
        // 檢查手牌數量是否少於3
        guard playerHand.count < 3 && !isdraw else { return }
        
        if let drawnCard = playerDeck.randomElement() {
            playerHand.append(drawnCard)
            isdraw = true
            if let index = playerDeck.firstIndex(where: { $0.id == drawnCard.id }) {
                playerDeck.remove(at: index)
            }
        }
    }

    
    // 抽對手卡片函數
    private func drawOpponentCard() {
        // 檢查手牌數量是否少於3
        guard opponentHand.count < 3 && !isdraw else { return }
        
        if let drawnCard = opponentDeck.randomElement() {
            opponentHand.append(drawnCard)
            isdraw = true
            if let index = opponentDeck.firstIndex(where: { $0.id == drawnCard.id }) {
                opponentDeck.remove(at: index)
            }
        }
    }
    private func endTurn() {
        attackboost = false
        cansee = false
        canCoin = true
        isdraw = false
        timerModel.resetTimer()
        timerModel.startTimer()
        if isPlayerTurn && playerActiveCard == nil{
            winner = "Opponent"
            isGameOver = true
            winPokemonCard = opponentActiveCard as? PokemonCard
        }
        if !isPlayerTurn && opponentActiveCard == nil{
            winner = "Player"
            isGameOver = true
            winPokemonCard = playerActiveCard as? PokemonCard
        }
        isPlayerTurn.toggle() // 切換回合
        currentTurn = (currentTurn == "紅方") ? "藍方" : "紅方"
        print("現在是 \(isPlayerTurn ? "紅方" : "藍方") 的回合")
    }
    private func resetGame() {
        // 重置所有必要的遊戲狀態
        isGameOver = false
        winner = nil
        winPokemonCard = nil
        playerActiveCard = nil
        opponentActiveCard = nil
        playerScore = 0
        opponentScore = 0
        playerHand.removeAll()
        opponentHand.removeAll()
        Firsttime = false
        attackboost = false
        cansee = false
        canCoin = true
        isdraw = false
        //確保玩家開場時能有一隻寶可夢
        if let playerPokemon = playerDeck.shuffled().first(where: { $0 is PokemonCard }) as? PokemonCard {
            playerActiveCard = playerPokemon
            playerDeck.removeAll { $0.id == playerPokemon.id } // 移除選中的寶可夢卡片
        }
            
        if let opponentPokemon = opponentDeck.shuffled().first(where: { $0 is PokemonCard }) as? PokemonCard {
            opponentActiveCard = opponentPokemon
            opponentDeck.removeAll { $0.id == opponentPokemon.id } // 移除選中的寶可夢卡片
        }
        // 重新發牌
        drawPlayerCard()
        isdraw = false
        drawPlayerCard()
        isdraw = false
        drawPlayerCard()
        isdraw = false
        drawOpponentCard()
        isdraw = false
        drawOpponentCard()
        isdraw = false
        drawOpponentCard()
        isdraw = false
        // 確保回合轉換為玩家的回合
        isPlayerTurn = true
        timerModel.resetTimer()
        timerModel.startTimer()
    }

}

struct EnergyView: View {
    let energyCount: Int
    var energyIcon : String
    var body: some View {
        HStack {
            ForEach(0..<energyCount, id: \.self) { _ in
                Image(energyIcon) // 替換為你的能量圖片名稱
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
                    .padding(0)
                Text(" ")
            }
        }
    }
}

struct CoinFlipSheetView: View {
    @State private var isFlipping = false
    @State private var currentSide = "head" // "head" or "tail"
    @State private var rotationAngle: Double = 0
    @State private var resultMessage: String?
    @Binding var isPresented: Bool
    @Binding var pokemon: PokemonCard?
    @StateObject private var audioManager = AudioManager.shared
    @State var justone : Bool = true

    let coinSides = ["head", "tail"]

    var body: some View {
        VStack {
            Button(action: {
                if justone{
                    flipCoin()
                    audioManager.playSoundEffect(named: "coin")
                }
                justone = false
            })
            {
                Image(currentSide)
                    .resizable()
                    .frame(width: 100, height: 100)
                    .rotation3DEffect(
                        .degrees(rotationAngle),
                        axis: (x: 1, y: 0, z: 0)
                    )
                    .animation(.easeInOut(duration: 0.2), value: rotationAngle)
                    .padding()
            }
            .padding(-5)
            if let message = resultMessage {
                Button(action: {
                    audioManager.playSoundEffect(named: "buttonclick")
                    isPresented = false
                }, label: {
                    Text(message)
                        .font(.custom("HanyiSentyCrayon", size: 30))
                        .padding()
                        .foregroundColor(.white)
                })
            }
        }
        .padding()
    }

    func flipCoin() {
        isFlipping = true
        var flips = 0
        let totalFlips = 10
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            rotationAngle += 180
            if rotationAngle.truncatingRemainder(dividingBy: 360) == 0 {
                currentSide = coinSides.randomElement() ?? "head"
            }
            flips += 1
            if flips >= totalFlips {
                timer.invalidate()
                isFlipping = false
                showResult()
            }
        }
    }
    func showResult() {
            if currentSide == "head" {
                resultMessage = "恭喜獲得1能量"
                pokemon?.elementnow += 1
            } else {
                resultMessage = "下次再加油"
            }
        }
}

struct PokemonTCGView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonTCGView()
    }
}
