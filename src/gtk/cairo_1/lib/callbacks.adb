with ada.text_io;				use ada.text_io;
with ada.calendar;				use ada.calendar;
with ada.calendar.formatting;	use ada.calendar.formatting;

with gtk.main;					use gtk.main;


package body callbacks is

	procedure cb_terminate (
		main_window : access gtk_widget_record'class) 
	is begin
		put_line ("exiting ...");
		gtk.main.main_quit;
	end cb_terminate;


-- 	procedure cb_horizontal_moved (
-- 		scrollbar : access gtk_adjustment_record'class)
-- 	is begin
-- 		put_line ("horizontal moved " & image (clock));
-- 	end cb_horizontal_moved;
-- 
-- 	
-- 	procedure cb_vertical_moved (
-- 		scrollbar : access gtk_adjustment_record'class)
-- 	is begin
-- 		put_line ("vertical moved " & image (clock));
-- 	end cb_vertical_moved;

	
	function cb_draw (
		canvas	: access gtk_widget_record'class;
		context	: in cairo_context)
		return boolean
	is
		result : boolean := true;
	begin
		put_line ("cb_draw " & image (clock));

		set_line_width (context, 1.0);
		set_source_rgb (context, 1.0, 0.0, 0.0);

		rectangle (context, 1.0, 1.0, 100.0, 100.0);
		stroke (context);
		
		return result;
	end cb_draw;

	
end callbacks;

