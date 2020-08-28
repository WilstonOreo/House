
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

PARTS = [
    [ "INNER_WALL", "White" ],
    [ "OUTER_WALL", "Gray" ],
    [ "PARQUETRY", "SaddleBrown" ],
    [ "TILES", "White" ],
    [ "KITCHEN_TILES", "Orange" ],
    [ "DOOR_LEAF", "White" ], 
    [ "DOOR_FRAME", "White" ],
    [ "DOOR_JOINT", "Gray" ],
    [ "WINDOW_SILL", "DimGray" ],
    [ "WINDOW_EDGING", "White" ],
    [ "WINDOW_FRAME", "DimGray" ],
    [ "WINDOW_GLASS", [ 0.5, 0.5, 0.5, 0.3 ] ],
    [ "WINDOW_BLIND", "White" ]
];



module slot(width, shift, height, z) {
    translate([shift, -OUTER_WALL_THICKNESS*0.05, z])
        cube([width, OUTER_WALL_THICKNESS * 1.1, height]);
}

module window(width, shift, height = 0.54, brh = DEFAULT_BRH) {
    slot(width, shift, height, FLOOR_HEIGHT + brh); 
}

module door(shift, width = DEFAULT_DOOR_WIDTH, height = DEFAULT_DOOR_HEIGHT) {
    slot(width, shift, height, FLOOR_HEIGHT);
}


module wall(width, thickness, shift_x = 0.0, shift_y = 0.0, height = WALL_HEIGHT) {
    translate([shift_x, shift_y, 0]) {
        difference() {
            cube([width, thickness, height]);
            children();
        }
    }
}

module outer_wall(width, shift_x = 0.0, shift_y = 0.0, height = WALL_HEIGHT) {
    color("Gray") wall(width, OUTER_WALL_THICKNESS, shift_x, shift_y, height) {
            children();
    }
}

module inner_wall(width, thickness, height = WALL_HEIGHT) {
    part("INNER_WALL") difference() {
        cube([width, thickness, height]);
        children();
    }
}

module thick_inner_wall(width, shift_x = 0.0, shift_y = 0.0, height = WALL_HEIGHT) {
    inner_wall(width, 0.175, shift_x, shift_y, height) {
        children();
    }
}

module thin_inner_wall(width, shift_x = 0.0, shift_y = 0.0, height = WALL_HEIGHT) {
    inner_wall(width, 0.115, shift_x, shift_y, height) {
        children();
    }
}

module align(alignment, shift_x, shift_y) {
    if (alignment == "") {
       Mvert = [ [ 1  , 0  , 0  , shift_x   ],
                 [ 0  , 1  , 0  , shift_y   ],
                 [ 0  , 0  , 1  , 0   ],
            [          0  , 0  , 0  , 1   ] ] ;
          multmatrix(Mvert) children();
    }

    if (alignment == "h") {
        Mvert = [ [ 0  , 1  , 0  , shift_y   ],
                  [ 1  , 0  , 0  , shift_x   ],
                  [ 0  , 0  , 1  , 0   ],
                  [ 0  , 0  , 0  , 1   ] ] ;              
        multmatrix(Mvert) children();
    } 

    if (alignment == "v") {
        Mvert = [ [ 1  , 0  , 0  , shift_x ],
                  [ 0  , -1  , 0  , shift_y   ],
                  [ 0  , 0  , 1  , 0   ],
                  [ 0  , 0  , 0  , 1   ] ] ;
        multmatrix(Mvert) children();
    }
} 


module inner_walls(walls) {
    translate([OUTER_WALL_THICKNESS, OUTER_WALL_THICKNESS, 0]) {
        for (w = walls) {
            align(alignment = w[0], shift_x = w[3], shift_y = w[4]) {
                inner_wall(w[2], thickness = w[1], height = is_undef(w[6]) ? WALL_HEIGHT : w[6]) {
                    door_slots(doors = w[5]);
                }

                door_frames(doors = w[5]);
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
    
    part("WINDOW_EDGING") difference() {
        e = EDGING_WIDTH;
        
        translate([-e,0,-e])
            cube([width + e * 2, thickness - EDGING_SUNK, height + e * 2]);
        translate([0,-thickness,0])
        cube([width, thickness*3, height]);
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
                cube([e*0.5, 0.02, height - (e) * 2]);
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

module window_frames(windows) {
    for (w = windows) {
        translate([w[2],0,w[3]+ FLOOR_HEIGHT])
            window_frame(width = w[0], height= w[1], thickness = OUTER_WALL_THICKNESS, blind = w[4], subdivisions = w[5]);
        }
}

module window_slots(windows) {
    for (w = windows) {
        e = EDGING_WIDTH;
        window(width = w[0] + e*2, height= w[1] + e*2, shift = w[2]-e, brh = w[3]-e);
    }
}


module door_handle() {
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
        
        
module door_frame(width, height, thickness, angle = 0.0) {
    door_thickness = 0.05;
    if (is_undef(height)) {
        height = DEFAULT_DOOR_HEIGHT;
    }
    if (is_undef(angle)) {
        angle = 0.0;
    }

    part("DOOR_FRAME") difference() {
        e = DOOR_FRAME_WIDTH;
        
        translate([-e,-e*0.15,0])
            cube([width + e * 2, thickness + e*0.3, height + e * 1.2]);
        translate([0,-thickness, e * 0.2])
        cube([width, thickness*3, height]);
    }
    
    part("DOOR_LEAF") {
        mirror([1,0,0]) translate([-width, - 0.01,0])  rotate([0,0,-angle]) translate([0,-DOOR_FRAME_WIDTH*0.3 ,0])    { 
            color("White") cube([width, 0.03, height + DOOR_FRAME_WIDTH*0.2]);
            
            part("DOOR_HANDLE") {
                translate([width - 0.08, - door_thickness * 0.4, height*0.5]) {
        
                translate([0,  door_thickness * 1.2,0]) mirror([-1,1,0]) door_handle();
           mirror([0,-1,0]) mirror([1,-1,0]) door_handle();
        }
    }
        }
    }
    
    part("DOOR_JOINT") {
        translate([width,-0.05,0.3]) cylinder(r = 0.015, h = 0.3, $fn = 32, center = true);
        translate([width,-0.05,height - 0.3]) cylinder(r = 0.015, h = 0.3, $fn = 32, center = true);
    }
}

module door_frames(doors) {
    for (d = doors) {
        translate([d[1],0,FLOOR_HEIGHT])
            door_frame(width = d[0], height = d[3], thickness = d[2], angle = d[4]);
        }
}

module door_slots(doors) {
    for (d = doors) {
        e = EDGING_WIDTH;
        door(width = d[0], height= d[3], shift = d[1]);
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


module part(name) {
    if (is_undef($PART) || $PART == name) {
        color([for (p = PARTS) if (p[0] == name) p[1] ][0]) children();
    }
}

module horizontal() {
    Mvert = [ [ 0  , 1  , 0  , 0   ],
      [ 1  , 0  , 0  , 0   ],
      [ 0  , 0  , 1  , 0   ],
      [ 0  , 0  , 0  , 1   ] ] ;
    multmatrix(Mvert) { children(); }
} 


