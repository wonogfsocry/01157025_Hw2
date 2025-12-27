//
//  rules.swift
//  電子書馬的法克
//
//  Created by user10 on 2024/11/22.
//

import SwiftUI

struct RulesView: View {
    @StateObject private var audioManager = AudioManager.shared
    var body: some View {
        ZStack{
            Image(.ruleback)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            ScrollView{
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                VStack{
                    Text("準備階段")
                        .font(.custom("HanyiSentyCrayon", size: 50))
                        .foregroundStyle(.red)
                        .padding()
                    VStack(alignment: .leading){
                        Text("1.雙方從三種牌組中選擇想玩的出戰")
                            .foregroundStyle(.black)
                            .font(.custom("HanyiSentyCrayon", size: 30))
                        Text("2.都準備完畢後，會出現GoGO按鈕開始遊戲")
                            .foregroundStyle(.black)
                            .font(.custom("HanyiSentyCrayon", size: 30))
                        Text("3.開場時雙方場上會從牌庫隨機抽一隻寶可夢和三張手牌")
                            .foregroundStyle(.black)
                            .font(.custom("HanyiSentyCrayon", size: 30))
                    }
                    .frame(width: 300.0)
                    Text("對戰規則")
                        .font(.custom("HanyiSentyCrayon", size: 50))
                        .foregroundStyle(.blue)
                        .padding()
                    VStack(alignment: .leading){
                        Text("1.每回合可選擇一隻自己的寶可夢填能量，硬幣骰到正面才能夠成功填能")
                            .foregroundStyle(.black)
                            .font(.custom("HanyiSentyCrayon", size: 30))
                        Text("2.每隻寶可夢會有招式能量需求，能量足夠才能夠攻擊")
                            .foregroundStyle(.black)
                            .font(.custom("HanyiSentyCrayon", size: 30))
                        Text("3.攻擊時，如果自身的屬性是對方的弱點，傷害加二十")
                            .foregroundStyle(.black)
                            .font(.custom("HanyiSentyCrayon", size: 30))
                        Text("4.每回合不限制物品卡使用數量")
                            .foregroundStyle(.black)
                            .font(.custom("HanyiSentyCrayon", size: 30))
                        Text("5.每回合可以抽一張牌，但手牌量不可以超過3張")
                            .foregroundStyle(.black)
                            .font(.custom("HanyiSentyCrayon", size: 30))
                        Text("6.可以直接讓手牌寶可夢上場，此時場上的寶可夢會到棄牌區但對手不會得分")
                            .foregroundStyle(.black)
                            .font(.custom("HanyiSentyCrayon", size: 30))
                        Text("7.若攻擊結束或限制時間結束就會結束自己的回合")
                            .foregroundStyle(.black)
                            .font(.custom("HanyiSentyCrayon", size: 30))
                    }
                    .frame(width: 300.0)
                    Text("獲勝條件")
                        .font(.custom("HanyiSentyCrayon", size: 50))
                        .foregroundStyle(.orange)
                        .padding()
                    VStack(alignment: .leading){
                        Text("1.擊敗三隻對手寶可夢獲得三分")
                            .foregroundStyle(.black)
                            .font(.custom("HanyiSentyCrayon", size: 30))
                        Text("2.擊敗對手場上寶可夢後，對手手牌不存在寶可夢")
                            .foregroundStyle(.black)
                            .font(.custom("HanyiSentyCrayon", size: 30))
                        Text("3.對手回合結束時場上不存在寶可夢")
                            .foregroundStyle(.black)
                            .font(.custom("HanyiSentyCrayon", size: 30))
                    }
                    .frame(width: 300.0)
                }
                .frame(width: 300.0, height: 1000.0)
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Spacer()
            }
        }
        .scrollIndicators(.hidden)
        .onAppear{
            audioManager.playSoundEffect(named: "transition")
        }
    }
}

#Preview {
    RulesView()
}
