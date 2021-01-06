turret_bottom=19/2; 
turret_top=15/2;
ring_height=2;
ring_polygon=24;

//砲塔基本部分
module turm_basic(turm_h, turm_r1, turm_r2){
	cylinder(h=turm_h, r1=turm_r1, r2=turm_r2);
}

//リベット基本部分
module rivet_basic(rivet_r, rivet_number, rivet_height, sphere_r){
	for(i=[0:rivet_number-1]){
		a=i*(360/rivet_number);	
		translate([rivet_r*cos(a), rivet_r*sin(a), rivet_height]){
			sphere(sphere_r, $fn=10); //リベットの半径
		}
	}
}

//ガンポート基本部分
module gunport_basic(gunport_y, gunport_r, gunport_height, translate_x, cylinder_height, $fn=30){
	for(y=[-gunport_y:gunport_y*2:gunport_y]){
		translate([translate_x, y, gunport_height]){
			rotate([0, 90, 0]){
				cylinder(h=cylinder_height, r=gunport_r);
			}
		}
	}
}

//ガンポートのリベット
module gunport_rivet(){
	for(y=[-3:3*2:3]){
		translate([8, y, 5]){
			rotate([90, 0, 0]){
				rotate([0, 90, 0]){
					rivet_basic(1.5, 6, 0.65, 0.25); //リベット
				}
			}
		}
	}
}

//砲塔部分のモデリング
module turret(r=turret_bottom-0.15, rivet_number=24){
	turm_basic(9, turret_bottom, turret_top, $fn=70); //砲塔本体
	rivet_basic(r, 24, 0.65, 0.3); //リベット
	difference(){
		gunport_basic(3, 1.8, 5, 3.7, 5, $fn=30);
		gunport_basic(3, 1.8/2, 5, 8.35, 1, $fn=30);
	}
}

//砲身
module barrel(){
	translate([3.6, -3, 5]){
		rotate([0, 90, 0]){
			cylinder(h=15, r=0.6, $fn=30);
		}
	}
	translate([8.65, -3, 5]){ //砲身基部
		sphere(r=1.8/2-0.05, $fn=35);
	}
}


//ターレットリング
module ring($fn=ring_polygon){
	translate([0, 0, -ring_height]){
		cylinder(h=ring_height, r=14.5/2);
	}
}

//各モジュールを結合
module target(){
	union(){
		turret();
		ring();
		barrel();
		gunport_rivet();
	}
}

//減算用モジュール
module tool($fn=ring_polygon/2, turret_thickness=1){
	translate([17.5, -3, 5]){ //マズル
		rotate([0, 90, 0]){
			cylinder(h=3, r=0.3, $fn=10);
		}
	}
	translate([0, 0, -ring_height]){ //ターレットリング
		cylinder(h=ring_height+turret_thickness, r=12.5/2);
	}
	translate([0, 0, turret_thickness]){ //砲塔内部
		turm_basic(6.5, turret_bottom-turret_thickness, turret_top-turret_thickness);
	}
}

//targetからtoolを減算
difference(){
	target();
	tool();
}
