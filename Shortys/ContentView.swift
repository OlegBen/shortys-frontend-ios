//
//  ContentView.swift
//  Shortys
//
//  Created by user on 22.12.2021.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                
                NavigationLink {
                    LinkShorterView()
                } label: {
                    Text("Создать сокращенную ссылку")
                        .foregroundColor(.white)
                        .fontWeight(.medium)
                }
                .frame(width: UIScreen.main.bounds.width - 32, height: 50)
                .background(Color.blue)
                .cornerRadius(12)
                
                NavigationLink {
                    LinksListView()
                } label: {
                    Text("Список активных ссылок")
                        .foregroundColor(.white)
                        .fontWeight(.medium)
                }
                .frame(width: UIScreen.main.bounds.width - 32, height: 50)
                .background(Color.blue)
                .cornerRadius(12)

                Spacer()
            }
            .navigationTitle("Меню")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
