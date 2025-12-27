//
//  Untitled.swift
//  電子書馬的法克
//
//  Created by user10 on 2024/11/5.
//
import SwiftUI

struct Detail1: View {
    let pokemons : [Pokemon]
    let type : type
    let columns = Array(repeating: GridItem(), count: 2)
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(pokemons) { pokemon in
                    NavigationLink{
                        Detail2(pokemon: pokemon, type: type)
                    }
                    label:{
                        pokemon.image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 140.0, height: 220.0)
                            .padding(10)
                            .background(Image(.背板).resizable().scaledToFill())
                            .frame(width: 150.0, height: 230.0)
                            .padding()
                    }
                }
            }
        }
        .toolbar(content: {
            ToolbarItem(placement: .principal) {
                Text("圖鑑")
                    .font(.custom("HanyiSentyCrayon", size: 20))
                    .foregroundStyle(.white)
            }
        })
        .background(Image(type.pic3).resizable().scaledToFill()
            .ignoresSafeArea())
    }
}
