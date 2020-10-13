turret_bottom=19/2; 
turret_top=15/2;
ring_height=2;
ring_polygon=12;
rivet_number=24;
r=turret_bottom-0.15; //リベットを円周上に並べる際の半径

//砲塔本体
module turm($fn=55){
	cylinder(h=9, r1=turret_bottom, r2=turret_top);
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
//module ring($fn=ring_polygon){
module ring($fn=24){
	translate([0,0,-ring_height]){
		cylinder(h=ring_height, r=14.5/2);
	}
}

//本体とリング,リベットを結合
module target(){
	union(){
		turm();
		rivet();
		ring();
	}
}

//内部の空洞化
module tool($fn=ring_polygon){
	translate([0,0,-ring_height]){
		cylinder(h=ring_height, r=12.5/2);
	}
	cylinder(h=7, r1=12.5/2, r2=turret_top-3);
}

//targetからtoolを減算
difference(){
	target();
	tool();
}
