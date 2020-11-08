turret_bottom=19/2; 
turret_top=15/2;
ring_height=2;
ring_polygon=24;
rivet_number=24;
r=turret_bottom-0.15; //リベットを円周上に並べる際の半径

//砲塔本体
module turm($fn=65){
	cylinder(h=9, r1=turret_bottom, r2=turret_top);
}

//ガンポート
module gunport(gunport_y=3, $fn=12){
	color([0.2, 0.6, 0.2])
	for(y=[-gunport_y:gunport_y*2:gunport_y]){
		translate([3.5, y, 9/2]){
			rotate([0, 90, 0]){
				cylinder(h=5, r=1.6);
			}
		}
	}
}

//リベット
module rivet($fn=8){
	for(i=[0:rivet_number-1]){
		a=i*(360/rivet_number);	
		translate([r*cos(a), r*sin(a), 0.65]){
			sphere(0.3); //リベットの半径
		}
	}
}

//ターレットリング
module ring($fn=ring_polygon){
	translate([0, 0, -ring_height]){
		cylinder(h=ring_height, r=14.5/2);
	}
}

//本体とリング, リベット,ガンポートを結合
module target(){
	union(){
		turm();
		rivet();
		ring();
		gunport();
	}
}

//内部の空洞化
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
