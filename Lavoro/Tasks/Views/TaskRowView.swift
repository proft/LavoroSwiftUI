import SwiftUI

struct TaskRowView: View {
    let task: TaskViewModel
    
    var body: some View {
        HStack {
            Circle()
                .fill(styleForPriority(task.priority))
                .frame(width: 16, height: 16)
            Text(task.name)
            Spacer()
            Image(systemName: task.isCompleted ?  "checkmark.square" : "square")
        }
    }
    
    func styleForPriority(_ value: String) -> Color {
        let priority = Priority(rawValue: value)
        switch priority {
        case .low:
            return .green
        case .medium:
            return .orange
        case .high:
            return .red
        case .none:
            return .black
        }
    }
}
