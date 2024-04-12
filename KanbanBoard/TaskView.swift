//
//  ContentView.swift
//  KanbanBoard
//
//  Created by Jovane Samuels on 2/29/24.
//


import SwiftUI

struct TaskView: View {
    @Environment(\.colorScheme) var colorScheme

    let markdownParser = MarkdownParser(markdown: markdown)
    var body: some View {
        VStack {
            HStack{
                Text("Cyber Gym")
                    .font(.title)
                    .bold()
                Image(systemName: "chevron.down")
                    .bold()
            }

            .padding(.top,4)
            Divider()
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(markdownParser.statuses) { status in
                        Column(title: status.name, tasks: status.tasks)
                            .padding()
                                        }
                }
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(colorScheme == .dark ? Color(hex: "#2D4356") : Color.white)
        
    }
}

struct Column: View {
    @Environment(\.colorScheme) var colorScheme
    var title: String
    var tasks: [Task]
    
    private var titleColor: Color {
        switch title.lowercased() {
        case "backlog":
            return Color(hex: "#A12568")
        case "review":
            return Color(hex: "#D21312")
        case "doing":
            return Color(hex: "#4C3575")
        case "completed":
            return Color(hex: "#1E5128")
        default:
            return colorScheme == .dark ? .white : .black // Default color if none of the cases match
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                //Spacer()
                Text(title)
                    .font(.system(.title, design: .default))
                    .bold()
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    
                Spacer()
            }
            .padding()
            .background(titleColor)
            
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(tasks) { task in
                    TaskCard(taskName: task.description, subtasks: task.subtasks.map { $0.description })
                        .padding()
                }
            }

            Spacer()

        }
        .background(colorScheme == .dark ? Color(hex: "#2D4356") : Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .shadow(color: colorScheme == .dark ? Color(hex: "#A76F6F") : Color.primary, radius: 4)
        .frame(width: 300)
    }
}

struct TaskCard: View {
    @Environment(\.colorScheme) var colorScheme

    var taskName: String
    var subtasks: [String] = []
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                CheckboxView(label:taskName)
                    .font(.system(.title3, design: .default))
                    .bold()
                    .foregroundColor(colorScheme == .dark ? .white : .black)

                Spacer()
                if !subtasks.isEmpty {
                    
                    Button(){
                        //do stuff
                    }label: {
                        Image(systemName: "ellipsis")
                    }
                    .buttonStyle(.plain)

                }
            }
            .padding()
            
            if !subtasks.isEmpty   {
                       Divider()
                       ForEach(subtasks, id: \.self) { subtask in
                           HStack {
                               Image(systemName: "circle")
                               Text(subtask)
                                   
                           }
                           .padding()
                           .bold()
                           
                       }
                   }
        }
        .background(colorScheme == .dark ? Color(hex: "#435B66") : Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .shadow(color: colorScheme == .dark ? Color(hex: "A76F6F") : Color.primary, radius: 3)
    }
}

struct CheckboxView: View {
    @State private var isChecked: Bool = false
    var label: String
    
    var body: some View {
        HStack {
            // Checkbox Button
            Button(action: {
                // Toggle the checked state
                self.isChecked.toggle()
            }) {
                // Conditionally display a checkmark if isChecked is true
                Image(systemName: isChecked ? "checkmark.square.fill" : "square")
                    .foregroundColor(isChecked ? .blue : .gray)
            }
            .buttonStyle(PlainButtonStyle())
            Text(label)
                .bold()
        }
        
    }
}


extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

#Preview {
    TaskView()
}
