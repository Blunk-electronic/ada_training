-- This is a simple ada program,
-- that demonstrates user specific 
-- new types.

with ada.text_io;	use ada.text_io;

procedure types_new_2 is

	-- These are new created types which are
	-- not compatible:
	type musicians_classic is (brahms, bach, mozart);
	type musicians_techno is (marusha, vaeth, kalkbrenner);

	mc : musicians_classic := bach;
	mt : musicians_techno := marusha;

begin
	mc := brahms;
	put_line(musicians_classic'image(mc));

	--mt := mozart; -- does not compile
end types_new_2;