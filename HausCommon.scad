
OUTER_WALL_THICKNESS = 0.365;
WALL_HEIGHT = 2.95;
THIN_INNER_WALL_THICKNESS = 0.115;
THICK_INNER_WALL_THICKNESS = 0.175;
DEFAULT_DOOR_HEIGHT = 2.01;
DEFAULT_DOOR_WIDTH = 0.885;

DEFAULT_BRH = 0.84;
FLOOR_HEIGHT = 0.19;

EDGING_WIDTH = 0.1;
EDGING_SUNK = 0.03;

WINDOWFRAME_WIDTH = 0.06;
WINDOWFRAME_OFFSET = 0.05;

DOOR_FRAME_WIDTH = 0.08;

BLIND_WIDTH = 0.03;

BATHROOM_WIDTH = 2.50;

PARTS = [
    [ "INNER_WALL", "White" ],
    [ "OUTER_WALL", "Gray" ],
    [ "OUTER_WALL_LAMP", [0.15,0.15,0.15] ],
    [ "OUTER_WALL_LIGHTBULB", [1.0,1.0,0.6] ],
    [ "PARQUETRY", "SaddleBrown" ],
    [ "TILES", "White" ],
    [ "KITCHEN_TILES", "Orange" ],
    [ "DOOR_LEAF", "White" ], 
    [ "DOOR_FRAME", "White" ],
    [ "DOOR_JOINT", "Gray" ],
    [ "DOOR_HANDLE", "Gray" ],
    [ "HOUSEDOOR_LEAF", "Sienna" ], 
    [ "HOUSEDOOR_FRAME", "White" ],
    [ "HOUSEDOOR_HANDLE", "Gray" ],
    [ "WINDOW_SILL", "DimGray" ],
    [ "WINDOW_EDGING", "White" ],
    [ "WINDOW_FRAME", "DimGray" ],
    [ "WINDOW_GLASS", [ 0.5, 0.5, 0.5, 0.3 ] ],
    [ "WINDOW_BLIND", "White" ],
    [ "ROOF_TOP", [0.15,0.15,0.15] ],
    [ "ROOF_BOTTOM", "White" ],
    [ "ROOF_SOLARPANEL", "Black" ],
    [ "ROOF_LADDER", "Black" ],
    [ "ROOF_DOWNPIPE", [0.15, 0.15, 0.15] ],
    [ "FUNNEL", "DimGray" ],
    [ "CHIMNEY", [0.15,0.15,0.15] ],
    [ "STAIRS_STEPS", "SaddleBrown" ],
    [ "STAIRS_BARS", "White" ],
    [ "STAIRS_FRONT", "White" ],
    [ "STAIRS_HANDRAIL", "SaddleBrown" ],
    [ "OUTDOOR_TERRACE", "Gray" ],
    [ "OUTDOOR_WALK", "Gray" ],
    [ "OUTDOOR_ENTRY_BOTTOM", "Gray" ],
    [ "OUTDOOR_ENTRY_MAT", "DimGray" ],
    [ "OUTDOOR_GARDEN", [0.0, 0.3, 0.0] ]
];


module slot(width, shift, height, z) {
    translate([shift, -OUTER_WALL_THICKNESS*0.05, z])
        cube([width, OUTER_WALL_THICKNESS * 1.1, height]);
}

module window(width, shift, height = 0.54, brh = DEFAULT_BRH) {
    slot(width, shift, height, FLOOR_HEIGHT + brh); 
}


module wall(width, thickness, shift_x = 0.0, shift_y = 0.0, height = WALL_HEIGHT) {
    translate([shift_x, shift_y, 0]) {
        difference() {
            cube([width, thickness, height]);
            children();
        }
    }
}

module outer_wall(width, height = WALL_HEIGHT, thickness = OUTER_WALL_THICKNESS) {
    part("INNER_WALL") difference() {
        translate([thickness - 0.05,thickness - 0.05,0]) cube([width - thickness * 2 + 0.1, 0.05, height]);
        children();
    }
    part("OUTER_WALL") difference() {
        cube([width, thickness - 0.05, height]);
        children();
    }
}

module inner_wall(width, height = WALL_HEIGHT, thickness = THICK_INNER_WALL_THICKNESS) {
    part("INNER_WALL") difference() {
        cube([width, thickness, height]);
        children();
    }
}

module align(alignment, shift_x, shift_y) {
    if (alignment == "S") {
       Mvert = [ [ 1  , 0  , 0  , shift_x   ],
                 [ 0  , 1  , 0  , shift_y   ],
                 [ 0  , 0  , 1  , 0   ],
            [          0  , 0  , 0  , 1   ] ] ;
          multmatrix(Mvert) children();
    }

    if (alignment == "W") {
        Mvert = [ [ 0  , 1  , 0  , shift_y   ],
                  [ 1  , 0  , 0  , shift_x   ],
                  [ 0  , 0  , 1  , 0   ],
                  [ 0  , 0  , 0  , 1   ] ] ;              
        multmatrix(Mvert) children();
    } 

