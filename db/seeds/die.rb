# frozen_string_literal: true

Die.destroy_all

Die.create!(
  name: :boost,
  sides: [
    *Array.new(2, SideType.find_by_results),
    SideType.find_by_results(success: 1),
    SideType.find_by_results(success: 1, advantage: 1),
    SideType.find_by_results(advantage: 2),
    SideType.find_by_results(advantage: 1)
  ]
)
Die.create!(
  name: :setback,
  sides: [
    *Array.new(2, SideType.find_by_results),
    *Array.new(2, SideType.find_by_results(failure: 1)),
    *Array.new(2, SideType.find_by_results(threat: 1))
  ]
)
Die.create!(
  name: :ability,
  sides: [
    SideType.find_by_results,
    *Array.new(2, SideType.find_by_results(success: 1)),
    SideType.find_by_results(success: 2),
    *Array.new(2, SideType.find_by_results(advantage: 1)),
    SideType.find_by_results(advantage: 2),
    SideType.find_by_results(success: 1, advantage: 1)
  ]
)
Die.create!(
  name: :difficulty,
  sides: [
    SideType.find_by_results,
    SideType.find_by_results(failure: 1),
    SideType.find_by_results(failure: 2),
    *Array.new(3, SideType.find_by_results(threat: 1)),
    SideType.find_by_results(threat: 2),
    SideType.find_by_results(failure: 1, threat: 1)
  ]
)
Die.create!(
  name: :proficiency,
  sides: [
    SideType.find_by_results,
    *Array.new(2, SideType.find_by_results(success: 1)),
    *Array.new(2, SideType.find_by_results(success: 2)),
    SideType.find_by_results(advantage: 1),
    *Array.new(3, SideType.find_by_results(success: 1, advantage: 1)),
    *Array.new(2, SideType.find_by_results(advantage: 2)),
    SideType.find_by_results(triumph: 1)
  ]
)
Die.create!(
  name: :challenge,
  sides: [
    SideType.find_by_results,
    *Array.new(2, SideType.find_by_results(failure: 1)),
    *Array.new(2, SideType.find_by_results(failure: 2)),
    *Array.new(2, SideType.find_by_results(threat: 1)),
    *Array.new(2, SideType.find_by_results(failure: 1, threat: 1)),
    *Array.new(2, SideType.find_by_results(threat: 2)),
    SideType.find_by_results(despair: 1)
  ]
)
Die.create!(
  name: :fate,
  sides: [
    *Array.new(6, SideType.find_by_results(dark: 1)),
    SideType.find_by_results(dark: 2),
    *Array.new(2, SideType.find_by_results(light: 1)),
    *Array.new(3, SideType.find_by_results(light: 2))
  ]
)
