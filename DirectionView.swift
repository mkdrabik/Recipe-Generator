//
//  DirectionView.swift
//  Foody
//
//  Created by Mason Drabik on 4/22/24.
//

import SwiftUI

struct DirectionView: View {
    @State var d: String
    @State var completed = false
    @State var c = Color.red
    var body: some View {
        HStack {
            Text(d)
                .font(.callout)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
                .foregroundColor(Color.black)
            Spacer()
            Button{
                completed.toggle()
                if completed{
                    c = Color.green
                } else {
                    c = Color.red
                }
            } label:{
                Image(systemName: c == Color.green ? "checkmark.circle.fill" : "checkmark.circle")
                    .resizable()
                    .foregroundColor(c)
                    .frame(width: 25, height: 25)
            }
            .padding()
        }
        //.background(c)
//        .background(
//            RoundedRectangle(cornerRadius: 10)
//                .fill(c)
//                //.padding(.horizontal, 10)
//        )

    }
}

#Preview {
    DirectionView(d: "2. Add garlic and cook until fragrant")
}
