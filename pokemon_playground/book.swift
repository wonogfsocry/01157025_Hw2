//
//  book.swift
//  電子書馬的法克
//
//  Created by user10 on 2024/11/8.
//
import SwiftUI

struct BookView: View {
    var body: some View {
        List {
            ForEach(typelist){type in
                NavigationLink{
                    Detail1(pokemons : type.pokemons, type: type)
                }
                label:{
                    InfoRow(info: type.ele, pic1:type.pic1, pic2:type.pic2, pic3: type.pic3)
                }
            }
        }
    }
}

