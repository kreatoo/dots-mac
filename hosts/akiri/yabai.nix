{ pkgs, ... }:
{
	services.yabai.enable = true;
	services.skhd.enable = true;
	services.sketchybar.enable = true;
	services.skhd.skhdConfig = ''
		hyper - return : open -a /Applications/iTerm.app ~
		shift + ctrl - z : yabai -m window --space next
		shift + ctrl - 2 : yabai -m window --space  2
		
		# send window to monitor and follow focus
		#ctrl + cmd - c  : yabai -m window --display next; yabai -m display --focus next
		#ctrl + cmd - 1  : yabai -m window --display 1; yabai -m display --focus 1
		
		# move floating window
		# shift + ctrl - a : yabai -m window --move rel:-20:0
		# shift + ctrl - s : yabai -m window --move rel:0:20
		
		# increase window size
		# shift + alt - a : yabai -m window --resize left:-20:0
		# shift + alt - w : yabai -m window --resize top:0:-20
		
		# decrease window size
		# shift + cmd - s : yabai -m window --resize bottom:0:-20
		# shift + cmd - w : yabai -m window --resize top:0:20
		
		# set insertion point in focused container
		# ctrl + alt - h : yabai -m window --insert west
		
		# toggle window zoom
		# alt - d : yabai -m window --toggle zoom-parent
		# alt - f : yabai -m window --toggle zoom-fullscreen
		
		# toggle window split type
		# alt - e : yabai -m window --toggle split
		
		# float / unfloat window and center on screen
		hyper - t : yabai -m window --toggle float --grid 4:4:1:1:2:2
		
		# toggle sticky(+float), picture-in-picture
		hyper - p : yabai -m window --toggle sticky --toggle pip
	'';

	services.yabai.config = {
			external_bar                 = "off:40:0";       
    		menubar_opacity              = 0.0;            
    		mouse_follows_focus          = "off";            
    		focus_follows_mouse          = "off";            
    		display_arrangement_order    = "default";        
    		window_origin_display        = "default";        
    		window_placement             = "second_child";   
    		window_zoom_persist          = "on";   
    		window_shadow                = "on";             
    		window_animation_duration    = 0.0;            
    		window_animation_easing      = "ease_out_circ";  
    		window_opacity_duration      = 0.0;            
    		active_window_opacity        = 1.0;            
    		normal_window_opacity        = 0.90;           
    		window_opacity               = "off";            
    		insert_feedback_color        = "0xffd75f5f";    
    		split_ratio                  = 0.50;           
    		split_type                   = "auto";          
    		auto_balance                 = "off";            
    		top_padding                  = 12;             
    		bottom_padding               = 12;             
    		left_padding                 = 12;             
    		right_padding                = 12;             
    		window_gap                   = 06;             
    		layout                       = "bsp";            
    		mouse_modifier               = "fn";             
    		mouse_action1                = "move";           
    		mouse_action2                = "resize";         
    		mouse_drop_action            = "swap";
	};
}
