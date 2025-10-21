//
//  ContentView.swift
//  mai
//
//  Created by 오승준 on 10/12/25.
//

import SwiftUI

struct ContentView: View {
    @State private var currentMonth: Date = Date()
    @State private var selectedDate: Date = Calendar.current.startOfDay(for: Date())

    private let medications: [MedicationEvent] = MedicationEvent.sampleData

    private var monthFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }

    private var calendar: Calendar {
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "ko_KR")
        return calendar
    }

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [Color("CalendarBackground").opacity(0.4), .white], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()

                VStack(spacing: 24) {
                    header
                    dayOfWeekLabels
                    calendarGrid
                    medicationList
                }
                .padding(20)
            }
            .navigationTitle("복약 알리미")
        }
        .onChange(of: currentMonth) { _, newValue in
            guard !calendar.isDate(selectedDate, equalTo: newValue, toGranularity: .month) else { return }
            selectedDate = calendar.date(from: calendar.dateComponents([.year, .month], from: newValue)) ?? newValue
        }
    }

    private var header: some View {
        HStack(spacing: 16) {
            Button {
                withAnimation(.easeInOut) {
                    currentMonth = calendar.date(byAdding: .month, value: -1, to: currentMonth) ?? currentMonth
                }
            } label: {
                Image(systemName: "chevron.left")
                    .font(.title3.weight(.semibold))
                    .padding(8)
                    .background(.ultraThinMaterial, in: Circle())
            }

            Spacer()

            Text(monthFormatter.string(from: currentMonth))
                .font(.title2.weight(.bold))
                .accessibilityIdentifier("currentMonthLabel")

            Spacer()

            Button {
                withAnimation(.easeInOut) {
                    currentMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth) ?? currentMonth
                }
            } label: {
                Image(systemName: "chevron.right")
                    .font(.title3.weight(.semibold))
                    .padding(8)
                    .background(.ultraThinMaterial, in: Circle())
            }
        }
    }

    private var dayOfWeekLabels: some View {
        let symbols = calendar.shortWeekdaySymbols
        return HStack(spacing: 0) {
            ForEach(symbols, id: \.self) { symbol in
                Text(symbol)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, 4)
    }

    private var calendarGrid: some View {
        let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 7)

        return LazyVGrid(columns: columns, spacing: 12) {
            ForEach(extractDates()) { value in
                VStack(spacing: 6) {
                    Text(value.day == 0 ? "" : "\(value.day)")
                        .font(.body.weight(.semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 4)
                        .overlay(alignment: .topTrailing) {
                            if isToday(value.date) {
                                Circle()
                                    .fill(.blue)
                                    .frame(width: 6, height: 6)
                                    .offset(x: -6, y: 6)
                            }
                        }

                    if hasMedication(on: value.date) && value.day != 0 {
                        Capsule()
                            .fill(selectedDateMatches(value.date) ? Color.white.opacity(0.9) : Color.blue.opacity(0.2))
                            .frame(width: 36, height: 6)
                    } else {
                        Capsule()
                            .fill(Color.clear)
                            .frame(width: 36, height: 6)
                    }
                }
                .frame(minHeight: 52)
                .frame(maxWidth: .infinity)
                .padding(8)
                .background(
                    ZStack {
                        if value.day != 0 {
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .fill(selectedDateMatches(value.date) ? Color.blue : Color.clear)
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .strokeBorder(isToday(value.date) ? Color.blue.opacity(0.5) : .clear, lineWidth: 1)
                        }
                    }
                )
                .foregroundStyle(selectedDateMatches(value.date) ? .white : .primary)
                .opacity(value.day == 0 ? 0 : 1)
                .onTapGesture {
                    guard value.day != 0 else { return }
                    selectedDate = value.date
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel(accessibilityLabel(for: value))
            }
        }
    }

    private var medicationList: some View {
        let dailyMedications = medicationsForSelectedDate()

        return VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(selectedDate.formatted(date: .abbreviated, time: .omitted))
                    .font(.headline)
                Spacer()
                if !dailyMedications.isEmpty {
                    Text("총 \(dailyMedications.count)회 복약")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }

            if dailyMedications.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "checkmark.seal")
                        .font(.system(size: 36))
                        .foregroundStyle(.green)
                    Text("예정된 복약이 없습니다.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 24)
                .background(RoundedRectangle(cornerRadius: 18, style: .continuous).fill(.ultraThinMaterial))
            } else {
                VStack(spacing: 12) {
                    ForEach(dailyMedications) { medication in
                        HStack(spacing: 16) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(medication.name)
                                    .font(.headline)
                                Text(medication.dosage)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                if let note = medication.notes {
                                    Text(note)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            Spacer()
                            Text(medication.scheduledDate.formatted(date: .omitted, time: .shortened))
                                .font(.headline.weight(.semibold))
                                .foregroundStyle(.blue)
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 16, style: .continuous).fill(.ultraThinMaterial))
                    }
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(RoundedRectangle(cornerRadius: 28, style: .continuous).fill(Color.white.opacity(0.7)))
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(Color.black.opacity(0.04), lineWidth: 1)
        )
    }

    private func medicationsForSelectedDate() -> [MedicationEvent] {
        medications
            .filter { calendar.isDate($0.scheduledDate, inSameDayAs: selectedDate) }
            .sorted { $0.scheduledDate < $1.scheduledDate }
    }

    private func hasMedication(on date: Date) -> Bool {
        medications.contains { calendar.isDate($0.scheduledDate, inSameDayAs: date) }
    }

    private func isToday(_ date: Date) -> Bool {
        calendar.isDateInToday(date)
    }

    private func selectedDateMatches(_ date: Date) -> Bool {
        calendar.isDate(date, inSameDayAs: selectedDate)
    }

    private func extractDates() -> [DateValue] {
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentMonth)) ?? currentMonth
        let dayRange = calendar.range(of: .day, in: .month, for: startOfMonth) ?? Range(1...31)
        var days = dayRange.compactMap { day -> DateValue in
            let date = calendar.date(bySetting: .day, value: day, of: startOfMonth) ?? startOfMonth
            return DateValue(day: day, date: date)
        }

        if let firstDay = days.first?.date {
            let weekday = calendar.component(.weekday, from: firstDay)
            let offset = (weekday - calendar.firstWeekday + 7) % 7
            for _ in 0..<offset {
                days.insert(DateValue(day: 0, date: Date()), at: 0)
            }
        }

        return days
    }

    private func accessibilityLabel(for value: DateValue) -> String {
        guard value.day != 0 else { return "" }
        var label = "\(value.day)일"
        if isToday(value.date) {
            label += ", 오늘"
        }
        let dailyCount = medications.filter { calendar.isDate($0.scheduledDate, inSameDayAs: value.date) }.count
        if dailyCount > 0 {
            label += ", 복약 \(dailyCount)회"
        }
        if selectedDateMatches(value.date) {
            label += ", 선택됨"
        }
        return label
    }
}

private struct DateValue: Identifiable {
    let id = UUID()
    let day: Int
    let date: Date
}

#Preview {
    ContentView()
}