    if (alignment == "E") {
        Mvert = [ [ 0  , -1  , 0  , shift_y   ],
                  [ 1  , 0  , 0  , shift_x   ],
                  [ 0  , 0  , 1  , 0   ],
                  [ 0  , 0  , 0  , 1   ] ] ;              
        multmatrix(Mvert) children();
    } 

    if (alignment == "N") {
        Mvert = [ [ 1  , 0  , 0  , shift_x ],
                  [ 0  , -1  , 0  , shift_y   ],
                  [ 0  , 0  , 1  , 0   ],
                  [ 0  , 0  , 0  , 1   ] ] ;
        multmatrix(Mvert) children();
    }
} 

module outer_walls(walls, wall_height = WALL_HEIGHT, thickness = OUTER_WALL_THICKNESS) {
    for (w = walls) {
        align(alignment = w[0], shift_x = w[2], shift_y = w[3]) {
            outer_wall(width = w[1],height = wall_height, thickness = thickness) {
                window_slots(windows= w[4]);
            }
            window_frames(windows = w[4], thickness = thickness);
        }
    }
}

module inner_walls(walls, wall_height = WALL_HEIGHT, thickness = THICK_INNER_WALL_THICKNESS) {
    translate([OUTER_WALL_THICKNESS, OUTER_WALL_THICKNESS, 0]) {
        for (w = walls) {
            align(alignment = w[0], shift_x = w[2], shift_y = w[3]) {
                inner_wall(w[1], thickness = thickness, height = wall_height) {
                    door_slots(doors = w[4], thickness = thickness);
                }

                door_frames(doors = w[4], thickness = thickness);
            }
        }
    }
}



module window_frame(width, height, thickness, subdivisions = 1, blind = 0.4) {
    part("INNER_WALL") {
        difference() {
        e = EDGING_SUNK / 10.0;
        translate([0,0,0])
            cube([width + e, thickness*0.5, height + e]);
        translate([e,-thickness,e])
            cube([width - e * 2, thickness*3, height - e * 2]);
        }
    }
    
    if (height > 1.0) {
    part("WINDOW_EDGING") difference() {
        e = EDGING_WIDTH;
        
        translate([-e,0,-e])
            cube([width + e * 2, thickness - EDGING_SUNK, height + e * 2]);
        translate([0,-thickness,0])
        cube([width, thickness*3, height]);
    }
    }
    
    part("WINDOW_FRAME") { 
        difference() {
            e = WINDOWFRAME_WIDTH;
            translate([0,thickness*0.5,0])
                cube([width, 0.04, height]);
            translate([e,-thickness,e])
                cube([width - e * 2, thickness*3, height - e * 2]);
        }
        
        difference() {
            inset = WINDOWFRAME_OFFSET;
            e = WINDOWFRAME_WIDTH;
            translate([inset,thickness*0.5 - 0.05,inset])
                cube([width - inset*2, 0.06, height - inset*2]);
            translate([e + inset,-thickness,e + inset])
                cube([width - (e + inset) * 2, thickness*3, height - (e + inset) * 2]);
        }
        
        if (!is_undef(subdivisions) && subdivisions >= 2) {
            for (i = [1:subdivisions-1]) {
                inset = WINDOWFRAME_OFFSET;
                e = WINDOWFRAME_WIDTH;
                translate([inset+ i * (width - inset*2) / subdivisions - e / 4,thickness*0.5 - 0.01,inset])
                cube([e*0.5, 0.02, height - e * 2]);
            }
        }
    }
    
    if (height > 0.8 && height <= 2.0) {
        part("WINDOW_SILL") {
            translate([0, thickness/2,-0.02]) rotate([-6,0,0]) cube([width, thickness*0.5, 0.06]);
        }
    }
    
    part("WINDOW_GLASS") {
        translate([0,thickness*0.5 - 0.03,0])
                cube([width, 0.005, height]);
    }
    
    if (!is_undef(blind)) {
    part("WINDOW_BLIND") {
        blindcount = floor(blind*height/BLIND_WIDTH);
        for (i = [0:blindcount]) {
            translate([0,thickness*0.75, height - i*BLIND_WIDTH - BLIND_WIDTH]) {
                intersection() {
                    cube([width, 0.02, BLIND_WIDTH]);
                    translate([0,-BLIND_WIDTH*0.35,BLIND_WIDTH*0.5]) rotate([0,90,0]) cylinder(r = BLIND_WIDTH, h = width, $fn = 32);
                }
                
                if (i == blindcount)
                translate([0,0.005, -BLIND_WIDTH*0.3]) cube([width, 0.025, BLIND_WIDTH*0.4]);
            }
        }
    }
    }
}

