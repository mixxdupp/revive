import WidgetKit
import SwiftUI

struct EmergencySirenProvider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        let entry = SimpleEntry(date: Date())
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct EmergencySirenWidgetEntryView : View {
    var entry: EmergencySirenProvider.Entry

    var body: some View {
        ZStack {
            Color(red: 0.85, green: 0.1, blue: 0.1) // Emergency Red
            
            VStack(spacing: 8) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundStyle(.white)
                
                Text("SOS SIREN")
                    .font(.system(size: 14, weight: .black))
                    .foregroundStyle(.white)
            }
        }
        .widgetURL(URL(string: "revive://siren")) // Deep Link
    }
}

struct EmergencySirenWidget: Widget {
    let kind: String = "EmergencySirenWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: EmergencySirenProvider()) { entry in
            EmergencySirenWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Emergency Siren")
        .description("Instant access to the loud emergency alarm.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct EmergencySirenWidget_Previews: PreviewProvider {
    static var previews: some View {
        EmergencySirenWidgetEntryView(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
