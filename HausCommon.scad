
OUTER_WALL_THICKNESS = 0.365;
WALL_HEIGHT = 2.95;
THIN_INNER_WALL_THICKNESS = 0.115;
THICK_INNER_WALL_THICKNESS = 0.175;

DEFAULT_BRH = 0.84;
FLOOR_HEIGHT = 0.19;

module slot(width, shift, height, z) {
    translate([shift, -OUTER_WALL_THICKNESS*0.05, z])
        cube([width, OUTER_WALL_THICKNESS * 1.1, height]);
}

module window(width, shift, height = 0.54, brh = DEFAULT_BRH) {
    slot(width, shift, height, FLOOR_HEIGHT + brh); 
}

module door(shift, width = 0.885, height = 2.01) {
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

module inner_wall(width, thickness, shift_x = 0.0, shift_y = 0.0, height = WALL_HEIGHT) {
    color("White") translate([OUTER_WALL_THICKNESS, OUTER_WALL_THICKNESS,0])
        wall(width, thickness, shift_x, shift_y, height) {
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

module ground(width, height, shift_x = 0.0, shift_y = 0.0) {
    translate([OUTER_WALL_THICKNESS + shift_x, OUTER_WALL_THICKNESS + shift_y,0]) {
        cube([width, height, FLOOR_HEIGHT]);
    }
}


module part(name) {
    if (is_undef($PART) || $PART == name) {
        children();
    }
}

module colored_part(name, part_color) {
    if (is_undef($PART) || $PART == name) {
        color(part_color) children();
    }
}


module horizontal() {
    Mvert = [ [ 0  , 1  , 0  , 0   ],
      [ 1  , 0  , 0  , 0   ],
      [ 0  , 0  , 1  , 0   ],
      [ 0  , 0  , 0  , 1   ] ] ;
    multmatrix(Mvert) { children(); }
} 


