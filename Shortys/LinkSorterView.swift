//
//  LinkSorterView.swift
//  Shortys
//
//  Created by Egor on 22.12.2021.
//

import SwiftUI

struct LinkShorterView: View {
    
    @State private var link: String = ""
    @State private var shortLink: String = ""
    @State private var ending: String = ""
    
    @State private var isLoading: Bool = false
    
    private var network = NetworkManager()
    
    var body: some View {
        VStack {
            
            TextField("Введите ссылку", text: $link, prompt: Text("Введите ссылку"))
                .font(.system(size: 20, weight: .medium))
                .padding()
            
            Text("Выберите окончание сокращенной ссылки")
            Picker("Выбрать окончание", selection: $ending) {
                Text(".com")
                Text(".su")
                Text(".ru")
            }
            .frame(width: UIScreen.main.bounds.width, height: 50)
            
            Button {
                shortTheLink()
            } label: {
                Text("Сократить!")
                    .foregroundColor(.white)
                    .fontWeight(.medium)
            }
            .frame(width: UIScreen.main.bounds.width - 32, height: 50)
            .background(Color.blue)
            .cornerRadius(12)
            
            if isLoading {
                Text("Загрузка...")
                    .foregroundColor(.blue)
                    .fontWeight(.medium)
            }

                
            if !shortLink.isEmpty {
                TextField("Введите ссылку", text: $shortLink, prompt: Text("Введите ссылку"))
                    .font(.system(size: 20, weight: .medium))
                    .padding()
            }
            
            
            Spacer()
            
        }
    }
    
    private func shortTheLink() {
        shortLink = ""
        isLoading = true
        network.create(link: self.link, linkEnd: self.ending) { response, error in
            self.isLoading = false
            guard error == nil else { return }
            
            guard let link = response?.shortenedLink else {
                return
            }

            self.shortLink = link
            
        }
    }
}

struct LinkSorterView_Previews: PreviewProvider {
    static var previews: some View {
        LinkShorterView()
    }
}
