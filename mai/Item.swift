//
//  MedicationEvent.swift
//  mai
//
//  Created by 오승준 on 10/12/25.
//

import Foundation

struct MedicationEvent: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let dosage: String
    let scheduledDate: Date
    let notes: String?

    init(name: String, dosage: String, scheduledDate: Date, notes: String? = nil) {
        self.name = name
        self.dosage = dosage
        self.scheduledDate = scheduledDate
        self.notes = notes
    }
}

extension MedicationEvent {
    static var sampleData: [MedicationEvent] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        func makeDate(dayOffset: Int, hour: Int, minute: Int = 0) -> Date {
            calendar.date(byAdding: DateComponents(day: dayOffset, hour: hour, minute: minute), to: today) ?? today
        }

        return [
            MedicationEvent(name: "아침 혈압약", dosage: "1정", scheduledDate: makeDate(dayOffset: 0, hour: 8), notes: "식후 30분 내 복용"),
            MedicationEvent(name: "혈당 조절제", dosage: "2정", scheduledDate: makeDate(dayOffset: 0, hour: 20), notes: "저녁 식사 후"),
            MedicationEvent(name: "비타민 D", dosage: "1캡슐", scheduledDate: makeDate(dayOffset: 2, hour: 9)),
            MedicationEvent(name: "갑상선 약", dosage: "1정", scheduledDate: makeDate(dayOffset: 3, hour: 7), notes: "공복에 물과 함께"),
            MedicationEvent(name: "항생제", dosage: "1정", scheduledDate: makeDate(dayOffset: 5, hour: 8), notes: "10일간 복용"),
            MedicationEvent(name: "항생제", dosage: "1정", scheduledDate: makeDate(dayOffset: 5, hour: 20)),
            MedicationEvent(name: "오메가-3", dosage: "2캡슐", scheduledDate: makeDate(dayOffset: 8, hour: 12)),
            MedicationEvent(name: "비타민 B", dosage: "1정", scheduledDate: makeDate(dayOffset: 10, hour: 8), notes: "물과 함께"),
            MedicationEvent(name: "수면제", dosage: "1정", scheduledDate: makeDate(dayOffset: 12, hour: 22), notes: "취침 직전"),
            MedicationEvent(name: "통증 완화제", dosage: "1정", scheduledDate: makeDate(dayOffset: 12, hour: 14)),
            MedicationEvent(name: "유산균", dosage: "1포", scheduledDate: makeDate(dayOffset: 14, hour: 7), notes: "공복 복용"),
            MedicationEvent(name: "철분제", dosage: "1정", scheduledDate: makeDate(dayOffset: 18, hour: 9), notes: "비타민 C와 함께"),
            MedicationEvent(name: "진통제", dosage: "1정", scheduledDate: makeDate(dayOffset: 20, hour: 13)),
            MedicationEvent(name: "관절 영양제", dosage: "2정", scheduledDate: makeDate(dayOffset: 21, hour: 8), notes: "아침 식사 후"),
            MedicationEvent(name: "혈압약", dosage: "1정", scheduledDate: makeDate(dayOffset: 25, hour: 8)),
            MedicationEvent(name: "혈압약", dosage: "1정", scheduledDate: makeDate(dayOffset: 26, hour: 8)),
            MedicationEvent(name: "혈압약", dosage: "1정", scheduledDate: makeDate(dayOffset: 27, hour: 8)),
            MedicationEvent(name: "혈압약", dosage: "1정", scheduledDate: makeDate(dayOffset: 28, hour: 8))
        ]
    }
}
