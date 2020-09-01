
module outdoor_terrace() {

}

module outdoor_entry(width = 1.8, height = FLOOR_HEIGHT * 0.5) {
    part("OUTDOOR_ENTRY_BOTTOM") difference() {
        cylinder(r = width*0.5, h = height, $fn = 40);
        translate([0, -width*0.5, -height]) cube([width, width*2, height*3]);
    }

    translate([-0.6, -0.45, height ]) part("OUTDOOR_ENTRY_MAT") cube([0.6, 0.9, 0.02]);
}

module outdoors() {
    // Garden plane
    translate([-3.5,-3, -FLOOR_HEIGHT]) part("OUTDOOR_GARDEN") cube([19, 13, FLOOR_HEIGHT]);

    // Paths
    translate([-2,-1.4, 0]) part("OUTDOOR_WALK") cube([17, 1.2, 0.04]);
    translate([-2,0.8, 0]) part("OUTDOOR_WALK") cube([2, 1.2, 0.04]);
    translate([-1.8,-1.4, 0]) rotate([0,0,90]) part("OUTDOOR_WALK") cube([11.0, 1.2, 0.04]);
    translate([14.0,-1.4, 0]) rotate([0,0,90]) part("OUTDOOR_WALK") cube([5.0, 1.2, 0.04]);

    // Terrace
    translate([14.3,3.4, 0]) rotate([0,0,90]) part("OUTDOOR_TERRACE") cube([5.0, 3.9, 0.1]);

    translate([0,0, 0]) {
        translate([0,1.45,0]) outdoor_entry();
        outdoor_terrace();
    }

}

outdoors();