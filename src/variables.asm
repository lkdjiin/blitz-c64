block_counter: .byte 0 // (towers are made of blocks) Number of tower's block on the screen
bomb_on: .byte 0 // 1 if a bomb is currently visible, else 0
bomb_collision: .byte 0 // 1 bomb hit a tower, else 0

game_lost: .byte 0 // 1 if plane fall, else 0
game_won: .byte 0 // 1 if win, else 0

plane_collision: .byte 0 // 1 plane hit a tower, else 0

tower_face: .byte 91, 92, 93, 94 // Possible chars to display a tower
tower_height: .byte 0 // Height of a tower in characters

town_left_column: .byte 8 // First column of the town
town_width: .byte 16 // Width of the town in characters
