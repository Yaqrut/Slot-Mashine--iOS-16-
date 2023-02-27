//
//  InfoView.swift
//  Slot Mashine
//
//  Created by YAQRUT on 2023-02-23.
//

import SwiftUI

struct InfoView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            LogoView()
            
            Spacer()
            
            Form {
                Section(header: Text("About the application")) {
                    FormRowView(firstItem: "Application", secondItem: "SlotMashine")
                    FormRowView(firstItem: "Platforms", secondItem: "iPhone, iPad, Mac")
                    FormRowView(firstItem: "Developer", secondItem: "YAQRUT")
                    FormRowView(firstItem: "Music", secondItem: "Hans Zimer")
                    FormRowView(firstItem: "Designer", secondItem: "Alexandra Gumbert")
                    FormRowView(firstItem: "Website", secondItem: "yaqrut.com")
                    FormRowView(firstItem: "Gopiright", secondItem: "@ 2023 All right Reserved")
                    FormRowView(firstItem: "The best FC", secondItem: "Manchester United")
                    FormRowView(firstItem: "Version", secondItem: "1.0.0")
                }
            }
                .font(.system(.body, design: .rounded))
        }
        .padding(.top, 40)
        .overlay(
            Button(action: {
                audioPlayer?.stop()
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark.circle")
                    .font(.title)
            }
                .padding(.top, 30)
                .padding(.trailing, 20)
                .accentColor(Color.secondary)
                ,alignment: .topTrailing
        )
        .onAppear(perform: {
            playSound(sound: "background-music", type: "mp3")
        })
    }
}

struct FormRowView: View {
    var firstItem: String
    var secondItem: String
    
    
    var body: some View {
        HStack {
            Text(firstItem).foregroundColor(Color.gray)
            Spacer()
            Text(secondItem)
        }
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}

