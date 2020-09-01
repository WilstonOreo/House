include <HausCommon.scad>;

function vec_d(d,a,b) = a + (b - a) * d / norm(b-a);

STAIRS_BORDER = 0.05;

module stairs_bars(number, inc) {
    for (i = [0:number-1]) {
        translate([i*0.12, 0, i*inc]) part("STAIRS_BARS") cylinder(r = 0.01, h = 0.7, $fn = 18);
    }
}

module stairs_handrail(length) {
    b = STAIRS_BORDER;
    part("STAIRS_HANDRAIL") cube([b*1.5, b*1.5, length]);
}

module stairs_pole(height = 1.0) {
    b = STAIRS_BORDER;
    part("STAIRS_BARS") cube([b*1.5, b*1.5, height]);
}

module stairs(width = 1.0) {
    step_width = 0.268;
    step_height = 0.181;
    b = STAIRS_BORDER;
    length = 2.9;
    length_2 = 2.4;
    lw = length - width;
    rail_height = 0.3;
    
    polygons = [ 
        for (i = [0:4]) [ [ 0, i*step_width ], [ width, i*step_width ], [ width, step_width*(i+1) ], [ 0, step_width*(i+1) ] ],
        [ [ 0, 1.305],  [ width, 1.305 ],  [ width, 1.531 ], [ 0, 1.63] ],
        [ [ 0, 1.63 ], [ width, 1.531 ], [width, 1.701], [0,  1.990] ],
        [ [ 0, 1.990 ], [ width, 1.701 ], [width, 1.810], [0,  2.490] ],
        [ [0,  2.490], [width, 1.810], [ width, lw ], [0, 2.86 + step_width * 2 ] ],
        [ [width, lw], [step_width, length], [0.84, length], [1.1, lw] ],
        [ [1.1, lw], [0.84, length], [1.17, length], [1.27, lw] ],
        [ [1.27, lw], [1.17, length], [1.5, length], [1.5, lw]  ],
        for (i = [0:1]) [ [1.5 + i * step_width, lw], [1.5 + i * step_width, length], 
                          [ 1.5 + (i  + 1) * step_width , length ], [ 1.5 + (i + 1) * step_width, lw ] ],
        [ [1.5 + step_width * 2, lw], [1.5 + step_width * 2, length], 
                          [ length_2 , length ], [ length_2, lw ] ]
    ];

    intersection() {
        union() {
             part("STAIRS_FRONT") cube([width, 2.9, WALL_HEIGHT]);
            translate([0,2.9 - width, 0])
                 part("STAIRS_FRONT") cube([length_2, width, WALL_HEIGHT]);
        }
        union() {
            lower_right = [ [ 0.0, 0.0], [ step_height, 0.0],  [ lw, step_height * 7],
                   [lw, step_height * 8 + rail_height], [ 0.0, rail_height] 
                ];
    lower_left = [ [ 0.0, 0.0], [ step_height, 0.0],  [ length, step_height * 8.8],
                   [length, step_height * 9.3 + rail_height],
                   [length - step_height, step_height * 9.3 + rail_height], [ 0.0, rail_height] 
                ];

    upper_left = [ [0, step_height * 11.0 ], [ width * 0.7, step_height * 11.0 ], [ length_2, WALL_HEIGHT + step_height ],
                   [ length_2, WALL_HEIGHT - step_height*2] , [ width * 0.7, step_height * 8.3], [ 0, step_height * 8.3 ]
                 ];
    upper_right = [ [width - b, step_height * 11.0 ], [ length_2, WALL_HEIGHT + step_height ],
                   [ length_2, WALL_HEIGHT - step_height*2] , [ width - b, step_height * 8.3]
                 ];

    translate([width - b,0,0]) rotate([90,0,90]) part("STAIRS_FRONT") linear_extrude(height = b) polygon(lower_right);
    rotate([90,0,90]) part("STAIRS_FRONT")  linear_extrude(height = b) polygon(lower_left);
    translate([0, length,0]) rotate([90,0,0]) part("STAIRS_FRONT")  linear_extrude(height = b) polygon(upper_left);
    translate([0, lw + b,0]) rotate([90,0,0]) part("STAIRS_FRONT")  linear_extrude(height = b) polygon(upper_right);


    z = 0;
    
    for (i = [0:len(polygons)-1]) {
        p = polygons[i];
        echo(i * step_height);
        translate([0,0,i * step_height]) {
            translate([0,0,step_height - b])
                part("STAIRS_STEPS") linear_extrude(height = b) {
                    polygon( [ p[0], p[1], vec_d(norm(p[2] - p[1]) + b*2, p[1], p[2]), vec_d(norm(p[3] - p[0]) + b*2, p[0], p[3])] );
                }

            part("STAIRS_FRONT") linear_extrude(height = step_height - b) {
                polygon( [ vec_d(0.03, p[0], p[3]),
                           vec_d(0.03, p[1], p[2]),  
                           vec_d(0.03 + b, p[1], p[2]), 
                           vec_d(0.03 + b, p[0], p[3])] );
            }
        }
    }

    }




        
    }

    translate([width - b * 1.5, -b*0.5, 0 ])  stairs_pole(); 
    translate([width - b * 1.5, lw , 1.5 ]) stairs_pole(height = 1.2);
    
    translate([width - b * 1.5, -b*0.5, 0.9 ]) rotate([-51.5,0,0]) {
        stairs_handrail(2.5);
    }

    translate([width - b * 1.5, lw + b * 1.5, 2.7 ]) rotate([-51.5,0,-90]) {
        stairs_handrail(1.6);
    }
    
    translate([width - b * 0.5, 0.11, rail_height]) rotate([0,0,90]) stairs_bars(15, 0.095);
    translate([width - b * 0.5, lw + b * 0.5, step_height * 11]) stairs_bars(11, 0.095);
    translate([length_2 - b * 0.5 - 0.08, lw + b * 0.5, step_height * 16.2]) stairs_bars(1, 0.0);
/*
    for (i = [0:4]) {
        p0 = [ 0, i * step_width ];
        p1 = [ width, i * step_width ];
        h = step_height - step_board_height;

        stairs_step(p0, p1, step_width * 1.2, step_width * 1.2, step_board_height, h + i * step_height);
        stairs_step(p0, p1, step_board_height, step_board_height, h, i * step_height);
    }
*/



}

stairs();