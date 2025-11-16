.const SCREEN_ROW_24 = $07c0 // Address in VRAM of the start of the last screen row

// Zero page
.const TOWER_BASE_PTR = $10 // Pointer for the base VRAM address of a tower
.const BLOCK_PTR = $12 // Pointer on a tower face (a char)
.const LOCATION_PTR = $14 // Pointer on a memory location (of a tower) possibly hit by the plane
