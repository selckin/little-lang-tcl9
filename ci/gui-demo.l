/*
 * A small L-gui (Tk) smoke test: build a window, press its button
 * programmatically, and report what happened to the file given as the
 * first argument.
 */

string	report[];

void
pressed()
{
	push(&report, "button pressed");
}

int
main(string av[])
{
	string	out = av[1];
	FILE	f;

	ttk::label(".l", text: "Little on Tcl/Tk ${Info_patchlevel()}");
	ttk::button(".b", text: "Press me", command: &pressed);
	pack(".l", ".b", padx: 10, pady: 10);
	update();

	push(&report, "tk ${Package_require("Tk")}");
	push(&report, "mapped ${Winfo_ismapped(".b")}");
	eval(".b invoke");

	unless (f = fopen(out, "w")) die("cannot write ${out}");
	fprintf(f, "%s\n", join("\n", report));
	fclose(f);
	exit(0);
}