module window_frames(windows, thickness = OUTER_WALL_THICKNESS) {
    for (w = windows) {
        translate([w[2],thickness,w[3]+ FLOOR_HEIGHT])
            mirror([0,1,0])
            window_frame(width = w[0], height= w[1], thickness = thickness, blind = w[4], subdivisions = w[5]);
        }
}

module window_slots(windows) {
    for (w = windows) {
        e = w[1] > 1.0 ? EDGING_WIDTH : 0.0;
        window(width = w[0] + e*2, height= w[1] + e*2, shift = w[2]-e, brh = w[3]-e);
    }
}


module door(shift, width = DEFAULT_DOOR_WIDTH, height = DEFAULT_DOOR_HEIGHT) {
    slot(width, shift, height, FLOOR_HEIGHT);
}


module door_handle() {
    part("DOOR_HANDLE") {
    translate([-0.015*0.5,0,0]) {    
        rotate([0,90,0]) 
            cylinder(r=0.035,h=0.015, $fn = 16, center = true);
                
        translate([0,0,-0.12])
            rotate([0,90,0]) 
                cylinder(r=0.035,h=0.015, $fn = 16, center = true);
    }
            
    translate([0,-0.05,0]) {
        rotate_extrude(angle=90, convexity=10, $fn = 32)
            translate([0.05, 0.0])
                circle(0.015, $fn = 16);
        translate([0.05,0,0]) 
            rotate([90,0,0])
                cylinder(r=0.015,h=0.12, $fn = 16);
    }
    }
}
        
        
module door_frame(width, height, thickness, angle = 0.0) {
    door_thickness = 0.05;

    part("DOOR_FRAME") difference() {
        e = DOOR_FRAME_WIDTH;
        
        translate([-e,-e*0.15,0])
            cube([width + e * 2, thickness + e*0.3, height + e * 1.2]);
        translate([0,-thickness, e * 0.2])
        cube([width, thickness*3, height]);
    }
    
    part("DOOR_LEAF") {
        mirror([1,0,0]) translate([-width, - 0.01,0])  rotate([0,0,-angle]) translate([0,-DOOR_FRAME_WIDTH*0.3 ,0])
        { 
            cube([width, 0.03, height + DOOR_FRAME_WIDTH*0.2]);
        }
    }

    mirror([1,0,0]) translate([-width, - 0.01,0])  rotate([0,0,-angle]) translate([0,-DOOR_FRAME_WIDTH*0.3 ,0])
        {
            translate([width - 0.08, - door_thickness * 0.4, height*0.5]) {
                translate([0,  door_thickness * 1.2,0]) mirror([-1,1,0]) door_handle();
                mirror([0,-1,0]) mirror([1,-1,0]) door_handle();
            }
        }

    part("DOOR_JOINT") {
        translate([width,-0.05,0.3]) cylinder(r = 0.015, h = 0.3, $fn = 32, center = true);
        translate([width,-0.05,height - 0.3]) cylinder(r = 0.015, h = 0.3, $fn = 32, center = true);
    }
}

module door_frames(doors, thickness = THICK_INNER_WALL_THICKNESS) {
    for (d = doors) {
        translate([d[1],0,FLOOR_HEIGHT])
            door_frame(width = d[0], height = DEFAULT_DOOR_HEIGHT, thickness = thickness, angle = d[2]);
        }
}

module door_slots(doors, thickness = THICK_INNER_WALL_THICKNESS) {
    for (d = doors) {
        e = EDGING_WIDTH;
        door(width = d[0], height= DEFAULT_DOOR_HEIGHT, shift = d[1]);
    }
}

module ground(width, height, shift_x = 0.0, shift_y = 0.0) {
    translate([OUTER_WALL_THICKNESS + shift_x, OUTER_WALL_THICKNESS + shift_y,0]) {
        cube([width, height, FLOOR_HEIGHT]);
    }
}

module rooms(rs) {
    for (r = rs) {
        part(name = r[0]) {
            for (g = r[1]) {
                ground(width = g[0], height = g[1], shift_x = g[2], shift_y = g[3]);
            }
        }
    }
}

module chimney(bottom, top, width = 0.4) {
    part("CHIMNEY") {
        translate([6.0, 2.7, 0]) difference() {
            height = WALL_HEIGHT*2 + 0.6;
            group() {
                cube([width, width, height]);
                translate([-0.04,-0.04,height])
                    cube([width + 0.08, width + 0.08, 0.08]);
            }

            translate([width/2, width/2, 0]) cylinder(r = width*0.2, h = height+1.0, $fn = 32);

            translate([-width/2, -width/2, 0]) {
                if (bottom > 0) {
                    translate([0,0,-0.1]) cube([width*2,width*2,bottom+0.1]);
                }
                if (top > 0) {
                    translate([0,0,top])
                        cube([width*2,width*2,10.0]);
                }

            }

        }
    }
}

module part(name) {
    if (is_undef($PART) || $PART == name) {
        color([for (p = PARTS) if (p[0] == name) p[1] ][0]) children();
    }
}


