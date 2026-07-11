// ==========================================
// 変数・パラメータ定義
// ==========================================

// 基本寸法
turret_bottom = 19 / 2;
turret_top    = 15 / 2;
ring_height   = 2;
ring_polygon  = 24;
rotate_angle  = 90;

// 砲身パラメータ
barrel_x      = 3.6;
barrel_y      = -3;
barrel_z      = 5;
barrel_length = 15;
barrel_r      = 0.6;

// 砲身基部（マントレット球）
mantlet_x = 8.65;
mantlet_r = 1;

// マズル穴（減算用）
muzzle_x      = 17.5;
muzzle_length = 3;
muzzle_r      = 0.3;

// ペリスコープパラメータ
periscope_x      = 2;
periscope_y      = 3;
periscope_base_z = turret_top + 1.3;
periscope_top_z  = turret_top + 1.4;
periscope_hole_x = 3;
periscope_hole_y = 3;
periscope_hole_z = turret_top + 2.2;

// ハッチパラメータ
hatch_x = -2.4;
hatch_y = 0;
hatch_z = turret_top + 1.4;

// ==========================================
// 基本形状モジュール
// ==========================================

// 砲塔基本部分（台形円柱）
module turret_cylinder(turret_h, turret_r1, turret_r2, fn = 160) {
    cylinder(h = turret_h, r1 = turret_r1, r2 = turret_r2, $fn = fn);
}

// リベット基本部分
module rivet_func(rivet_r, rivet_number, rivet_height, sphere_r) {
    for (i = [0 : rivet_number - 1]) {
        a = i * (360 / rivet_number);
        translate([rivet_r * cos(a), rivet_r * sin(a), rivet_height]) {
            sphere(sphere_r, $fn = 10);
        }
    }
}

// ガンポート基本部分
module gunport_func(gunport_y, gunport_r, gunport_height, translate_x, cylinder_height, fn = 30) {
    for (y = [-gunport_y : gunport_y * 2 : gunport_y]) {
        translate([translate_x, y, gunport_height]) {
            rotate([0, rotate_angle, 0]) {
                cylinder(h = cylinder_height, r = gunport_r, $fn = fn);
            }
        }
    }
}

// ==========================================
// 部品モジュール
// ==========================================

// 砲塔本体
module turret(rivet_number = 24, gunport_r = 1.8, h = 5, ch = 5) {
    // 砲塔本体
    turret_cylinder(9, turret_bottom, turret_top, fn = 160);

    // ガンポート
    difference() {
        gunport_func(3, gunport_r + 0.3, h, 3.8, ch, fn = 60);
        gunport_func(3, gunport_r / 2, h, 8.5, 1, fn = 60);
    }
}

// ガンポートのリベット
module gunport_rivet() {
    for (y = [-3 : 3 * 2 : 3]) {
        translate([8.1, y, 5]) {
            rotate([rotate_angle, 0, 0]) {
                rotate([0, rotate_angle, 0]) {
                    rivet_func(1.85, 6, 0.65, 0.25);
                }
            }
        }
    }
}

// ペリスコープ
module periscope() {
    difference() {
        union() {
            // 上部
            translate([periscope_x, periscope_y, periscope_top_z]) {
                turret_cylinder(1.35, 1, 1, fn = 30);
            }
            // 基部
            translate([periscope_x, periscope_y, periscope_base_z]) {
                turret_cylinder(0.5, 1.5, 1.2, fn = 30);
            }
        }
        // 穴
        translate([periscope_hole_x, periscope_hole_y, periscope_hole_z]) {
            cube(size = [1, 1, 0.6], center = true);
        }
    }
}

// 砲塔のリベット
module turret_rivet() {
    for (y = [-3 : 3 * 2 : 3]) {
        translate([0, 0, 2]) {
            rotate([rotate_angle, 90, 0]) {
                rotate([0, rotate_angle, 0]) {
                    rivet_func(turret_bottom - 0.3, 28, 0.65, 0.25);
                }
            }
        }
    }
}

// 砲身
module barrel() {
    translate([barrel_x, barrel_y, barrel_z]) {
        rotate([0, rotate_angle, 0]) {
            cylinder(h = barrel_length, r = barrel_r, $fn = 30);
        }
    }
    translate([mantlet_x, barrel_y, barrel_z]) {
        sphere(r = mantlet_r, $fn = 35);
    }
}

// ターレットリング
module ring() {
    translate([0, 0, -ring_height]) {
        cylinder(h = ring_height, r = 14.5 / 2, $fn = ring_polygon);
    }
}

// 砲塔前面の構造物
module turret_object() {
    translate([6.5, 0, 7.5]) {
        rotate([0, -10, 0]) {
            difference() {
                cube(size = [3, 2.3, 2], center = true);
                cube(size = [10, 2.3 - 0.5, 2 - 0.5], center = true);
            }
        }
    }
    translate([7, 0, 8.5]) {
        cube(size = [4, 2.3, 0.5], center = true);
    }
}

// ハッチ
module hatch() {
    translate([hatch_x, hatch_y, hatch_z]) {
        difference() {
            color("blue")
                cube([5, 4.5 * 2, 0.3], true);
            cube([4.6, 4.2 * 2, 0.4], true);
        }
    }
}

// ==========================================
// アセンブリ
// ==========================================

// 外形結合
module target() {
    union() {
        turret();
        ring();
        barrel();
        turret_rivet();
        gunport_rivet();
        turret_object();
    }
}

// 減算用モジュール
module tool(turret_thickness = 1) {
    // マズル
    translate([muzzle_x, barrel_y, barrel_z]) {
        rotate([0, rotate_angle, 0]) {
            cylinder(h = muzzle_length, r = muzzle_r, $fn = 10);
        }
    }

    // ターレットリング内部
    translate([0, 0, -ring_height]) {
        cylinder(h = ring_height + turret_thickness, r = 12.5 / 2, $fn = ring_polygon);
    }

    // 砲塔内部
    translate([0, 0, turret_thickness]) {
        turret_cylinder(6.5, turret_bottom - turret_thickness, turret_top - turret_thickness, fn = 80);
    }
}

// 全体組み立て（定義と実行を分離）
module complete_turret() {
    difference() {
        union() {
            target();
            periscope();
            hatch();
        }
        tool();
    }
}

// ==========================================
// レンダリング
// ==========================================
complete_turret();
