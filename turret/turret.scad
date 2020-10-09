turret_bottom=19/2;
turret_top=15/2;
ring_height=2;
$fn=35;

//砲塔本体
module target(){
	cylinder(h=9, r1=turret_bottom, r2=turret_top);
	//ターレットリング
	translate([0,0,-ring_height]){
		cylinder(h=ring_height, d=14.5);
	}
}

module tool(){
	translate([0,0,-ring_height]){
		cylinder(h=ring_height, d=12.5);
	}
}

difference(){
	target();
	tool();
}

//砲塔上部のリベットをfor文でモデリング
//ミラーを使うのもあり?
