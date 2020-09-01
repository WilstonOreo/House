include <HausCommon.scad>;
use <Dach.scad>;
    

module second_floor() {


    translate([0,0, WALL_HEIGHT]) difference() 
    { group() 
    {
    max_wall_height = 4.135;

    windows = [
        [1.13, 1.42, 0.86, DEFAULT_BRH, 0.0 ], // Gästezimmer
        [0.885, 2.26, 3.74, 3.16 - WALL_HEIGHT, undef ], // Fensterband
        [1.51, 1.72, 0.74, DEFAULT_BRH, 0.0], // Gästezimmer West
        [1.51, 1.72, 8.61 - 0.74 - 1.51, DEFAULT_BRH, 0.0], // Schlafzimmer
    ];

    outer_walls([
        ["S", 10.49, 0, 0, [windows[0]]],
        ["N", 10.49, 0, 8.615],
        ["W", 8.61, 0, 0, [for (i = [1:3]) windows[i]]],
        ["E", 8.61, 0, 10.49]
    ], max_wall_height);

    outer_walls([
        ["W", 8.61, 0, 6.01 + 0.365 + 0.12],
        ["E", 8.61, 0, 6.01 + 0.365 + 0.12],
    ], 1.7, 0.12);

    doors = [
        [ 0.9, 2.4, 0.0 ],
        [ 0.9, 1.6, 0.0 ],
    ];

    inner_walls([
        ["S", 6.05 - BATHROOM_WIDTH, 0.0, 2.76, [doors[0]]],
        ["N", 6.05 - BATHROOM_WIDTH, 0.0, 5.24, [doors[0]]],
        ["S", BATHROOM_WIDTH, 6.05 - BATHROOM_WIDTH, 2.575 - 0.365],
        ["N", BATHROOM_WIDTH, 6.05 - BATHROOM_WIDTH, 2.575 - 0.365 + 3.46],
    ], max_wall_height);

    inner_walls([
        ["E", 3.46, 2.575 - 0.365, 6.05 - BATHROOM_WIDTH, [doors[1]] ]
    ], max_wall_height, thickness = THIN_INNER_WALL_THICKNESS);

    translate([0,0, -WALL_HEIGHT]) chimney(WALL_HEIGHT, WALL_HEIGHT*2);

    rooms([
        // Gästezimmer
        ["PARQUETRY", [[ 6.05 - BATHROOM_WIDTH, 2.76,0,0 ], [BATHROOM_WIDTH, 2.575 - 0.365, 6.05 - BATHROOM_WIDTH,0,0 ]]],

        // Schlafzimmer
        ["PARQUETRY", [[ 6.05 - BATHROOM_WIDTH, 2.81, 0, 2.76 + 0.175 + 2.135 ], [BATHROOM_WIDTH, 2.575 - 0.36, 6.05 - BATHROOM_WIDTH, 2.575 + 3.46 - 0.365,0 ]]],

        // Galerie    
        ["PARQUETRY", [[ 1.2, 2.135, 6.05 - BATHROOM_WIDTH - 1.2, 0.175 + 2.76]]], 

        // Badezimmer
        ["TILES", [[BATHROOM_WIDTH, 3.46 - 0.175 * 2, 6.05 - BATHROOM_WIDTH, 2.575 - 0.19 ]]]
    ]);


    }



    roof_transform(offset = 0.0)
                    cube([12.0, 8.61 + 0.3 + 0.3,8]);

}

    


}

second_floor();