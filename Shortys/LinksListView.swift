//
//  LinksListView.swift
//  Shortys
//
//  Created by Egor on 22.12.2021.
//

import SwiftUI

struct LinksListView: View {
    
    @State private var links: [ShorterLinkResponse] = []
    @State private var isLoading: Bool = false
    
    private var network = NetworkManager()
    
    var body: some View {
        if isLoading {
            Text("Загрузка...")
                .foregroundColor(.blue)
                .fontWeight(.medium)
        } else {
            ScrollView(.vertical, showsIndicators: true) {
                VStack {
                    
                    ForEach(links, id: \.id) { value in
                        Text(value.shortenedLink ?? "shortened link")
                    }
                    
                }
            }
            .onAppear {
                if links.isEmpty {
                    requestList()
                }
            }
        }
    }
    
    private func requestList() {
        isLoading = true
        network.getShorterLinks { response, error in
            guard error == nil else { return }
            
            guard let list = response?.results else {
                return
            }
            
            self.links = list
            self.isLoading = false
        }
    }
}

struct LinksListView_Previews: PreviewProvider {
    static var previews: some View {
        LinksListView()
    }
}
