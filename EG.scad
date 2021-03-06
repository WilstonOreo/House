include <HausCommon.scad>;

use <Stairs.scad>;

module house_door_slot(width = 1.3, height = 2.2, thickness = OUTER_WALL_THICKNESS) {
    translate([0,-thickness*0.5,0]) cube([width, thickness * 2, height]);
}

module house_door(angle = 0, width = 1.10, height = 2.10, frame_width = 0.12, thickness = OUTER_WALL_THICKNESS) {
    strength = 0.068;
    f = frame_width - 0.02;
    // Door frame
    part("HOUSEDOOR_FRAME") translate([0,strength*1.5 + thickness * 0.2,0.0]) difference() {
        cube([width + f*2, frame_width*2, height + f]);
        translate([f,-thickness*0.5,0]) cube([width, thickness * 2, height]);
    }

    // Door leaf
    translate([0,strength,0.0]) translate([f,thickness * 0.2,0.0]) rotate([0,0,angle]) {
    part("HOUSEDOOR_LEAF") {
        cube([width, strength, height ]);
        cube([width, 0.11, 0.12]);
        // Door handle
    }

    part("HOUSEDOOR_HANDLE") {
    handle_length = 0.07;
        translate([width - 0.18, handle_length + strength, 0.3]) {
            cylinder(r = 0.02, h = 1.5, $fn = 24);

            translate([0,0,0.3]) {
                rotate([90,0,0]) cylinder(r = 0.015, h = handle_length, $fn = 24);
                translate([0,0,0.9]) rotate([90,0,0]) cylinder(r = 0.015, h = handle_length, $fn = 24);
            }
        }

        // Door lock
        translate([width - 0.09, 0.083, 1.0])
            rotate([90,0,0]) cylinder(r = 0.04, h = 0.02, $fn = 24);
        }

        translate([width - 0.1, -0.015, 1.0]) rotate([0,0,270]) door_handle();
    }
}

FUNNEL_WIDTH = 0.6;

module funnel_slot(width = FUNNEL_WIDTH, thickness = OUTER_WALL_THICKNESS * 2) {
    cube([width, thickness, width], center = true);
}

module funnel_frame() {
    
    part("FUNNEL") {
    border_width = 0.03;

    difference() {
        funnel_slot(thickness = OUTER_WALL_THICKNESS + border_width);
        funnel_slot(width = FUNNEL_WIDTH - border_width);
    }

    blind_width = 0.03;

    for (i = [0:(FUNNEL_WIDTH - border_width*2)  / blind_width]) {
        translate([0,FUNNEL_WIDTH*0.3,i * (blind_width + 0.002) - FUNNEL_WIDTH/2 + border_width*0.3]) rotate([34,0,0]) cube([FUNNEL_WIDTH,0.01,blind_width], center = true);
    }
    }
}

module outer_wall_lamp() {

    part("OUTER_WALL_LAMP") {
        difference() {
            linear_extrude(height = 0.1, scale = 0.2) 
                circle(d = 0.25, $fn = 32);
            translate([0.00, 0.0,-0.01]) linear_extrude(height = 0.11, scale = 0.0) 
                circle(d = 0.24, $fn = 32);
        }

        cylinder(d = 0.02, h = 0.2, $fn = 24);

        translate([0,0.0,0.19]) rotate([-90,0,0.0]) {
            cylinder(d = 0.02, h = 0.2, $fn = 24);
            translate([0,0.05,0.19]) cylinder(d = 0.18, h = 0.02, $fn = 32);
        }

        translate([0,0.0,-0.12]) rotate([135,0,0]) rotate([0,90,0])
            rotate_extrude(angle=45, convexity=10, $fn = 64)
                translate([0.28, 0.0])
                    circle(d = 0.02, $fn = 16);
    }

    part("OUTER_WALL_LIGHTBULB") sphere(r = 0.03, $fn = 32);
}

module first_floor() {
    
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

difference() {
    
outer_walls([
    // Südseite
    [ "S", 10.49, 0.0, 0.0, [for (i = [0:2]) windows[i]]],
    // Nordseite
    [ "N", 10.49, 0, 8.615, [for (i = [3:6]) windows[i]]],
    // Westseite
    [ "W", 8.61, 0, 0 ],
    // Ostseite
    [ "E", 8.61, 0, 10.49, [for (i = [7:8]) windows[i]]]
]);

rotate([0,0,90])
translate([0.8, -OUTER_WALL_THICKNESS, FLOOR_HEIGHT]) house_door_slot();

translate([0,0,1.60]) {
    translate([0.9,8.43,0]) funnel_slot();
    translate([OUTER_WALL_THICKNESS*0.5,7.7,0]) rotate([0,0,90]) funnel_slot();
}

}

translate([0,0,1.60]) {
    translate([0.9,8.43,0]) funnel_frame();
    translate([OUTER_WALL_THICKNESS*0.5,7.7,0]) rotate([0,0,90]) funnel_frame();
}


rotate([0,0,90])
translate([0.8, -OUTER_WALL_THICKNESS *1.3, FLOOR_HEIGHT]) house_door();

// Lampe Haustür
translate([-0.21, OUTER_WALL_THICKNESS *1.2, 2.3])rotate([0,0,-90]) 
    outer_wall_lamp();

// Lampe Terrasse
translate([10.70, 8.0, 2.3])rotate([0,0,90]) 
    outer_wall_lamp();

    // Innenwände
    doors = [
    // Width, Shift, Thickness, Height, Angle 
        [ 0.885, 1.8, 0.0 ], // Arbeitszimmer
        [ 0.885, 2.0, 0.0 ], // HWR
        [ 0.76, 3.5, 0.0 ], // Gäste-WC
        [ 0.63, 1.2, 0.0 ], // Vorratskammer
    ];

    inner_walls([ 
        // Alignment, Thickness, Width, Shift X, Shift Y, List of doors
        ["S", 3.765 + 0.175 * 2, 2.135, 2.76, [doors[0]]],
        ["W", 2.64, 5.07 + 0.175, 3.135],
        ["W", 2.64, 5.07 + 0.175, 3.135 + 1.095 + 0.115],
    ], thickness = THIN_INNER_WALL_THICKNESS);

    inner_walls([ 
        ["N", 2.135 + 0.175 + 3.765 + 0.175, 0.0, 5.07 + THICK_INNER_WALL_THICKNESS, [doors[1], doors[2]] ],
        ["W", 2.64, 5.07 + 0.175, 3.135 + 1.095 + 0.115*2 + 1.615, [doors[3]] ],
        ["W", 2.76, 0.0, 2.135],
        ["W", 2.76, 0.0, 2.135 + 3.765 + 0.175],    
    ], thickness = THICK_INNER_WALL_THICKNESS);

    chimney(0.0, WALL_HEIGHT);
    
    translate([OUTER_WALL_THICKNESS,2.53,FLOOR_HEIGHT])
        stairs();



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


}

first_floor();