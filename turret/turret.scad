turret_bottom=19/2; 
turret_top=15/2;
ring_height=2;
ring_polygon=24;

//砲塔及びリベット
module turm($fn=70, r=turret_bottom-0.15, rivet_number=24){  //リベットを円周上に並べる際の半径
	//砲塔本体
	cylinder(h=9, r1=turret_bottom, r2=turret_top);
	//リベット
	for(i=[0:rivet_number-1]){
		a=i*(360/rivet_number);	
		translate([r*cos(a), r*sin(a), 0.65]){
			sphere(0.3, $fn=8); //リベットの半径
		}
	}
}

//ガンポートの基本部分
module gunport_basic(gunport_y, gunport_r, gunport_height, translate_x, cylinder_height, $fn=30){
	for(y=[-gunport_y:gunport_y*2:gunport_y]){
		translate([translate_x, y, gunport_height]){
			rotate([0, 90, 0]){
				cylinder(h=cylinder_height, r=gunport_r);
			}
		}
	}
}

module gunport(){
	difference(){
		gunport_basic(3, 1.8, 5, 3.7, 5, $fn=30);
		gunport_basic(3, 1.8/2, 5, 8.35, 1, $fn=30);
	}
}

//銃身
module barrel($fn=12){
	translate([3.6, -3, 5]){
		rotate([0, 90, 0]){
			cylinder(h=15, r=0.6);
		}
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
		turm();
		ring();
		gunport();
		barrel();
	}
}

//内部の空洞化用モジュール
module tool($fn=ring_polygon/2, turret_thickness=1){
	//ターレットリング
	translate([0, 0, -ring_height]){
		cylinder(h=ring_height+turret_thickness, r=12.5/2);
	}
	//砲塔内部
	translate([0, 0, turret_thickness]){
		cylinder(h=6.5, r1=turret_bottom-turret_thickness, r2=turret_top-turret_thickness);
	}
}

//targetからtoolを減算
difference(){
	target();
	tool();
}
