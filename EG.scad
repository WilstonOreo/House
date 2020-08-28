include <HausCommon.scad>;


windows = [
    // Width, Height, Shift, BRH, Blind
    [ 1.13, 1.42, 0.86, DEFAULT_BRH, 0.0], // Flur
    [ 1.51, 1.42, 4.115, DEFAULT_BRH, 0.0], // Arbeitszimmer
    [ 1.01, 1.42, 4.115 + 1.51 + 2.74, DEFAULT_BRH, 0.3], // Wohnzimmer
    [ 1.13, 0.635, 1.49, 1.63 ], // HWR
    [ 0.76, 0.635, 1.49 + 1.13 + 1.24, 1.63 ], // Gäste-WC
    [ 1.13, 0.635, 1.49 + 1.13 + 1.24 + 0.76 + 0.615, 1.63 ], // Vorratskammer
    [ 1.13, 0.50, 1.49 + 1.13 + 1.24 + 0.76 + 0.615 + 0.885 + 1.615, 0.95 ], // Küche Festverglasung
    [ 1.51, 1.42, 1.11, DEFAULT_BRH, 0.0 ], // Wohnzimmer
    [ 3.01, 2.26, 1.11 + 1.51 + 1.865, 0.065, 0, 2] // Terrassentür
];

outer_walls([
    // Südseite
    [ "", 10.49, 0.0, 0.0, [for (i = [0:2]) windows[i]]],
    // Nordseite
    [ "v", 10.49, 0, 8.615, [for (i = [3:6]) windows[i]]],
    // Westseite
    [ "h", 8.61, 0, 0 ],
    // Ostseite
    [ "h", 8.61, 0, 10.125, [for (i = [7:8]) windows[i]]]
]);


/*

// Außenwände und Fenster

// Westseite
group() horizontal() {
    outer_wall(8.61, 0, 0) {
        door(0.76, 1.0);
    }
}

}*/


// Innenwände
group() {
    doors = [
        // Width, Shift, Thickness, Height, Angle 
        [ 0.885, 1.8, THIN_INNER_WALL_THICKNESS, DEFAULT_DOOR_HEIGHT, 0.0 ], // Arbeitszimmer
        [ 0.885, 2.0, THICK_INNER_WALL_THICKNESS, DEFAULT_DOOR_HEIGHT, 0.0 ], // HWR
        [ 0.76, 3.5, THICK_INNER_WALL_THICKNESS, DEFAULT_DOOR_HEIGHT, 0.0 ], // Gäste-WC
        [ 0.63, 1.2, THICK_INNER_WALL_THICKNESS, DEFAULT_DOOR_HEIGHT, 0.0 ], // Vorratskammer
    ];

    inner_walls([ 
        // Alignment, Thickness, Width, Shift X, Shift Y, List of doors
        ["", THIN_INNER_WALL_THICKNESS, 3.765 + 0.175 * 2, 2.135, 2.76, [doors[0]]],
        ["v", THICK_INNER_WALL_THICKNESS, 2.135 + 0.175 + 3.765 + 0.175, 0.0, 5.07 + THICK_INNER_WALL_THICKNESS, [doors[1], doors[2]] ],
        ["h", THIN_INNER_WALL_THICKNESS, 2.64, 5.07 + 0.175, 3.135],
        ["h", THIN_INNER_WALL_THICKNESS, 2.64, 5.07 + 0.175, 3.135 + 1.095 + 0.115],
        ["h", THICK_INNER_WALL_THICKNESS, 2.64, 5.07 + 0.175, 3.135 + 1.095 + 0.115*2 + 1.615, [doors[3]] ],
        ["h", THICK_INNER_WALL_THICKNESS, 2.76, 0.0, 2.135],
        ["h", THICK_INNER_WALL_THICKNESS, 2.76, 0.0, 2.135 + 3.765 + 0.175],
    ]);
}


rooms([ 
    // Flur
    [ "PARQUETRY", [ [ 2.135, 2.76 + 0.115, 0, 0 ], [ 2.135 + 0.175 + 0.175 + 3.765, 2.19, 0, 2.76 + 0.115 ] ] ],
    // HWR
    [ "TILES", [[3.135, 2.64, 0, 2.76 + 0.115 + 2.19 + 0.175 ]]],
    // Gäste WC
    [ "TILES", [[1.095, 2.64, 3.135 + 0.115, 2.76 + 0.115 + 2.19 + 0.175]]],
    // Vorratskammer
    [ "TILES", [[1.615, 2.64, 3.135 + 0.115 + 0.115 + 1.095, 2.76 + 0.115 + 2.19 + 0.175]]],
    // Küche
    [ "KITCHEN_TILES", [[3.51, 2.64 + 0.175, 3.135 + 0.115 + 0.115 + 1.095 + 1.615 + 0.175, 2.76 + 0.115 + 2.19]]],
    // Wohnzimmer
    [ "PARQUETRY", [[3.51, 5.07, 3.135 + 0.115 + 0.115 + 1.095 + 1.615 + 0.175, 0.0]]],
    // Arbeitszimmer
    [ "PARQUETRY", [[3.765, 2.76, 2.135 + 0.175, 0.0]]]
 ]);

