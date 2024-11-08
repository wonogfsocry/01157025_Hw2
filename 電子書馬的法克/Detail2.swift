//
//  Detail2.swift
//  電子書馬的法克
//
//  Created by user10 on 2024/11/5.
//

import SwiftUI

struct Detail2: View {
    let pokemon : Pokemon
    let type : type
    let exchangeRates = ["NT$": 1.0, "JPY": 3.7, "USD": 0.031] //台幣、日幣、美金匯率
    @State private var displayedPrice: Double = 0
    @State private var currencySymbol: String = "NT$" // 預設為台幣
    private func convertPrice(to currency: String) {
            if let rate = exchangeRates[currency] {
                displayedPrice = pokemon.price * rate
                currencySymbol = currency == "NT$" ? "NT$" : (currency == "JPY" ? "¥" : "$")
            }
        }
    var body: some View {
        ScrollView{
            ZStack{
                LazyVStack(spacing: 20) {
                    // 寶可夢圖片
                    pokemon.image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 300)
                        .shadow(radius: 5)
                        .background(Image(.背板).resizable().scaledToFill().frame(width: 230, height: 330))
                        .padding()
                    // 屬性、名稱和 HP 的膠囊框
                    LazyVStack(spacing: 10) {
                        // 屬性膠囊
                        Capsule()
                            .fill(Color.green.opacity(0.2))
                            .overlay(
                                HStack {
                                    Image(type.pic1)
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                    Text(type.ele)
                                        .font(.custom("PokemonSolidNormal", size: 30))
                                        .bold()
                                        .foregroundColor(.green)
                                }
                            )
                            .frame(height: 50)
                        // 名稱膠囊
                        Capsule()
                            .fill(Color.blue.opacity(0.2))
                            .overlay(
                                Text(pokemon.name)
                                    .font(.custom("PokemonSolidNormal", size: 30))
                                    .bold()
                                    .foregroundColor(.blue)
                            )
                            .frame(height: 50)
                        // HP 膠囊
                        Capsule()
                            .fill(Color.red.opacity(0.2))
                            .overlay(
                                Text("HP \(pokemon.hp)")
                                    .font(.custom("PokemonSolidNormal", size: 30))
                                    .bold()
                                    .foregroundColor(.red)
                            )
                            .frame(height: 50)
                    }
                    .padding(.horizontal)
                    // Move 和描述的大圓角框
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.gray.opacity(0.5))
                        .overlay(
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text(pokemon.move)
                                        .font(.custom("Cubic_11", size: 30))
                                        .bold()
                                    Spacer()
                                    Text("\(pokemon.damage)")
                                        .font(.custom("Cubic_11", size: 25))
                                        .bold()
                                        .foregroundColor(.red)
                                }
                                Text(pokemon.description)
                                    .font(.custom("Cubic_11", size: 15))
                                    .foregroundColor(.black)
                            }
                                .padding()
                        )
                        .frame(height: 120)
                        .padding(.horizontal)
                    // 切換匯率的按鈕
                    LazyHStack(spacing: 20) {
                        Button(action: { convertPrice(to: "NT$") }) {
                            Text("台幣")
                                .foregroundStyle(.white)
                                .padding()
                                .background(Capsule().fill(Color.blue.opacity(0.3)))
                        }
                        Button(action: { convertPrice(to: "JPY") }) {
                            Text("日幣")
                                .foregroundStyle(.white)
                                .padding()
                                .background(Capsule().fill(Color.green.opacity(0.3)))
                        }
                        Button(action: { convertPrice(to: "USD") }) {
                            Text("美金")
                                .foregroundStyle(.white)
                                .padding()
                                .background(Capsule().fill(Color.red.opacity(0.3)))
                        }
                    }
                    .padding()
                    LazyHStack {
                        Text("Price: \(currencySymbol)\(displayedPrice, specifier: "%.2f")")
                            .foregroundStyle(.white)
                            .font(.headline)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.yellow.opacity(0.3)))
                    .padding(.horizontal)
                }
            }
                .padding()
                .cornerRadius(15)
                .shadow(radius: 10)
                // 顯示價錢的框框
        }
        .background(Image(type.pic3).resizable().scaledToFill().ignoresSafeArea())
    }
}
