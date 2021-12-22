//
//  LinksListView.swift
//  Shortys
//
//  Created by Egor on 22.12.2021.
//

import SwiftUI

struct Link {
    var id: String
    var link: String
}

struct LinksListView: View {
    
    @State var links: [Link] = []
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack {
                
                ForEach(links, id: \.id) { value in
                    Text(value.link)
                }
                
            }
        }
    }
}

struct LinksListView_Previews: PreviewProvider {
    static var previews: some View {
        LinksListView()
    }
}
