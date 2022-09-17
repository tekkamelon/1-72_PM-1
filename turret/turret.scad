// 変数
turret_bottom=19/2; 
turret_top=15/2;
ring_height=2;
ring_polygon=24;
rotate_anlge=90;

// 砲塔基本部分
module turm_func(turm_h, turm_r1, turm_r2){
	cylinder(h=turm_h, r1=turm_r1, r2=turm_r2);
}

// リベット基本部分
module rivet_func(rivet_r, rivet_number, rivet_height, sphere_r){
	for(i=[0:rivet_number-1]){
		a=i*(360/rivet_number);	
		translate([rivet_r*cos(a), rivet_r*sin(a), rivet_height]){
			sphere(sphere_r, $fn=10); // リベットの半径
		}
	}
}

// ガンポート基本部分
module gunport_func(gunport_y, gunport_r, gunport_height, translate_x, cylinder_height, $fn=30){
	for(y=[-gunport_y:gunport_y*2:gunport_y]){
		translate([translate_x, y, gunport_height]){
			rotate([0, rotate_anlge, 0]){
				cylinder(h=cylinder_height, r=gunport_r);
			}
		}
	}
}

// 砲塔部分のモデリング
module turret(r=turret_bottom-0.15, rivet_number=24, r=1.8, h=5, ch=5){
	// 砲塔本体
	turm_func(9, turret_bottom, turret_top, $fn=80); 
	// 砲塔のリベット
	rivet_func(r, 24, 0.65, 0.3); // リベット

	difference(){
		// ガンポート
		gunport_func(3, r+0.2, h, 3.8, ch, $fn=30);
		// 減算用
		gunport_func(3, r/2, h, 8.5, 1, $fn=30);
	}
}

// ガンポートのリベット
module gunport_rivet(){
	for(y=[-3:3*2:3]){
		translate([8.1, y, 5]){
			rotate([rotate_anlge, 0, 0]){
				rotate([0, rotate_anlge, 0]){
					rivet_func(1.65, 6, 0.65, 0.25); // リベット
				}
			}
		}
	}
}

// ペリスコープ
difference(){
	// 本体
	union(){
		// 上部
		translate([2,4, turret_top+1.4]){
			turm_func(1.35, 1, 1, $fn=30);
		}
		// 基部
		translate([2, 4, turret_top+1.3]){
			turm_func(0.5, 1.5, 1.2, $fn=30);
		}
	}
	// 穴
	translate([3, 4, turret_top+2.2]){
		cube(size=[1, 1, 0.6], center=true);
	}
}

// 砲塔のリベット
module turret_rivet(){
	for(y=[-3:3*2:3]){
		translate([0, 0, 1]){
			rotate([rotate_anlge, 90, 0]){
				rotate([0, rotate_anlge, 0]){
					rivet_func(turret_bottom-0.15, 28, 0.65, 0.25); // リベット
				}
			}
		}
	}
}

// 砲身
module barrel(){
	translate([3.6, -3, 5]){
		rotate([0, rotate_anlge, 0]){
			cylinder(h=15, r=0.6, $fn=30);
		}
	}
	translate([8.65, -3, 5]){ // 砲身基部
		sphere(r=1, $fn=35);
	}
}


// ターレットリング
module ring($fn=ring_polygon){
	translate([0, 0, -ring_height]){
		cylinder(h=ring_height, r=14.5/2);
	}
}

// 各モジュールを結合
module target(){
	union(){
		turret();
		ring();
		barrel();
		turret_rivet();
		gunport_rivet();
	}
}

// 減算用モジュール
module tool($fn=ring_polygon/2, turret_thickness=1){
	translate([17.5, -3, 5]){ // マズル
		rotate([0, rotate_anlge, 0]){
			cylinder(h=3, r=0.3, $fn=10);
		}
	}
	// ターレットリング
	translate([0, 0, -ring_height]){ 
		cylinder(h=ring_height+turret_thickness, r=12.5/2, $fn=ring_polygon);
	}
	translate([0, 0, turret_thickness]){ // 砲塔内部
		turm_func(6.5, turret_bottom-turret_thickness, turret_top-turret_thickness);
	}
}

// targetからtoolを減算
difference(){
	target();
	tool();
}
