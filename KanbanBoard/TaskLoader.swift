import Foundation

struct Status: Identifiable {
    let id = UUID()
    var name: String
    var tasks: [Task]
}

struct Task: Identifiable {
    let id = UUID()
    var description: String
    var subtasks: [Subtask]
}

struct Subtask: Identifiable {
    let id = UUID()
    var description: String
}


class MarkdownParser {
    var statuses: [Status] = []

    init(markdown: String) {
        self.statuses = self.parseMarkdown(markdown)
    }

    private func parseMarkdown(_ markdown: String) -> [Status] {
        var statuses: [Status] = []
        var currentStatus: Status?
        var currentTask: Task?

        let statusPattern = "^##\\s+(.*)"
        let taskPattern = "^-\\s+\\[\\s*\\]\\s+(.*)"
        let subtaskPattern = "^\\s+-\\s+\\[\\s*\\]\\s+(.*)"

        markdown.enumerateLines { line, _ in
            if let statusMatch = line.matchingStrings(regex: statusPattern).first {
                if let currentStatus = currentStatus {
                    statuses.append(currentStatus)
                }
                currentStatus = Status(name: statusMatch[1], tasks: [])
                currentTask = nil
            } else if let taskMatch = line.matchingStrings(regex: taskPattern).first {
                let task = Task(description: taskMatch[1], subtasks: [])
                currentStatus?.tasks.append(task)
                currentTask = task
            } else if let subtaskMatch = line.matchingStrings(regex: subtaskPattern).first, let currentTask = currentTask {
                let subtask = Subtask(description: subtaskMatch[1])
                var tasks = currentStatus?.tasks.dropLast() ?? []
                var updatedTask = currentTask
                updatedTask.subtasks.append(subtask)
                tasks.append(updatedTask)
                currentStatus?.tasks = Array(tasks)
            }
        }

        if let currentStatus = currentStatus {
            statuses.append(currentStatus)
        }

        return statuses
    }
}


extension String {
    func matchingStrings(regex: String) -> [[String]] {
        do {
            let regex = try NSRegularExpression(pattern: regex, options: [])
            let nsString = self as NSString
            let results = regex.matches(in: self, range: NSRange(self.startIndex..., in: self))
            return results.map { result in
                (0..<result.numberOfRanges).map {
                    result.range(at: $0).location != NSNotFound ? nsString.substring(with: result.range(at: $0)) : ""
                }
            }
        } catch let error {
            print("Invalid regex: \(error.localizedDescription)")
            return []
        }
    }
}

let markdown = """
## Doing

- [ ] Pushups
  - [ ] Get more data
  - [ ] Improve training inference
- [ ] Squats
  - [ ] Get more data due: 02/

## Completed
- [ ] Test
- [ ] New
## Review

- [ ] Pull Ups
  - [ ] Get more data
- [ ] Test

## Backlog

- [ ] Training Inference Improvements
  - [ ] For pull ups due: 03/04
  - [ ] For sit ups
- [ ] Data Gathering
  - [ ] For sit ups
- [ ] Exercise Tracking
  - [ ] Walking
  - [ ] Running
  - [ ] Push Up
  - [ ] Sit up
  - [ ] Pull Up
  - [ ] Squats
- [ ] User Experience Enhancements
  - [ ] Show user updates in realtime
  - [ ] Sync leaderboard with other users
  - [ ] Add online pvp
  - [ ] Add calorie tracking and rewards for calories burned
  - [ ] Make it more contrasty in the dark mode
  - [ ] Add idle animations in the homescreen
- [ ] App Development Features
  - [ ] Add apple watch support, especially for tracking running and walking
  - [ ] Set up user login page so it starts whenever user is starting for the first time
  - [ ] Add Settings page
  - [ ] Enhance the animations and actions performed when an action is detected
  - [ ] Add functionality to the buttons in the hamburger menu
  - [ ] Create app icon
  - [ ] Allow user to select profile photo
  - [ ] Add themes
  - [ ] Extract my stylings into reusable code
  - [ ] Add a 3D animation to the onboarding screen
"""





