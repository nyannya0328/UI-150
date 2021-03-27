//
//  ContentView.swift
//  UI-149
//
//  Created by にゃんにゃん丸 on 2021/03/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
       Home()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Home : View {
    @State var offset : CGSize = .zero
    @State var showHome  = false
    var body: some View{
        
        ZStack{
            
            Color.red
                .overlay(
                
                    VStack(alignment: .leading, spacing: 15, content: {
                        
                        Text("JA")
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                        
                        Text("DEG")
                            .font(.caption)
                            .bold()
                        
                        
                    })
                    .foregroundColor(.white)
                    .padding(.horizontal,30)
                    .offset(y: -15)
                )
                .clipShape(liquidSwipe(offset: offset))
                .ignoresSafeArea()
               
                .overlay(
                
                Image(systemName: "chevron.left")
                    .font(.largeTitle)
                    .frame(width: 50, height: 50)
                    .contentShape(Rectangle())
                   
                    .gesture(DragGesture().onChanged({ (value) in
                        
                        withAnimation(.interactiveSpring(response: 0.7, dampingFraction: 0.6, blendDuration: 06)){
                            
                            offset = value.translation
                            
                        }
                        
                    }).onEnded({ (value) in
                        
                        let screen = UIScreen.main.bounds
                        
                        withAnimation(.spring()){
                            
                            
                            if -offset.width > screen.width / 2{
                                
                                offset.width = -screen.height
                                showHome.toggle()
                                
                            }
                            
                            else{
                                
                                offset = .zero
                            }
                        }
                        
                    }))
                    .offset(x:15,y: 55)
                    .opacity(offset == .zero ? 1 : 0)
                    
                    
                    ,alignment: .topTrailing
                    
              
                
                )
                .padding(.trailing)
            
            if showHome{
                
               AnalogClock()
                    .onTapGesture {
                        withAnimation(.spring()){
                            
                            offset = .zero
                            showHome.toggle()
                        }
                    }
            }
            
            
            
        }
       
    }
}

struct liquidSwipe : Shape {
    var offset : CGSize
    var animatableData: CGSize.AnimatableData{
        
        get{return offset.animatableData}
        set{offset.animatableData = newValue}
    }
    func path(in rect: CGRect) -> Path {
        return Path {path in
            
            let with = rect.width + (-offset.width > 0 ? offset.width : 0)
            
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            
            let from = 80 + (offset.width)
            
            path.move(to: CGPoint(x: rect.width, y: from > 80 ? 80 : from))
            
            var to = 180 + (offset.height) + (-offset.width)
            to = to < 180 ? 180 : to
            
            let mid : CGFloat = 80 + ((to - 80) / 2)
            
            

        
            path.addCurve(to: CGPoint(x: rect.width, y: to), control1: CGPoint(x: with - 50, y: mid), control2: CGPoint(x: with - 50, y: mid))
        
            
        }
    }
}


