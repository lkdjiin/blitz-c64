.const SCREEN_ROW_24 = $07c0 // Address in VRAM of the start of the last screen row
.const TOWN_LEFT_COLUMN = 10 // First column of the town
.const TOWN_WIDTH = 12 // Width of the town in characters

// Zero page
.const TOWER_BASE_PTR = $02 // Pointer for the base VRAM address of a tower
.const BLOCK_PTR = $04 // Pointer on a tower face (a char)
.const LOCATION_PTR = $22 // Pointer on a memory location (of a tower) possibly hit by the plane
