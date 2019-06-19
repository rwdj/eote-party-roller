# frozen_string_literal: true

SideType.destroy_all

SideType.create!

SideType.create!(success: 1)
SideType.create!(success: 2)
SideType.create!(success: 1, advantage: 1)
SideType.create!(advantage: 1)
SideType.create!(advantage: 2)
SideType.create!(triumph: 1)

SideType.create!(failure: 1)
SideType.create!(failure: 2)
SideType.create!(failure: 1, threat: 1)
SideType.create!(threat: 1)
SideType.create!(threat: 2)
SideType.create!(despair: 1)

SideType.create!(dark: 1)
SideType.create!(dark: 2)
SideType.create!(light: 1)
SideType.create!(light: 2)
